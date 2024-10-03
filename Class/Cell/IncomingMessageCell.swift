//
//  IncomingMessageCell.swift
//  ChatApp
//
//  Created by Santhosh on 30/09/24.
//

import UIKit

class IncomingMessageCell: UITableViewCell {

    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bubbleView.layer.cornerRadius = 15
        bubbleView.backgroundColor = UIColor.systemBlue
        messageLabel.textColor = .white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
