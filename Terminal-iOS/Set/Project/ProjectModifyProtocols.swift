//
//  ProjectModifyProtocols.swift
//  Terminal-iOS
//
//  Created by once on 2021/01/01.
//  Copyright © 2021 정재인. All rights reserved.
//

import UIKit

protocol ProjectModifyViewProtocol: class {
    var presenter: ProjectModifyPresenterProtocol? { get set }
    
    // PRESENTER -> VIEW
    func modifyResultHandle(result: Bool, message: String)
}

protocol ProjectModifyWireFrameProtocol: class {
    static func createModule() -> UIViewController
}

protocol ProjectModifyPresenterProtocol: class {
    var view: ProjectModifyViewProtocol? { get set }
    var interactor: ProjectModifyInteractorInputProtocol? { get set }
    var wireFrame: ProjectModifyWireFrameProtocol? { get set }
    
    // VIEW -> PRESENTER
    func completeModify(title: String, contents: String)
}

protocol ProjectModifyInteractorInputProtocol: class {
    var presenter: ProjectModifyInteractorOutputProtocol? { get set }
    
    // PRESENTER -> INTERACTOR
    func completeModify(title: String, contents: String)
}

protocol ProjectModifyInteractorOutputProtocol: class {
    // INTERACTOR -> PRESENTER
    func didCompleteModify(result: Bool, message: String)
}
