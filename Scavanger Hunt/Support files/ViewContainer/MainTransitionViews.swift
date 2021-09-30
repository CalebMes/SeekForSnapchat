//
//  MainTransitionViews.swift
//  Scavanger Hunt
//
//  Created by Caleb Mesfien on 7/18/20.
//  Copyright © 2020 Caleb Mesfien. All rights reserved.
//

import UIKit
import SCSDKCreativeKit
import SCSDKCoreKit
import SCSDKBitmojiKit
import Lottie
import Firebase
import WebKit
import StoreKit
import FirebaseDatabase


protocol textInputProtocol {
    func textForPost(text: String)
}


class SuggestingPost: UIViewController, SCSDKBitmojiStickerPickerViewControllerDelegate, textInputProtocol, UITextFieldDelegate, UITextViewDelegate{
    func textForPost(text: String) {
        mainLabel.attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22) ])
        viewBeingPosted.heightAnchor.constraint(equalTo: whitePostedView.heightAnchor, constant: 100).isActive = true
    }
    

    
    var delegate: blackViewProtocol?
    var snapAPI: SCSDKSnapAPI?
    var ref = Database.database().reference()
    var KeyFound = String()
    var nameOfGroup = String()

    var moneyMiddle: NSLayoutConstraint?
    var challengeMiddle: NSLayoutConstraint?

    override func viewDidLoad() {

        view.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        super.viewDidLoad()
        snapAPI = SCSDKSnapAPI()

        mainLabel.delegate = self
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (someAction(_:)))
        mainLabel.addGestureRecognizer(gesture)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)


        constraintContainer()
        

        

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)


    }
    
    func bitmojiStickerPickerViewController(_ stickerPickerViewController: SCSDKBitmojiStickerPickerViewController, didSelectBitmojiWithURL bitmojiURL: String, image: UIImage?) {
            bitmojiImageView.image = image
            stickerVC.view.removeFromSuperview()
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.bitmojiImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.bitmojiImageView.transform = CGAffineTransform(translationX: 0, y: 0)
        })
    }
    func bitmojiStickerPickerViewController(_ stickerPickerViewController: SCSDKBitmojiStickerPickerViewController, searchFieldFocusDidChangeWithFocus hasFocus: Bool) {
        
    }
    
    func image(with view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        defer { UIGraphicsEndImageContext() }
        if let context = UIGraphicsGetCurrentContext() {
            view.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            return image
        }
        return nil
    }
    
    
    func yourMethodWhereYouShareToSnapchatFromWithCompletion(completionHandler: (Bool, Error?) ->()) {
        let renderer = UIGraphicsImageRenderer(size: viewBeingPosted.bounds.size)
        let image = renderer.image { ctx in
            viewBeingPosted.drawHierarchy(in: viewBeingPosted.bounds, afterScreenUpdates: true)
        }
        let sticker = SCSDKSnapSticker(stickerImage: image)


        let snap = SCSDKNoSnapContent()
        // Sticker
        snap.sticker = sticker
        // Caption

        // URL
        snap.attachmentUrl = "https://scavenge-162d6.web.app/?type=code&Id=\(KeyFound)"

        snapAPI!.startSending(snap) { error in

            if let error = error {
                print(error.localizedDescription, "this was not done")
            } else {
                // success
            }
        }
    }

    
    
    
    
    
    
    
