//
//  NoteExtension.swift
//  Notes
//
//  Created by Savonevich Constantine on 6/27/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import UIKit

// MARK: - JSON
extension Note {
    
    static func parse(json: [String: Any]) -> Note? {
        
        // MARK: - Stored Porperties
        var color = UIColor.white
        var importance = Importance.normal
        var selfDestructionDate: Date?
        
        /// Validating values type
        guard let title = json["title"] as? String else { return nil }
        guard let content = json["content"] as? String else { return nil }
        guard let uid = json["uid"] as? String else { return nil }
        
        /// Change color if it present at dictionary
        if let colorArray = json["color"] as? [CGFloat] {
            
            color = UIColor.init(red: colorArray[RGBA.red.index],
                                 green: colorArray[RGBA.green.index],
                                 blue: colorArray[RGBA.blue.index],
                                 alpha: colorArray[RGBA.alpha.index])
        }
        
        /// Change selfDestructionDate vlaue if it present at dictionary
        if let timeIntervalSince1970 = json["selfDestructionDate"] as? Double {
            selfDestructionDate = Date(timeIntervalSince1970: timeIntervalSince1970)
        }
        /// Change importance value if it present at dictionary
        if let importanceValue = json["importance"] as? String {
            importance = Importance(rawValue: importanceValue)!
        }
        
        return Note(title: title,
                    content: content,
                    importance: importance,
                    color: NoteColor(currentColor: color),
                    selfDestructionDate: selfDestructionDate,
                    uid: uid)
        
    }
    /// Dictionary for parsing
    var json: [String: Any] {
        
        var dictionary = [String: Any]()
        
        dictionary["title"] = self.title
        dictionary["content"] = self.content
        dictionary["uid"] = self.uid
        
        /// If color not white push into dictionary
        if self.color.currentColor != UIColor.white {
            dictionary["color"] = createColorArray()
        }
        
        /// If importance not normal push into dictionary
        if self.importance.rawValue != Importance.normal.rawValue {
            dictionary["importance"] = self.importance
        }
        /// If selfDestructionDate != nil push into dictionary
        if let selfDestructionDate = self.selfDestructionDate {
            dictionary["selfDestructionDate"] = Double(selfDestructionDate.timeIntervalSince1970)
        }
        return dictionary
    }
        
    func createColorArray() -> [CGFloat] {
        var colorArray = [CGFloat]()
        colorArray.append(self.color.red)
        colorArray.append(self.color.green)
        colorArray.append(self.color.blue)
        colorArray.append(self.color.alpha)
        return colorArray
    }
}
