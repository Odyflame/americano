//
//  ChatViewProtocols.swift
//  Terminal-iOS
//
//  Created by 정재인 on 2020/11/23.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit

protocol ChatViewProtocol: class {
    var presenter: ChatPresenterProtocol? { get set }
    
    //PRESENTER -> VIEW
    func viewLoad() 
    func showLastChat(lastChat: [Chat])
    func showSocketChat(socketChat: [Chat], reloadIndex: Int?)
    func showPagingChat(pagingChat: [Chat]) 
    func showLoading()
    func hideLoading()
    func showError(message: String)
    func emitFailed(uuid: String)
}

protocol ChatInteractorProtocol: class {
    var presenter: ChatPresenterProtocol? { get set }
    var remoteDataManager: ChatRemoteDataManagerProtocol? { get set }
    var localDataManager: ChatLocalDataManagerProtocol? { get set }
    var studyID: Int? { get set }
    
    // PRESENTER -> INTERACTOR
    func connectSocket()
    func emit(message: String)
    func disconnectSocket()
    func mergeChatFromSocket()
    func getPreChat()
    
    // remoteDataManager -> Interactor
    func receiveMessage(message: Chat)
    func receiveLastChat(lastRemoteChat: BaseResponse<RemoteChatInfo>)
    func sessionTaskError(message: String)
    func setNicknameList(list: [ChatParticipate])
}

protocol ChatPresenterProtocol: class {
    var view: ChatViewProtocol? { get set }
    var wireFrame: ChatWireFrameProtocol? { get set }
    var interactor: ChatInteractorProtocol? { get set }
    
    // VIEW -> PRESENTER
    func viewDidLoad()
    func viewRoadLastChat()
    func emitButtonDidTap(message: String)
    func viewWillDisappear()
    func chatPaging()
    
    // INTERACTOR -> PRESENTER
    func getLastChatResult(lastChat: [Chat])
    func arrangedChatFromChat(chat: [Chat], reloadIndex: Int?)
    func emitFailed(uuid: String)
    func showError(message: String)
    func getPreChatResult(pagingChat: [Chat])
}

protocol ChatRemoteDataManagerProtocol: class {
    var interactor: ChatInteractorProtocol? { get set }
    func socketConnect(studyID: Int, date: Int?)
    func emit(message: [String: Any])
    func disconnectSocket()
    func getRemoteChat(studyID: Int, date: Int?)
}

protocol ChatLocalDataManagerProtocol: class {
    
}

protocol ChatWireFrameProtocol: class {
    var presenter: ChatPresenterProtocol? { get set }
    static func createChatModule(studyID: Int) -> UIViewController
}