//                      THIS IS FOR THE STICKER SELECTION
    let stickerVC: SCSDKBitmojiStickerPickerViewController =
           SCSDKBitmojiStickerPickerViewController(config: SCSDKBitmojiStickerPickerConfigBuilder()
               .withShowSearchBar(true)
               .withShowSearchPills(true)
               .withTheme(.light)
               .build()
    )
    
    lazy var contentSize2 = CGSize(width: self.view.frame.width, height: self.view.frame.height)
    lazy var contentSize1 = CGSize(width: self.view.frame.width, height: 500+whitePostedView.frame.height)
    
    
    

    
    
     lazy var scrollView: UIScrollView = {
        let view = UIScrollView(frame: .zero)
        view.bounds = view.bounds
        view.backgroundColor = .clear
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    fileprivate let lottieBackground: AnimationView = {
        let animationView = AnimationView()
        animationView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        animationView.animation = Animation.named("YellowCorner1")
        animationView.loopMode = .loop
        animationView.play()

        animationView.translatesAutoresizingMaskIntoConstraints = false
        return animationView
    }()
    
    
    fileprivate let whiteView: UIView = {
        let view = UIView()
        view.backgroundColor = .white

        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    fileprivate let NotificationView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        view.layer.shadowRadius = 8.0
        view.layer.shadowOpacity = 0.2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    fileprivate let NotificationTitle: UILabel = {
        let textView = UILabel()
        textView.textAlignment = .center
        textView.numberOfLines = 2
        textView.attributedText = NSAttributedString(string: "Send this snap to friends you want to join the group.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)])
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
//                                                  STACKVIEW VIEWS SETUP

    fileprivate let behindStakcView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        

        view.layer.cornerRadius = 15
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        view.layer.shadowRadius = 8.0
        view.layer.shadowOpacity = 0.2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    fileprivate let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    fileprivate let inviteButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = .white
        button.setAttributedTitle(NSAttributedString(string: "Invite", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)]), for: .normal)
        button.addTarget(self, action: #selector(SendToSnap), for: .touchUpInside)

        button.layer.cornerRadius = 15
        button.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate let newHuntButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = .white
                button.setAttributedTitle(NSAttributedString(string: "Hunt", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)]), for: .normal)
        button.addTarget(self, action: #selector(stackViewButtonsSelected2), for: .touchUpInside)

        
        button.layer.cornerRadius = 15
        button.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMaxXMinYCorner]
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    private let shareToSnap: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 252/255, green: 248/255, blue: 0/255, alpha: 1.0)

        button.setAttributedTitle(NSAttributedString(string: "Snap", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 45/255, green: 45/255, blue: 45/255, alpha: 1), NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)]), for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(SendToSnap), for: .touchUpInside)




        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate let continueImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "rightArrow")
