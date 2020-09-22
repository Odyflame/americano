//
//  SnsInputUIView.swift
//  Terminal-iOS
//
//  Created by 정재인 on 2020/09/22.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit

class SNSInputUIVIew: UIView {
    var notion =  SNSInputItem()
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        attribute()
        layout()
    }
    
    func attribute() {
        notion.do {
            $0.textField.text = "무러나느거야"
        }
    }
    func layout() {
        addSubview(notion)
        
        notion.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            $0.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            $0.heightAnchor.constraint(equalTo: heightAnchor,constant: -50).isActive = true
            $0.widthAnchor.constraint(equalTo: widthAnchor,constant: -50).isActive = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
