//
//  CreateStudyView.swift
//  Terminal-iOS
//
//  Created by 정재인 on 2020/09/15.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit

class CreateStudyView: UIViewController {
    var presenter: CreateStudyPresenterProtocols?
    
    let screenSize = UIScreen.main.bounds
    var selectedCategory: String?
    
    let scrollView = UIScrollView()
    let imageView = UIImageView()
    let studyTitleTextField = UITextField()
    var seletedCategory: String?
    var studyOverviewView: StudyOverViewUIView?
    var SNSInputView = SNSInputUIVIew()
    var locationView = LocationUIVIew()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter?.viewDidLoad()
    }
    
    func attribute() {
        
        view.do {
            $0.backgroundColor = UIColor(named: "background")
        }
        scrollView.do {
            $0.backgroundColor = UIColor(named: "background")
        }
        imageView.do {
            $0.image = #imageLiteral(resourceName: "swiftBackground")
        }
        studyTitleTextField.do {
            $0.placeholder = "스터디 이름"
            $0.backgroundColor = .white
            $0.textAlignment = .center
            $0.textColor = .black
        }
        studyOverviewView = StudyOverViewUIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), category: seletedCategory!)
        studyOverviewView!.do {
            $0.backgroundColor = .cyan
            $0.textView.backgroundColor = .blue
        }
        SNSInputView.do {
            $0.backgroundColor = .orange
            $0.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        }
        locationView.do {
            $0.backgroundColor = .red
            $0.detailAddress.backgroundColor = .yellow
        }
    }
    
    func layout() {
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(studyTitleTextField)
        scrollView.addSubview(studyOverviewView!)
        scrollView.addSubview(SNSInputView)
        scrollView.addSubview(locationView)
        
        scrollView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
            $0.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor).isActive = true
            $0.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
            $0.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
            $0.contentSize = CGSize(width: screenSize.width, height: 2000)
        }
        imageView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.widthAnchor.constraint(equalToConstant: screenSize.width).isActive = true
            $0.heightAnchor.constraint(equalToConstant: (170/667) * screenSize.height).isActive = true
            $0.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        }
        studyTitleTextField.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.centerXAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.centerXAnchor).isActive = true
            $0.widthAnchor.constraint(equalToConstant: (300/375) * screenSize.width).isActive = true
            $0.heightAnchor.constraint(equalToConstant: (55/667) * screenSize.height).isActive = true
            $0.topAnchor.constraint(equalTo: imageView.bottomAnchor,constant: -((((55/667) * screenSize.height) * 16) / 55)).isActive = true
        }
        studyOverviewView!.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor, constant: -(18/375) * screenSize.width ).isActive = true
            $0.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor, constant: (18/375) * screenSize.width ).isActive = true
            $0.topAnchor.constraint(equalTo: studyTitleTextField.bottomAnchor, constant: 100).isActive = true
            $0.bottomAnchor.constraint(equalTo: (studyOverviewView?.textView.bottomAnchor)!, constant: 10).isActive = true
        }
        SNSInputView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: studyOverviewView!.safeAreaLayoutGuide.bottomAnchor).isActive = true
            $0.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor, constant: -(18/375) * screenSize.width ).isActive = true
            $0.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor, constant: (18/375) * screenSize.width ).isActive = true
            $0.bottomAnchor.constraint(equalTo: SNSInputView.web.bottomAnchor).isActive = true
        }
        locationView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: SNSInputView.bottomAnchor).isActive = true
            $0.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor, constant: -(18/375) * screenSize.width ).isActive = true
            $0.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor, constant: (18/375) * screenSize.width ).isActive = true
            $0.bottomAnchor.constraint(equalTo: locationView.detailAddress.bottomAnchor).isActive = true
        }
    }
}

extension CreateStudyView: CreateStudyViewProtocols {
    func setView() {
        attribute()
        layout()
    }
    func getBackgroundImage() {
        print("getBackgroundImage")
    }
    func setBackgroundImage() {
        print("setVackgroundImage")
    }
}