//        image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    fileprivate let changeBitmojiView: CustomView  = {
        let view = CustomView()
        view.backgroundColor = .white
        
        view.layer.cornerRadius = 50/2
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        view.layer.shadowRadius = 5.0
        view.layer.shadowOpacity = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let changeBitmoji: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(ChangeBitmojiSelected), for: .touchUpInside)
        button.setImage(UIImage(named: "bitmojiExample"), for: .normal)
        button.layer.cornerRadius = 50/2
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    
    fileprivate let changeTextView: CustomView  = {
        let view = CustomView()
        view.backgroundColor = .white
        
        view.layer.cornerRadius = 50/2
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        view.layer.shadowRadius = 5.0
        view.layer.shadowOpacity = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    
    private let changeText: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(changeTextSelected), for: .touchUpInside)
        button.setImage(UIImage(named: "keyboard"), for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 50/2
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
//                                               THIS IS FOR THE VIEW THAT WILL BE POSTED!
    
    fileprivate let viewBeingPosted: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate let whitePostedView: CustomView = {
        let view = CustomView()
         view.backgroundColor = .white
        
         view.layer.cornerRadius = 22
        
         view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate let bitmojiImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.load(url: URL(string:userDefault.string(forKey: "BitmojiURL")!)!)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    fileprivate let SeekLabelImage: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "SeekLabelImage")

        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    fileprivate let swipeUpButton: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named:"swipeUpArrow")
        imageView.layer.cornerRadius = 8
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    fileprivate let scavangerLabel: UILabel = {
       let label = UILabel()
//        UIColor(red: 23/255, green: 122/255, blue: 242/255)
        label.attributedText = NSAttributedString(string: "Scavenge", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)])
        label.textAlignment = .center


        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    fileprivate let scavangerLabelView: CustomView = {
       let view = CustomView()
//        view.text = UIColor(red: 23/255, green: 122/255, blue: 242/255, alpha: 1.0)
        
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate let mainLabel: UITextView = {
        let label = UITextView()
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        label.textAlignment = .center
        label.attributedText = NSAttributedString(string: "Let's start a game😈", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22),NSAttributedString.Key.paragraphStyle:style])
        label.isScrollEnabled = false
        label.returnKeyType = .done
        label.accessibilityIdentifier = "mainTextView"

        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var mainLabelSelected = false
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: mainLabel.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height{
                constraint.constant = estimatedSize.height
            }
        }
        viewBeingPosted.heightAnchor.constraint(equalTo: whitePostedView.heightAnchor, constant: 100).isActive = true
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if mainLabelSelected{
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
        }
        }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            mainLabelSelected = false
            self.view.frame.origin.y = 0
        }
    }
    
    
    
    
    
    @objc func someAction(_ sender:UITapGestureRecognizer){
        mainLabelSelected = true
        mainLabel.becomeFirstResponder()
    }
    private func constraintContainer(){
        view.addSubview(lottieBackground)
        view.addSubview(scrollView)
        

        view.addSubview(NotificationView)
        NotificationView.addSubview(NotificationTitle)
        
        view.addSubview(whiteView)

        whiteView.addSubview(shareToSnap)
        shareToSnap.addSubview(continueImageView)
        
        whiteView.addSubview(changeBitmojiView)
        changeBitmojiView.addSubview(changeBitmoji)
        
        whiteView.addSubview(changeTextView)
        changeTextView.addSubview(changeText)
        
        whiteView.addSubview(changeText)


        scrollView.addSubview(viewBeingPosted)
        viewBeingPosted.addSubview(whitePostedView)
        whitePostedView.addSubview(bitmojiImageView)
        whitePostedView.addSubview(SeekLabelImage)
        whitePostedView.addSubview(mainLabel)
        whitePostedView.addSubview(swipeUpButton)
        

//                      THIS IS FOR THE STICKER SELECTION


        
        
        NSLayoutConstraint.activate([

            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: whiteView.topAnchor),
            

            NotificationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            NotificationView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            NotificationView.bottomAnchor.constraint(equalTo: whiteView.topAnchor, constant: -16),
            NotificationView.heightAnchor.constraint(equalToConstant: 45),
            
            NotificationTitle.leadingAnchor.constraint(equalTo: NotificationView.leadingAnchor, constant: 8),
            NotificationTitle.trailingAnchor.constraint(equalTo: NotificationView.trailingAnchor, constant: -8),
            NotificationTitle.centerYAnchor.constraint(equalTo: NotificationView.centerYAnchor),
            
            
            
            whiteView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            whiteView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            whiteView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            whiteView.heightAnchor.constraint(equalToConstant: 90),
            
            lottieBackground.topAnchor.constraint(equalTo: view.topAnchor,constant: -8),
            lottieBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lottieBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lottieBackground.heightAnchor.constraint(equalToConstant: 250),
            
            shareToSnap.topAnchor.constraint(equalTo: whiteView.topAnchor, constant: 8),
            shareToSnap.trailingAnchor.constraint(equalTo: whiteView.trailingAnchor, constant: -16),
            shareToSnap.heightAnchor.constraint(equalToConstant: 50),
            shareToSnap.widthAnchor.constraint(equalTo: whiteView.widthAnchor, multiplier: 0.5, constant: -16),

            continueImageView.trailingAnchor.constraint(equalTo: shareToSnap.trailingAnchor, constant: -15),
            continueImageView.heightAnchor.constraint(equalTo: shareToSnap.heightAnchor, multiplier: 0.5),
            continueImageView.widthAnchor.constraint(equalTo: continueImageView.heightAnchor),
            continueImageView.centerYAnchor.constraint(equalTo: shareToSnap.centerYAnchor),
            
            
            changeBitmojiView.centerYAnchor.constraint(equalTo: shareToSnap.centerYAnchor),
            changeBitmojiView.leadingAnchor.constraint(equalTo: whiteView.leadingAnchor, constant: 16),
            changeBitmojiView.heightAnchor.constraint(equalTo: shareToSnap.heightAnchor),
            changeBitmojiView.widthAnchor.constraint(equalTo: shareToSnap.heightAnchor),
            
            
            changeBitmoji.widthAnchor.constraint(equalTo: changeBitmojiView.widthAnchor),
            changeBitmoji.heightAnchor.constraint(equalTo: changeBitmojiView.heightAnchor),
            changeBitmoji.centerYAnchor.constraint(equalTo: changeBitmojiView.centerYAnchor),
            changeBitmoji.centerXAnchor.constraint(equalTo: changeBitmojiView.centerXAnchor),
            
            
            changeTextView.centerYAnchor.constraint(equalTo: shareToSnap.centerYAnchor),
            changeTextView.leadingAnchor.constraint(equalTo: changeBitmoji.trailingAnchor, constant: 16),
            changeTextView.widthAnchor.constraint(equalTo: shareToSnap.heightAnchor),
            changeTextView.heightAnchor.constraint(equalTo: shareToSnap.heightAnchor),
            
            changeText.widthAnchor.constraint(equalTo: changeTextView.widthAnchor, constant: -8),
            changeText.heightAnchor.constraint(equalTo: changeTextView.heightAnchor, constant: -8),
            changeText.centerYAnchor.constraint(equalTo: changeTextView.centerYAnchor),
            changeText.centerXAnchor.constraint(equalTo: changeTextView.centerXAnchor),
            
            

            
            //                                               THIS IS FOR THE VIEW THAT WILL BE POSTED!


            viewBeingPosted.topAnchor.constraint(equalTo: scrollView.centerYAnchor,constant: -100),
            viewBeingPosted.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            viewBeingPosted.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            viewBeingPosted.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -8),

            whitePostedView.topAnchor.constraint(equalTo: viewBeingPosted.topAnchor, constant: 50),
            whitePostedView.bottomAnchor.constraint(equalTo: viewBeingPosted.bottomAnchor),
            whitePostedView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            whitePostedView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.8),

            bitmojiImageView.widthAnchor.constraint(equalToConstant: 100),
            bitmojiImageView.heightAnchor.constraint(equalToConstant: 100),
            bitmojiImageView.leadingAnchor.constraint(equalTo: whitePostedView.leadingAnchor, constant: -30),
            bitmojiImageView.topAnchor.constraint(equalTo: whitePostedView.topAnchor, constant: -50),
            
            SeekLabelImage.topAnchor.constraint(equalTo: whitePostedView.topAnchor, constant: 8),
            SeekLabelImage.widthAnchor.constraint(equalToConstant: 75),
            SeekLabelImage.heightAnchor.constraint(equalToConstant: 37.5),
            SeekLabelImage.trailingAnchor.constraint(equalTo: whitePostedView.trailingAnchor, constant: -8),


            swipeUpButton.bottomAnchor.constraint(equalTo: whitePostedView.bottomAnchor, constant: -8),
            swipeUpButton.widthAnchor.constraint(equalToConstant: 50),
            swipeUpButton.heightAnchor.constraint(equalToConstant: 30),
            swipeUpButton.centerXAnchor.constraint(equalTo: whitePostedView.centerXAnchor),


                        mainLabel.topAnchor.constraint(equalTo: bitmojiImageView.bottomAnchor, constant: 8),
                        mainLabel.heightAnchor.constraint(equalToConstant: 40),

                        mainLabel.widthAnchor.constraint(equalTo: whitePostedView.widthAnchor, multiplier: 0.8),
                        mainLabel.centerXAnchor.constraint(equalTo: whitePostedView.centerXAnchor),
                        mainLabel.centerYAnchor.constraint(equalTo: whitePostedView.centerYAnchor)
        ])
        
        challengeMiddle?.isActive = true
        moneyMiddle?.isActive = true
        
    }
    


    @objc func SendToSnap(){
        yourMethodWhereYouShareToSnapchatFromWithCompletion { (Bool, error) in}

        let id = ref.child("Groups").childByAutoId()
        KeyFound = id.key!
        id.setValue(["Active":["isActive":"false"], "Name":nameOfGroup,"LeaderID":userDefault.string(forKey:"externalID")!,  "bitmoji":userDefault.string(forKey:"BitmojiURL")!])
        let user = id.child("Users").childByAutoId()
        user.setValue(["id":userDefault.string(forKey:"externalID")!, "Name": userDefault.string(forKey:"displayName")!, "Score": 0, "userImage": userDefault.string(forKey:"BitmojiURL")!])

        ref.child("user IDs").child(userDefault.string(forKey:"externalID")!).child("InGroups").childByAutoId().setValue(["key":id.key,"userId":user.key])
        dismiss(animated: true, completion:nil)
        
    }
    
    
    
    @objc func ChangeBitmojiSelected(){
        stickerVC.view.translatesAutoresizingMaskIntoConstraints = false
               stickerVC.delegate = self
        self.addChild(stickerVC)
               view.addSubview(stickerVC.view)
        stickerVC.didMove(toParent: self)

        stickerVC.view.layer.cornerRadius = 22
        stickerVC.view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]

        NSLayoutConstraint.activate([
        stickerVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        stickerVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        stickerVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        stickerVC.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
        ])
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            let space = UIScreen.main.bounds.width-(UIScreen.main.bounds.width*0.8) - 20
            self.bitmojiImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.bitmojiImageView.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width/2-(space), y: -75)
        })
    }
    
    
    @objc func changeTextSelected(){
        mainLabelSelected = true
        mainLabel.becomeFirstResponder()
    }
    
    @objc func backgroundTapped(gesture: UIGestureRecognizer) {
        delegate?.changeBlackView()
        
        self.dismiss(animated: true, completion: {})

    }
    
    
    
    
    
    @objc func stackViewButtonsSelected(){
        inviteButton.titleLabel?.textColor = .black
        newHuntButton.titleLabel?.textColor = .lightGray
    }
    
    @objc func stackViewButtonsSelected2(){
        newHuntButton.titleLabel?.textColor = .black
        inviteButton.titleLabel?.textColor = .lightGray
    }
    
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        textField.resignFirstResponder()
        return true
     }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

}







