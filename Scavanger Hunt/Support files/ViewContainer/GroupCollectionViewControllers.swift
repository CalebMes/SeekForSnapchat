//
//  GroupCollectionViewControllers.swift
//  Scavanger Hunt
//
//  Created by Caleb Mesfien on 9/24/20.
//  Copyright © 2020 Caleb Mesfien. All rights reserved.
//

import UIKit
import SCSDKCreativeKit
import SCSDKCoreKit
import SCSDKBitmojiKit
import Firebase
import FirebaseDatabase
import Lottie








var ref = Database.database().reference()

class mainViewClass: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    let menuImages = ["challengeIcon", "leaderboardIcon", "Notifications", "newPostIcon"]
    let menuTitles = ["Challenges", "Leaderboard","Notifications", "Post"]
    let cellID = "cellID"
    var keyFound = String()
    var KeyOfKey = String()


    let firstView = ChallangesView()
    let secondView = LeaderBoardView()
    let thirdView = NotificationView()
    let fourthView = PostView()
    override func viewDidLoad(){
        super.viewDidLoad()
        constraintController()
        firstView.KeyFound = keyFound
        firstView.keyOfKey = KeyOfKey
        
        secondView.keyFound = keyFound
        thirdView.keyFound = keyFound
        
        fourthView.keyFound = keyFound
//        fourthView
        newView(newView: firstView)
        view.backgroundColor = .white
        
        let selectedIndexPath = NSIndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath as IndexPath, animated: false, scrollPosition: .init())

    }
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MenuClassCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()

    func newView(newView: UIViewController){
        firstView.view.removeFromSuperview()
        secondView.view.removeFromSuperview()
        thirdView.view.removeFromSuperview()
        fourthView.view.removeFromSuperview()
        addChild(newView)
        view.addSubview(newView.view)
        newView.didMove(toParent: self)
        

        view.addConstraintsWithFormat(format: "H:|[v0]|", views: newView.view)
        NSLayoutConstraint.activate([
            newView.view.topAnchor.constraint(equalTo: view.topAnchor),
            newView.view.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -8)
        ])
        
        
    }
    
    fileprivate func constraintController(){

        
        view.addSubview(collectionView)
        view.addConstraintsWithFormat(format: "V:[v0(48)]", views: collectionView)
        view.addConstraintsWithFormat(format: "H:[v0(\(view.frame.width*0.75))]", views: collectionView)
        NSLayoutConstraint.activate([
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])
        
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: (view.frame.width*0.74)/4, height: 48)
        return size
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MenuClassCell
        cell.imageView.image = UIImage(named: menuImages[indexPath.row])?.withRenderingMode(.alwaysTemplate)
        cell.textLabel.attributedText = NSAttributedString(string: menuTitles[indexPath.row], attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10)])
        cell.tintColor = .lightGray
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let views = [firstView, secondView,thirdView,fourthView]
        newView(newView: views[indexPath.row])
    }
}






                                    //                             MARK: CHALLANGES VIEW






protocol changeView {
    func gameBegan(time:String)
}


class ChallangesView: UIViewController, blackViewProtocol, changeView{

    func gameBegan(time: String) {
        pointRemovalMainview.isUserInteractionEnabled = false
        pointRemovalLabel.text = "Ends: \(time)"
        pointRemovalLabel.textColor = .lightGray
        view.layoutIfNeeded()
    }
    
    var KeyFound = String()
    var keyOfKey = String()

    func changeBlackView() {
        UIView.animate(withDuration: 0.5) {
                self.blackWindow.alpha = 0
        }
    }
    let blackWindow = UIView()
    
    
    
    func fetchItems(){
        let fetch = ref.child("Groups").child(KeyFound)
        
            fetch.observeSingleEvent(of:.value) { snapshot in

            let value = snapshot.value as? NSDictionary
                let leaderID = value?["LeaderID"] as? String ?? ""
            
            if leaderID == userDefault.string(forKey:"externalID")!{
                self.pointRemovalLabel.text = "Start Game!"
                self.pointRemovalLabel.textColor = .black
                let gesture = UITapGestureRecognizer(target: self, action: #selector(self.startGame))
                self.pointRemovalMainview.addGestureRecognizer(gesture)
            }
    }
    }
    override func viewDidLoad(){
        super.viewDidLoad()
        loadingAnimation.play()
        constraintContainer()
        loadCollectionView()
        DoneChallanges()
        
        let item = ref.child("Groups").child(KeyFound)
            item.child("Active").observeSingleEvent(of:.value) { snapshot in
            let date = Date()
            let secondFormatter = DateFormatter()
            secondFormatter.dateFormat  = "MM-dd-yyyy hh:mm a"
            let value = snapshot.value as? NSDictionary
            let isActive = value?["isActive"] as? String

            if isActive == "false"{
                self.fetchItems()
            }else if isActive == nil{
                return
            }else{
                let entireDate = value?["EntireDate"] as? String
                if entireDate! > secondFormatter.string(from: date){
                    let time = value?["endTime"] as? String
                
                    self.pointRemovalLabel.text = "Ends: \(time!)"
                    self.pointRemovalLabel.textColor = .lightGray
                }else{
                    item.child("Active").child("isActive").setValue("nil")
                    self.loadingAnimation.removeFromSuperview()
                    self.pointRemovalLabel.text = "Game Ended"
                    self.pointRemovalLabel.textColor = .lightGray
                }
            }
            self.view.layoutIfNeeded()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.loadingAnimation.isAnimationPlaying == false {
           self.loadingAnimation.play()
        }
    }
//                                                                                                           REWARD VIEW

    
    fileprivate let TitleLabel: CustomLabel = {
        let label = CustomLabel()
        label.attributedText = NSAttributedString(string: "Challenges", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 25)])
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label 
    }()
    fileprivate let titleLabelView: CustomView = {
       let view = CustomView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 18
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        view.layer.shadowRadius = 10.0
        view.layer.shadowOpacity = 0.3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate let pointRemovalMainview: UIView = {
     let view = UIView()
        view.backgroundColor = .white
        
        view.layer.cornerRadius = 22
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        view.layer.shadowRadius = 10.0
        view.layer.shadowOpacity = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    fileprivate let pointRemovalLabel: CustomLabel = {
       let label = CustomLabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        
        label.attributedText = NSAttributedString(string: "Waiting for the leader", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)])
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let loadingAnimation: AnimationView = {
        let animationView = AnimationView()
        animationView.backgroundColor = .clear
        animationView.animation = Animation.named("loadingSpinner")
        animationView.animationSpeed = 0.5
        animationView.loopMode = .loop
        animationView.play()

        animationView.translatesAutoresizingMaskIntoConstraints = false
        return animationView
    }()
    
    

    
    fileprivate let groupmemberButtonView: CustomView = {
       let view = CustomView()
        view.backgroundColor = .white
        view.layer.cornerRadius = (UIScreen.main.bounds.width*0.10)/2
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        view.layer.shadowRadius = 10.0
        view.layer.shadowOpacity = 0.3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate let groupImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bitmojiImage")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    fileprivate let groupMemberLabel: CustomLabel = {
       let label = CustomLabel()
        label.attributedText = NSAttributedString(string: "Scores", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)])
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    

