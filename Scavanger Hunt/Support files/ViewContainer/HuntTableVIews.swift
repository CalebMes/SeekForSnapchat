//
//  HuntTableVIews.swift
//  Scavanger Hunt
//
//  Created by Caleb Mesfien on 7/21/20.
//  Copyright © 2020 Caleb Mesfien. All rights reserved.
//

import UIKit


class HuntCollectionCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        constraintContainer()
//        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(LongPressActivated(Recognizer:)))
//        longPress.minimumPressDuration = 0.5
//        self.addGestureRecognizer(longPress)
    }
    
     let itemTitle: CustomLabel = {
       let label = CustomLabel()
        label.attributedText = NSAttributedString(string: "", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
     let itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    fileprivate func constraintContainer(){
        self.addSubview(itemTitle)
        self.addSubview(itemImageView)
        
        self.addConstraintsWithFormat(format: "V:|-[v0]-|", views: itemTitle)
        self.addConstraintsWithFormat(format: "V:|-[v0]-|", views: itemImageView)
        self.addConstraintsWithFormat(format: "H:|-[v0(\(self.frame.height-16))]-[v1]-|", views: itemImageView, itemTitle)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}















class RemoveGroup: UIViewController {
    var delegate: blackViewProtocol?
    var deleteItem: removeItem?
    
    var userKey = String()
    var userImageURL = String()
    var username = String()
    var keyFound = String()
    var keyOfKey = String()
    var userIdKey = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        bitmojiImage.load(url: URL(string: userImageURL)!)
        let attr1 = [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]
        let attr2 = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)]
        let string1 = NSMutableAttributedString(string:"Do you want to leve the group ", attributes: attr1)
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
    
     let bitmojiImage: UIImageView = {
       let imageView = UIImageView()
//        imageView.load(url: )
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    fileprivate let viewTitle: CustomLabel = {
        let label = CustomLabel()
        label.textAlignment = .center
        label.attributedText = NSAttributedString(string: "Leave Group", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)])
        
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
        button.setAttributedTitle(NSAttributedString(string: "Leave", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]), for: .normal)
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
    
    fileprivate let dismissView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private func constraintContainer(){
        view.addSubview(dismissView)
        view.addSubview(whiteView)
        
        whiteView.addSubview(bitmojiImage)
        whiteView.addSubview(viewTitle)
        whiteView.addSubview(viewDescription)

            whiteView.addSubview(removeButton)
            whiteView.addSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            dismissView.topAnchor.constraint(equalTo: view.topAnchor),
            dismissView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dismissView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dismissView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
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
        dismissView.addGestureRecognizer(tapGesture)
    }

    
    @objc func backgroundTapped(gesture: UIGestureRecognizer) {
        delegate?.changeBlackView()
        self.dismiss(animated: true, completion:nil)

    }
    
    @objc func PasteButtonSelected(){
//
//        let notiSec = ref.child("Groups").child(keyFound).child("Notifications").childByAutoId()
//        let user = userDefault.string(forKey:"displayName")
//        let userImage = userDefault.string(forKey:"BitmojiURL")
//        let time = Date()
//        let formatter = DateFormatter()
//        formatter.timeStyle = .short
//        notiSec.setValue(["user":user, "userImage":userImage, "type":"removed", "time": formatter.string(from: time)])

        let item = ref.child("Groups").child(self.keyFound)
        let group = ref.child("user IDs").child(userDefault.string(forKey: "externalID")!).child("InGroups").child(keyOfKey)
        group.observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let userID = value!["userId"] as! String
                item.child("Users").child(userID).setValue(nil)
        }
        group.setValue(nil)


        item.observe(.value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let leader = value?["LeaderID"] as? String
            if userDefault.string(forKey: "externalID")! == leader{
                item.setValue(nil)
            }
        }



        DispatchQueue.main.async {
            self.deleteItem?.removeKey(itemAt:self.keyFound)
            self.delegate?.changeBlackView()
            self.dismiss(animated: true, completion:nil)
        }

    }
    

    @objc func JoinButtonSelected(){
        delegate?.changeBlackView()

        self.dismiss(animated: true, completion: {
        })
        }
    

    func GroupFound(){
        let userItem = ref.child("Groups").child("textField.text!").child("Users").childByAutoId()
        userItem.setValue(["Name":userDefault.string(forKey:"displayName")!, "Score":0, "id":userDefault.string(forKey:"externalID")!, "userImage":userDefault.string(forKey:"BitmojiURL")!])
        
        
        ref.child("user IDs").child(userDefault.string(forKey:"externalID")!).child("InGroups").childByAutoId().setValue(["key":"textField.text!", "userId":userItem.key])
        delegate?.changeBlackView()

        self.dismiss(animated: true, completion: nil)
    }
//    func error(){
//        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
//        })
//
//        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
//        })
//        
//    }

    
    
    

}