//                                              JOINHUNT VIEW
class JoinHuntView: UIViewController {
    var delegate: blackViewProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        constraintContainer()
        textFieldApearing()
    }
    func textFieldApearing(){
        textField.becomeFirstResponder()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardWillChange(notification: Notification){
        let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
//        view.frame.origin.y = -keyboardRect.height - 30
        whiteView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -keyboardRect.height - 30).isActive = true

//        whiteViewWidth.isActive = false
//        whiteView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
//
//        whiteView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    fileprivate let whiteView: CustomView = {
        let view = CustomView()
        view.backgroundColor = .white
        
        view.layer.cornerRadius = 22
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate let viewTitle: CustomLabel = {
        let label = CustomLabel()
        label.textAlignment = .center
        label.attributedText = NSAttributedString(string: "Join group with code", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)])
        
        label.translatesAutoresizingMaskIntoConstraints  = false
        return label
    }()
    
    
    fileprivate let viewDescription: CustomLabel = {
        let label = CustomLabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.attributedText = NSAttributedString(string: "This code will give you access into a private scavanger group. Type or paste the code in to join.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)])
        
        label.translatesAutoresizingMaskIntoConstraints  = false
        return label
    }()
    
    
    fileprivate let textFieldView: CustomView = {
       let view = CustomView()
       view.backgroundColor = .white
        
        view.layer.cornerRadius = 15
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        view.layer.shadowRadius = 8.0
        view.layer.shadowOpacity = 0.2
       view.translatesAutoresizingMaskIntoConstraints = false
       return view
    }()

    fileprivate let textField: UITextField = {
       let field = UITextField()
        field.placeholder = "Type code..."
        field.tintColor = .lightGray
        field.returnKeyType = .done
        
        field.translatesAutoresizingMaskIntoConstraints = false
       return field
    }()
    
    fileprivate let pasteButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "Paste", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15), NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]), for: .normal)
        button.addTarget(self, action: #selector(PasteButtonSelected), for: .touchUpInside)

        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate let joinButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setAttributedTitle(NSAttributedString(string: "Join",  attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]), for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addTarget(self, action: #selector(JoinButtonSelected), for: .touchUpInside)
        
        button.layer.cornerRadius = UIScreen.main.bounds.height/40
        button.layer.shadowColor = UIColor.lightGray.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        button.layer.shadowRadius = 10.0
        button.layer.shadowOpacity = 0.3
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate let pasteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "clipboard")
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private func constraintContainer(){
        view.addSubview(whiteView)
        whiteView.addSubview(viewTitle)
        whiteView.addSubview(viewDescription)
            whiteView.addSubview(textFieldView)
                textFieldView.addSubview(textField)
            whiteView.addSubview(pasteButton)
            whiteView.addSubview(joinButton)
        
        NSLayoutConstraint.activate([
//            whiteView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            whiteView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            whiteView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            whiteView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.40),
            
            viewTitle.topAnchor.constraint(equalTo: whiteView.topAnchor, constant: 16),
            viewTitle.leadingAnchor.constraint(equalTo: whiteView.leadingAnchor, constant: 16),
            viewTitle.trailingAnchor.constraint(equalTo: whiteView.trailingAnchor, constant: -16),
            viewTitle.heightAnchor.constraint(equalToConstant: viewTitle.intrinsicContentSize.height),
            
            viewDescription.topAnchor.constraint(equalTo: viewTitle.bottomAnchor, constant: 8),
            viewDescription.leadingAnchor.constraint(equalTo: viewTitle.leadingAnchor, constant: 16),
            viewDescription.trailingAnchor.constraint(equalTo: viewTitle.trailingAnchor, constant: -16),
            viewDescription.heightAnchor.constraint(equalToConstant: viewDescription.intrinsicContentSize.height*3),
            
            textFieldView.topAnchor.constraint(equalTo: viewDescription.bottomAnchor, constant: 8),
            textFieldView.leadingAnchor.constraint(equalTo: whiteView.leadingAnchor, constant: 16),
            textFieldView.trailingAnchor.constraint(equalTo: whiteView.trailingAnchor, constant: -16),
            textFieldView.heightAnchor.constraint(equalTo: whiteView.heightAnchor, multiplier: 0.12),
            
            textField.topAnchor.constraint(equalTo: textFieldView.topAnchor, constant: 3),
            textField.leadingAnchor.constraint(equalTo: textFieldView.leadingAnchor, constant: 8),
            textField.trailingAnchor.constraint(equalTo: textFieldView.trailingAnchor, constant: -8),
            textField.bottomAnchor.constraint(equalTo: textFieldView.bottomAnchor, constant: -3),
            
            pasteButton.topAnchor.constraint(equalTo: textFieldView.bottomAnchor, constant: 8),
            pasteButton.heightAnchor.constraint(equalTo: whiteView.heightAnchor, multiplier: 0.10),
            pasteButton.widthAnchor.constraint(equalTo: whiteView.heightAnchor,multiplier: 0.20),
            pasteButton.centerXAnchor.constraint(equalTo: whiteView.centerXAnchor),
            
            joinButton.widthAnchor.constraint(equalToConstant: 110),
            joinButton.centerXAnchor.constraint(equalTo: whiteView.centerXAnchor),
            joinButton.heightAnchor.constraint(equalTo: whiteView.heightAnchor, multiplier: 0.12),
            joinButton.bottomAnchor.constraint(equalTo: whiteView.bottomAnchor, constant: -8)
            
        ])
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        for letter in string{
            for i in "/:;()$&@\",?!'[]{}#%^*+=\\|~<>€£¥•,?!' "{
                if letter == i{
                    return false
                }
            }
        }
//        error()
    return true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped(gesture:)))
        view.addGestureRecognizer(tapGesture)
    }

    
    @objc func backgroundTapped(gesture: UIGestureRecognizer) {
        delegate?.changeBlackView()

        self.dismiss(animated: true, completion: {
//            ViewController().blackWindow.removeFromSuperview()
        })

    }
    
    @objc func PasteButtonSelected(){
        let pastboard = UIPasteboard.general
        generator.impactOccurred()
        guard let text = pastboard.string else {
            error()
            return
        }
        textField.text = text
    }
    
    let ref = Database.database().reference()
    
    @objc func JoinButtonSelected(){
        if textField.text != nil && textField.text != ""{
        let id = ref.child("Groups")
        id.observeSingleEvent(of: .value) { (DataSnapshot) in
            if DataSnapshot.hasChild(self.textField.text!){
                self.GroupFound()
            }else{
                self.error()
            }
        }
        }
        }
    

    func GroupFound(){
        print("THIS IS IN PROGRESS")
        let userItem = ref.child("Groups").child(textField.text!).child("Users").childByAutoId()

        if userDefault.string(forKey: "BitmojiURL") != nil{
        userItem.setValue(["Name":userDefault.string(forKey: "displayName")!, "Score":0, "id":userDefault.string(forKey: "externalID")!, "userImage":userDefault.string(forKey: "BitmojiURL")!])
        }
        
        ref.child("user IDs").child(userDefault.string(forKey: "externalID")!).child("InGroups").childByAutoId().setValue(["key":textField.text!, "userId":userItem.key])
        delegate?.changeBlackView()
        

        self.dismiss(animated: true, completion: nil)
    }
    func error(){
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.textFieldView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        })

        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.textFieldView.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
        
    }

}










