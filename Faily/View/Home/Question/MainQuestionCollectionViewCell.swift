//
//  MainQuestionCollectionViewCell.swift
//  Faily
//
//  Created by 구본의 on 2021/09/27.
//

import UIKit
import CollectionViewPagingLayout

protocol ReloadMainQuestionCollectionViewDelegate: AnyObject {
    func reloadCollectionView()
}

class MainQuestionCollectionViewCell: UICollectionViewCell, ScaleTransformView {
    
    
    @IBOutlet weak var questionBox: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerStackView: UIStackView!
    @IBOutlet weak var answerStackViewLabel: UILabel!
    @IBOutlet weak var answerStackViewImage: UIImageView!
    
    @IBOutlet weak var bgView: UIImageView!
    var getQuestionIndex = 0
    var question = ""
    
    var scaleOptions = ScaleTransformViewOptions (
        minScale: 0.68,
        scaleRatio: 0.35,
        translationRatio: CGPoint(x: 0.66, y: 0.2),
        //translationRatio: CGPoint(x: 0.77, y: 0.2),
        maxTranslationRatio: CGPoint(x: 2, y: 0),
        keepVerticalSpacingEqual: true,
        keepHorizontalSpacingEqual: true,
        scaleCurve: .linear,
        translationCurve: .linear
    )

    weak var delegate: ReloadMainQuestionCollectionViewDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goAnswerView))
        answerStackView.addGestureRecognizer(tapGesture)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
        self.bgView.layer.cornerRadius = 20
    }
    
    @objc func goAnswerView(_ recognizer: UITapGestureRecognizer) {
        if answerStackViewLabel.text == "답변하러 가기" {
            let storyBoard = UIStoryboard(name: "Home", bundle: nil)
            let qaVC = storyBoard.instantiateViewController(withIdentifier: "QAViewController") as! QAViewController
            qaVC.modalPresentationStyle = .overCurrentContext
            qaVC.getQuestionIndex = self.getQuestionIndex
            qaVC.question = self.question
            qaVC.delegate = self
            self.window?.rootViewController?.present(qaVC, animated: true, completion: nil)
            
        } else if answerStackViewLabel.text == "답변보러 가기" {
            let storyBoard = UIStoryboard(name: "Home", bundle: nil)
            let allAnswerVC = storyBoard.instantiateViewController(withIdentifier: "AllAnswerViewController")
            allAnswerVC.modalPresentationStyle = .overCurrentContext
            self.window?.rootViewController?.present(allAnswerVC, animated: true, completion: nil)
        }
    }
}

extension MainQuestionCollectionViewCell: ReloadQuestionCollectionViewDelegate {
    func reloadCollectionView() {
        self.delegate?.reloadCollectionView()
    }
    
    
}