    fileprivate let groupDaresCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delaysContentTouches = false
        collectionView.backgroundColor = .white
        collectionView.register(groupDaresCollectionViewCell.self, forCellWithReuseIdentifier: collectionViewCellIDs().groupDaresCollectionViewCell)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    
    
    fileprivate func constraintContainer(){
        groupDaresCollectionView.dataSource = self
        groupDaresCollectionView.delegate = self


        view.addSubview(titleLabelView)
        titleLabelView.addSubview(TitleLabel)
        
        view.addSubview(pointRemovalMainview)
            pointRemovalMainview.addSubview(pointRemovalLabel)
            pointRemovalMainview.addSubview(loadingAnimation)

        view.addSubview(groupDaresCollectionView)

        NSLayoutConstraint.activate([
            
            titleLabelView.topAnchor.constraint(equalTo: view.topAnchor,constant: 8),
            titleLabelView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabelView.heightAnchor.constraint(equalTo: TitleLabel.heightAnchor, constant: 8),
            titleLabelView.widthAnchor.constraint(equalTo: TitleLabel.widthAnchor, constant: 32),
            
            TitleLabel.centerXAnchor.constraint(equalTo: titleLabelView.centerXAnchor),
            TitleLabel.centerYAnchor.constraint(equalTo: titleLabelView.centerYAnchor),
            
    
            groupDaresCollectionView.topAnchor.constraint(equalTo: TitleLabel.bottomAnchor, constant: 16),
            groupDaresCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            groupDaresCollectionView.widthAnchor.constraint(equalToConstant: view.frame.width),
            groupDaresCollectionView.bottomAnchor.constraint(equalTo: pointRemovalMainview.topAnchor, constant: -8),
            


//            BOTTOM SECTION (BUTTONS)
            
            pointRemovalMainview.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8),
            pointRemovalMainview.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.90),
            pointRemovalMainview.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pointRemovalMainview.heightAnchor.constraint(equalToConstant: 50),

            pointRemovalLabel.centerXAnchor.constraint(equalTo:pointRemovalMainview.centerXAnchor),
            pointRemovalLabel.centerYAnchor.constraint(equalTo: pointRemovalMainview.centerYAnchor),
            
            loadingAnimation.centerYAnchor.constraint(equalTo: pointRemovalLabel.centerYAnchor),
            loadingAnimation.trailingAnchor.constraint(equalTo: pointRemovalMainview.trailingAnchor, constant: -16),
            loadingAnimation.widthAnchor.constraint(equalToConstant: 30),
            loadingAnimation.heightAnchor.constraint(equalToConstant: 30),
            
        ])
        
    }
    
    
    
    @objc func startGame(){
        let vc = MenuChallengeView()
        vc.keyFound = KeyFound
        
        if let window = UIApplication.shared.keyWindow{
            blackWindow.frame = window.frame
            blackWindow.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackWindow.alpha = 0

            view.addSubview(blackWindow)

            UIView.animate(withDuration: 0.5) {
                self.blackWindow.alpha = 1
            }
        }

        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        vc.changeView = self


        present(vc, animated: true)
    }

    

    var ListOfChallenges = [String]()
    var CompletedChallangesList = [String]()
    var IDChallangesList = [String]()
    func loadCollectionView(){
            ref.child("Groups").child(KeyFound).child("Challanges").queryOrderedByKey().observe(.childAdded) { snapshot in

                let value = snapshot.value as? NSDictionary
                let Messages = value?["Message"] as! String
                let Id = value?["Id"] as! String

                if self.ListOfChallenges.contains(Messages){
                    return
                }else{
                    self.ListOfChallenges.insert(Messages, at: 0)
                    self.IDChallangesList.insert(Id, at: 0)
                    self.groupDaresCollectionView.reloadData()
            }
        }
    }
    func DoneChallanges(){

        ref.child("user IDs").child(userDefault.string(forKey:"externalID")!).child("InGroups").child(keyOfKey).child("CompletedChallanges").queryOrderedByKey().observe(.childAdded) { snapshot in

                let value = snapshot.value as? NSDictionary
                let Ids = value?["Ids"] as! String
            if self.CompletedChallangesList.contains(Ids){
                    return
                }else{
                    self.CompletedChallangesList.insert(Ids, at: 0)
                    self.groupDaresCollectionView.reloadData()
            }
        }
    }
    

}

extension ChallangesView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ListOfChallenges.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellIDs().groupDaresCollectionViewCell, for: indexPath) as! groupDaresCollectionViewCell


//}
        ref.child("Groups").child(KeyFound).child("Active").observe(.value) { snapshot in
            
            let value = snapshot.value as? NSDictionary
            let active = value?["isActive"] as? String
            
            if active == "false" || active == "nil"{
                cell.dareTextLabel.attributedText = NSAttributedString(string: self.ListOfChallenges[indexPath.row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)])
            }else{
                cell.dareTextLabel.attributedText = NSAttributedString(string: self.ListOfChallenges[indexPath.row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)])
            }
        }

        
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 25
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        cell.layer.shadowRadius = 5.0
        cell.layer.shadowOpacity = 0.3

        if CompletedChallangesList.contains(IDChallangesList[indexPath.row]){
                                cell.doneView.backgroundColor = .green
                                cell.doneView.layer.borderWidth = 0
                                cell.dareTextLabel.alpha = 0.5
                        }else{
                            cell.doneView.layer.borderWidth = 1
                            cell.doneView.backgroundColor = .clear
                            cell.dareTextLabel.alpha = 1
                        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sizeOfItem = CGSize(width: (UIScreen.main.bounds.width-50)-8-55, height: 1000)

        let item = NSString(string: ListOfChallenges[indexPath.row]).boundingRect(with:sizeOfItem , options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)], context: nil)
        let size = CGSize(width: UIScreen.main.bounds.width-50, height: item.height + (UIScreen.main.bounds.width*0.08))
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        return inset
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if userDefault.bool(forKey:"LoggedInSnap") == true{
        ref.child("Groups").child(KeyFound).child("Active").observe(.value) { snapshot in
            
            let value = snapshot.value as? NSDictionary
            let active = value?["isActive"] as! String
            
            if active == "false" || active == "nil"{return}else{
            
                if self.CompletedChallangesList.contains(self.IDChallangesList[indexPath.row]){
                    return
                }else{
                if let window = UIApplication.shared.keyWindow{
                    self.blackWindow.frame = window.frame
                    self.blackWindow.backgroundColor = UIColor(white: 0, alpha: 0.5)
                    self.blackWindow.alpha = 0

                    self.view.addSubview(self.blackWindow)

                    UIView.animate(withDuration: 0.5) {
                        self.blackWindow.alpha = 1
                    }
            }
                let cell = collectionView.cellForItem(at: indexPath)!
                
                let renderer = UIGraphicsImageRenderer(size: cell.bounds.size)
                let image = renderer.image { ctx in
                    cell.drawHierarchy(in: cell.bounds, afterScreenUpdates: true)
                }
                let vc = TaskComplition()
                vc.SuggestionImageView.image = image
                vc.whiteView.heightAnchor.constraint(equalToConstant: cell.bounds.height + 175).isActive = true
                vc.modalPresentationStyle = .overCurrentContext
                    vc.cellKey = self.IDChallangesList[indexPath.row]
                    vc.keyFound = self.KeyFound
                    vc.keyOfKey = self.keyOfKey
                    
                    vc.delegate = self
                
                    self.present(vc, animated: true)
                }
        }
            }
        }
    }

}