class AboutView: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        constraintContainer()
    }
    var url: String?
    
    let webView: WKWebView = {
        let view = WKWebView()
        view.backgroundColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1)
        view.load(URLRequest(url: URL(string: "https://seek-challenges.flycricket.io/privacy.html")!))
//        view.load(URLRequest(url: URL(string: "https://apps.apple.com/us/app/id1514249158")!))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private func constraintContainer(){
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}














protocol GameCreated {
    func openSuggestingView(isTrue: Bool, name: String)
}
//                                              MARK:NAME VIEW
class nameViewController: UIViewController {
    var delegate: blackViewProtocol?
    var gameCreated: GameCreated?
//    var nameOfGroup = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        constraintContainer()
        textFieldApearing()
    }
    func textFieldApearing(){
        textField.becomeFirstResponder()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardWillChange(notification: Notification){
        let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
//        view.frame.origin.y = -keyboardRect.height - 30
        whiteView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -keyboardRect.height - 30).isActive = true

//        whiteViewWidth.isActive = false
//        whiteView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
//
//        whiteView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    fileprivate let whiteView: CustomView = {
        let view = CustomView()
        view.backgroundColor = .white
        
        view.layer.cornerRadius = 22
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate let viewTitle: CustomLabel = {
        let label = CustomLabel()
        label.textAlignment = .center
        label.attributedText = NSAttributedString(string: "Give the group a name...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)])
        
        label.translatesAutoresizingMaskIntoConstraints  = false
        return label
    }()
    
    
    fileprivate let textFieldView: CustomView = {
       let view = CustomView()
       view.backgroundColor = .white
        
        view.layer.cornerRadius = 15
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        view.layer.shadowRadius = 8.0
        view.layer.shadowOpacity = 0.2
       view.translatesAutoresizingMaskIntoConstraints = false
       return view
    }()

    fileprivate let textField: UITextField = {
       let field = UITextField()
        field.placeholder = "Type Name..."
        field.tintColor = .lightGray
        field.returnKeyType = .done
        
        field.translatesAutoresizingMaskIntoConstraints = false
       return field
    }()

    
    fileprivate let joinButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setAttributedTitle(NSAttributedString(string: "Next",  attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]), for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addTarget(self, action: #selector(JoinButtonSelected), for: .touchUpInside)
        
        button.layer.cornerRadius = UIScreen.main.bounds.height/40
        button.layer.shadowColor = UIColor.lightGray.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        button.layer.shadowRadius = 10.0
        button.layer.shadowOpacity = 0.3
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private func constraintContainer(){
        view.addSubview(whiteView)
        whiteView.addSubview(viewTitle)
            whiteView.addSubview(textFieldView)
                textFieldView.addSubview(textField)
            whiteView.addSubview(joinButton)
        
        NSLayoutConstraint.activate([
//            whiteView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            whiteView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            whiteView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            whiteView.heightAnchor.constraint(equalToConstant: 175),
            
            viewTitle.topAnchor.constraint(equalTo: whiteView.topAnchor, constant: 16),
            viewTitle.leadingAnchor.constraint(equalTo: whiteView.leadingAnchor, constant: 16),
            viewTitle.trailingAnchor.constraint(equalTo: whiteView.trailingAnchor, constant: -16),
            viewTitle.heightAnchor.constraint(equalToConstant: viewTitle.intrinsicContentSize.height),
            
            
            textFieldView.topAnchor.constraint(equalTo: viewTitle.bottomAnchor, constant: 8),
            textFieldView.leadingAnchor.constraint(equalTo: whiteView.leadingAnchor, constant: 16),
            textFieldView.trailingAnchor.constraint(equalTo: whiteView.trailingAnchor, constant: -16),
            textFieldView.heightAnchor.constraint(equalToConstant: 40),
            
            textField.topAnchor.constraint(equalTo: textFieldView.topAnchor, constant: 3),
            textField.leadingAnchor.constraint(equalTo: textFieldView.leadingAnchor, constant: 8),
            textField.trailingAnchor.constraint(equalTo: textFieldView.trailingAnchor, constant: -8),
            textField.bottomAnchor.constraint(equalTo: textFieldView.bottomAnchor, constant: -3),
            

            
            joinButton.widthAnchor.constraint(equalToConstant: 110),
            joinButton.centerXAnchor.constraint(equalTo: whiteView.centerXAnchor),
            joinButton.heightAnchor.constraint(equalToConstant: 40),
            joinButton.bottomAnchor.constraint(equalTo: whiteView.bottomAnchor, constant: -8)
            
        ])
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        for letter in string{
            for i in "/:;()$&@\",?!'[]{}#%^*+=\\|~<>€£¥•,?!' "{
                if letter == i{
                    return false
                }
            }
        }
//        error()
    return true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped(gesture:)))
        view.addGestureRecognizer(tapGesture)
    }

    
    @objc func backgroundTapped(gesture: UIGestureRecognizer) {
        delegate?.changeBlackView()

        self.dismiss(animated: true, completion: {
//            ViewController().blackWindow.removeFromSuperview()
        })

    }
    
    let ref = Database.database().reference()
    
    @objc func JoinButtonSelected(){
        if textField.text != nil && textField.text != ""{

            dismiss(animated: true, completion: {
                self.delegate?.changeBlackView()
                self.gameCreated?.openSuggestingView(isTrue:true, name:self.textField.text!)
            })
        }
        }
    

    func GroupFound(){
        print("THIS IS IN PROGRESS")

        let userItem = ref.child("Groups").child(textField.text!).child("Users").childByAutoId()
        userItem.setValue(["Name":userDefault.string(forKey: "displayName")!, "Score":0, "id":userDefault.string(forKey: "externalID")!, "userImage":userDefault.string(forKey: "BitmojiURL")!])
        
        
        ref.child("user IDs").child(userDefault.string(forKey: "externalID")!).child("InGroups").childByAutoId().setValue(["key":textField.text!, "userId":userItem.key])
        delegate?.changeBlackView()

        self.dismiss(animated: true, completion: nil)
    }
    func error(){
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.textFieldView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        })

        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.textFieldView.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
        
    }

}















