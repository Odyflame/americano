//
//  NoticeDetailView.swift
//  Terminal-iOS
//
//  Created by once on 2020/11/09.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit

class NoticeDetailView: UIViewController {
    lazy var noticeBackground = UIView()
    lazy var noticeLabel = UILabel()
    lazy var noticeTitle = UILabel()
    lazy var profileImage = UIImageView()
    lazy var profileName = UILabel()
    lazy var noticeDate = UILabel()
    lazy var noticeContents = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
    }
    
    func attribute() {
        self.do {
            $0.view.backgroundColor = UIColor.appColor(.terminalBackground)
        }
        noticeBackground.do {
            $0.layer.cornerRadius = 5
        }
        noticeLabel.do {
            $0.dynamicFont(fontSize: 12, weight: .medium)
            $0.textAlignment = .center
            $0.textColor = .white
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 5
        }
        noticeTitle.do {
            $0.dynamicFont(fontSize: 14, weight: .semibold)
            $0.textColor = .white
            $0.text = "모임 진행시 가이드 라인입니다!"
        }
        profileImage.do {
            $0.image = #imageLiteral(resourceName: "leehi")
            $0.contentMode = .scaleAspectFill
            $0.frame.size.width = Terminal.convertWidth(value: 35)
            $0.frame.size.height = Terminal.convertWidth(value: 35)
            $0.layer.cornerRadius = $0.frame.width / 2
            $0.clipsToBounds = true
        }
        profileName.do {
            $0.dynamicFont(fontSize: 12, weight: .medium)
            $0.text = "윤여울"
            $0.textColor = .white
            $0.textAlignment = .center
        }
        noticeDate.do {
            $0.dynamicFont(fontSize: 12, weight: .medium)
            $0.text = "2020.8.27 목요일 오후 10:00"
            $0.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            $0.textAlignment = .center
        }
        noticeContents.do {
            $0.dynamicFont(fontSize: 12, weight: .regular)
            $0.numberOfLines = 0
            $0.text = "[모임 진행시 가이드 라인]\n\n1. 스터디를 진행할 때 휴대폰은 매너모드로 설정해주세요\n\n2. 코로나 19 감염자가 급증함에 따라 정부에서 사회적 거리두기를 권장하고 있습니다. 스터디 참여시 마스크를 꼭 착용해 주세요\n\n3. 노트북 가져오세요"
        }
    }
    
    func layout() {
        [noticeBackground, noticeTitle, profileImage, profileName, noticeDate, noticeContents].forEach { view.addSubview($0)}
        noticeBackground.addSubview(noticeLabel)
        
        noticeBackground.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Terminal.convertHeigt(value: 9)).isActive = true
            $0.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Terminal.convertHeigt(value: 13)).isActive = true
            $0.widthAnchor.constraint(equalToConstant: Terminal.convertHeigt(value: 41)).isActive = true
            $0.heightAnchor.constraint(equalToConstant: Terminal.convertHeigt(value: 20)).isActive = true
        }
        noticeLabel.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.centerXAnchor.constraint(equalTo: noticeBackground.centerXAnchor).isActive = true
            $0.centerYAnchor.constraint(equalTo: noticeBackground.centerYAnchor).isActive = true
        }
        noticeTitle.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.leadingAnchor.constraint(equalTo: self.noticeBackground.trailingAnchor, constant: Terminal.convertWidth(value: 15)).isActive = true
            $0.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -10).isActive = true
            $0.centerYAnchor.constraint(equalTo: noticeBackground.centerYAnchor).isActive = true
        }
        profileImage.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: noticeBackground.bottomAnchor, constant: Terminal.convertHeigt(value: 25)).isActive = true
            $0.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Terminal.convertHeigt(value: 13)).isActive = true
            $0.widthAnchor.constraint(equalToConstant: Terminal.convertWidth(value: 35)).isActive = true
            $0.heightAnchor.constraint(equalToConstant: Terminal.convertWidth(value: 35)).isActive = true
        }
        profileName.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: noticeBackground.bottomAnchor, constant: Terminal.convertHeigt(value: 25)).isActive = true
            $0.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: Terminal.convertWidth(value: 8)).isActive = true
        }
        noticeDate.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: profileName.bottomAnchor, constant: 2).isActive = true
            $0.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: Terminal.convertWidth(value: 8)).isActive = true
        }
        noticeContents.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: Terminal.convertHeigt(value: 25)).isActive = true
            $0.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Terminal.convertWidth(value: 13)).isActive = true
            $0.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: Terminal.convertWidth(value: -13)).isActive = true
            $0.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor).isActive = true
        }
    }
}