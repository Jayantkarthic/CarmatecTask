//
//  String+CLAdditions.swift
//  CarmatecTask
//
//  Created by Jayantkarthic on 08/05/24.
//

import Foundation


public extension String {

    func empty() -> Bool {
        var isEmpty = true;
        let temporaryString: String = self .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if (temporaryString.count > 0) {
            isEmpty = false;
        }
        return isEmpty;
    }
    
    func isEmptyOrWhitespace() -> Bool {
            if(self.isEmpty) {
                return true
            }
            return (self.trimmingCharacters(in: NSCharacterSet.whitespaces) == "")
    }
    
    func validEmail() -> Bool {
        let emailReges: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        let predicate: NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailReges)
        let isValid = predicate.evaluate(with: self)
        return isValid;
    }
}
