//
//  ViewController.swift
//  Scavanger Hunt
//
//  Created by Caleb Mesfien on 7/10/20.
//  Copyright © 2020 Caleb Mesfien. All rights reserved.
//

import UIKit
import MessageUI
import SCSDKCreativeKit
import SCSDKCoreKit
import SCSDKBitmojiKit
import SCSDKLoginKit
import Firebase
import StoreKit
import WebKit
import FirebaseDatabase
import Lottie
import AVFoundation

struct GroupItem {
    var id: String
    var name: String
    var bitmoji: String
}

protocol blackViewProtocol {
    func changeBlackView()
}
protocol removeItem {
    func removeKey(itemAt: String)
}


class collectionViewCellIDs {
    let currentItem = "CurrentItem"
    let pastItem = "PastItem"
    let menuCollectionCell = "menuCollectionCell"
    let NotificationViewCell = "NotificationViewCell"
    let groupDaresCollectionViewCell = "groupDaresCollectionView"
    let groupMembersCollectionViewCell = "groupMembersCollectionViewCell"
}

let generator = UIImpactFeedbackGenerator()
class ViewController: UIViewController, blackViewProtocol, CALayerDelegate, menuItemSelected, MFMessageComposeViewControllerDelegate, removeItem, GameCreated{
    func openSuggestingView(isTrue: Bool, name:String) {
        if isTrue{
            let vc = SuggestingPost()
            vc.nameOfGroup = name
            present(vc, animated: true)
        }
    }
    
