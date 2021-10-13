//
//  ChatViewController.swift
//  Faily
//
//  Created by 구본의 on 2021/09/17.
//

import UIKit
import CoreMIDI
import IQKeyboardManager
import RxCocoa
import RxSwift



class ChatViewController: UIViewController {
    
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var bottomBaseView: UIView!
    @IBOutlet weak var bottomBaseViewHeight: NSLayoutConstraint!
    @IBOutlet weak var typingBaseView: UIView!
    @IBOutlet weak var messageTextView: UITextView!
    
    @IBOutlet weak var chatTableView: UITableView!
    
    var menuState = false
    
    let stackView = UIStackView()
    let emoticonStackView = UIStackView()
    let galleryStackView = UIStackView()
    let cameraStackView = UIStackView()
    let scheduleStackView = UIStackView()
    
    
    @IBOutlet weak var bottomMargin: NSLayoutConstraint!
    @IBOutlet weak var inputViewBottomMargin: NSLayoutConstraint!
    
    @IBOutlet weak var tableViewBottomMargin: NSLayoutConstraint!
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    let disposeBag = DisposeBag()
    
    var isFistLayoutSubviews = true
    var oldTableViewBottomInset: CGFloat = 0
    
    override func loadView() {
        super.loadView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        
        let emoticonImage = UIImageView()
        emoticonImage.image = UIImage(named: "emoticon_chat")
        let emoticonLabel = UILabel(frame: .zero)
        emoticonLabel.textAlignment = .center
        emoticonLabel.font = .boldSystemFont(ofSize: 12)
        emoticonLabel.textColor = UIColor(named: "grayscale2")
        emoticonLabel.text = "이모티콘"
        
        
        emoticonStackView.axis = .vertical
        emoticonStackView.alignment = .center
        emoticonStackView.distribution = .equalSpacing
        emoticonStackView.spacing = 3
        emoticonStackView.addArrangedSubview(emoticonImage)
        emoticonStackView.addArrangedSubview(emoticonLabel)
        emoticonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        let galleryImage = UIImageView()
        galleryImage.image = UIImage(named: "gallery_chat")
        let galleryLabel = UILabel(frame: .zero)
        galleryLabel.textAlignment = .center
        galleryLabel.font = .boldSystemFont(ofSize: 12)
        galleryLabel.textColor = UIColor(named: "grayscale2")
        galleryLabel.text = "갤러리"
        
        
        galleryStackView.axis = .vertical
        galleryStackView.alignment = .center
        galleryStackView.distribution = .equalSpacing
        galleryStackView.spacing = 3
        galleryStackView.addArrangedSubview(galleryImage)
        galleryStackView.addArrangedSubview(galleryLabel)
        galleryStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let cameraImage = UIImageView()
        cameraImage.image = UIImage(named: "camera_chat")
        let cameraLabel = UILabel(frame: .zero)
        cameraLabel.textAlignment = .center
        cameraLabel.font = .boldSystemFont(ofSize: 12)
        cameraLabel.textColor = UIColor(named: "grayscale2")
        cameraLabel.text = "카메라"
        
        
        cameraStackView.axis = .vertical
        cameraStackView.alignment = .center
        cameraStackView.distribution = .equalSpacing
        cameraStackView.spacing = 3
        cameraStackView.addArrangedSubview(cameraImage)
        cameraStackView.addArrangedSubview(cameraLabel)
        cameraStackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        
        let scheduleImage = UIImageView()
        scheduleImage.image = UIImage(named: "schedule_chat")
        let scheduleLabel = UILabel(frame: .zero)
        scheduleLabel.textAlignment = .center
        scheduleLabel.font = .boldSystemFont(ofSize: 12)
        scheduleLabel.textColor = UIColor(named: "grayscale2")
        scheduleLabel.text = "일정"
        
        
        scheduleStackView.axis = .vertical
        scheduleStackView.alignment = .center
        scheduleStackView.distribution = .equalSpacing
        scheduleStackView.spacing = 3
        scheduleStackView.addArrangedSubview(scheduleImage)
        scheduleStackView.addArrangedSubview(scheduleLabel)
        scheduleStackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        stackView.addArrangedSubview(emoticonStackView)
        stackView.addArrangedSubview(galleryStackView)
        stackView.addArrangedSubview(cameraStackView)
        stackView.addArrangedSubview(scheduleStackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.bottomBaseView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            emoticonImage.heightAnchor.constraint(equalToConstant: 24),
            emoticonImage.widthAnchor.constraint(equalToConstant: 24),
            
            galleryImage.heightAnchor.constraint(equalToConstant: 24),
            galleryImage.widthAnchor.constraint(equalToConstant: 24),
            
            cameraImage.heightAnchor.constraint(equalToConstant: 24),
            cameraImage.widthAnchor.constraint(equalToConstant: 24),
            
            scheduleImage.heightAnchor.constraint(equalToConstant: 24),
            scheduleImage.widthAnchor.constraint(equalToConstant: 24),
            
            stackView.topAnchor.constraint(equalTo: self.typingBaseView.bottomAnchor, constant: 15),
            stackView.leadingAnchor.constraint(equalTo: self.bottomBaseView.leadingAnchor, constant: 60),
            stackView.trailingAnchor.constraint(equalTo: self.bottomBaseView.trailingAnchor, constant: -60),
            //stackView.centerYAnchor.constraint(equalTo: self.bottomBaseView.centerYAnchor),
            
            
        ])
        typingBaseView.layer.cornerRadius = 17
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.stackView.isHidden = true
        IQKeyboardManager.shared().isEnabled = false
        