class groupDaresCollectionViewCell: UICollectionViewCell{
    override init(frame: CGRect){
        super.init(frame:frame)
        constraintContainer()
}
    
    fileprivate let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.backgroundColor = .white
//        imageView.image = UIImage(named: "bitmojiExample")
        
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    fileprivate let lineView: UIView = {
        let line = UIView()
        line.backgroundColor = .black
        
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    
    fileprivate let doneView: UIView = {
        let line = UIView()
        line.layer.cornerRadius = 15/2
        line.layer.borderColor = UIColor.black.cgColor
        
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    
    fileprivate let usernameLabel: CustomLabel = {
        let label = CustomLabel()
        label.attributedText = NSAttributedString(string: "Caleb Mesfien", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)])
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let dareTextLabel: CustomLabel = {
       let label = CustomLabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    

    fileprivate func constraintContainer(){
//        self.addSubview(imageView)
//        self.addSubview(usernameLabel)
        self.addSubview(dareTextLabel)
        self.addSubview(lineView)
        self.addSubview(doneView)

//        self.addConstraintsWithFormat(format: "H:|-[v0(\(UIScreen.main.bounds.width*0.08))]-[v1]-|", views: imageView, usernameLabel)
//        self.addConstraintsWithFormat(format: "V:|-[v0(\(UIScreen.main.bounds.width*0.08))]-[v1]", views: imageView, dareTextLabel)
//        self.addConstraintsWithFormat(format: "V:|-[v0(\(UIScreen.main.bounds.width*0.08))]", views: usernameLabel)
        self.addConstraintsWithFormat(format: "V:|-[v0]-|", views: dareTextLabel)
        self.addConstraintsWithFormat(format: "V:[v0(\(self.frame.height*0.6))]", views: lineView)
        self.addConstraintsWithFormat(format: "V:[v0(15)]", views: doneView)
        
        self.addConstraintsWithFormat(format: "H:|-[v0]-[v1(0.3)]-16-[v2(15)]-12-|", views: dareTextLabel, lineView, doneView)
        
        NSLayoutConstraint.activate([
            doneView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            lineView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
}
}






//                              MARK:TASK COMPLITION

class TaskComplition: UIViewController{
    var keyFound = String()
    var keyOfKey = String()
    var userKey = [String]()
    var delegate: blackViewProtocol?
    var snapAPI: SCSDKSnapAPI?
    var cellKey = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        constraintContainer()
        snapAPI = SCSDKSnapAPI()
        let accapt2 = ref.child("user IDs").child(userDefault.string(forKey:"externalID")!).child("InGroups").child(keyOfKey)
            
        accapt2.observeSingleEvent(of: .value) { (DataSnapshot) in
            let value = DataSnapshot.value as? NSDictionary
            let key = value!["userId"] as! String
            self.userKey.removeAll()
            self.userKey.insert(key, at: 0)
        }
    }
    func AcceptChallange(Id: String){
        let accapt = ref.child("user IDs").child(userDefault.string(forKey:"externalID")!).child("InGroups").child(keyOfKey)
                    
        accapt.child("CompletedChallanges").childByAutoId().setValue(["Ids": Id])
        
        let notiSec = ref.child("Groups").child(keyFound).child("Notifications").childByAutoId()
        let user = userDefault.string(forKey:"displayName")
        let userImage = userDefault.string(forKey:"BitmojiURL")
        let time = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        notiSec.setValue(["user":user, "userImage":userImage, "type":"completed", "time": formatter.string(from: time)])
        
        
        let point = ref.child("Groups").child(keyFound).child("Users").child(userKey[0])
        point.observeSingleEvent(of:.value)  { snapshot in
            let value = snapshot.value as? NSDictionary
            let name = value?["Name"] as! String
            let ID = value?["id"] as! String
            let userImage  = value?["userImage"] as! String
            let score = value?["Score"] as! NSInteger

            point.setValue(["Name":name,"Score":score+1, "id":ID, "userImage":userImage])
        }
    }
    
    
    fileprivate let whiteView: CustomView = {
        let view = CustomView()
//        view.backgroundColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 1)
        
        view.layer.cornerRadius = 22
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate let viewTitle: CustomLabel = {
        let label = CustomLabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.attributedText = NSAttributedString(string: "Would you like to accept this task?", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22)])
        
        label.translatesAutoresizingMaskIntoConstraints  = false
        return label
    }()
    
    fileprivate let SuggestionImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    fileprivate let joinButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setAttributedTitle(NSAttributedString(string: "Accept",  attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]), for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addTarget(self, action: #selector(AcceptSelected), for: .touchUpInside)
        
        button.layer.cornerRadius = 20
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
//        whiteView.addSubview(viewDescription)
        whiteView.addSubview(SuggestionImageView)
            whiteView.addSubview(joinButton)
        
        NSLayoutConstraint.activate([
            whiteView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            whiteView.widthAnchor.constraint(equalTo: view.widthAnchor,constant: -42),
            whiteView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            viewTitle.topAnchor.constraint(equalTo: whiteView.topAnchor, constant: 16),
            viewTitle.leadingAnchor.constraint(equalTo: whiteView.leadingAnchor, constant: 16),
            viewTitle.trailingAnchor.constraint(equalTo: whiteView.trailingAnchor, constant: -16),
            viewTitle.heightAnchor.constraint(equalToConstant: viewTitle.intrinsicContentSize.height * 2),
            
//            viewDescription.topAnchor.constraint(equalTo: viewTitle.bottomAnchor, constant: 8),
//            viewDescription.leadingAnchor.constraint(equalTo: viewTitle.leadingAnchor, constant: 16),
//            viewDescription.trailingAnchor.constraint(equalTo: viewTitle.trailingAnchor, constant: -16),
//            viewDescription.heightAnchor.constraint(equalToConstant: viewDescription.intrinsicContentSize.height*3),

            SuggestionImageView.topAnchor.constraint(equalTo: viewTitle.bottomAnchor,constant: 8),
            SuggestionImageView.widthAnchor.constraint(equalTo: whiteView.widthAnchor, constant: -16),
            SuggestionImageView.centerXAnchor.constraint(equalTo: whiteView.centerXAnchor),
            
            
            joinButton.widthAnchor.constraint(equalToConstant: 110),
            joinButton.heightAnchor.constraint(equalToConstant: 40),
            joinButton.centerXAnchor.constraint(equalTo: whiteView.centerXAnchor),
            joinButton.bottomAnchor.constraint(equalTo: whiteView.bottomAnchor, constant: -8)
            
        ])
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped(gesture:)))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func backgroundTapped(gesture: UIGestureRecognizer) {
        delegate?.changeBlackView()

        self.dismiss(animated: true, completion: nil)

    }

    
    func yourMethodWhereYouShareToSnapchatFromWithCompletion(completionHandler: (Bool, Error?) ->()) {
        let renderer = UIGraphicsImageRenderer(size: SuggestionImageView.bounds.size)
        let image = renderer.image { ctx in
            SuggestionImageView.drawHierarchy(in: SuggestionImageView.bounds, afterScreenUpdates: true)
        }
//        let stickerImage = UIImage(view: viewBeingPosted) // Any image is OK. In this codes, SceneView's snapshot is passed.
        let sticker = SCSDKSnapSticker(stickerImage: image)


        let snap = SCSDKNoSnapContent()
        // Sticker
        snap.sticker = sticker
        // Caption

        // URL
        snap.attachmentUrl = "https://scavenge-162d6.web.app/?type=fetch&Id=\(keyFound)"

        snapAPI!.startSending(snap) { error in

            if let error = error {
                print(error.localizedDescription)
            } else {
                // success
            }
        }
    }
    @objc func AcceptSelected(){
        yourMethodWhereYouShareToSnapchatFromWithCompletion { (Bool, eror) in}
        AcceptChallange(Id: cellKey)
        delegate?.changeBlackView()

            self.dismiss(animated: true, completion: {
            })
        
    }
}






//                              MENU SELECTED VIEW




class MenuChallengeView: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return hours.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return hours[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        timeSelected = hoursTime[row]
    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        dayPicker.selectRow(3, inComponent: 0, animated: true)
//
//    }
    var delegate: blackViewProtocol?
    var changeView: changeView?
    var keyFound = String()
    var timeSelected = 120
    
    override func viewDidLoad() {
        super.viewDidLoad()
        constraintContainer()
    }
    let hours = ["15 Minutes",
                 "30 Minutes",
                 "1 Hour",
                 "2 Hours",
                 "6 Hours",
                 "12 Hours",
                 "24 Hours"]
    
    let hoursTime = [15,
                 30,
                 60,
                 60*2,
                 60*6,
                 12*60,
                 24*60]
    fileprivate let dismissView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate let whiteView: CustomView = {
        let view = CustomView()
        view.backgroundColor = .white
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let dayPicker: UIPickerView = {
       let picker = UIPickerView()
        picker.selectRow(3, inComponent: 0, animated: true)
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    fileprivate let viewLabel: CustomLabel = {
        let label = CustomLabel()
        label.numberOfLines =  2
        label.textAlignment = .center
        label.attributedText = NSAttributedString(string: "How long should this game be?", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 25), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    fileprivate let startButtonView: CustomView = {
        let view = CustomView()
        
        view.backgroundColor = .white
        
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        view.layer.shadowRadius = 8.0
        view.layer.shadowOpacity = 0.3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    fileprivate let startButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "Start", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22), NSAttributedString.Key.foregroundColor: UIColor.black]), for: .normal)
        button.addTarget(self, action: #selector(StartGameSelected), for: .touchUpInside)

        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private func constraintContainer(){
        dayPicker.delegate = self

        view.addSubview(dismissView)
        
        view.addSubview(whiteView)
            whiteView.addSubview(viewLabel)
            whiteView.addSubview(dayPicker)

            whiteView.addSubview(startButtonView)
                startButtonView.addSubview(startButton)
        
        NSLayoutConstraint.activate([
            dismissView.topAnchor.constraint(equalTo: view.topAnchor),
            dismissView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dismissView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dismissView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -350),
            
//            whiteView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            whiteView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            whiteView.widthAnchor.constraint(equalTo: view.widthAnchor),
            whiteView.heightAnchor.constraint(equalToConstant: 350),
            
            viewLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewLabel.topAnchor.constraint(equalTo: whiteView.topAnchor, constant: 18),
            viewLabel.widthAnchor.constraint(equalTo: whiteView.widthAnchor, multiplier: 0.7),
            viewLabel.heightAnchor.constraint(equalToConstant: 75),
            
            dayPicker.topAnchor.constraint(equalTo: viewLabel.bottomAnchor, constant: 8),
            dayPicker.bottomAnchor.constraint(equalTo: startButtonView.topAnchor, constant: -8),
            dayPicker.centerXAnchor.constraint(equalTo: whiteView.centerXAnchor),
            

            
//            lottieView.topAnchor.constraint(equalTo: whiteView.topAnchor, constant: 8),
//            lottieView.heightAnchor.constraint(equalTo: whiteView.widthAnchor, multiplier: 0.25),
//            lottieView.widthAnchor.constraint(equalTo: whiteView.widthAnchor, multiplier: 0.25),

            
            startButtonView.centerXAnchor.constraint(equalTo: whiteView.centerXAnchor),
            startButtonView.widthAnchor.constraint(equalTo: whiteView.widthAnchor, multiplier: 0.8),
            startButtonView.heightAnchor.constraint(equalToConstant: 40),
            startButtonView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            
            startButton.centerXAnchor.constraint(equalTo: startButtonView.centerXAnchor),
            startButton.centerYAnchor.constraint(equalTo: startButtonView.centerYAnchor)
            
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
    return true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        dayPicker.selectRow(3, inComponent: 0, animated: true)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped(gesture:)))
        dismissView.addGestureRecognizer(tapGesture)
    }

    
    @objc func backgroundTapped(gesture: UIGestureRecognizer) {
        delegate?.changeBlackView()
        self.dismiss(animated: true, completion: nil)

    }
    
    
    func getCurrentDate()-> Date {
        var now = Date()
        var nowComponents = DateComponents()
        let calendar = Calendar.current
        nowComponents.year = Calendar.current.component(.year, from: now)
        nowComponents.month = Calendar.current.component(.month, from: now)
        nowComponents.day = Calendar.current.component(.day, from: now)
        nowComponents.hour = Calendar.current.component(.hour, from: now)
        nowComponents.minute = Calendar.current.component(.minute, from: now)
        nowComponents.second = Calendar.current.component(.second, from: now)
        nowComponents.timeZone = NSTimeZone.local
        now = calendar.date(from: nowComponents)!
        return now as Date
    }

    
    @objc func StartGameSelected(){
        let point = ref.child("Groups").child(keyFound).child("Active")
        point.observeSingleEvent(of:.value)  {snapshot in

            
            let formatter = DateFormatter()
            let secondFormatter = DateFormatter()
            formatter.dateFormat = "hh:mm a"
            secondFormatter.dateFormat  = "MM-dd-yyyy hh:mm a"
            let currentDate = self.getCurrentDate()
     
            var dateComponent = DateComponents()
            dateComponent.minute = self.timeSelected
            
            let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
            
            point.setValue(["isActive":"true", "endTime":formatter.string(from: futureDate!), "EntireDate":secondFormatter.string(from: futureDate!)])
        

            self.delegate?.changeBlackView()
            self.changeView?.gameBegan(time: formatter.string(from: futureDate!))
            self.dismiss(animated: true, completion: nil)
    }
        
    }
}





//                              COLLECTION VIEW CELL
class MenuClassCell: UICollectionViewCell{
    override var isHighlighted: Bool {
        didSet{
            imageView.tintColor = isHighlighted ? .black : UIColor.lightGray
            textLabel.textColor = isHighlighted ? .black : UIColor.lightGray
            
        }
    }
    override var isSelected: Bool {
        didSet{
            imageView.tintColor = isSelected ? .black : UIColor.lightGray
            textLabel.textColor = isSelected ? .black : UIColor.lightGray
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(textLabel)
        addConstraintsWithFormat(format: "V:|[v0]-[v1(10)]|", views: imageView, textLabel)
        addConstraintsWithFormat(format: "H:[v0(30)]", views: imageView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: textLabel)
        imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    let imageView: UIImageView = {
       let imageView = UIImageView()

        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let textLabel: CustomLabel = {
       let label = CustomLabel()
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}





//                                                MARK:LEADERBOARD VIEW



struct leaderboardUser {
    var name: String
    var image: String
    var score: Int
    var userKey: String
}

class LeaderBoardView: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, blackViewProtocol {
    func changeBlackView() {
        UIView.animate(withDuration: 0.5) {
            self.blackWindow.alpha = 0
    }
    }
    
    func presentShareView() {
        
    }
    
    var keyFound = String()
    var rewardText = String()
    var numOfUsers = Int()
    
    var listOfUsers = [leaderboardUser]()
    
    let blackWindow = UIView()
    var ref = Database.database().reference()
    func fetchUsers(){
        listOfUsers.removeAll()
        let item = ref.child("Groups").child(keyFound).child("Users")
            item.observe(.childAdded)  {snapshot in
            if snapshot.exists(){
            let value = snapshot.value as? NSDictionary
            let name = value?["Name"] as! String
            let image = value?["userImage"] as! String
            let score = value?["Score"] as! NSInteger
            let key = snapshot.key
                self.listOfUsers.insert(leaderboardUser(name: name, image: image, score: score, userKey: key), at: 0)
                self.collectionView.reloadData()
        }
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listOfUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellIDs().groupMembersCollectionViewCell, for: indexPath) as! GroupMembersCollectionViewCell


        cell.memberNameLabel.text = listOfUsers[indexPath.row].name
        cell.bitmojiImageView.load(url: URL(string: listOfUsers[indexPath.row].image)!)
        cell.userScore.attributedText = NSAttributedString(string: String(listOfUsers[indexPath.row].score), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.black])
        
        cell.layer.cornerRadius = 20.0
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        cell.layer.shadowRadius = 8.0
        cell.layer.shadowOpacity = 0.5
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: UIScreen.main.bounds.width-50, height: 55)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if userDefault.bool(forKey:"LoggedInSnap") == true{
        ref.child("Groups").child(keyFound).observeSingleEvent(of:.value) { snapshot in
            let value = snapshot.value as? NSDictionary
            let leaderID = value?["LeaderID"] as! String
            self.ref.child("Groups").child(self.keyFound).child("Active").observe(.value) { snapshot in
                
                let value = snapshot.value as? NSDictionary
                let active = value?["isActive"] as! String
                
                if active == "false" || active == "nil"{return}else{
        if leaderID == userDefault.string(forKey:"externalID")!{


            if let window = UIApplication.shared.keyWindow{
                self.blackWindow.frame = window.frame
                self.blackWindow.backgroundColor = UIColor(white: 0, alpha: 0.5)
                self.blackWindow.alpha = 0

                self.view.addSubview(self.blackWindow)

                UIView.animate(withDuration: 0.5) {
                    self.blackWindow.alpha = 1
                }
            }
        }
        
    }
//        ref.child("Groups").child(keyFound).child("Users").observe(.childAdded) { snapshot in

    let vc = RemovePointView()
    vc.modalPresentationStyle = .overCurrentContext
    vc.delegate = self
            vc.username = self.listOfUsers[indexPath.row].name
            vc.userKey = self.listOfUsers[indexPath.row].userKey
            vc.userImageURL = self.listOfUsers[indexPath.row].image
            vc.keyFound = self.keyFound

            self.present(vc, animated: true)

        }
        }
        }
    }
    
    func fetchReward(){
                ref.child("Groups").child(keyFound).child("Users").observe(.value) { snapshot in
                    let value = snapshot.value as? NSDictionary
                    if value?.count == nil{
                        self.numOfUsers = 0
                    }else{
                            self.numOfUsers = value!.count
                        }
                }
    }
    
    
    
    
    
    
    
    
    var delegate: blackViewProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        collectionView.backgroundView = refreshControl

        constraintContainer()
        fetchUsers()
        fetchReward()
    }
    
    fileprivate let leaderboardLabel: CustomLabel = {
        let label = CustomLabel()
        label.attributedText = NSAttributedString(string: "Leaderboard", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 25)])
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let leaderboardTitleView: CustomView = {
       let view = CustomView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 18
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        view.layer.shadowRadius = 10.0
        view.layer.shadowOpacity = 0.3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    fileprivate let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.layer.cornerRadius = 25
        collectionView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        collectionView.register(GroupMembersCollectionViewCell.self, forCellWithReuseIdentifier: collectionViewCellIDs().groupMembersCollectionViewCell)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()


    
    
//          REMOVE POINT FROM MEMBER
    fileprivate let pointRemovalMainview: UIView = {
     let view = UIView()
        view.backgroundColor = .white
        
        view.layer.cornerRadius = 22
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        view.layer.shadowRadius = 10.0
        view.layer.shadowOpacity = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    fileprivate let pointRemovalLabel: CustomLabel = {
       let label = CustomLabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.attributedText = NSAttributedString(string: "The group leader can remove points from members by selecting their tag.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)])
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let pointRemovalXButton: UIButton = {
        let button = UIButton()
        
        button.addTarget(self, action: #selector(pointRemvalButtonSlected), for: .touchUpInside)
        button.setImage(UIImage(named: "xImage"), for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 25/2
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshGroupList(_:)), for: .valueChanged)
        refresh.layoutIfNeeded()
        
        
        return refresh
    }()
    var rewardViewHight: Array<NSLayoutConstraint>.ArrayLiteralElement?
    var collectionViewBottom: Array<NSLayoutConstraint>.ArrayLiteralElement?
    private func constraintContainer(){
        collectionView.delegate = self
        collectionView.dataSource = self
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refreshControl
//            pastHuntsCollectionView.sendSubviewToBack(refreshControl)

        } else {
            collectionView.addSubview(refreshControl)
//            pastHuntsCollectionView.sendSubviewToBack(refreshControl)
        }
        
        view.addSubview(leaderboardTitleView)
        leaderboardTitleView.addSubview(leaderboardLabel)
        view.addSubview(collectionView)
        
        view.addSubview(pointRemovalMainview)
            pointRemovalMainview.addSubview(pointRemovalLabel)
            pointRemovalMainview.addSubview(pointRemovalXButton)
        

        collectionViewBottom = collectionView.bottomAnchor.constraint(equalTo: pointRemovalMainview.topAnchor, constant: -8)

        NSLayoutConstraint.activate([
            leaderboardTitleView.topAnchor.constraint(equalTo: view.topAnchor,constant: 8),
            leaderboardTitleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            leaderboardTitleView.heightAnchor.constraint(equalTo: leaderboardLabel.heightAnchor, constant: 8),
            leaderboardTitleView.widthAnchor.constraint(equalTo: leaderboardLabel.widthAnchor, constant: 32),
            
            leaderboardLabel.centerXAnchor.constraint(equalTo: leaderboardTitleView.centerXAnchor),
            leaderboardLabel.centerYAnchor.constraint(equalTo: leaderboardTitleView.centerYAnchor),

            
            collectionView.topAnchor.constraint(equalTo: leaderboardTitleView.bottomAnchor, constant: 8),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            
            pointRemovalMainview.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8),
            pointRemovalMainview.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.90),
            pointRemovalMainview.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pointRemovalMainview.heightAnchor.constraint(equalToConstant: 50),
            
            pointRemovalLabel.leadingAnchor.constraint(equalTo: pointRemovalMainview.leadingAnchor, constant: 28),
            pointRemovalLabel.trailingAnchor.constraint(equalTo: pointRemovalMainview.trailingAnchor, constant: -28),
            pointRemovalLabel.bottomAnchor.constraint(equalTo: pointRemovalMainview.bottomAnchor, constant: -8),
            
            pointRemovalXButton.centerYAnchor.constraint(equalTo: pointRemovalMainview.centerYAnchor),
            pointRemovalXButton.trailingAnchor.constraint(equalTo: pointRemovalMainview.trailingAnchor, constant: -8),
            pointRemovalXButton.widthAnchor.constraint(equalToConstant: 20),
            pointRemovalXButton.heightAnchor.constraint(equalToConstant: 20),
            
            


        ])
//        userDefault.setValue(nil, forKey: "removePointRemoverView")
        if userDefault.object(forKey: "removePointRemoverView") == nil{
            collectionViewBottom?.isActive = true
        }else{
            pointRemovalMainview.removeFromSuperview()
            pointRemovalLabel.removeFromSuperview()
            pointRemovalXButton.removeFromSuperview()
            collectionViewBottom = collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8)
            collectionViewBottom?.isActive = true
            
        }

    }

