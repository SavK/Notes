//
//  EditNoteViewController+CustomMethods.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/18/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import UIKit

// MARK: - Custom Methods
extension EditNoteViewController {
    
    /// Unselect all squares and select input square
    func pickSquare(square: ColorSquareView?) {
        whiteSquare.isSelect = false
        redSquare.isSelect = false
        greenSquare.isSelect = false
        customSquare.isSelect = false
        square?.isSelect = true
    }
    
    func findSelectedColor() -> UIColor? {
        let squares = [redSquare, greenSquare, whiteSquare, customSquare]
        guard let square = squares.first(where: { $0 != nil && $0!.isSelect }) else { return nil }
        return square?.squareColor
    }
}
