//
//  LaunchPresenter.swift
//  Terminal-iOS
//
//  Created by 정재인 on 2021/02/23.
//  Copyright © 2021 정재인. All rights reserved.
//

import Foundation

class LaunchPresenter: LaunchPresenterProtocol {
    weak var view: LaunchViewProtocol?
    var interactor: LaunchInteractorInputProtocol?
    var wireFrame: LaunchWireFrameProtocol?
    
    func viewDidLoad() {
        interactor?.getVersionCheck()
    }
    
    func getRefreshTokenValid() {
        interactor?.refreshTokenCheck()
    }
    
    func jumpToAppStore() {
        wireFrame?.jumpToAppStore()
    }
}

extension LaunchPresenter: LaunchInteractorOutputProtocol {
    func versionNeedUpdate(force: VersionResultType) {
        switch force {
        case .Recommended:
            view?.showVersionUpdateAlert(alertType: .VersionUpdateRecommend)
        case .Required:
            view?.showVersionUpdateAlert(alertType: .VersionUpdateRequired)
        case .notRequired: break
        }
    }
    
    func refreshTokenIsEmpty() {
        wireFrame?.replaceRootViewToIntroView()
    }
    
    func refreshTokenResult(result: Bool) {
        switch result {
        case true:
            wireFrame?.replaceRootViewToMainView()
        case false:
            wireFrame?.replaceRootViewToIntroView()
        }
    }
}