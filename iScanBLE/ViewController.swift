
//  ViewController.swift
//  iScanBLE

//  Created by Sejal on 7/04/23.


import UIKit
import CoreBluetooth
class ViewController: UIViewController{
    
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var listOfDevicesTableView: UITableView!
    var bleDevices : [BLEDevices] = []    //an array to store the list of discovered BLE devices
    var centralManager: CBCentralManager?   //Declaring the CBCentralManager instance variable
    private var peripheral: CBPeripheral?  //represents the BLE peripheral that the app is currently connected to.
    
   


    //var device = ["sejal's iPhone" , "Samsung" , "watch" , "AppleWatch"]  //Static data
    override func viewDidLoad() {
    super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue: nil) //set delegate
        registerXib()
        setDelegates()
    }
    
    func setDelegates(){
        listOfDevicesTableView.delegate = self
        listOfDevicesTableView.dataSource = self
    }
    
    func registerXib() {
        let nib = UINib(nibName: "DeviceNameTableViewCell", bundle: nil)
        listOfDevicesTableView.register(nib, forCellReuseIdentifier: "DeviceNameTableViewCell")
    }
}

extension ViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bleDevices.count
    }
    
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listOfDevicesTableView.dequeueReusableCell(withIdentifier: "DeviceNameTableViewCell")as! DeviceNameTableViewCell
      
        let bleDevice = bleDevices[indexPath.row]
        cell.checkIfDeviceIsConneted(isConnected: bleDevice.isConnected)
        cell.deviceNameLabel.text = bleDevice.name
        
        //disconnecting any previously connected device and connecting the current device
        cell.onConnectButtonTapped = {  //executes when button is tapped
        self.makeAllDisconncted()
        if let peripheral = self.peripheral {
        self.centralManager?.cancelPeripheralConnection(peripheral) // disconnect already conncted device
            }

            // now we are sure that BT is disconnted from all devices
            self.peripheral = bleDevice.peripheral
            self.centralManager?.stopScan()
            bleDevice.peripheral.delegate = self
            self.centralManager?.connect(bleDevice.peripheral, options: nil)
        }
        return cell
    }

}
 //implememting CBCentralManagerDelegate protocol
//The extension for the CBCentralManagerDelegate and CBPeripheralDelegate protocols implements methods for scanning for BLE devices, connecting to and disconnecting from BLE devices, and handling errors.

extension ViewController : CBCentralManagerDelegate, CBPeripheralDelegate{
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
            case .unknown:
                print("Bluetooth state is unknown")
            case .unsupported:
                print("Bluetooth is unsupported on this device")
            case .unauthorized:
                print("The user has not authorized Bluetooth usage")
            case .poweredOff:
                print("Bluetooth is currently powered off")
            case .poweredOn:
                print("Bluetooth is currently powered on and available to use")
                central.scanForPeripherals(withServices: nil, options: nil) // scan nearby available BT devices
            case .resetting:
                print("Bluetooth is resetting")
            @unknown default:
                print("Unknown Bluetooth state")
            }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        let name = peripheral.name ?? "Unknown"
        let uuid = peripheral.identifier
        print(uuid)
        let bleDevice = BLEDevices(name: name, uuid: uuid, peripheral: peripheral)
        
        if checkIfUUIDExist(uuid: uuid.uuidString) == false { //To avoid duplicates in table view
            bleDevices.append(bleDevice)
            // Reload the table view to display the new device.
            listOfDevicesTableView.reloadData()
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
       
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to peripheral \(peripheral.identifier.uuidString)")
        
        makeDeviceConneted(uuid: peripheral.identifier.uuidString)
        
        listOfDevicesTableView.reloadData()
        labelStatus.text = "Connected to peripheral \(peripheral.identifier.uuidString)"
    }

    func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
        //empty
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Failed to connect to peripheral \(peripheral) with error: \(error?.localizedDescription ?? "unknown error")")
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        
        makeDeviceDisconnctedConneted(uuid: peripheral.identifier.uuidString)
        listOfDevicesTableView.reloadData()
        print("Disconnected from peripheral \(peripheral) with error: \(error?.localizedDescription ?? "unknown error")")
        labelStatus.text = "Disconnected from peripheral \(peripheral) with error: \(error?.localizedDescription ?? "unknown error")"

    }
    
    /********************************/
    //helper methods used to keep track of which devices are connected.
    func makeAllDisconncted(){
        for bleDevice in bleDevices {
            bleDevice.isConnected = false
        }
    }
    
    func makeDeviceConneted(uuid: String) {
        for bleDevice in bleDevices {
            if bleDevice.uuid.uuidString == uuid {
                bleDevice.isConnected = true
            }
        }
    }
    
    func makeDeviceDisconnctedConneted(uuid: String) {
        for bleDevice in bleDevices {
            if bleDevice.uuid.uuidString == uuid {
                bleDevice.isConnected = false
            }
        }
    }
    
    func checkIfUUIDExist(uuid: String) -> Bool{
        for bleDevice in bleDevices {
            if bleDevice.uuid.uuidString == uuid {
                return true
            }
        }
        return false
    }
}
    


//peripheral: The peripheral object that was discovered.
//advertisementData: A dictionary containing any advertisement data that was received with the peripheral.
//RSSI: The received signal strength indicator (RSSI) of the peripheral.