    @objc private func refreshGroupList(_ sender: UIRefreshControl) {
        sender.endRefreshing()
//        DispatchQueue.main.async {
            fetchUsers()
            collectionView.reloadData()
            view.layoutIfNeeded()
//        }

    }
    @objc func pointRemvalButtonSlected(){
        userDefault.setValue(true, forKey: "removePointRemoverView")
        pointRemovalMainview.removeFromSuperview()
        pointRemovalLabel.removeFromSuperview()
        pointRemovalXButton.removeFromSuperview()
        collectionViewBottom = collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8)
        collectionViewBottom?.isActive = true

    }

}










//                                              MARK:REMOVE POINT VIEW
class RemovePointView: UIViewController {
    var delegate: blackViewProtocol?
    
    var userKey = String()
    var userImageURL = String()
    var username = String()
    var keyFound = String()
    var keyOfKey = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bitmojiImage.load(url: URL(string: userImageURL)!)
        let attr1 = [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]
        let attr2 = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)]
        let string1 = NSMutableAttributedString(string:"Are you sure you want to remove a point from ", attributes: attr1)
        let string2 = NSMutableAttributedString(string:username, attributes: attr2)
        let string3 = NSMutableAttributedString(string:"?", attributes: attr1)
        
        string1.append(string2)
        string1.append(string3)
        viewDescription.attributedText = string1
        constraintContainer()
    }
    

    fileprivate let whiteView: CustomView = {
        let view = CustomView()
        view.backgroundColor = .white
        
        view.layer.cornerRadius = 22
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate let bitmojiImage: UIImageView = {
       let imageView = UIImageView()
//        imageView.load(url: )
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    fileprivate let viewTitle: CustomLabel = {
        let label = CustomLabel()
        label.textAlignment = .center
        label.attributedText = NSAttributedString(string: "Remove Point", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)])
        
        label.translatesAutoresizingMaskIntoConstraints  = false
        return label
    }()
    
    
    fileprivate let viewDescription: CustomLabel = {
        let label = CustomLabel()
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints  = false
        return label
    }()
    
    
    fileprivate let removeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 253/255, green: 78/255, blue: 81/255, alpha: 1)
        button.setAttributedTitle(NSAttributedString(string: "Remove", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]), for: .normal)
        button.addTarget(self, action: #selector(PasteButtonSelected), for: .touchUpInside)

        button.layer.cornerRadius = 35/2
        button.layer.shadowColor = UIColor(red: 253/255, green: 78/255, blue: 81/255, alpha: 1).cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        button.layer.shadowRadius = 10.0
        button.layer.shadowOpacity = 0.3
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate let cancelButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setAttributedTitle(NSAttributedString(string: "Cancel",  attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)]), for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addTarget(self, action: #selector(JoinButtonSelected), for: .touchUpInside)
        
        button.layer.cornerRadius = 35/2
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
        
        whiteView.addSubview(bitmojiImage)
        whiteView.addSubview(viewTitle)
        whiteView.addSubview(viewDescription)

            whiteView.addSubview(removeButton)
            whiteView.addSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            whiteView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            whiteView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            whiteView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.70),
            whiteView.heightAnchor.constraint(equalToConstant: 250),
            
            bitmojiImage.topAnchor.constraint(equalTo: whiteView.topAnchor, constant: 16),
            bitmojiImage.widthAnchor.constraint(equalToConstant: 50),
            bitmojiImage.heightAnchor.constraint(equalToConstant: 50),
            bitmojiImage.centerXAnchor.constraint(equalTo: whiteView.centerXAnchor),
            
            viewTitle.topAnchor.constraint(equalTo: bitmojiImage.bottomAnchor, constant: 16),
            viewTitle.leadingAnchor.constraint(equalTo: whiteView.leadingAnchor, constant: 16),
            viewTitle.trailingAnchor.constraint(equalTo: whiteView.trailingAnchor, constant: -16),
            viewTitle.heightAnchor.constraint(equalToConstant: viewTitle.intrinsicContentSize.height),
            
            viewDescription.topAnchor.constraint(equalTo: viewTitle.bottomAnchor, constant: 8),
            viewDescription.leadingAnchor.constraint(equalTo: viewTitle.leadingAnchor, constant: 16),
            viewDescription.trailingAnchor.constraint(equalTo: viewTitle.trailingAnchor, constant: -16),
            viewDescription.heightAnchor.constraint(equalToConstant: viewDescription.intrinsicContentSize.height*3),
            
            removeButton.topAnchor.constraint(equalTo: viewDescription.bottomAnchor, constant: 16),
            removeButton.heightAnchor.constraint(equalToConstant: 35),
            removeButton.widthAnchor.constraint(equalTo: whiteView.heightAnchor,multiplier: 0.75),
            removeButton.centerXAnchor.constraint(equalTo: whiteView.centerXAnchor),
            
            cancelButton.topAnchor.constraint(equalTo: removeButton.bottomAnchor, constant: 16),
            cancelButton.heightAnchor.constraint(equalToConstant: 35),
            cancelButton.widthAnchor.constraint(equalTo: whiteView.heightAnchor,multiplier: 0.75),
            cancelButton.centerXAnchor.constraint(equalTo: whiteView.centerXAnchor),
            
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
    @objc func PasteButtonSelected(){
//
        let notiSec = ref.child("Groups").child(keyFound).child("Notifications").childByAutoId()
        let user = userDefault.string(forKey:"displayName")
        let userImage = userDefault.string(forKey:"BitmojiURL")
        let time = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        notiSec.setValue(["user":user, "userImage":userImage, "type":"removed", "time": formatter.string(from: time)])

        let point = ref.child("Groups").child(keyFound).child("Users").child(userKey)
        point.observeSingleEvent(of:.value)  { snapshot in
            let value = snapshot.value as? NSDictionary
            let name = value?["Name"] as! String
            let ID = value?["id"] as! String
            let userImage  = value?["userImage"] as! String
            let score = value?["Score"] as! NSInteger

            if score > 0{
                point.setValue(["Name":name,"Score":score-1, "id":ID, "userImage":userImage])
            }
        }
        DispatchQueue.main.async {
            self.delegate?.changeBlackView()
            self.dismiss(animated: true, completion:nil)
        }

    }
    

    @objc func JoinButtonSelected(){
        delegate?.changeBlackView()
        self.dismiss(animated: true, completion: nil)
    }
    

    func GroupFound(){
        let userItem = ref.child("Groups").child("textField.text!").child("Users").childByAutoId()
        userItem.setValue(["Name":userDefault.string(forKey:"displayName")!, "Score":0, "id":userDefault.string(forKey:"externalID")!, "userImage":userDefault.string(forKey:"BitmojiURL")!])
        
        
        ref.child("user IDs").child(userDefault.string(forKey:"externalID")!).child("InGroups").childByAutoId().setValue(["key":"textField.text!", "userId":userItem.key])
        delegate?.changeBlackView()

        self.dismiss(animated: true, completion: nil)
    }

}























