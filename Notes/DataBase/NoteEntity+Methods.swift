//
//  NoteEntity+Methods.swift
//  Notes
//
//  Created by Savonevich Constantine on 8/18/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import CoreData
import UIKit

extension NoteEntity {
    
    /// Parse Note from NSManagedObject
    var noteFromEntity: Note {
        let colorData = self.color
        let resultColor: UIColor? = getColor(fromData: colorData)
        
        return Note(title: self.title ?? "",
                    content: self.content ?? "",
                    importance: getImportance(self.importance) ?? .normal,
                    color: NoteColor(currentColor: resultColor ?? .white),
                    selfDestructionDate: self.selfDestructionDate,
                    uid: self.uid)
    }
    
    private func getImportance(_ value: String?) -> Importance? {
        guard let value = value else { return nil }
        return Importance(rawValue: value)
    }
    
    private func getColor(fromData data: Data?) -> UIColor? {
        guard let data = data else { return nil }
        
        guard let colorArray = try? JSONDecoder().decode([CGFloat].self, from: data)
            else { return UIColor.white }
        
        let color = UIColor.init(red: colorArray[RGBA.red.index],
                                 green: colorArray[RGBA.green.index],
                                 blue: colorArray[RGBA.blue.index],
                                 alpha: colorArray[RGBA.alpha.index])
        
        return color
    }
}
