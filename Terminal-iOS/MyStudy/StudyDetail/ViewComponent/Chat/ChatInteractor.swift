//
//  ChatInteractor.swift
//  Terminal-iOS
//
//  Created by 정재인 on 2020/11/23.
//  Copyright © 2020 정재인. All rights reserved.
//

import Foundation

class ChatInteractor: ChatInteractorProtocol {
    weak var presenter: ChatPresenterProtocol?
    var remoteDataManager: ChatRemoteDataManagerProtocol?
    var localDataManager: ChatLocalDataManagerProtocol?
    var studyID: Int?
    var lastLocalChat: [Chat] = []
    var receiveFromSocketChat: [Chat] = []
    var lastTimeStamp: Int?
    var mergeChatFromSocketFlag = false
    
    func connectSocket() {
        getLastLocalChat {
            if self.lastLocalChat.isEmpty {
                self.remoteDataManager?.socketConnect(studyID: self.studyID!, date: nil)
            } else {
                self.remoteDataManager?.socketConnect(studyID: self.studyID!,
                                                      date: self.lastLocalChat.last!.date)
            }
        }
    }
    func emit(message: String) {
        remoteDataManager?.emit(message: message)
    }
    func disconnectSocket() {
        remoteDataManager?.disconnectSocket()
    }
    func getLastLocalChat(_: @escaping () -> Void ) {
        //로컬 챗 세팅
        lastLocalChat = CoreDataManager.shared.getCurrentChatInfo(studyID: studyID!)
    }
    func receiveMessage(message: Chat) {
        //챗 from socket
        receiveFromSocketChat.append(message)
        arrangeChat()
    }
    func receiveLastChat(lastRemoteChat: BaseResponse<[Chat]>) {
        switch lastRemoteChat.result {
        case true:
            if let remoteChat = lastRemoteChat.data {
                if !remoteChat.isEmpty {
                    //기준이 될 라스트 타임스탬프 할당
                    lastTimeStamp = lastRemoteChat.data?.last?.date
                    //CoreDataManager에 lastRemoteChat 저장
                    //      CoreDataManager save chat 블라블라~
                    //로컬 + 리모트 채팅을 프레젠터로 패스
                    presenter?.getLastChatResult(lastChat: lastLocalChat + lastRemoteChat.data!)
                } else {
                    presenter?.getLastChatResult(lastChat: lastLocalChat)
                }
            }
        case false:
            // 에러 핸들링
        break
        }

    }
    func mergeChatFromSocket() {
        mergeChatFromSocketFlag = true
        arrangeChat()
    }
    func arrangeChat() {
        var arragedChatList: [Chat] = []
        while mergeChatFromSocketFlag
                && !receiveFromSocketChat.isEmpty{
            if lastTimeStamp! >= receiveFromSocketChat.first!.date {
                receiveFromSocketChat.removeFirst()
            } else {
                arragedChatList.append(receiveFromSocketChat.first!)
                receiveFromSocketChat.removeFirst()
            }
        }
        if !arragedChatList.isEmpty {
            presenter?.arrangedChatFromChat(chat: arragedChatList)
        }
    }
}