class GroupMembersCollectionViewCell: UICollectionViewCell{
    override init(frame: CGRect) {
        super.init(frame: frame)
        constraintContainer()
        self.backgroundColor = .white
    }
    
    fileprivate let bitmojiImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    fileprivate let memberNameLabel: CustomLabel = {
       let label = CustomLabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let userScore: CustomLabel = {
       let label = CustomLabel()
        label.adjustsFontSizeToFitWidth = true

        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    fileprivate func constraintContainer(){
        self.addSubview(bitmojiImageView)
        self.addSubview(memberNameLabel)
        self.addSubview(userScore)

        
        self.addConstraintsWithFormat(format: "H:|-16-[v0]-[v1]-[v2(40)]-16-|", views:bitmojiImageView, memberNameLabel, userScore)
        
        self.addConstraintsWithFormat(format: "V:[v0(45)]", views: bitmojiImageView)
        self.addConstraintsWithFormat(format: "V:|[v0]|", views: memberNameLabel)
        self.addConstraintsWithFormat(format: "V:|[v0]|", views: userScore)
        NSLayoutConstraint.activate([
            bitmojiImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            bitmojiImageView.widthAnchor.constraint(equalToConstant: 45),
            
        ])
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}










//                                  MARK:NOTIFICATIONS











struct notiPosts {
    var username: String
    var userImage: String
    var type: String
    var time: String
}
class NotificationView: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    var keyFound = String()
    var notificaions = [notiPosts]()
    
    var ref = Database.database().reference()
    func fetchUsers(){
        ref.child("Groups").child(keyFound).child("Notifications").queryOrderedByKey().observe(.childAdded) { snapshot in
                let value = snapshot.value as? NSDictionary
                let username = value?["user"] as! String
                let userImage = value?["userImage"] as! String
                let type = value?["type"] as! String
                let time = value?["time"] as! String
            
//
                self.notificaions.insert(notiPosts(username: username, userImage: userImage, type: type, time: time), at: 0)
                self.collectionView.reloadData()
        }
            
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notificaions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellIDs().NotificationViewCell, for: indexPath) as! NotificationViewCell
        
        
        if notificaions[indexPath.row].type == "completed"{
            cell.backgroundColor = UIColor(red: 60/255, green: 178/255, blue: 226/255, alpha: 1)
            cell.actionLabel.attributedText = NSAttributedString(string: "Completed a challenge.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize:20)])
        }else{
            cell.backgroundColor = UIColor(red: 233/255, green: 39/255, blue: 84/255, alpha: 1)
            cell.actionLabel.attributedText = NSAttributedString(string: "A point has been reduced.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize:20)])
        }
        
        cell.layer.cornerRadius = 20.0
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        cell.layer.shadowRadius = 8.0
        cell.layer.shadowOpacity = 0.5
        
        cell.bitmojiImageView.load(url: URL(string:notificaions[indexPath.row].userImage)!)
//        cell.bitmojiImageView.image = UIImage(named: "bitmojiExample")
        cell.userScore.attributedText = NSAttributedString(string: notificaions[indexPath.row].time, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22), NSAttributedString.Key.foregroundColor: UIColor.white])
        cell.memberNameLabel.attributedText = NSAttributedString(string: notificaions[indexPath.row].username, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22)])
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: UIScreen.main.bounds.width-50, height:110)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8)
    }
    
    
    
    
    var delegate: blackViewProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        constraintContainer()
        fetchUsers()
    }
    
    fileprivate let leaderboardLabel: CustomLabel = {
        let label = CustomLabel()
        label.attributedText = NSAttributedString(string: "Notifications", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 25)])
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let leaderboardTitleView: CustomView = {
       let view = CustomView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 18
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        view.layer.shadowRadius = 10.0
        view.layer.shadowOpacity = 0.3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    fileprivate let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.layer.cornerRadius = 25
        collectionView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        collectionView.register(NotificationViewCell.self, forCellWithReuseIdentifier: collectionViewCellIDs().NotificationViewCell)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private func constraintContainer(){
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(leaderboardTitleView)
        leaderboardTitleView.addSubview(leaderboardLabel)
        view.addSubview(collectionView)

        

        NSLayoutConstraint.activate([
            leaderboardTitleView.topAnchor.constraint(equalTo: view.topAnchor,constant: 8),
            leaderboardTitleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            leaderboardTitleView.heightAnchor.constraint(equalTo: leaderboardLabel.heightAnchor, constant: 8),
            leaderboardTitleView.widthAnchor.constraint(equalTo: leaderboardLabel.widthAnchor, constant: 32),
            
            leaderboardLabel.centerXAnchor.constraint(equalTo: leaderboardTitleView.centerXAnchor),
            leaderboardLabel.centerYAnchor.constraint(equalTo: leaderboardTitleView.centerYAnchor),

            
            collectionView.topAnchor.constraint(equalTo: leaderboardTitleView.bottomAnchor, constant: 8),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),


        ])
        
    }
}




