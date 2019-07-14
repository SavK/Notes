//
//  Note.swift
//  Notes
//
//  Created by Savonevich Constantine on 6/24/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import UIKit

enum Importance: String {
    case unimportant
    case normal
    case important
}

struct Note {
    let title: String
    let content: String
    let color: UIColor
    let importance: Importance.RawValue
    let selfDestructionDate: Date?
    let uid: String
    
    init(title: String,
         content: String,
         importance: Importance,
         color: UIColor = UIColor.white,
         selfDestructionDate: Date? = nil,
         uid: String = UUID().uuidString)
    {
        self.title = title
        self.content = content
        self.importance = importance.rawValue
        self.color = color
        self.selfDestructionDate = selfDestructionDate
        self.uid = uid
    }
}
