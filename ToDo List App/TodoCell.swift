//
//  TodoCell.swift
//  ToDo List App
//
//  Created by SHUAA on 04/05/1444 AH.
//

import UIKit

class TodoCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var todoImage: UIImageView!
    @IBOutlet weak var todoCreationLabel: UILabel!
    @IBOutlet weak var todoTitleLabel: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
