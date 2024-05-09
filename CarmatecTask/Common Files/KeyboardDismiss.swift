//
//  KeyboardDismiss.swift
//  CarmatecTask
//
//  Created by Jayantkarthic on 08/05/24.
//

import Foundation
import UIKit

//MARK : To Hide the Keybord click at out side

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