//                                                                  MENU VIEW
protocol menuItemSelected {
    func completeTask(number:Int)
}


class MenuViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellIDs().menuCollectionCell, for: indexPath) as! menuCollectionViewCell
        cell.backgroundColor = .white
        
        cell.cellLabel.attributedText = NSAttributedString(string: menuItems[indexPath.row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: UIScreen.main.bounds.width, height: collectionView.frame.height/4)
        return size
    }
    

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.changeBlackView()
        self.dismiss(animated: true, completion: {
            ViewController().blackWindow.removeFromSuperview()
            self.delegate2?.completeTask(number: indexPath.row)
        })


    }
    
    
    var delegate: blackViewProtocol?
    var delegate2: menuItemSelected?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        constraintContainer()
    }
    let menuItems = [ "📱\t\tRate App","🤓\t\tAbout","💌\t\tInvite","🥱\t\tLogout"]
    
    
    fileprivate let whiteView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        view.layer.cornerRadius = 25
        view.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
        private let bitmojiImageView: UIImageView = {
           let imageView = UIImageView()
            if userDefault.string(forKey: "BitmojiURL") != nil{
                imageView.load(url: URL(string: userDefault.string(forKey: "BitmojiURL")!)!)
            }else{
                imageView.image = UIImage(named: "NoImageImage")
            }

            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
    
    
    
    
    
    
    fileprivate let cancel: UIButton = {
        let button = UIButton()
//        button.backgroundColor = .white
        button.setAttributedTitle(NSAttributedString(string: "Cancel",  attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]), for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(backgroundTapped(gesture:)), for: .touchUpInside)
        
        button.layer.cornerRadius = 15
        button.layer.shadowColor = UIColor.lightGray.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        button.layer.shadowRadius = 10.0
        button.layer.shadowOpacity = 0.3
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate let usernameLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.attributedText = NSAttributedString(string:userDefault.string(forKey: "displayName")!, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)])
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let menucollection: UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.minimumLineSpacing = 0
        let collection = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
        collection.backgroundColor = .white
        collection.isScrollEnabled = false
        collection.register(menuCollectionViewCell.self, forCellWithReuseIdentifier: collectionViewCellIDs().menuCollectionCell)
        
        
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    fileprivate let topHalfView: UIView = {
       let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private func constraintContainer(){
        menucollection.dataSource = self
        menucollection.delegate =  self
        
        view.addSubview(topHalfView)
        view.addSubview(whiteView)
        view.addSubview(bitmojiImageView)
        view.addSubview(usernameLabel)
        view.addSubview(menucollection)

        NSLayoutConstraint.activate([
            topHalfView.topAnchor.constraint(equalTo: view.topAnchor),
            topHalfView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topHalfView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topHalfView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.65),
            
            whiteView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            whiteView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            whiteView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            whiteView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.40),
            

            
            bitmojiImageView.topAnchor.constraint(equalTo: whiteView.topAnchor, constant: 16),
            bitmojiImageView.centerXAnchor.constraint(equalTo: whiteView.centerXAnchor),
            bitmojiImageView.widthAnchor.constraint(equalTo: whiteView.widthAnchor, multiplier: 0.12),
            bitmojiImageView.heightAnchor.constraint(equalTo: whiteView.widthAnchor, multiplier: 0.12),
            
            usernameLabel.topAnchor.constraint(equalTo: bitmojiImageView.bottomAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: whiteView.leadingAnchor, constant: 8),
            usernameLabel.trailingAnchor.constraint(equalTo: whiteView.trailingAnchor, constant: -8),
            usernameLabel.heightAnchor.constraint(equalTo: whiteView.heightAnchor, multiplier: 0.10),
            
            menucollection.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8),
            menucollection.leadingAnchor.constraint(equalTo: whiteView.leadingAnchor),
            menucollection.trailingAnchor.constraint(equalTo: whiteView.trailingAnchor),
            menucollection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            
            
        ])
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped(gesture:)))
        topHalfView.addGestureRecognizer(tapGesture)
    }

    @objc func backgroundTapped(gesture: UIGestureRecognizer) {
        delegate?.changeBlackView()
        self.dismiss(animated: true, completion: {
            ViewController().blackWindow.removeFromSuperview()
        })
    }
}


class menuCollectionViewCell: UICollectionViewCell{
    override init(frame: CGRect) {
        super.init(frame: frame)
        constraintContainer()
    }
    

    fileprivate let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
//        view.backgroundColor = .lightGray
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate let cellLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    

    
    fileprivate func constraintContainer(){
        self.addSubview(lineView)
        self.addSubview(cellLabel)
        
        
        self.addConstraintsWithFormat(format: "H:|-16-[v0]-|", views: cellLabel)
        self.addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: lineView)
        self.addConstraintsWithFormat(format: "V:|[v0(0.3)][v1]|", views: lineView, cellLabel)
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}





extension UIImage {
convenience init(view: UIView) {
    UIGraphicsBeginImageContext(view.frame.size)
    view.layer.render(in:UIGraphicsGetCurrentContext()!)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    self.init(cgImage: image!.cgImage!)
    }
}
