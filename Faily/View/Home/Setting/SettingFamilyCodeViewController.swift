//
//  SettingFamilyCodeViewController.swift
//  Faily
//
//  Created by źµ¬ė³øģ on 2021/10/05.
//

import UIKit

class SettingFamilyCodeViewController: UIViewController {

    @IBOutlet var baseView: UIView!
    @IBOutlet weak var codeView: UIView!
    @IBOutlet weak var inviteCodeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGesture()
       
    }
    
    func addGesture() {
        let dismissBaseViewGesture = UITapGestureRecognizer(target: self, action: #selector(dissmissView))
        baseView.isUserInteractionEnabled = true
        baseView.addGestureRecognizer(dismissBaseViewGesture)
    }
    
    @objc func dissmissView(sender: UITapGestureRecognizer) {
        self.dismiss(animated: false, completion: nil)
    }
    

    @IBAction func shareCodeButtonAction(_ sender: Any) {
        var objectsToShare = [String]()
        if let text = inviteCodeLabel.text {
            objectsToShare.append("š„³Faily ź°ģ”± ģøģ¦ģ½ėė„¼ ė³“ė“ėė ¤ģ\n\(text)")
            print("ź³µģ ķ  ķģ¤ķøė [\(text)]ģėė¤.")
        }
        
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        
        self.present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func copyCodeButtonAction(_ sender: Any) {
        print("ģ“ėģ½ėź° ė³µģ¬ėģģµėė¤.")
        let alert = UIAlertController(title: "ģ“ėģ½ėź° ė³µģ¬ėģģµėė¤.", message: "", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "ķģø", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
        UIPasteboard.general.string = inviteCodeLabel.text
    }
}
