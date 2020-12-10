//
//  AddNoticeInteractor.swift
//  Terminal-iOS
//
//  Created by 정재인 on 2020/11/27.
//  Copyright © 2020 정재인. All rights reserved.
//

import Foundation

class AddNoticeInteractor: AddNoticeInteractorProtocol {
    var presenter: AddNoticePresenterProtocol?
    var remoteDataManager: AddNoticeRemoteDataManagerProtocol?
    var localDataManager: AddNoticeLocalDataManagerProtocol?
    
    func postNotice(studyID: Int, notice: NoticePost, state: AddNoticeState, noticeID: Int?) {
        if state == .edit {
            remoteDataManager?.putNotice(studyID: studyID, notice: notice, noticeID: noticeID!, completion: { result, notice in
                self.presenter?.addNoticeResult(result: result, notice: notice, studyID: studyID)
            })
        } else if state == .new {
            remoteDataManager?.postNotice(studyID: studyID, notice: notice, completion: { result, notice in
                self.presenter?.addNoticeResult(result: result, notice: notice, studyID: studyID)
            })
        } else {
            print("addnoticestate값 지정 안됨")
        }
        
    }
}