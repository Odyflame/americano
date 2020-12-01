//
//  ProjectView.swift
//  Terminal-iOS
//
//  Created by once on 2020/12/02.
//  Copyright © 2020 정재인. All rights reserved.
//


import UIKit

class ProjectTableView: UITableView {
    var maxHeight: CGFloat = UIScreen.main.bounds.size.height
    
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
    }
    
    override var intrinsicContentSize: CGSize {
        let height = min(contentSize.height, maxHeight)
        return CGSize(width: contentSize.width, height: height)
    }
}
