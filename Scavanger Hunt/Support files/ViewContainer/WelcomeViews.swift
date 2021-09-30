//
//  WelcomeViews.swift
//  Scavanger Hunt
//
//  Created by Caleb Mesfien on 7/10/20.
//  Copyright © 2020 Caleb Mesfien. All rights reserved.
//

import UIKit
import SCSDKLoginKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import AuthenticationServices


var BitmojiImage: String?


protocol logedIn {
    func user(signedIn: Bool)
}


class WelcomeView: UIViewController, logedIn {
    var ref = Database.database().reference()
    func user(signedIn: Bool) {
        if signedIn{
            navigationController?.pushViewController(ViewController(), animated: true)
        }
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
         
        
        constraintContainer()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    
    fileprivate let seekIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "SHLogoSlim")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    fileprivate let backgroundImage: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "WelcomeBackground")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
        
    }()
    

    
    fileprivate let appleLogin: UIButton = {
        let button  = UIButton()

        button.backgroundColor = .black


        button.addTarget(self, action: #selector(PhoneNumberPressed), for: .touchUpInside)
        button.setAttributedTitle(NSAttributedString(string: "Continue with Apple", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]), for: .normal)



        button.layer.cornerRadius = 22.0

//        button.layer.shadowColor = UIColor.lightGray.cgColor
//        button.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
//        button.layer.shadowRadius = 8.0
//        button.layer.shadowOpacity = 0.3
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    
    
//    fileprivate let appleLogin: ASAuthorizationAppleIDButton = {
//        let button  = ASAuthorizationAppleIDButton()
//
////        button.s
//        button.backgroundColor = .white
//        button.layer.cornerRadius = 22.0
//        button.clipsToBounds = true
//        button.layer.shadowColor = UIColor.lightGray.cgColor
//        button.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
//        button.layer.shadowRadius = 8.0
//        button.layer.shadowOpacity = 0.3
//        button.addTarget(self, action:#selector(PhoneNumberPressed), for: .touchUpInside)
//        button.translatesAutoresizingMaskIntoConstraints = false
//       return button
//    }()
//
    
    
    
    
    
    
//    let snapLoginButton: SCSDKLoginButton={
//        let button = SCSDKLoginButton()
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
    fileprivate let snapLoginButton: UIButton = {
        let button  = UIButton()

        button.backgroundColor = UIColor(red: 1.00, green: 0.99, blue: 0.00, alpha: 1.00)


        button.addTarget(self, action: #selector(SnapLoginPressed), for: .touchUpInside)
        button.setAttributedTitle(NSAttributedString(string: "Continue with Snapchat", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]), for: .normal)



        button.layer.cornerRadius = 22.0
//        button.layer.shadowColor = UIColor.lightGray.cgColor
//        button.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
//        button.layer.shadowRadius = 8.0
//        button.layer.shadowOpacity = 0.3
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    fileprivate let snapGhostImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "SnapGhost")
        
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
       return imageView
    }()
    fileprivate let appleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "appleIconImage")
        
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
       return imageView
    }()

    fileprivate let TermsOfServices: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.setAttributedTitle(NSAttributedString(string: "By signing up you agree to the terms of service and privacy policy", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]), for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
       return button
    }()
    
    fileprivate let mainLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.attributedText = NSAttributedString(string: "Complete challenges with friends.", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.90, green: 0.90, blue: 0.90, alpha: 1), NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 25)])
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    func constraintContainer(){
//        view.addSubview(backgroundImage)
        view.addSubview(seekIcon)
        view.addSubview(mainLabel)
        view.addSubview(appleLogin)
            appleLogin.addSubview(appleImageView)
        view.addSubview(snapLoginButton)
            snapLoginButton.addSubview(snapGhostImageView)
        view.addSubview(TermsOfServices)
        
        
        NSLayoutConstraint.activate([
            seekIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            seekIcon.widthAnchor.constraint(equalToConstant: 0.08*2560),
            seekIcon.heightAnchor.constraint(equalToConstant: 0.08*1280),
            seekIcon.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height/5),
            
//            backgroundImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
////            backgroundImage.bottomAnchor.constraint(equalTo: snapLoginButton.topAnchor),
//            backgroundImage.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
//
            mainLabel.topAnchor.constraint(equalTo: seekIcon.bottomAnchor, constant: 8),
            mainLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            mainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            
            snapLoginButton.bottomAnchor.constraint(equalTo: appleLogin.topAnchor, constant: -16),
            snapLoginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 45),
            snapLoginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -45),
            snapLoginButton.heightAnchor.constraint(equalToConstant: 50),
            
            appleLogin.bottomAnchor.constraint(equalTo: TermsOfServices.topAnchor, constant: -15),
            appleLogin.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 45),
            appleLogin.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -45),
            appleLogin.heightAnchor.constraint(equalToConstant: 50),
            
            appleImageView.leadingAnchor.constraint(equalTo: appleLogin.leadingAnchor, constant: 15),
            appleImageView.heightAnchor.constraint(equalToConstant: 25),
            appleImageView.widthAnchor.constraint(equalToConstant: 25),
            appleImageView.centerYAnchor.constraint(equalTo: appleLogin.centerYAnchor),
            
                snapGhostImageView.leadingAnchor.constraint(equalTo: snapLoginButton.leadingAnchor, constant: 15),
                snapGhostImageView.heightAnchor.constraint(equalToConstant: 25),
                snapGhostImageView.widthAnchor.constraint(equalToConstant: 25),
                snapGhostImageView.centerYAnchor.constraint(equalTo: snapLoginButton.centerYAnchor),
                
            TermsOfServices.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            TermsOfServices.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 55),
            TermsOfServices.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -55),
            
        ])
    }
    
    @objc func SnapLoginPressed(){
//        vc.delegate = self
//        SCSDKLoginClient.login(from: self, completion: { success, error in
        print("selected")
        SCSDKLoginClient.login(from: self.navigationController!) { (success, error) in

            if let error = error {
                print(error.localizedDescription)
                return
            }

            print("before done")
            if success {
                
                print("done")
                self.fetchSnapUserInfo()
            }
        }

    }
    
    
        @objc func PhoneNumberPressed(){
//            let vc = PhoneNumberVerification()
//            vc.delegate = self
//            navigationController?.present(vc, animated: true, completion: nil)
            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.requestedScopes = [.fullName, .email]
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
        }
    

    
    private func fetchSnapUserInfo(){
        let graphQLQuery = "{me{displayName bitmoji{avatar} externalId}}"
        let variables = ["page": "bitmoji"]

        SCSDKLoginClient.fetchUserData(withQuery: graphQLQuery, variables: variables, success: { (resources: [AnyHashable: Any]?) in
            guard let resources = resources,
                let data = resources["data"] as? [String: Any],
                let me = data["me"] as? [String: Any] else { return }

            let displayName = me["displayName"] as? String
            var bitmojiAvatarUrl: String?

            if let bitmoji = me["bitmoji"] as? [String: Any] {
                bitmojiAvatarUrl = bitmoji["avatar"] as? String
            }
            var externalID = me["externalId"] as? String
            BitmojiImage = bitmojiAvatarUrl!
            userDefault.set(bitmojiAvatarUrl, forKey: "BitmojiURL")

            externalID?.removeAll { $0 == "/" }
            userDefault.set(externalID, forKey: "externalID")
            userDefault.set(displayName, forKey: "displayName")

            self.ref.child("user IDs").observeSingleEvent(of: .value) { (DataSnapshot) in
                if DataSnapshot.hasChild(externalID!) == false{
                    self.ref.child("user IDs").child(externalID!).setValue(["username": displayName, "Image URL":bitmojiAvatarUrl])
                }
            }
            print("somethingCool")
            DispatchQueue.main.async {
                userDefault.set(true, forKey: DefualtKey.removeWelcomeView)
                userDefault.set(true, forKey: "LoggedInSnap")
                self.navigationController?.pushViewController(ViewController(), animated: true)
            }


        }, failure: { (error: Error?, isUserLoggedOut: Bool) in
            // handle error
        })
        
    }
    
    
    
    
    
    
    
    