    func removeKey(itemAt:String) {
        if let index = postsKey.firstIndex(of: itemAt) {
            print("This was done", postsKey.count)
            DispatchQueue.main.async {
                self.postsKey.remove(at: index)
                self.pastHuntsCollectionView.reloadData()
            }
            loadCollectionView()
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        dismiss(animated: true)
    }
    
    

    func completeTask(number: Int) {
        if number == 0{
            let view = SKStoreProductViewController()
            view.delegate = self as? SKStoreProductViewControllerDelegate

            view.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier: 1514249157])
                        present(view, animated: true, completion: nil)
        }else if number == 1{
            let vc = AboutView()
            present(vc, animated: true)
        }else if number == 2{
            let composeVC = MFMessageComposeViewController()
            composeVC.messageComposeDelegate = self

            // Configure the fields of the interface.
            composeVC.body = "https://apps.apple.com/us/developer/caleb-mesfien/id1514249157"

            // Present the view controller modally.
            if MFMessageComposeViewController.canSendText() {
                self.present(composeVC, animated: true, completion: nil)
            }
        }else if number == 3 {
            userDefault.set(false, forKey: DefualtKey.removeWelcomeView)
            navigationController?.pushViewController(WelcomeView(), animated: true)
        }
    }
    
    var posts = [GroupItem]()
    var postsKey = [String]()
    var keyOfKey = [String]()
    
    
    
    private let refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.attributedTitle = NSAttributedString(string: "Hold down cell to remove", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 13)])
        refresh.addTarget(self, action: #selector(refreshGroupList(_:)), for: .valueChanged)
        refresh.layoutIfNeeded()
        
        
        return refresh
    }()

    func changeBlackView() {
        view.layoutIfNeeded()
        if userDefault.string(forKey: "BitmojiURL") == nil{
            bitmojiImageView.image = UIImage(named: "NoImageImage")
        }else{
            bitmojiImageView.load(url: URL(string: userDefault.string(forKey: "BitmojiURL")!)!)
        }
            UIView.animate(withDuration: 0.5) {
                self.blackWindow.alpha = 0
        }
    }
    
    var delegate: logedIn!
    let blackWindow = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        pastHuntsCollectionView.backgroundView = refreshControl
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(LongPressActivated(Recognizer:)))
        longPress.minimumPressDuration = 0.5
        pastHuntsCollectionView.addGestureRecognizer(longPress)
        constraintContainer()
        loadCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if userDefault.string(forKey: "BitmojiURL") != nil{
        bitmojiImageView.load(url: URL(string:userDefault.string(forKey: "BitmojiURL")!)!)
        }
        NoGroupAnimation.play()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        blackWindow.removeFromSuperview()
        NoGroupAnimation.play()
        view.layoutIfNeeded()

    }
    
    @objc private func refreshGroupList(_ sender: UIRefreshControl) {
        sender.endRefreshing()
        DispatchQueue.main.async {
            self.loadCollectionView()
            self.pastHuntsCollectionView.reloadData()
            self.view.layoutIfNeeded()
        }
        if userDefault.string(forKey: "BitmojiURL") == nil{
            bitmojiImageView.image = UIImage(named: "NoImageImage")
        }else{
            bitmojiImageView.load(url: URL(string: userDefault.string(forKey: "BitmojiURL")!)!)
        }
    }
    

    func loadCollectionView(){
        let josh = ref.child("user IDs").child(userDefault.string(forKey: "externalID")!).child("InGroups").queryOrderedByKey()
        josh.observe(.childAdded) { snapshot in

            if snapshot.exists(){
                let value = snapshot.value as? NSDictionary
                let key = value?["key"] as? String
                    self.keyOfKey.insert(snapshot.key, at: 0)
            if self.postsKey.contains(key!){
                    return
                }else{
                    print("SUCCESS")
                    self.postsKey.insert(key!, at: 0)
                    self.pastHuntsCollectionView.reloadData()
                    
            }
            }else{
                self.pastHuntsCollectionView.reloadData()
            }
        }
        
    }
    
    
    fileprivate let NoGroupAnimation: AnimationView = {
        let animationView = AnimationView()
        //        animationView.alpha = 0.2
        animationView.backgroundColor = .clear
               animationView.animation = Animation.named("startGame")
               animationView.loopMode = .loop
                animationView.animationSpeed = 0.6
               animationView.play()

               animationView.translatesAutoresizingMaskIntoConstraints = false
        return animationView
    }()
    fileprivate let startGameLabel: CustomLabel = {
        let label = CustomLabel()
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        if userDefault.bool(forKey: "LoggedInSnap") == false || userDefault.bool(forKey: "LoggedInSnap") == nil{
            label.numberOfLines = 2
        label.attributedText = NSAttributedString(string: "Start a game with snapchat friends. Sign into Snapchat to begin.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)])
        }else{
            label.attributedText = NSAttributedString(string: "Start a game with snapchat friends.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)])
        }
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func noGroupFound(){
        view.addSubview(NoGroupAnimation)
        view.addSubview(startGameLabel)
        
        NSLayoutConstraint.activate([
            NoGroupAnimation.topAnchor.constraint(equalTo: menuView.bottomAnchor, constant: 16),
            NoGroupAnimation.widthAnchor.constraint(equalToConstant: 400),
            NoGroupAnimation.heightAnchor.constraint(equalToConstant: 200),
            NoGroupAnimation.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            startGameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startGameLabel.topAnchor.constraint(equalTo: NoGroupAnimation.bottomAnchor, constant: 8),
            startGameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
        ])
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//                                                                          ITEMS IN MENUBAR
    private let menuView: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    private let bitmojiImageView: UIImageView = {
       let imageView = UIImageView()
        if userDefault.string(forKey: "BitmojiURL") == nil{
            imageView.image = UIImage(named: "NoImageImage")
        }else{
            imageView.load(url: URL(string: userDefault.string(forKey: "BitmojiURL")!)!)
        }
        imageView.backgroundColor = .white

        imageView.layer.cornerRadius = (UIScreen.main.bounds.height*0.071)/2
        imageView.layer.shadowColor = UIColor.lightGray.cgColor
        imageView.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        imageView.layer.shadowRadius = 5.0
        imageView.layer.shadowOpacity = 0.5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    

//
    private let menuBar: UIButton = {
       let animationView = UIButton()
        animationView.setImage(UIImage(named: "MenuDots"), for: .normal)
        animationView.addTarget(self, action: #selector(MenuBarSelected), for: .touchUpInside)
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        return animationView
    }()
    

    private let postHuntbutton: UIButton = {
        let button = UIButton()
//        button.backgroundColor = UIColor(red: 1.00, green: 0.99, blue: 0.00, alpha: 1.00)
        button.backgroundColor = UIColor(red: 252/255, green: 248/255, blue: 0/255, alpha: 1.0)

        button.setAttributedTitle(NSAttributedString(string: "Create", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 45/255, green: 45/255, blue: 45/255, alpha: 1), NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)]), for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(NewHuntSelected), for: .touchUpInside)




        
        button.layer.cornerRadius = 25
//        button.layer.shadowColor = UIColor.lightGray.cgColor
//        button.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
//        button.layer.shadowRadius = 8.0
//        button.layer.shadowOpacity = 0.4
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate let snapGhostImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "SnapGhost")
        
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
       return imageView
    }()

    fileprivate let joinHuntButton: UIButton = {
       let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "Join", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)]), for: .normal)
        button.layer.cornerRadius = 25
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(JoinHuntSelected), for: .touchUpInside)
        
        button.layer.shadowColor = UIColor.lightGray.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        button.layer.shadowRadius = 8.0
        button.layer.shadowOpacity = 0.2
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