        let galleryStackViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(galleryStackViewActoin))
        galleryStackView.isUserInteractionEnabled = true
        galleryStackView.addGestureRecognizer(galleryStackViewTapGesture)
        
        let cameraStackViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(cameraStackViewAction))
        cameraStackView.isUserInteractionEnabled = true
        cameraStackView.addGestureRecognizer(cameraStackViewTapGesture)
        
        let scheduleStackViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(scheduleStackViewAction))
        scheduleStackView.isUserInteractionEnabled = true
        scheduleStackView.addGestureRecognizer(scheduleStackViewTapGesture)
        
        
        
        
        
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.separatorStyle = .none
        chatTableView.register(UINib(nibName: "MyMessageTableViewCell", bundle: nil), forCellReuseIdentifier: "MyMessageTableViewCell")
        chatTableView.register(UINib(nibName: "FamilyMessageTableViewCell", bundle: nil), forCellReuseIdentifier: "FamilyMessageTableViewCell")
        
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: {(completed) in
            let indexPath = IndexPath(row: 10, section: 0)
            self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        })
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShowNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHideNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
    }
    
    @objc func handleKeyboardShowNotification(_ sender: Notification) {
        
        let userInfo:NSDictionary = sender.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        print(keyboardRectangle)
        
        bottomMargin.constant =  keyboardRectangle.height - 22
        
       
        

        
    }
    
    @objc func handleKeyboardHideNotification(_ sender: Notification) {
        
        let userInfo:NSDictionary = sender.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        print(keyboardRectangle)
        
        
        bottomMargin.constant = 0

        
    }
    
    
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.shared().isEnabled = true
    }
    
    @objc func galleryStackViewActoin(_ sender: UITapGestureRecognizer) {
        print("gallery")
    }
    
    @objc func cameraStackViewAction(_ sender: UITapGestureRecognizer) {
        print("camera")
    }
    
    @objc func scheduleStackViewAction(_ sender: UITapGestureRecognizer) {
        print("schedule")
    }
    
    
    @IBAction func dismissButtonAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
        
    }
    
    @IBAction func menuButtonAction(_ sender: Any) {
        self.menuState.toggle()
        if menuState == true {
            bottomBaseView.layoutIfNeeded()
            menuButton.setImage(UIImage(named: "closeMark"), for: .normal)
            messageTextView.endEditing(true)
            UIView.animate(withDuration: 0, animations: {() -> Void in
                self.bottomBaseViewHeight.constant = 125
            })
            stackView.isHidden = false
        } else {
            bottomBaseView.layoutIfNeeded()
            menuButton.setImage(UIImage(named: "add_chat"), for: .normal)
            messageTextView.endEditing(true)
            UIView.animate(withDuration: 0, animations: {() -> Void in
                self.bottomBaseViewHeight.constant = 64
            })
            stackView.isHidden = true
        }
        
    }
    
    
    @IBAction func sendButtonAction(_ sender: Any) {
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: {(completed) in
            let indexPath = IndexPath(row: 10, section: 0)
            self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        })
    }
    
}


extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 11
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row < 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyMessageTableViewCell", for: indexPath) as! MyMessageTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FamilyMessageTableViewCell", for: indexPath) as! FamilyMessageTableViewCell
            return cell
        }
        
        
        
    }
    
    
}
