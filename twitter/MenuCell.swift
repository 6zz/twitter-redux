//
//  MenuCell.swift
//  twitter
//
//  Created by Shawn Zhu on 9/20/15.
//  Copyright © 2015 Shawn Zhu. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    @IBOutlet weak var linkLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension MenuCell {
    func setLink(name: String) {
        linkLabel.text = name
    }
}