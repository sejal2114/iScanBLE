//
//  DeviceNameTableViewCell.swift
//  iScanBLE
//
//  Created by Sejal on 10/04/23.
//

import UIKit
import CoreBluetooth
class DeviceNameTableViewCell: UITableViewCell {

    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var deviceNameLabel: UILabel!
    
    @IBAction func connecteTapped(_ sender: UIButton) {
        onConnectButtonTapped?()  // is a callback function that will be triggered when the user taps the connect button in the table view cell.
     connectButton.setTitle("connected", for: .normal)
    }
    
    var onConnectButtonTapped: (() -> Void)?  // declare a closure to handle button tap
      
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func checkIfDeviceIsConneted(isConnected: Bool){
        if isConnected == true {            // updates the title of the connect button accordingly.
            connectButton.setTitle("Connected", for: .normal)
        } else {
            connectButton.setTitle("Not Connected", for: .normal)
        }
        
    }
    
}
