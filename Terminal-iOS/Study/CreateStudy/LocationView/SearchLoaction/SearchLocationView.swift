//
//  SearchLocationView.swift
//  Terminal-iOS
//
//  Created by 정재인 on 2020/10/29.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit

class SearchLocationView: UIViewController {
    var presenter: SearchLocationPresenterProtocol?
    
    var closeButton = UIButton()
    var searchTextField = UITextField()
    var searchButton = UIButton()
    var tableView = UITableView()
    var searchResultList: [searchLocationResult] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
    }
    
    func attribute() {
        self.do {
            $0.view.backgroundColor = .systemBackground
        }
        closeButton.do {
            $0.setImage(#imageLiteral(resourceName: "back"), for: .normal)
            $0.addTarget(self, action: #selector(didCloseButtonClicked), for: .touchUpInside)
        }
        searchButton.do {
            $0.setImage(#imageLiteral(resourceName: "search"), for: .normal)
            $0.addTarget(self, action: #selector(didSearchButtonClicked), for: .touchUpInside)
        }
        searchTextField.do {
            $0.textColor = .white
            $0.placeholder = "장소를 검색하세요"
        }
        tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(SearchLocationTableViewCell.self, forCellReuseIdentifier: SearchLocationTableViewCell.identifier)
        }
    }
    
    func layout() {
        [closeButton, searchTextField, searchButton, tableView].forEach { view.addSubview($0) }
        
        closeButton.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Terminal.convertWidth(value: 15)).isActive = true
            $0.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Terminal.convertHeigt(value: 18)).isActive = true
            $0.widthAnchor.constraint(equalToConstant: Terminal.convertWidth(value: 30)).isActive = true
            $0.heightAnchor.constraint(equalToConstant: Terminal.convertWidth(value: 30)).isActive = true
        }
        searchButton.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Terminal.convertWidth(value: 29)).isActive = true
            $0.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Terminal.convertHeigt(value: 18)).isActive = true
            $0.widthAnchor.constraint(equalToConstant: Terminal.convertWidth(value: 30)).isActive = true
            $0.heightAnchor.constraint(equalToConstant: Terminal.convertWidth(value: 30)).isActive = true
        }
        searchTextField.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Terminal.convertHeigt(value: 18)).isActive = true
            $0.leadingAnchor.constraint(equalTo: closeButton.trailingAnchor, constant: Terminal.convertWidth(value: 15.7)).isActive = true
            $0.widthAnchor.constraint(equalToConstant: Terminal.convertWidth(value: 250)).isActive = true
            $0.heightAnchor.constraint(equalToConstant: Terminal.convertHeigt(value: 30)).isActive = true
        }
        tableView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: Terminal.convertHeigt(value: 20.6)).isActive = true
            $0.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: Terminal.convertWidth(value: 13.5)).isActive = true
            $0.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -Terminal.convertWidth(value: 13.5)).isActive = true
            $0.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        }
    }
    
    @objc func didCloseButtonClicked() {
        dismiss(animated: true)
    }
    @objc func didSearchButtonClicked() {
        presenter?.didClickedSearchButton(text: searchTextField.text!)
    }
}

extension SearchLocationView: SearchLocationViewProtocol {
    func dismiss() {
        dismiss(animated: true)
    }
    
    func showSearchResult(list: [searchLocationResult]) {
        searchResultList = list
        tableView.reloadData()
    }
}

extension SearchLocationView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchLocationTableViewCell.identifier, for: indexPath) as! SearchLocationTableViewCell
        cell.detailAddress.text = searchResultList[indexPath.row].address
        cell.title.text = searchResultList[indexPath.row].placeName
        cell.category.text = searchResultList[indexPath.row].category
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectedItem(item: searchResultList[indexPath.row], view: self)
    }
}