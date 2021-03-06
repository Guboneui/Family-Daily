//
//  GetAllEmoticonViewModel.swift
//  Faily
//
//  Created by 구본의 on 2021/11/01.
//

import Foundation

class GetAllEmoticonViewModel {
    let useService: GetAllEmoticonService = GetAllEmoticonService()
    let deleteService: PostDeleteEmoticonService = PostDeleteEmoticonService()
    weak var emoticonView: EmoticonBoxViewController?
    weak var chatView: ChatViewController?
    
    var emoticonBox: [EmoticonInfo] = [] {
        didSet{
            self.emoticonView?.emoticonBoxCollectionView.reloadData()
        }
        
    }
    
    var chatEmoticonBox: [EmoticonInfo] = [] {
        didSet{
            self.chatView?.userEmoticonCollectionView.reloadData()
        }
    }
    
    func getAllEmoticon(){
        useService.getAllEmoticon(onCompleted: {[weak self] response in
            guard let self = self else {return}
            if response.isSuccess == true {
                print("이모티콘을 불러 왔습니다.")
                self.emoticonBox = response.result!
                self.chatEmoticonBox = response.result!
            } else {
               print("이모티콘을 불러오지 못했습니다.")
            }
        }, onError: { error in
            print("\(error)")
        })
    }
    
    func postDeleteEmoticon(_ parameter: PostDeleteEmoticonRequest) {
        deleteService.postDeleteEmoticon(parameter, onCompleted: {[weak self] response in
            guard let self = self else {return}
            if response.isSuccess == true {
                print("이모티콘 삭제 성공")
                self.getAllEmoticon()
                self.emoticonView?.emoticonBoxCollectionView.reloadData()
            } else {
                print("이모티콘 삭제 실패")
            }
        }, onError: {error in
            print(error)
        })
    }
}
