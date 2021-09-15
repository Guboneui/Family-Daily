//
//  MainTabBar.swift
//  Faily
//
//  Created by 구본의 on 2021/09/16.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
    
    var homeButton: UIButton!
    var goChatView: UIView!
    private var shouldAllowPan: Bool = false
    private var isLongPressed: Bool = false
    
    
    
    override func loadView() {
        super.loadView()
        configUI()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedIndex = 2
        self.goChatView.isHidden = true
    }
    
    private func configUI() {
        self.homeButton = UIButton(frame: CGRect(x: (self.view.bounds.width / 2) - 30, y: -20, width: 60, height: 60))
        homeButton.backgroundColor = .orange
        self.tabBar.addSubview(homeButton)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture))
        panGesture.delegate = self
        self.panGesture(panGesture)
        homeButton.addGestureRecognizer(panGesture)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longGesture(_:)))
        homeButton.addGestureRecognizer(longPressGesture)
        
        
        let bounds: CGRect = UIScreen.main.bounds
        let height: CGFloat = bounds.size.height
        let k = height * 0.7

        
        self.goChatView = UIView(frame: CGRect(x: (self.view.frame.width / 2) - 40, y: height - k, width: 80, height: 80))
        goChatView.backgroundColor = .black
        self.view.addSubview(goChatView)
    }
    
    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        let position = recognizer.translation(in: self.view)
        let view = recognizer.view
        switch recognizer.state {
        case .changed:
            let maxValue: CGFloat = 50
            var now = position.y.magnitude
            
            if now > maxValue {
                now = maxValue
            }
            
            var newScale: CGFloat = 1 - ((now / maxValue) * 0.2)
            
            if let previousScale = view?.transform.d {
                newScale = CGFloat.minimum(newScale, previousScale)
            }
            let transform = CGAffineTransform(translationX: position.x, y: position.y).scaledBy(x: newScale, y: newScale)
            view?.transform = transform
            
            
            
            let aaa = recognizer.location(in: self.goChatView)
            
            let isOnX = 0...self.goChatView.frame.width ~= aaa.x
            let isOnY = 0...self.goChatView.frame.height ~= aaa.y
            
            let isOn = isOnY && isOnX
            
            let color: UIColor = (isOn) ? .black : .green
            let radius: CGFloat = isOn ? self.goChatView.frame.height / 2 : 0
            UIView.animate(withDuration: 0.5) {
                //self.middleLabel.textColor = .white
                self.goChatView.backgroundColor = color
                self.goChatView.layer.cornerRadius = radius
                
                
            }
            
        case .ended:
            
            self.isLongPressed = false
            
            if goChatView.backgroundColor == .black {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "확인", message: "", preferredStyle: .alert)
                    let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                view?.transform = .identity
                self.goChatView.backgroundColor = .green
                self.goChatView.layer.cornerRadius = 0
            }, completion: nil)
            print("End")
            
            
        default:
            break
        
        }
    }
    
    @objc
    func longGesture(_ recognizer: UILongPressGestureRecognizer) {
        switch recognizer.state {
        case .began:
            goChatView.isHidden = false
            HapticsManager.shared.impact()
            print("Long pressed - Start")
            guard let view = recognizer.view else { return }
            
            self.isLongPressed = true
            
            view.layer.zPosition = -(view.layer.zPosition)
            UIView.animate(withDuration: 0.4) {
                recognizer.view?.alpha = 1
            }
        
        case .changed:
            shouldAllowPan = true
            
            
        case .ended:
            goChatView.isHidden = true
            print("Long pressed - End")
            shouldAllowPan = false
            guard let view = recognizer.view else { return }
            self.isLongPressed = false
            
            UIView.animate(withDuration: 0.4, animations: {
                recognizer.view?.alpha = 1
            }) { _ in
                view.layer.zPosition = -(view.layer.zPosition)
            }
            
           
            
        default:
            break
        }
    }
}

extension MainTabBarController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if((gestureRecognizer is UIPanGestureRecognizer) && (shouldAllowPan == false)) {
                 return false
             }
             return true
    }

}