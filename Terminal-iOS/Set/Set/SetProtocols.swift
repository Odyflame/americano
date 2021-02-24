//
//  SetViewProtocols.swift
//  Terminal-iOS
//
//  Created by once on 2020/09/30.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit

protocol SetViewProtocol: class {
    var presenter: SetPresenterProtocol? { get set }
    
    func loggedOut()
    func showUserInfo(with userInfo: UserInfo)
    func emailAuthResponse(result: Bool, message: String)
    
    func showLoading()
    func hideLoading()
    func showError(message: String)
}

protocol SetWireFrameProtocol: class {
    static func setCreateModule() -> UIViewController
    
    // PRESENT -> WIREFRAME
    func presentProfileDetailScreen(from view: SetViewProtocol)
    func presentUserWithdrawal(from view: SetViewProtocol)
    func replaceRootViewToIntroView(from view: SetViewProtocol)
}

protocol SetPresenterProtocol: class {
    var view: SetViewProtocol? { get set }
    var interactor: SetInteractortInputProtocol? { get set }
    var wireFrame: SetWireFrameProtocol? { get set }
    
    // VIEW -> PRESENTER
    func viewDidLoad()
    func showProfileDetail()
    func emailAuthRequest()
    
    func loggedOut()
    func loggedOutConfirmed()
    func userWithdrawal()
}

protocol SetInteractorOutputProtocol: class {
    func didRetrievedUserInfo(userInfo: UserInfo)
    func eamilAuthResponse(result: Bool, message: String)
    func logoutResult(result: BaseResponse<String>)
    func onError()
}

protocol SetInteractortInputProtocol: class {
    var presenter: SetInteractorOutputProtocol? { get set }
    var localDataManager: SetLocalDataManagerInputProtocol? { get set }
    var remoteDataManager: SetRemoteDataManagerInputProtocol? { get set }
    
    func getUserInfo()
    func emailAuthRequest()
    func removeRefreshToken()
}

//이친구는 왜있는거지?
protocol SetDataManagerInputProtocol: class {
    // INTERACOTER -> DATAMANAGER
    
}

protocol SetRemoteDataManagerInputProtocol: class {
    var interactor: SetRemoteDataManagerOutputProtocol? { get set }
    // INTERACTOR -> REMOTEDATAMANAGER
    func getUserInfo()
    func emailAuthRequest()
    func postLogout(userID: String)
}

protocol SetRemoteDataManagerOutputProtocol: class {
    func onUserInfoRetrieved(userInfo: BaseResponse<UserInfo>)
    func emailAuthResponse(result: BaseResponse<Bool>)
    func postLogoutResult(result: BaseResponse<String>)
    func error()
}

protocol SetLocalDataManagerInputProtocol: class {

}
