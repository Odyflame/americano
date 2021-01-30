//
//  MyApplyStudyDetailProtocols.swift
//  Terminal-iOS
//
//  Created by 정재인 on 2021/01/11.
//  Copyright © 2021 정재인. All rights reserved.
//

import UIKit


protocol MyApplyStudyModifyViewProtocol {
    var presenter: MyApplyStudyModifyPresenterInputProtocol? { get set }
    var studyID: Int? { get set }
    var parentView: UIViewController? { get set }
    
//    PRESENTER -> VIEW
    func showMyApplyStudyDetail(message: String)
    func showModifyApplyMessageResult(message: String)
    func showError()
}

protocol MyApplyStudyModifyPresenterInputProtocol {
    var view: MyApplyStudyModifyViewProtocol? { get set }
    var interactor: MyApplyStudyModifyInteractorInputProtocol? { get set }
    var wireFrame: MyApplyStudyModifyWireFrameProtocol? { get set }
    
//    VIEW -> PRESENTER
    func viewDidLoad(studyID: Int)
    func admitButtonDidTap(newMessage: String)
}

protocol MyApplyStudyModifyInteractorInputProtocol {
    var presenter: MyApplyStudyModifyInteractorOutputProtocol? { get set }
    var remoteDataManager: MyApplyStudyModifyRemoteDataManagerInputProtocol? { get set }
    
//    PRESENTER -> INTERACTOR
    func getMyApplyStudyDetail(studyID: Int)
    func putNewApplyMessage(newMessage: String)
}

protocol MyApplyStudyModifyInteractorOutputProtocol {
    
//    INTERACTOR -> PRESENTER
    func retriveMyApplyStudyDetail(result: Bool, message: String)
    func retriveModifyApplyMessage(result: Bool, message: String)
}

protocol MyApplyStudyModifyRemoteDataManagerInputProtocol {
    var interactor: MyApplyStudyModifyRemoteDataManagerOutputProtocol? { get set }
    
//    INTERACTOR -> REMOTEDATAMANAGER
    func getMyApplyStudyDetail(studyID: Int, userID: Int)
    func putNewApplyMessage(studyID: Int,applyID: Int, newMessage: String)
}

protocol MyApplyStudyModifyRemoteDataManagerOutputProtocol {
    
//    REMOTEDATAMANAGER -> INTERACTOR
    func retriveMyApplyStudyDetail(result: Bool, data: ApplyUserResult)
    func retriveModifyApplyMessage(result: Bool, message: String)
}

protocol MyApplyStudyModifyWireFrameProtocol {
    static func createMyApplyStudyModifyModule(parentView: UIViewController, studyID: Int) -> UIViewController
}