//
//  SetViewPresenter.swift
//  Terminal-iOS
//
//  Created by once on 2020/09/30.
//  Copyright © 2020 정재인. All rights reserved.
//

import Foundation

class SetPresenter: SetPresenterProtocol {
    var view: SetViewProtocol?
    var interactor: SetInteractortInputProtocol?
    var wireFrame: SetWireFrameProtocol?
    
    func viewDidLoad() {
        view?.showLoading()
        interactor?.getUserInfo()
    }
    
    func showProfileDetail() {
        wireFrame?.presentProfileDetailScreen(from: view!)
    }
    
    func showEmailAuth() {
        wireFrame?.presentEmailAuth(from: view!)
    }
   
    func loggedOut() {
        view?.loggedOut()
    }
    
    func userWithdrawal() {
        wireFrame?.presentUserWithdrawal(from: view!)
    }
}

extension SetPresenter: SetInteractorOutputProtocol {
    func didRetrievedUserInfo(userInfo: UserInfo) {
        view?.showUserInfo(with: userInfo)
    }
    
    func onError() {
        
    }
}