//                      COLLECITONVIEW CELL



class NotificationViewCell: UICollectionViewCell{
    override init(frame: CGRect) {
        super.init(frame: frame)
        constraintContainer()
//        self.backgroundColor = .
    }
    
    fileprivate let bitmojiImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    fileprivate let memberNameLabel: CustomLabel = {
       let label = CustomLabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    fileprivate let tintView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.alpha = 0.5
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    fileprivate let userScore: CustomLabel = {
       let label = CustomLabel()
        label.adjustsFontSizeToFitWidth = true

        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let actionLabel: CustomLabel = {
        let label = CustomLabel()
        label.textAlignment = .center
        return label
    }()
        
    fileprivate func constraintContainer(){
//        self.addSubview(tintView)
        self.addSubview(bitmojiImageView)
        self.addSubview(memberNameLabel)
        self.addSubview(userScore)
        self.addSubview(actionLabel)

//        self.addConstraintsWithFormat(format: "H:|[v0]|", views: tintView)
        self.addConstraintsWithFormat(format: "H:|-[v0]-|", views: actionLabel)
//        self.addConstraintsWithFormat(format: "V:|[v0]|", views: tintView)

        self.addConstraintsWithFormat(format: "H:|-16-[v0(45)]-[v1]-[v2(50)]-16-|", views:bitmojiImageView, memberNameLabel, userScore)
        
        self.addConstraintsWithFormat(format: "V:|-[v0(45)]", views: bitmojiImageView)
        self.addConstraintsWithFormat(format: "V:|-[v0]-[v1(50)]-|", views: memberNameLabel, actionLabel)
        self.addConstraintsWithFormat(format: "V:|-[v0]", views: userScore)
        
        NSLayoutConstraint.activate([
            userScore.centerYAnchor.constraint(equalTo: memberNameLabel.centerYAnchor)
        ])
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


















//                                  FOURTH VIEW IN COLLECTION
class PostView: UIViewController, SCSDKBitmojiStickerPickerViewControllerDelegate, textInputProtocol, UITextFieldDelegate, UITextViewDelegate, blackViewProtocol, GameCreated {
    func openSuggestingView(isTrue: Bool, name: String) {
        if isTrue{
            let vc = SuggestingPost()
            vc.nameOfGroup = name
            present(vc, animated: true)
        }
    }
    
    func changeBlackView() {
        UIView.animate(withDuration: 0.5) {
            self.blackWindow.alpha = 0
    }
    }

    func textForPost(text: String) {
        mainLabel.attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22) ])
        viewBeingPosted.heightAnchor.constraint(equalTo: whitePostedView.heightAnchor, constant: 100).isActive = true
    }
    
    
    
    var delegate: blackViewProtocol?
    var snapAPI: SCSDKSnapAPI?
    var ref = Database.database().reference()
    var keyFound = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        snapAPI = SCSDKSnapAPI()
        mainLabel.delegate = self


        constraintController()
    }

    
    
    
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
//       view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
//       view.layer.cornerRadius = 30
       
