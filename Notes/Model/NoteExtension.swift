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
            
            color = UIColor.init(red: colorArray[0],
                                 green: colorArray[1],
                                 blue: colorArray[2],
                                 alpha: colorArray[3])
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
                    color: color,
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
        if self.color.rgba != UIColor.white.rgba {
            
            var colorArray = [CGFloat]()
            colorArray.append(self.color.rgba.red)
            colorArray.append(self.color.rgba.green)
            colorArray.append(self.color.rgba.blue)
            colorArray.append(self.color.rgba.alpha)
            
            dictionary["color"] = colorArray
        }
        
        /// If importance not normal push into dictionary
        if self.importance != Importance.normal.rawValue {
            dictionary["importance"] = self.importance
        }
        /// If selfDestructionDate != nil push into dictionary
        if let selfDestructionDate = self.selfDestructionDate {
            dictionary["selfDestructionDate"] = Double(selfDestructionDate.timeIntervalSince1970)
        }
        
        return dictionary
    }
}

// MARK: - Decompose the color value into RGBA
extension UIColor {
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return (red, green, blue, alpha)
    }
}
