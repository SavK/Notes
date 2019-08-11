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
        for square in squares {
            if square != nil, square!.isSelect {
                return square?.squareColor
            }
        }
        return nil
    }
    
    func getHsbColor(of color: UIColor) -> [CGFloat] {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        color.getHue(&h, saturation: &s, brightness: &b, alpha: nil)
        return [h, 1 - s, b]
    }
}
