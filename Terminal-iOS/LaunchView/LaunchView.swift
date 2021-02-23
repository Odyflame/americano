//
//  LaunchView.swift
//  Terminal-iOS
//
//  Created by 정재인 on 2021/02/23.
//  Copyright © 2021 정재인. All rights reserved.
//

import UIKit

class LaunchView: UIViewController {
    var presenter: LaunchPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    // MARK: @objc
    @objc func updateButtonDidtap() {
//        앱스토어로 가는 로직 구현부
    }
    
    @objc func updateLaterButtonDidTap() {
        presenter?.getRefreshTokenValid()
    }
}

extension LaunchView: LaunchViewProtocol {
    func showVersionUpdateAlert(alertType: AlertType) {
        TerminalAlertMessage.show(controller: self, type: alertType)
        TerminalAlertMessage.removeLeftButtonAction()
        TerminalAlertMessage.removeRightButtonAction()
        TerminalAlertMessage.getRightButton().addTarget(self, action: #selector(updateButtonDidtap), for: .touchUpInside)
        TerminalAlertMessage.getLeftButton().addTarget(self, action: #selector(updateLaterButtonDidTap), for: .touchUpInside)
    }
    
    func showError(message: String) {
        //좀더 생각을 해보는 걸로 
    }
}