//                  COLLECTIONVIEW
    fileprivate let activeHuntsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.isHidden = false
        collectionView.register(HuntCollectionCell.self, forCellWithReuseIdentifier: collectionViewCellIDs().currentItem)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    fileprivate let pastHuntsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(HuntCollectionCell.self, forCellWithReuseIdentifier: collectionViewCellIDs().pastItem)
        collectionView.alwaysBounceVertical = true
        collectionView.delaysContentTouches = false
//        collectionView.
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
//              IF THE collectionVIEW IS EMPTY LABEL
    fileprivate let emptyCollectionViewView: CustomView = {
       let view = CustomView()
        view.backgroundColor = .white

        
        view.layer.cornerRadius = 22
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        view.layer.shadowRadius = 10.0
        view.layer.shadowOpacity = 0.2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate let emptyCollectionViewLabel: CustomLabel = {
        let label = CustomLabel()
        label.textAlignment = .center
        label.backgroundColor = .white
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.attributedText = NSAttributedString(string: "There are no active hunts at this time. To create one, select on the button below.\n😴", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)])
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

//                                                                      CONSTRAINTCONTAINER TO SETUP CONSTRAINTS

    fileprivate func constraintContainer(){
        NoGroupAnimation.removeFromSuperview()
        startGameLabel.removeFromSuperview()
        if #available(iOS 10.0, *) {
            pastHuntsCollectionView.refreshControl = refreshControl
//            pastHuntsCollectionView.sendSubviewToBack(refreshControl)

        } else {
            pastHuntsCollectionView.addSubview(refreshControl)
//            pastHuntsCollectionView.sendSubviewToBack(refreshControl)
        }

        pastHuntsCollectionView.delegate = self
        pastHuntsCollectionView.dataSource = self
        
        view.addSubview(menuView)
        
        menuView.addSubview(bitmojiImageView)

        menuView.addSubview(menuBar)
        view.addSubview(pastHuntsCollectionView)
        
