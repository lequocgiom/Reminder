//
//  CustomCell.swift
//  Reminder2
//
//  Created by Le Trung on 5/4/19.
//  Copyright © 2019 Le Trung. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

//    @IBOutlet weak var checkLabel: UILabel!
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var detailButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
