//
//  Alert Handler.swift
//  CarmatecTask
//
//  Created by Jayantkarthic on 08/05/24.
//

import Foundation
import UIKit

public var sharedHandlerInsatnce = AlertHandler()

public class AlertHandler: NSObject {
    
    // MARK: Local Variable
    public final class sharedInstance {
        private init() { }
        static let shared = AlertHandler()
    }
    
    public func showAlert(alertMessage:String,title:String,contoller:UIViewController,successBlock: @escaping (_ isSuccess:Bool) -> Void) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title , message: alertMessage , preferredStyle: .alert)
            let ok  = UIAlertAction(title: Constants.AlertMessage.alertButtonOKTitle, style: .default) { (UIAlertAction) in
                successBlock(true)
            }
            alert.addAction(ok)
            contoller.present(alert, animated: true, completion: nil);
        }
    }
    
    public func showAlertOKCancel(alertMessage:String,title:String,contoller:UIViewController,successBlock: @escaping (_ isSuccess:Bool) -> Void) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title , message: alertMessage , preferredStyle: .alert)
            let ok  = UIAlertAction(title: Constants.AlertMessage.alertButtonOKTitle, style: .default) { (UIAlertAction) in
                successBlock(true)
            }
            let cancel  = UIAlertAction(title: Constants.AlertMessage.cancel, style: .default) { (UIAlertAction) in
                
            }
            alert.addAction(ok)
            alert.addAction(cancel)
            contoller.present(alert, animated: true, completion: nil);
        }
    }
}