//        view.addSubview(joinHuntButton)
//        view.addSubview(postHuntbutton)
//            postHuntbutton.addSubview(snapGhostImageView)
        
        pastHuntsCollectionView.addSubview(joinHuntButton)
        pastHuntsCollectionView.addSubview(postHuntbutton)
            postHuntbutton.addSubview(snapGhostImageView)
        
        
        NSLayoutConstraint.activate([
//                          MENU VIEW

                menuView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                menuView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                menuView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                menuView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.071),
                
                bitmojiImageView.leadingAnchor.constraint(equalTo: menuView.leadingAnchor, constant: 8),
                bitmojiImageView.topAnchor.constraint(equalTo: menuView.topAnchor),
                bitmojiImageView.bottomAnchor.constraint(equalTo: menuView.bottomAnchor),
                bitmojiImageView.widthAnchor.constraint(equalTo: bitmojiImageView.heightAnchor),

                
                menuBar.centerYAnchor.constraint(equalTo: menuView.centerYAnchor),
                menuBar.trailingAnchor.constraint(equalTo: menuView.trailingAnchor, constant: -8),
                menuBar.heightAnchor.constraint(equalTo: menuView.heightAnchor, multiplier: 0.6),
                menuBar.widthAnchor.constraint(equalTo: menuBar.heightAnchor),

                
            
                        pastHuntsCollectionView.topAnchor.constraint(equalTo: menuView.bottomAnchor, constant: 16),
                        pastHuntsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                        pastHuntsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                        pastHuntsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            
            //                          EMPTY COLLECTIONVIEW VIEW
            
                                        joinHuntButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                                        joinHuntButton.bottomAnchor.constraint(equalTo: pastHuntsCollectionView.safeAreaLayoutGuide.bottomAnchor, constant: -8),
                                        joinHuntButton.heightAnchor.constraint(equalToConstant: 50),
                                        joinHuntButton.widthAnchor.constraint(equalToConstant: 100),
            
                            postHuntbutton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                            postHuntbutton.bottomAnchor.constraint(equalTo:pastHuntsCollectionView.safeAreaLayoutGuide.bottomAnchor, constant: -8),
                            postHuntbutton.heightAnchor.constraint(equalToConstant: 50),
                            postHuntbutton.widthAnchor.constraint(equalToConstant: 140),

                snapGhostImageView.trailingAnchor.constraint(equalTo: postHuntbutton.trailingAnchor, constant: -15),
                snapGhostImageView.heightAnchor.constraint(equalTo: postHuntbutton.heightAnchor, multiplier: 0.5),
            snapGhostImageView.widthAnchor.constraint(equalTo: snapGhostImageView.heightAnchor, multiplier: 304/286),
                snapGhostImageView.centerYAnchor.constraint(equalTo: postHuntbutton.centerYAnchor),
        ])
    }


    
    @objc func MenuBarSelected(){
        generator.impactOccurred()
                if let window = UIApplication.shared.keyWindow{
                    blackWindow.frame = window.frame
//                    blackWindow.frame = CGRect(x:0, y: 0, width:view.frame.width, height:view.frame.height-(view.frame.height*0.50))
                    blackWindow.backgroundColor = UIColor(white: 0, alpha: 0.5)
                    blackWindow.alpha = 0

                    view.addSubview(blackWindow)
                    
                    UIView.animate(withDuration: 0.5) {
                        self.blackWindow.alpha = 1
                    }
        }

        let vc = MenuViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        vc.delegate2 = self
        navigationController?.present(vc, animated: true)
    }
    
    
    @objc func NewHuntSelected(){

            generator.impactOccurred()
                    if let window = UIApplication.shared.keyWindow{
                        blackWindow.frame = window.frame
                        blackWindow.backgroundColor = UIColor(white: 0, alpha: 0.5)
                        blackWindow.alpha = 0

                        view.addSubview(blackWindow)

                        UIView.animate(withDuration: 0.5) {
                            self.blackWindow.alpha = 1
                        }
            }
        if userDefault.bool(forKey: "LoggedInSnap") == false{

            let vc = NotLoggedIn()
            vc.modalPresentationStyle = .overCurrentContext
            vc.delegate = self


            navigationController?.present(vc, animated: true)
        }else{
            let vc = nameViewController()
            vc.modalPresentationStyle = .overCurrentContext
            vc.delegate = self
            vc.gameCreated = self


            navigationController?.present(vc, animated: true)
        }
    }
    var ref = Database.database().reference()

    @objc func JoinHuntSelected(){
        generator.impactOccurred()
                if let window = UIApplication.shared.keyWindow{
                    blackWindow.frame = window.frame
                    blackWindow.backgroundColor = UIColor(white: 0, alpha: 0.5)
                    blackWindow.alpha = 0

                    view.addSubview(blackWindow)

                    UIView.animate(withDuration: 0.5) {
                        self.blackWindow.alpha = 1
                    }
        }

        let vc = JoinHuntView()
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self


        navigationController?.present(vc, animated: true)

        
    }
}




extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if postsKey.count == 0{
            self.noGroupFound()
            NoGroupAnimation.play()
        }else{
         constraintContainer()
        }
        return postsKey.count
//        return 4
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellIDs().pastItem, for: indexPath) as! HuntCollectionCell
//
        let i = postsKey[indexPath.row]
        cell.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        cell.layer.cornerRadius = 20
        ref.child("Groups").child(i).observeSingleEvent(of:.value) { snapshot in
            if snapshot.exists(){
            let value = snapshot.value as? NSDictionary
            let name = value?["Name"] as! String
            let image = value?["bitmoji"] as! String
//            let ImageURL = userDefault.string(forKey: "BitmojiURL")!
            cell.itemTitle.attributedText = NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            cell.itemImageView.load(url: URL(string:image)!)
            }
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width-40, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                let vc = mainViewClass()
                vc.keyFound = self.postsKey[indexPath.row]
                vc.KeyOfKey = self.keyOfKey[indexPath.row]


                generator.impactOccurred()
                self.present(vc, animated: true)

    }
    
    
    

    @objc func LongPressActivated(Recognizer: UILongPressGestureRecognizer){

            let touchPoint = Recognizer.location(in: pastHuntsCollectionView)
            if let indexPath = pastHuntsCollectionView.indexPathForItem(at: touchPoint) {
                // your code here, get the row for the indexPath or do whatever you want
                print("Long press Pressed:)", indexPath.row)
               let cell = pastHuntsCollectionView.cellForItem(at: indexPath) as! HuntCollectionCell

            
    if Recognizer.state == .began{
        generator.impactOccurred()
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            cell.backgroundColor = .lightGray
            cell.itemTitle.textColor = .white
            cell.self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)

            cell.layoutIfNeeded()
        })
        let vc = RemoveGroup()
        if let window = UIApplication.shared.keyWindow{
            blackWindow.frame = window.frame
//                    blackWindow.frame = CGRect(x:0, y: 0, width:view.frame.width, height:view.frame.height-(view.frame.height*0.50))
            blackWindow.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackWindow.alpha = 0

            view.addSubview(blackWindow)
            
            UIView.animate(withDuration: 0.5) {
                self.blackWindow.alpha = 1
            }

    guard let username = cell.itemTitle.text else{return}
    guard let image = cell.itemImageView.image else{return}
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
            vc.deleteItem = self
        vc.username = username
        vc.bitmojiImage.image = image
        vc.keyFound = postsKey[indexPath.row]
            vc.keyOfKey = keyOfKey[indexPath.row]

        self.present(vc, animated: true)
        view.layoutIfNeeded()
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (Timer) in
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    cell.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
                    cell.itemTitle.textColor = .lightGray
                    cell.self.transform = CGAffineTransform(scaleX: 1, y: 1)
                    cell.layoutIfNeeded()
                })
            }
    }else if Recognizer.state == .ended{

        

}

    }
    }
    }
    

}








