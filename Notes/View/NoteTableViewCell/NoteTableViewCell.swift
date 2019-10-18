//
//  NoteTableViewCell.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/21/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    
    @IBOutlet var noteColorView: UIView!
    @IBOutlet var noteTitleLabel: UILabel!
    @IBOutlet var noteContentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        noteColorView.layer.borderColor = UIColor.black.cgColor
        noteColorView.layer.borderWidth = 0.5
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let color = noteColorView.backgroundColor
        super.setHighlighted(highlighted, animated: animated)
        if highlighted {
            noteColorView.backgroundColor = color
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        let color = noteColorView.backgroundColor
        super.setSelected(selected, animated: animated)
        if selected {
            noteColorView.backgroundColor = color
        }
    }
}