//    func logInToFirebase(){
//        Auth.auth().signIn(withCustomToken: customToken ?? "") { (user, error) in
//          // ...
//        }cv78
//    }

}





extension WelcomeView: ASAuthorizationControllerDelegate{
    private func registerNewAccount(credentials: ASAuthorizationAppleIDCredential) {

        self.ref.child("user IDs").child(userDefault.string(forKey: "externalID")!).setValue(["username": userDefault.string(forKey: "displayName"), "Image URL":"https://sdk.bitmoji.com/render/panel/09da38f4-35c2-4237-b893-368d60103c23-AXU5OE1voTiF5G8H8NIBwt3Bq7ygaw-v1.png?transparent=1&palette=1"])
        
        
        print("Registering new account with user: \(userDefault.string(forKey: "externalID")!) \(String(describing: credentials.email)) \(String(describing: credentials.fullName))")
        userDefault.set(true, forKey: DefualtKey.removeWelcomeView)
        userDefault.set(false, forKey: "LoggedInSnap")
        userDefault.set(nil, forKey: "BitmojiURL")
        self.navigationController?.pushViewController(ViewController(), animated: true)
    }
    private func signInWithUserAndPassword(credentials: ASAuthorizationAppleIDCredential) {

        print("Signing in with existing account with user: \(credentials.user)")
        ref.child("user IDs").child(userDefault.string(forKey: "externalID")!).observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let name = value!["username"] as! String
            
            userDefault.set(name, forKey: "displayName")
        }
        userDefault.set(true, forKey: DefualtKey.removeWelcomeView)
        userDefault.set(false, forKey: "LoggedInSnap")
        userDefault.set(nil, forKey: "BitmojiURL")

