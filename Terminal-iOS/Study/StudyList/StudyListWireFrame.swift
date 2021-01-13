//
//  StudyListWireFrame.swift
//  Terminal-iOS
//
//  Created by once on 2020/09/14.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit

class StudyListWireFrame: StudyListWireFrameProtocol {
    static func createStudyListModule() -> UIViewController {
        let view: StudyListViewProtocol = StudyListView()
        let presenter: StudyListPresenterProtocol & StudyListInteractorOutputProtocol = StudyListPresenter()
        let interactor: StudyListInteractorInputProtocol & StudyListRemoteDataManagerOutputProtocol = StudyListInteractor()
        let remoteDataManager: StudyListRemoteDataManagerInputProtocol = StudyListRemoteDataManager()
        let localDataManager: StudyListLocalDataManagerInputProtocol = StudyListLocalDataManager()
        let wireFrame: StudyListWireFrameProtocol = StudyListWireFrame()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.wireFrame = wireFrame
        interactor.presenter = presenter
        interactor.remoteDataManager = remoteDataManager
        interactor.localDataManager = localDataManager
        remoteDataManager.remoteRequestHandler = interactor
        
        if let view = view as? StudyListView {
            view.category = "ios"
            return view
        } else {
            return UIViewController()
        }
    }
    
    func presentStudyDetailScreen(from view: StudyListViewProtocol, keyValue: Int, state: Bool) {
        if state {
            let myStudyDetailViewController = MyStudyDetailWireFrame.createMyStudyDetailModule(studyID: keyValue)
            if let sourceView = view as? UIViewController {
                sourceView.navigationController?.pushViewController(myStudyDetailViewController, animated: true)
            }
        } else {
            let studyState: StudyDetailViewState = state ? .member : .none
            let studyDetailViewController = StudyDetailWireFrame.createStudyDetail(parent: nil, studyID: keyValue, state: studyState)
            if let sourceView = view as? UIViewController {
                sourceView.navigationController?.pushViewController(studyDetailViewController, animated: true)
            }
        }
    }
}
