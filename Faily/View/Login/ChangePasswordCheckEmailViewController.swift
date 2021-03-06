//
//  ChangePasswordCheckEmailViewController.swift
//  Faily
//
//  Created by 구본의 on 2021/09/14.
//

import UIKit

class ChangePasswordCheckEmailViewController: UIViewController {

    
    @IBOutlet weak var emailBaseView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var configButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
    }
    
    func configUI() {
        self.navigationItem.backButtonTitle = ""
        self.title = "비밀번호 재설정"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        
        emailTextField.delegate = self
        emailTextField.returnKeyType = .done
        emailTextField.keyboardType = .alphabet
        
       
    }
    
    
    @IBAction func deleteEmailTextButtonAction(_ sender: Any) {
        self.emailTextField.text = ""
    }
    
    @IBAction func configButtonAction(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Login", bundle: nil)
        let changePasswordVC = storyBoard.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
        self.navigationController?.pushViewController(changePasswordVC, animated: true)
    }
    
}

extension ChangePasswordCheckEmailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      if textField == emailTextField {
        emailTextField.resignFirstResponder()
      }
      return true
    }
}
