//
//  BaseProfileRemoteDataManagerInputProtocol.swift
//  Terminal-iOS
//
//  Created by 정재인 on 2021/01/14.
//  Copyright © 2021 정재인. All rights reserved.
//

import Foundation

protocol BaseProfileViewProtocol {
    func showUserInfo(userInfo: UserInfo)
    func addProjectToStackView(project: [Project])
    func showLoading()
    func hideLoading()
}

protocol BaseProfileRemoteDataManagerInputProtocol {
    var remoteRequestHandler: BaseProfileRemoteDataManagerOutputProtocol? { get set }
    
    func getUserInfo()
    func getProjectList()
}

protocol BaseProfileRemoteDataManagerOutputProtocol {
    // REMOTEDATAMANAGER -> INTERACTOR
    func onUserInfoRetrieved(userInfo: BaseResponse<UserInfo>)
    func onProjectRetrieved(project: BaseResponse<[Project]>)
}