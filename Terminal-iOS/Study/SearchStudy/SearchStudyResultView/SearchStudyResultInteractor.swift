//
//  SearchStudyResultInteractor.swift
//  Terminal-iOS
//
//  Created by 정재인 on 2021/01/04.
//  Copyright © 2021 정재인. All rights reserved.
//

import Foundation

class SearchStudyResultInteractor: SearchStudyResultInteractorInputProtocol {
    var presenter: SearchStudyResultInteractorOutputProtocol?
    var remoteDataManager: SearchStudyResultRemoteDataManagerInputProtocol?
    var studyList: [Study] = []
    var isPagingStudyList: [Int] = []
    
    func getSearchStudyList(keyWord: String) {
        remoteDataManager?.getSearchStudyList(keyWord: keyWord)
    }
    
    func getPagingStudyList() {
        var nextStudyList: [Int] = []
        for item in isPagingStudyList {
            nextStudyList.append(item)
            if nextStudyList.count > 9 {
                break
            }
        }
        if !isPagingStudyList.isEmpty {
            isPagingStudyList.removeSubrange(0..<nextStudyList.count)
            remoteDataManager?.getPagingStudyList(keys: nextStudyList)
        }
    }
}

extension SearchStudyResultInteractor: SearchStudyResultRemoteDataManagerOutputProtocol {
    
    func showSearchStudyListResult(result: BaseResponse<[Study]>) {
        switch result.result {
        case true:
            if let itemList = result.data {
                self.studyList = itemList.filter { !$0.isPaging! }
                self.isPagingStudyList = (itemList.filter { $0.isPaging! }).map { $0.id }
            }
            self.presenter?.showSearchStudyListResult(result: studyList)
        case false:
            print("err")
        }
    }
    
    func showPagingStudyListResult(result: BaseResponse<[Study]>) {
        switch result.result {
        case true:
            if let itemList = result.data {
                self.presenter?.showSearchStudyListResult(result: itemList)
            }
        case false:
            print("err")
        }
    }
}