       view.translatesAutoresizingMaskIntoConstraints = false
       return view
   }()
    
    private let shareToSnap: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 1.00, green: 0.99, blue: 0.00, alpha: 1.00)

        button.setAttributedTitle(NSAttributedString(string: "Snap", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)]), for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(SendToSnap), for: .touchUpInside)




        button.layer.cornerRadius = 25
//        button.layer.shadowColor = UIColor(red: 1.00, green: 0.99, blue: 0.00, alpha: 1.00).cgColor
//        button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
//        button.layer.shadowRadius = 8.0
//        button.layer.shadowOpacity = 0.3
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
        
        view.layer.cornerRadius = 45/2
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
        button.setImage(UIImage(named: "NoImageImage"), for: .normal)
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
    
//     THIS IS THE VIEW THAT WILL BE POSTED
    
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
        if userDefault.string(forKey: "BitmojiURL") != nil{
        imageView.load(url: URL(string: userDefault.string(forKey: "BitmojiURL")!)!)
        }else{
            imageView.image = UIImage(named: "NoImageImage")
        }
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
//        label.numberOfLines = 0
        label.textAlignment = .center
        label.attributedText = NSAttributedString(string: "Give us a challenge 😋", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22),NSAttributedString.Key.paragraphStyle:style])
        label.isScrollEnabled = false
        label.returnKeyType = .done
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
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
    
    

    fileprivate func constraintController(){
        view.addSubview(lottieBackground)
        view.addSubview(scrollView)
        
        view.addSubview(whiteView)

        whiteView.addSubview(shareToSnap)
        shareToSnap.addSubview(continueImageView)
        
        whiteView.addSubview(changeBitmojiView)
        changeBitmojiView.addSubview(changeBitmoji)
        
        whiteView.addSubview(changeTextView)
        changeTextView.addSubview(changeText)
        
        whiteView.addSubview(changeText)
        
//        THIS IS THE VIEW BEING POSTED
        scrollView.addSubview(viewBeingPosted)
        viewBeingPosted.addSubview(whitePostedView)
        whitePostedView.addSubview(bitmojiImageView)
        whitePostedView.addSubview(SeekLabelImage)
        whitePostedView.addSubview(mainLabel)
        whitePostedView.addSubview(swipeUpButton)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: whiteView.topAnchor),
            
            lottieBackground.topAnchor.constraint(equalTo: view.topAnchor,constant: -8),
            lottieBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lottieBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            lottieBackground.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            lottieBackground.heightAnchor.constraint(equalToConstant: 250),
            
            whiteView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            whiteView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            whiteView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            whiteView.heightAnchor.constraint(equalToConstant: 65),
            
            
            
            
            shareToSnap.centerYAnchor.constraint(equalTo: whiteView.centerYAnchor),
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


            
//            viewBeingPosted.topAnchor.constraint(equalTo: moneyMainView.bottomAnchor, constant: 16),
            viewBeingPosted.topAnchor.constraint(equalTo:  scrollView.centerYAnchor, constant: -75),
