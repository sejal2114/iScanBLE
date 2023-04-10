//
//  DeviceNameTableViewCell.swift
//  iScanBLE
//
//  Created by Sejal on 10/04/23.
//

import UIKit

class DeviceNameTableViewCell: UITableViewCell {

    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var deviceNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