        self.navigationController?.pushViewController(ViewController(), animated: true)
    }
    
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    
    
    
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIdCredential as ASAuthorizationAppleIDCredential:
            var userId = appleIdCredential.user
//            var name = appleIdCredential.fullName?.givenName
            userId.removeAll { $0 == "." }
            userDefault.setValue(userId, forKey: "externalID")
            userDefault.set(appleIdCredential.fullName?.givenName, forKey: "displayName")

            if let _ = appleIdCredential.email, let _ = appleIdCredential.fullName {
                registerNewAccount(credentials: appleIdCredential)
            }else{
                signInWithUserAndPassword(credentials: appleIdCredential)
            }
            print(userId, userDefault.object(forKey: "externalID"), userDefault.object(forKey: "displayName"))
        default:
            break
        }
    }
}
extension WelcomeView: ASAuthorizationControllerPresentationContextProviding{
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    
}








var continueButtonBottom: NSLayoutConstraint?
var continueButtonTop: NSLayoutConstraint?



class PhoneNumberVerification: UIViewController, logedIn {
    func user(signedIn: Bool) {
        if signedIn{
            dismiss(animated: true) {
                self.delegate.user(signedIn: true)
            }
        }
    }
    
    var delegate: logedIn!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        textFieldApearing()
        constraintContainer()
    }
    
    fileprivate let bitmojiImage: UIImageView = {
       let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    fileprivate let welcomeLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.attributedText = NSAttributedString(string: "Welcome to Seek!", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)])
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    fileprivate let mobileNumberLabel: CustomLabel = {
        let label = CustomLabel()
        label.attributedText = NSAttributedString(string: "MOBILE NUMBER", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    fileprivate let textFieldView: CustomView = {
       let view = CustomView()
       view.backgroundColor = .white
        
        view.layer.cornerRadius = 15
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 7.0)
        view.layer.shadowRadius = 8.0
        view.layer.shadowOpacity = 0.2
       view.translatesAutoresizingMaskIntoConstraints = false
       return view
    }()

    fileprivate let textField: UITextField = {
       let field = UITextField()
        field.attributedText = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)])
        field.keyboardType = .phonePad
        field.tintColor = .lightGray

        field.translatesAutoresizingMaskIntoConstraints = false
       return field
    }()
    
    fileprivate let reasonForNumber: CustomLabel = {
        let label = CustomLabel()
        label.attributedText = NSAttributedString(string: "To verify the account a SMS will be sent to this number.", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    fileprivate let skipButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "Skip", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15), NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]), for: .normal)
        button.addTarget(self, action: #selector(skipButtonSelected), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate let continueButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 1.00, green: 0.99, blue: 0.00, alpha: 1.00)
        button.setAttributedTitle(NSAttributedString(string: "Continue",  attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)]), for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(ContinueButtonSelected), for: .touchUpInside)
        
        button.layer.cornerRadius = 15
        button.layer.shadowColor = UIColor.lightGray.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        button.layer.shadowRadius = 10.0
        button.layer.shadowOpacity = 0.3
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate let continueImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "rightArrow")
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private func constraintContainer(){
        view.addSubview(bitmojiImage)
        view.addSubview(welcomeLabel)
        view.addSubview(mobileNumberLabel)
        
        view.addSubview(textFieldView)
        textFieldView.addSubview(textField)
        
        view.addSubview(reasonForNumber)
        
        view.addSubview(continueButton)
        continueButton.addSubview(continueImageView)
//        view.addSubview(skipButton)

        continueButtonBottom = continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        
        NSLayoutConstraint.activate([
            bitmojiImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            bitmojiImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.19),
            bitmojiImage.heightAnchor.constraint(equalTo: bitmojiImage.widthAnchor),
            bitmojiImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            welcomeLabel.topAnchor.constraint(equalTo: bitmojiImage.bottomAnchor, constant: 8),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            mobileNumberLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: view.frame.height*0.05),
            mobileNumberLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mobileNumberLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mobileNumberLabel.heightAnchor.constraint(equalToConstant: mobileNumberLabel.intrinsicContentSize.height),
            
            textFieldView.topAnchor.constraint(equalTo: mobileNumberLabel.bottomAnchor, constant: 8),
            textFieldView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.65),
            textFieldView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textFieldView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.050),
            
            textField.topAnchor.constraint(equalTo: textFieldView.topAnchor, constant: 3),
            textField.leadingAnchor.constraint(equalTo: textFieldView.leadingAnchor, constant: 8),
            textField.trailingAnchor.constraint(equalTo: textFieldView.trailingAnchor, constant: -8),
            textField.bottomAnchor.constraint(equalTo: textFieldView.bottomAnchor, constant: -3),
            
            reasonForNumber.topAnchor.constraint(equalTo: textFieldView.bottomAnchor, constant: 16),
            reasonForNumber.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            reasonForNumber.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            reasonForNumber.heightAnchor.constraint(equalToConstant: mobileNumberLabel.intrinsicContentSize.height*2),
            
            
            continueButton.widthAnchor.constraint(equalToConstant: 150),
            continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            continueButton.heightAnchor.constraint(equalToConstant: 40),
            
            continueImageView.trailingAnchor.constraint(equalTo: continueButton.trailingAnchor, constant: -15),
            continueImageView.heightAnchor.constraint(equalTo: continueButton.heightAnchor, multiplier: 0.5),
            continueImageView.widthAnchor.constraint(equalTo: continueImageView.heightAnchor),
            continueImageView.centerYAnchor.constraint(equalTo: continueButton.centerYAnchor),
            

        ])
    }
    func textFieldApearing(){
            self.textField.becomeFirstResponder()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardWillChange(notification: Notification){
        let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        UIView.animate(withDuration: 1) {
            self.continueButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -keyboardRect.height-40).isActive = true
        }

    }
    
    @objc func ContinueButtonSelected(){
        guard let phoneNumber = textField.text else { return }
        PhoneAuthProvider.provider().verifyPhoneNumber("+1"+phoneNumber, uiDelegate: nil) { (verificationId, error) in
            if error == nil{
                print(verificationId)
                UserDefaults.standard.set(verificationId, forKey: "authVerificationID")
                
                let view = OTPVerificationView()
                view.delegate = self
                self.present(view, animated: true)
                
            }else{
                print("THERE WAS AN ERROR!", error?.localizedDescription)
            }
        }

    }
    
    @objc func skipButtonSelected(){
                delegate.user(signedIn: true)
                dismiss(animated: true, completion: nil)
    }
        
    
}





