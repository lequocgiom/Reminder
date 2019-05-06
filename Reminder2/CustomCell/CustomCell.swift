//
//  CustomCell.swift
//  Reminder2
//
//  Created by Le Trung on 5/4/19.
//  Copyright © 2019 Le Trung. All rights reserved.
//

import UIKit

protocol CustomCellDelegate: class {
    func detail(_ cell: CustomCell, didTap detailButton: UIButton)
    func checkChange(_ cell: CustomCell, didTap checkButton: UIButton)
}

class CustomCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var detailButton: UIButton!
    
    weak var delegate: CustomCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(title: String, delegate: CustomCellDelegate) {
        label.text = title
        self.delegate = delegate
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(hexString: "#cc8e35")
        self.selectedBackgroundView = bgColorView
    }
    
    @IBAction func detailAction(_ button: UIButton) {
        delegate?.detail(self, didTap: button)
    }
    
    @IBAction func checkButtonTapped(_ button: UIButton) {
        delegate?.checkChange(self, didTap: button)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
