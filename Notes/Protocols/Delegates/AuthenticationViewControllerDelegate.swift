//
//  AuthenticationViewControllerDelegate.swift
//  Notes
//
//  Created by Savonevich Constantine on 8/10/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

protocol AuthenticationViewControllerDelegate: class {
    func handleTokenChanged(token: String)
}
