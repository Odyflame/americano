//
//  StudyCategoryPresenter.swift
//  Terminal-iOS
//
//  Created by once on 2020/09/14.
//  Copyright © 2020 정재인. All rights reserved.
//

import Foundation

class StudyCategoryPresenter: StudyCategoryPresenterProtocol {
    
    var view: StudyCategoryViewProtocol?
    
    var interactor: StudyCategoryInteractorInputProtocol?
    
    var wireFrame: StudyCategoryWireFrameProtocol?
    
    func viewDidLoad() {
        interactor?.retrieveStudyCategory()
    }
    func showStudyListDetail() {
        wireFrame?.presentStudyListScreen(from: view!)
    }
    func goToCreateStudy(category: [Category]) {
        wireFrame?.goToSelectCategory(from: view!, category: category)
        view?.categoryUpAnimate()
    }
    
    func didClickedCreateButton() {
        view?.categoryDownAnimate()
    }

}

extension StudyCategoryPresenter: StudyCategoryInteractorOutputProtocol {
    func didRetrieveCategories(_ categories: [Category]) {
        view?.showCategoryList(with: categories)
    }
    
    func onError() {
        
    }
}