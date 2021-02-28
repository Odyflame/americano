//
//  StudyCell.swift
//  Terminal-iOS
//
//  Created by once on 2020/09/11.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Then
import Kingfisher

class StudyCell: UITableViewCell {
    static let cellId = "StudyCellID"
    
    let mainTitle = UILabel()
    let location = UILabel()
    let date = UILabel()
    let distance = UILabel()
    let managerImage = UIImageView()
    let mainImage = UIImageView()
    let memberImage = UIImageView()
    let memberCount = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        attribute()
        layout()
    }

    override func prepareForReuse() {
        self.mainTitle.text = nil
        self.location.text = nil
        self.distance.text = nil
        self.date.text = nil
        self.managerImage.image = nil
        self.mainImage.image = nil
    }
    
    func setData(_ data: Study) {
        
        self.mainTitle.do {
            $0.text = data.title
        }
        
        self.location.do {
            $0.text = data.sigungu
        }
        
        self.date.do {
            $0.text = data.createdAt
        }
        
        self.memberCount.do {
            guard let count = data.memberCount else { return }
            $0.text = "\(count)"
        }
        
        self.distance.do {
            guard let distance = data.distance else { return }
            let point = Int((round(distance * 10) / 10) * 10) % 10
            
            if point == 0 {
                let result = "\((Int(round(distance * 10) / 10)))km"
                $0.text = result
            } else {
                let result = "\((round(distance * 10) / 10))km"
                $0.text = result
            }
        }
        
        guard let mainImageURL = data.image else {
            mainImage.image = #imageLiteral(resourceName: "swiftmain")
            return
        }
        
        guard let managerImageURL = data.leaderImage else {
            managerImage.image = #imageLiteral(resourceName: "defaultProfile")
            return
        }
        
        DispatchQueue.main.async {
            let processor = DownsamplingImageProcessor(size: self.mainImage.bounds.size)
            self.mainImage.kf.setImage(with: URL(string: mainImageURL),
                           placeholder: UIImage(named: "swift"),
                           options: [.requestModifier(RequestToken.token()),
                                     .processor(processor)])
            
            self.managerImage.kf.setImage(with: URL(string: managerImageURL),
                                          options: [.requestModifier(RequestToken.token())])
        }
    }
    
    func attribute() {
        self.backgroundColor = UIColor.appColor(.terminalBackground)
        
        self.mainTitle.do {
            $0.dynamicFont(fontSize: 15, weight: .regular)
            $0.textColor = .white
        }
        
        self.location.do {
            $0.textColor = UIColor.appColor(.mainColor)
            $0.dynamicFont(fontSize: 13, weight: .regular)
            $0.textAlignment = .center
            $0.sizeToFit()
        }
        
        self.distance.do {
            $0.textColor = UIColor.appColor(.mainColor)
            $0.dynamicFont(fontSize: 13, weight: .regular)
        }
        
        self.date.do {
            $0.dynamicFont(fontSize: 13, weight: .regular)
            $0.textColor = UIColor.appColor(.studySubTitle)
        }
        
        self.managerImage.do {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 10
        }
        
        self.memberImage.do {
            $0.image = UIImage(systemName: "person")?.withConfiguration(UIImage.SymbolConfiguration(weight: .regular))
            $0.tintColor = .white
        }
        
        self.memberCount.do {
            $0.textColor = .white
            $0.dynamicFont(fontSize: 13, weight: .regular)
            $0.textAlignment = .center
        }
        
        self.mainImage.do {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 10
        }
    }
    
    func layout() {
        [mainTitle, date, managerImage, mainImage, location, distance, memberImage, memberCount]
            .forEach { self.contentView.addSubview($0) }
       
        self.location.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
            $0.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 22).isActive = true
        }
        
        self.distance.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
            $0.leadingAnchor.constraint(equalTo: self.location.trailingAnchor, constant: 10).isActive = true
        }
        
        self.mainTitle.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: self.location.bottomAnchor, constant: 8).isActive = true
            $0.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
            $0.trailingAnchor.constraint(equalTo: self.mainImage.leadingAnchor, constant: -10).isActive = true
        }
        
        self.date.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: self.mainTitle.bottomAnchor, constant: 8).isActive = true
            $0.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        }
        
        self.managerImage.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.centerYAnchor.constraint(equalTo: self.date.centerYAnchor).isActive = true
            $0.leadingAnchor.constraint(equalTo: self.date.trailingAnchor, constant: 10).isActive = true
            $0.widthAnchor.constraint(equalToConstant: 20).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 20).isActive = true
        }
        
        self.mainImage.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
            $0.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
            $0.widthAnchor.constraint(equalToConstant: 112).isActive = true
            $0.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        }
        
        self.memberImage.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -7).isActive = true
            $0.trailingAnchor.constraint(equalTo: self.memberCount.leadingAnchor, constant: -3).isActive = true
            $0.widthAnchor.constraint(equalToConstant: Terminal.convertWidth(value: 20)).isActive = true
            $0.heightAnchor.constraint(equalToConstant: Terminal.convertWidth(value: 20)).isActive = true
        }
        
        self.memberCount.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -7).isActive = true
            $0.trailingAnchor.constraint(equalTo: self.mainImage.leadingAnchor, constant: -7).isActive = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
