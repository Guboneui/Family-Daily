//
//  AllQuestionViewModel.swift
//  Faily
//
//  Created by 구본의 on 2021/10/17.
//

import Foundation

class AllQuestionViewModel {
    weak var questionView: QuestionViewController?
    weak var questionCell: MainQuestionTableViewCell?
    let useService = AllQuestionService()
    var reloadCollectionView: () -> Void = {}
    var reloadTableView: () -> Void = {}
    
    var questionData: [AllQuestionDetail] = [] {
        didSet {
            reloadTableView()
            //reloadCollectionView()
            print(questionData.count)
            questionView?.mainQuestionPage = questionData.count - 1
        }
    }
    
    func getAllQuestion() {
        useService.getAllQuestion(onCompleted: {[weak self] response in
            guard let self = self else {return}
            let message = response.message
            let code = response.code
            if response.isSuccess == true {
                print("전체 질문을 불러왔습니다.")
                //self.questionCell?.allQuestionResult = response.result ?? []
                self.questionData = response.result!
                print(self.questionData)
                self.questionView?.questionMainTableView.reloadData()
            } else {
                print("전체 질문을 불러오지 못했습니다.")
            }
        }, onError: {error in
            print("AllQuestionViewModel - \(error)")
        })
    }
}