//            viewBeingPosted.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            
            viewBeingPosted.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            viewBeingPosted.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            viewBeingPosted.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -8),

//            whitePostedView.topAnchor.constraint(equalTo: moneyMainView.bottomAnchor, constant: 16),
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
        snap.attachmentUrl = "https://scavenge-162d6.web.app/?type=fetch&Id=\(keyFound)"

//        let api = SCSDKSnapAPI(content: snap)
        snapAPI!.startSending(snap) { error in

            if let error = error {
                print(error.localizedDescription)
            } else {
                // success
            }
        }
    }
    
    @objc func SendToSnap(){
        yourMethodWhereYouShareToSnapchatFromWithCompletion { (Bool, error) in}
    }
    let blackWindow = UIView()
    @objc func ChangeBitmojiSelected(){
        if userDefault.bool(forKey: "LoggedInSnap") == false{
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
            let vc = NotLoggedIn()
            vc.modalPresentationStyle = .overCurrentContext
            vc.delegate = self



            present(vc, animated: true)
        }else{
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
    }
    
    
    @objc func changeTextSelected(){
        mainLabel.becomeFirstResponder()
    }
    
    @objc func backgroundTapped(gesture: UIGestureRecognizer) {
        delegate?.changeBlackView()
        
        self.dismiss(animated: true, completion: {})

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
    func bitmojiStickerPickerViewController(_ stickerPickerViewController: SCSDKBitmojiStickerPickerViewController, didSelectBitmojiWithURL bitmojiURL: String, image: UIImage?) {
            bitmojiImageView.image = image
            stickerVC.view.removeFromSuperview()
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            
            let space = UIScreen.main.bounds.width-(UIScreen.main.bounds.width*0.8) - 20
            self.bitmojiImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.bitmojiImageView.transform = CGAffineTransform(translationX: 0, y: 0)
        })
    }
    func bitmojiStickerPickerViewController(_ stickerPickerViewController: SCSDKBitmojiStickerPickerViewController, searchFieldFocusDidChangeWithFocus hasFocus: Bool) {
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}





extension Date {
    func adding(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
}
