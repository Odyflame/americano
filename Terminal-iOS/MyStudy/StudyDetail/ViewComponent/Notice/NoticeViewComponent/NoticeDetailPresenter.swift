//
//  NoticeDetailPresenter.swift
//  Terminal-iOS
//
//  Created by 정재인 on 2020/12/01.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit

class NoticeDetailPresenter: NoticeDetailPresenterProtocol {
    weak var view: NoticeDetailViewProtocol?
    var interactor: NoticeDetailInteractorProtocol?
    var wireFrame: NoticeDetailWireFrameProtocol?
    
    func viewDidLoad(notice: Notice) {
        view?.showLoading()
        interactor?.getNoticeDetail(notice: notice)
    }
    
    func noticeDetailResult(result: Bool, notice: Notice) {
        switch result {
        case true:
            view?.hideLoading()
            view?.showNoticeDetail(notice: notice)
        case false:
            view?.hideLoading()
            view?.showError(message: "권한이 없습니다.")
        }
    }
    
    func removeButtonDidTap(notice: Notice) {
        view?.showLoading()
        interactor?.postNoticeRemove(notice: notice)
    }
    
    func modifyButtonDidTap(state: AddNoticeState,
                            notice: Notice,
                            parentView: NoticeDetailViewProtocol) {
        view?.showLoading()
        wireFrame?.goToNoticeEdit(state: state, notice: notice, parentView: parentView)
    }
    
    func noticeRemoveResult(result: Bool, message: String) {
        switch result {
        case true:
            view?.showNoticeRemove(message: message)
        case false:
            view?.hideLoading()
            view?.showError(message: message)
        }
    }
}
