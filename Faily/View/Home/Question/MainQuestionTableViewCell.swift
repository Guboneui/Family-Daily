//
//  MainQuestionTableViewCell.swift
//  Faily
//
//  Created by 구본의 on 2021/09/27.
//

import UIKit
import CollectionViewPagingLayout

class MainQuestionTableViewCell: UITableViewCell {
    
    var dateArr = ["2021년 9월 25일", "2021년 9월 26일", "2021년 9월 27일", "2021년 9월 28일", "2021년 9월 29일", "2021년 9월 30일", "2021년 10월 1일"]
    
    @IBOutlet weak var questionCollectionView: UICollectionView!
    @IBOutlet weak var showAllQuestionStackView: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
        print("awakeFromNib")
        questionCollectionView.delegate = self
        questionCollectionView.dataSource = self
        
        let layout = CollectionViewPagingLayout()
        layout.delegate = self

        questionCollectionView.collectionViewLayout = layout

        questionCollectionView.isPagingEnabled = true
        questionCollectionView.register(UINib(nibName: "MainQuestionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MainQuestionCollectionViewCell")
//        layout.setCurrentPage(14, animated: false, completion: {
//            print("setcurrentpage 호출")
//
//        })
            
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goAnswerView))
        showAllQuestionStackView.addGestureRecognizer(tapGesture)
    }
    
  
    override func layoutSubviews() {
        super.layoutSubviews()
        print("레이아웃")
        layoutIfNeeded()
        let collectionBounds = self.questionCollectionView.bounds
        let contentOffset = CGFloat(floor(self.questionCollectionView.contentOffset.x + (questionCollectionView.frame.width * CGFloat(dateArr.count))))
        print(self.questionCollectionView.contentOffset.x)
        print(collectionBounds.size.width)
        print(questionCollectionView.frame.width)
        DispatchQueue.main.async {
            self.moveCollectionToFrame(contentOffset: contentOffset)
        }
        questionCollectionView.isPagingEnabled = true
    }
    
    func moveCollectionToFrame(contentOffset : CGFloat) {
        let frame: CGRect = CGRect(
            x : contentOffset + (self.questionCollectionView.bounds.size.width / 4),
            y : self.questionCollectionView.contentOffset.y,
            width : self.questionCollectionView.frame.width,
            height : self.questionCollectionView.frame.height
        )
        self.questionCollectionView.scrollRectToVisible(frame, animated: false)
        print("move collection to frame")
    }
    
    @objc func goAnswerView(_ recognizer: UITapGestureRecognizer) {
        
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        let allAnswerVC = storyBoard.instantiateViewController(withIdentifier: "AllAnswerViewController")
        allAnswerVC.modalPresentationStyle = .overCurrentContext
        self.window?.rootViewController?.present(allAnswerVC, animated: true, completion: nil)
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension MainQuestionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dateArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainQuestionCollectionViewCell", for: indexPath) as! MainQuestionCollectionViewCell
        cell.dateLabel.text = dateArr[indexPath.item]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일"
        let current_date_string = formatter.string(from: Date())
        if cell.dateLabel.text == current_date_string {
            cell.questionBox.image = UIImage(named: "questionBox_BookMark")
            cell.answerStackViewLabel.text = "답변하러 가기"
            cell.answerStackViewImage.image = UIImage(named: "pencil_gray")
            cell.answerStackView.isHidden = false
            
        } else {
            cell.questionBox.image = UIImage(named: "questionBox_noBookMark")
            cell.answerStackViewLabel.text = "답변보러 가기"
            cell.answerStackViewImage.image = UIImage(named: "showAnswer")
            cell.answerStackView.isHidden = true
            
        }
        return cell
    }
    
    //    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    //        var visibleRect = CGRect()
    //
    //        visibleRect.origin = questionCollectionView.contentOffset
    //        visibleRect.size = questionCollectionView.bounds.size
    //
    //        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
    //
    //        guard let indexPath = questionCollectionView.indexPathForItem(at: visiblePoint) else { return }
    //
    //        print(indexPath)
    //    }
    
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
}


extension MainQuestionTableViewCell: CollectionViewPagingLayoutDelegate {
    func onCurrentPageChanged(layout: CollectionViewPagingLayout, currentPage: Int) {
        print(currentPage)
        print("collectionview paging layout delegate")
    }
}