class NotLoggedIn:UIViewController{
    var delegate: blackViewProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        constraintContainer()
    }


    fileprivate let whiteView: CustomView = {
        let view = CustomView()
        view.backgroundColor = .white
        
        view.layer.cornerRadius = 25
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    fileprivate let lottieImage: AnimationView = {
            let animationView = AnimationView()
            //        animationView.alpha = 0.2
            animationView.backgroundColor = .clear
                   animationView.animation = Animation.named("NoAccountMonkey")
                   animationView.loopMode = .loop
                   animationView.animationSpeed = 0.6
                   animationView.play()

                   animationView.translatesAutoresizingMaskIntoConstraints = false
            return animationView
        }()
    fileprivate let viewTitle: CustomLabel = {
        let label = CustomLabel()
        label.textAlignment = .center
        label.attributedText = NSAttributedString(string: "Sign in to create", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.88, green: 0.88, blue: 0.88, alpha: 1), NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)])
        
        label.translatesAutoresizingMaskIntoConstraints  = false
        return label
    }()
    
    fileprivate let snapLoginButton: UIButton = {
        let button  = UIButton()

        button.backgroundColor = UIColor(red: 1.00, green: 0.99, blue: 0.00, alpha: 1.00)


        button.addTarget(self, action: #selector(SnapLoginPressed), for: .touchUpInside)
        button.setAttributedTitle(NSAttributedString(string: "Continue with Snapchat", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]), for: .normal)



        button.layer.cornerRadius = 22.0
        button.layer.shadowColor = UIColor.lightGray.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        button.layer.shadowRadius = 8.0
        button.layer.shadowOpacity = 0.3
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    fileprivate let snapGhostImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "SnapGhost")
        
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
       return imageView
    }()
    
    private func constraintContainer(){
        view.addSubview(whiteView)
        view.addSubview(lottieImage)
        whiteView.addSubview(viewTitle)
        whiteView.addSubview(snapLoginButton)
        snapLoginButton.addSubview(snapGhostImageView)
        
        NSLayoutConstraint.activate([
            whiteView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            whiteView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            whiteView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            whiteView.heightAnchor.constraint(equalToConstant: 125),
            
            lottieImage.bottomAnchor.constraint(equalTo: whiteView.topAnchor),
            lottieImage.widthAnchor.constraint(equalToConstant: 50),
            lottieImage.heightAnchor.constraint(equalToConstant: 50),
            lottieImage.centerXAnchor.constraint(equalTo: whiteView.centerXAnchor),
            
            viewTitle.topAnchor.constraint(equalTo: whiteView.topAnchor, constant: 16),
            viewTitle.leadingAnchor.constraint(equalTo: whiteView.leadingAnchor, constant: 16),
            viewTitle.trailingAnchor.constraint(equalTo: whiteView.trailingAnchor, constant: -16),
            viewTitle.heightAnchor.constraint(equalToConstant: viewTitle.intrinsicContentSize.height),
            
            snapLoginButton.topAnchor.constraint(equalTo: viewTitle.bottomAnchor, constant: 16),
            snapLoginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 45),
            snapLoginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -45),
            snapLoginButton.heightAnchor.constraint(equalToConstant: 50),

            
                snapGhostImageView.leadingAnchor.constraint(equalTo: snapLoginButton.leadingAnchor, constant: 15),
                snapGhostImageView.heightAnchor.constraint(equalToConstant: 25),
                snapGhostImageView.widthAnchor.constraint(equalToConstant: 25),
                snapGhostImageView.centerYAnchor.constraint(equalTo: snapLoginButton.centerYAnchor),
            
            
        ])
        
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped(gesture:)))
        view.addGestureRecognizer(tapGesture)
    }

    
    @objc func backgroundTapped(gesture: UIGestureRecognizer) {
        delegate?.changeBlackView()

        self.dismiss(animated: true, completion:nil)
    }
    let ref = Database.database().reference()
    @objc func SnapLoginPressed(){
//        vc.delegate = self
        delegate?.changeBlackView()
        dismiss(animated: true, completion: nil)
        SCSDKLoginClient.login(from: self) { (success, error) in

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
            userDefault.set(true, forKey: "LoggedInSnap")

            self.ref.child("user IDs").observeSingleEvent(of: .value) { (DataSnapshot) in
                if DataSnapshot.hasChild(externalID!) == false{
                    self.ref.child("user IDs").child(externalID!).setValue(["username": displayName, "Image URL":bitmojiAvatarUrl])
                }
            }
            DispatchQueue.main.async {
                userDefault.set(true, forKey: DefualtKey.removeWelcomeView)
                self.navigationController?.pushViewController(ViewController(), animated: true)
            }


        }, failure: { (error: Error?, isUserLoggedOut: Bool) in
            // handle error
        })
        
    }


}
