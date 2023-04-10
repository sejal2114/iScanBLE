//
//  ViewController.swift
//  iScanBLE

//  Created by Sejal on 7/04/23.
//

import UIKit
import CoreBluetooth
class ViewController: UIViewController{
    
    @IBOutlet weak var listOfDevicesTableView: UITableView!
    
    var device = ["sejal's iPhone" , "Samsung" , "watch"]
    override func viewDidLoad() {
    super.viewDidLoad()
        
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
extension ViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return device.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceNameTableViewCell")as! DeviceNameTableViewCell
        cell.deviceNameLabel.text = device[indexPath.row]
        return cell
    }
    
}
