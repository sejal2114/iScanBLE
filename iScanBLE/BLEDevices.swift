//
//  BLEDevices.swift
//  iScanBLE
//
//  Created by Sejal on 10/04/23.
//

import Foundation
import CoreBluetooth
class BLEDevices {
    var name: String
    var uuid: UUID
    var peripheral: CBPeripheral
    var isConnected = false
    
    init(name: String, uuid: UUID, peripheral: CBPeripheral) {
        self.name = name
        self.uuid = uuid
        self.peripheral = peripheral
    }
}

