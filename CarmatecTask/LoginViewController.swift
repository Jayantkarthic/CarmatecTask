//
//  LoginViewController.swift
//  CarmatecTask
//
//  Created by Jayantkarthic on 08/05/24.
//

import UIKit
import AuthenticationServices
import GoogleSignIn

@available(iOS 13.0, *)
class LoginViewController: UIViewController {

    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
   
        hideKeyboardWhenTappedAround()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        emailTxt.text = ""
        passwordTxt.text = ""
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
   
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    
    @IBAction func signInWithGoogle(_ sender: Any) {
        // Start the sign in flow!
           GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, err in

               if let error = err {
                   print(error)
                   return
               }

               guard
                   let authentication = signInResult?.user,
                   let idToken = authentication.idToken?.tokenString
               else {
                   return
               }
               
               let user = signInResult?.user

               let emailAddress = user?.profile?.email

               let fullName = user?.profile?.name
               let givenName = user?.profile?.givenName
               let familyName = user?.profile?.familyName
               print(givenName,familyName)
               UserDefaults.standard.set(fullName, forKey: "username") //setObject
               UserDefaults.standard.set(emailAddress, forKey: "email") //setObject
               
               DispatchQueue.main.async {
                   
                   AlertHandler.sharedInstance.shared.showAlert(alertMessage: "Thanks for signing in with google", title:"SUCCESS", contoller: self, successBlock: { (isValid) in
                                                  
                           let storyboard = UIStoryboard(name: "Main", bundle: nil)
                           guard let viewController = storyboard.instantiateViewController(withIdentifier: "MapboxViewController") as? MapboxViewController else {
                               return
                           }
                           guard let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController else {
                               return
                           }
                           navigationController.pushViewController(viewController, animated: true)
                       
                   })
               }

           }
           
           
       }
    
    
    
    // MARK: Login
    @IBAction func logInButtonPressAction(_ sender: UIButton) {
        
        let emailStr = emailTxt.text ?? ""
        let password = passwordTxt.text ?? ""
        
     
         if emailStr.count == 0 {
             AlertHandler.sharedInstance.shared.showAlert(alertMessage: Constants.AlertMessage.alertMessageEmailEmpty, title:"CarmatecTask", contoller: self, successBlock: { (isValid) in
             })
        }
        else if password.count == 0 {
            AlertHandler.sharedInstance.shared.showAlert(alertMessage: Constants.AlertMessage.alertMessagePasswordEmpty, title:"CarmatecTask", contoller: self, successBlock: { (isValid) in
            })
        }
        else if !emailStr.validEmail() {
            AlertHandler.sharedInstance.shared.showAlert(alertMessage: Constants.AlertMessage.alertMessagePasswordValid, title:"CarmatecTask", contoller: self, successBlock: { (isValid) in
            })
        }
        else{
        }
        var message = ""
        
        if emailTxt.text == "demo@gmail.com" && passwordTxt.text == "123"{
            message = Constants.AlertMessage.alertMessageLoginSuccess
        }else
        {
            message = Constants.AlertMessage.alertMessageLoginFailed
        }
        DispatchQueue.main.async {
            
            AlertHandler.sharedInstance.shared.showAlert(alertMessage: message, title:"CarmatecTask", contoller: self, successBlock: { (isValid) in
                
                if message == Constants.AlertMessage.alertMessageLoginSuccess{
                                        
                    UserDefaults.standard.set("Demo", forKey: "username") //setObject
                    UserDefaults.standard.set("demo@gmail.com", forKey: "email") //setObject

                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    guard let viewController = storyboard.instantiateViewController(withIdentifier: "MapboxViewController") as? MapboxViewController else {
                        return
                    }
                    guard let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController else {
                        return
                    }
                    navigationController.pushViewController(viewController, animated: true)
                }
            })
        }
            
        self.view.endEditing(true)
        
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil {

            return
        }
        debugPrint(user.profile?.email ?? "")
        debugPrint(user.profile?.name ?? "")
        debugPrint(user.profile?.givenName ?? "")
        debugPrint(user.profile?.familyName ?? "")
          
    }
      
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
      
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
          
    }
      
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
}

