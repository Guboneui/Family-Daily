//
//  HomeViewController.swift
//  Faily
//
//  Created by 구본의 on 2021/09/16.
//

import UIKit
import MKMagneticProgress
import MKColorPicker

class HomeViewController: UIViewController {

    
    @IBOutlet weak var totalProgressBaseView: UIView!
    @IBOutlet weak var totalProgressBaseImageView: UIImageView!
    
    @IBOutlet weak var totalProgress: MKMagneticProgress!
    @IBOutlet weak var navTitleLabel: UILabel!
    @IBOutlet weak var navProfileImage: UIImageView!
   
    let progressColorPicker = ColorPickerViewController()
    let backgroundColorPicker = ColorPickerViewController()
    let titleColorPicker = ColorPickerViewController()
    let percentColorPicker = ColorPickerViewController()
    
    
    func gradientLayer(bounds : CGRect,
                       color1: CGColor, color2: CGColor, color3: CGColor, color4: CGColor, color5: CGColor, color6: CGColor, color7: CGColor, color8: CGColor, color9: CGColor) -> CAGradientLayer{
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [color1, color2, color3, color4, color5, color6, color7, color8, color9]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        return gradient
    }

    // 그래디언트 레이어로 그래디언트 색 만들기
    func gradientColor(gradientLayer :CAGradientLayer) -> UIColor? {
        UIGraphicsBeginImageContextWithOptions(gradientLayer.bounds.size, false, 0.0)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIColor(patternImage: image!)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    func configUI() {
        navProfileImage.layer.cornerRadius = navProfileImage.frame.height / 2
        totalProgressBaseView.layer.cornerRadius = 20
        totalProgressBaseView.layer.shadowColor = UIColor.FailyColor.grayscale_4.cgColor
        totalProgressBaseView.layer.shadowOpacity = 0.33
        totalProgressBaseImageView.layer.cornerRadius = 20
        totalProgressBaseView.layer.shadowOffset = CGSize(width: 0, height: 4)
        totalProgress.setProgress(progress: 0.6, animated: true)
        totalProgress.progressShapeColor = .yellow
        totalProgress.backgroundShapeColor = .white
        totalProgress.lineWidth = 30
        totalProgress.spaceDegree = 90
        totalProgress.titleLabel.text = nil
        totalProgress.title = ""
        
        let bounds = self.totalProgress.bounds
        let color = gradientLayer(bounds: bounds, color1: UIColor.FailyColor.gradient1.cgColor, color2: UIColor.FailyColor.gradient2.cgColor, color3: UIColor.FailyColor.gradient3.cgColor, color4: UIColor.FailyColor.gradient4.cgColor, color5: UIColor.FailyColor.gradient5.cgColor, color6: UIColor.FailyColor.gradient6.cgColor, color7: UIColor.FailyColor.gradient7.cgColor, color8: UIColor.FailyColor.gradient8.cgColor, color9: UIColor.FailyColor.gradient9.cgColor)
        let realColor = gradientColor(gradientLayer: color)
        totalProgress.progressShapeColor = realColor!
       
    }
 
}