class OTPVerificationView: UIViewController{
        var delegate: logedIn!
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .white
            
            textFieldApearing()
            constraintContainer()
        }
        

        
        fileprivate let mobileNumberLabel: CustomLabel = {
            let label = CustomLabel()
            label.attributedText = NSAttributedString(string: "SMS Verification Code", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        
        fileprivate let textFieldView: CustomView = {
           let view = CustomView()
           view.backgroundColor = .white
            
            view.layer.cornerRadius = 15
            view.layer.shadowColor = UIColor.lightGray.cgColor
            view.layer.shadowOffset = CGSize(width: 0.0, height: 7.0)
            view.layer.shadowRadius = 8.0
            view.layer.shadowOpacity = 0.2
           view.translatesAutoresizingMaskIntoConstraints = false
           return view
        }()

        fileprivate let textField: UITextField = {
           let field = UITextField()
            field.attributedText = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)])
            field.keyboardType = .phonePad
            field.tintColor = .lightGray

            field.translatesAutoresizingMaskIntoConstraints = false
           return field
        }()
        
        fileprivate let reasonForNumber: CustomLabel = {
            let label = CustomLabel()
            label.attributedText = NSAttributedString(string: "To verify number, type in the verification code that was sent via SMS", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            label.textAlignment = .center
            label.numberOfLines = 2
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        
        fileprivate let continueButton: UIButton = {
            let button = UIButton()
            button.backgroundColor = UIColor(red: 1.00, green: 0.99, blue: 0.00, alpha: 1.00)
            button.setAttributedTitle(NSAttributedString(string: "Done",  attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)]), for: .normal)
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.addTarget(self, action: #selector(ContinueButtonSelected), for: .touchUpInside)
            
            button.layer.cornerRadius = 15
            button.layer.shadowColor = UIColor.lightGray.cgColor
            button.layer.shadowOffset = CGSize(width: 0.0, height: 7.0)
            button.layer.shadowRadius = 10.0
            button.layer.shadowOpacity = 0.3
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        fileprivate let continueImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "rightArrow")
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        
        private func constraintContainer(){
            view.addSubview(mobileNumberLabel)
            
            view.addSubview(textFieldView)
            textFieldView.addSubview(textField)
            
            view.addSubview(reasonForNumber)
            
            view.addSubview(continueButton)

            continueButtonBottom = continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
            NSLayoutConstraint.activate([

//
                mobileNumberLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height*0.05),
                mobileNumberLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                mobileNumberLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                mobileNumberLabel.heightAnchor.constraint(equalToConstant: mobileNumberLabel.intrinsicContentSize.height),
                
                textFieldView.topAnchor.constraint(equalTo: mobileNumberLabel.bottomAnchor, constant: 8),
                textFieldView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.65),
                textFieldView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                textFieldView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.050),
                
                textField.topAnchor.constraint(equalTo: textFieldView.topAnchor, constant: 3),
                textField.leadingAnchor.constraint(equalTo: textFieldView.leadingAnchor, constant: 8),
                textField.trailingAnchor.constraint(equalTo: textFieldView.trailingAnchor, constant: -8),
                textField.bottomAnchor.constraint(equalTo: textFieldView.bottomAnchor, constant: -3),
                
                reasonForNumber.topAnchor.constraint(equalTo: textFieldView.bottomAnchor, constant: 16),
                reasonForNumber.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
                reasonForNumber.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
                reasonForNumber.heightAnchor.constraint(equalToConstant: mobileNumberLabel.intrinsicContentSize.height*2),
                
                
                continueButton.widthAnchor.constraint(equalToConstant: 150),
                continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                continueButton.heightAnchor.constraint(equalToConstant: 40),
                

            ])
        }
        func textFieldApearing(){
                self.textField.becomeFirstResponder()
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        }
        
        @objc func keyboardWillChange(notification: Notification){
            let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            
            UIView.animate(withDuration: 1) {
                self.continueButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -keyboardRect.height-16).isActive = true
            }

        }
        
        @objc func ContinueButtonSelected(){
            guard let OTPCode = textField.text else { return }
            let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")!

            let credential = PhoneAuthProvider.provider().credential(
                withVerificationID: verificationID,
            verificationCode: OTPCode)
            
            
            Auth.auth().signIn(with: credential) { (success, error) in
                if error == nil {
                    print(success, "user Signed in...")
                    self.dismiss(animated: true, completion: {
                        self.delegate.user(signedIn: true)
                    })
                } else {
                    print("Something went wrong... \(error?.localizedDescription)")
                }
            }
    }
    
}












extension UIView{
    func addConstraintsWithFormat(format: String, views: UIView...){
        var viewDictionary: Dictionary = [String: UIView]()
        
        for (index, view) in views.enumerated(){
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewDictionary))
    }
}

class CustomView: UIView {
    override var intrinsicContentSize: CGSize {
        let intrinsic = super.intrinsicContentSize
        return CGSize(width: intrinsic.width, height: intrinsic.height)
    }
}


class CustomLabel: UILabel {
    override var intrinsicContentSize: CGSize {
        let intrinsic = super.intrinsicContentSize
        return CGSize(width: intrinsic.width, height: intrinsic.height)
    }
}

class CustomImageView: UIImageView {
    override var intrinsicContentSize: CGSize {
        let intrinsic = super.intrinsicContentSize
        return CGSize(width: intrinsic.width, height: intrinsic.height)
    }
}



extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}



var vSpinner : UIView?
 
extension UIViewController {
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
//        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.)
        let ai = UIActivityIndicatorView.init(style: .large)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
}
