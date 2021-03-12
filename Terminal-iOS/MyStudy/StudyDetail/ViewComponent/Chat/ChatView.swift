//
//  TempChatView.swift
//  Terminal-iOS
//
//  Created by once on 2020/11/01.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit
import SocketIO
import SwiftyJSON

class ChatView: UIViewController {
    var presenter: ChatPresenterProtocol?
    var chatTableView = UITableView()
    var chatList: [Chat] = []
    var keyboardHeight: CGFloat = 0.0
    var chatTableViewConstraint: NSLayoutConstraint?
    var isEdting = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        attribute()
        layout()
        self.hideKeyboardWhenTappedAround()
        self.keyboardAddObserver(showSelector: #selector(keyboardWillShow),
                                 hideSelector: #selector(keyboardWillHide))
    }
    override func viewWillDisappear(_ animated: Bool) {
        presenter?.viewWillDisappear()
    }
    
    func attribute() {
        view.do {
            $0.backgroundColor = .appColor(.terminalBackground)
        }
        chatTableView.do {
            $0.backgroundColor = .appColor(.terminalBackground)
            $0.delegate = self
            $0.dataSource = self
            $0.register(ChatInputTableViewCell.self, forCellReuseIdentifier: ChatInputTableViewCell.id)
            $0.register(ChatOutputTableViewCell.self, forCellReuseIdentifier: ChatOutputTableViewCell.id)
            $0.separatorStyle = .none
        }
    }
    
    func layout() {
        [chatTableView].forEach { view.addSubview($0) }
        chatTableViewConstraint = chatTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        chatTableView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            $0.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            $0.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            chatTableViewConstraint?.isActive = true
        }
    }
    
    func tableViewAddConstant() {
    }
    
    // MARK: @objc
    @objc func keyboardWillShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame: NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        self.keyboardHeight = keyboardRectangle.height
        chatTableView.setBottomInset(to: keyboardHeight)
    }
    
    @objc func keyboardWillHide() {
        chatTableView.setBottomInset(to: 0.0)
    }
}

extension ChatView: ChatViewProtocol {
    func showLastChat(lastChat: [Chat]) {
        chatList += lastChat
        chatTableView.reloadData()
        presenter?.viewRoadLastChat()
    }
    func showSocketChat(socketChat: [Chat]) {
        chatList += socketChat
        chatTableView.reloadData()
        DispatchQueue.main.async {
            self.chatTableView.scrollToRow(at: [0, self.chatList.count], at: .bottom, animated: false)
        }
    }
    
    func showMessage(message: String) {
        
    }
    
    func showLoading() {
        LoadingRainbowCat.show(caller: self)
    }
    
    func hideLoading() {
        LoadingRainbowCat.hide(caller: self)
    }
    
    func showError(message: String) {
        showToast(controller: self, message: message, seconds: 1)
    }
    
}
extension ChatView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatList.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == chatList.count {
            let outputCell = tableView.dequeueReusableCell(withIdentifier: ChatOutputTableViewCell.id, for: indexPath) as! ChatOutputTableViewCell
            outputCell.textInput.delegate = self
            return outputCell
        } else {
            let inputCell = tableView.dequeueReusableCell(withIdentifier: ChatInputTableViewCell.id, for: indexPath) as! ChatInputTableViewCell
            inputCell.setData(chat: chatList[indexPath.row])
            return inputCell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isEdting {
            //            view.endEditing(true)
        }
    }
}

extension ChatView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
    
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let inputChatMessage = textField.text else { return true }
        presenter?.emitButtonDidTap(message: inputChatMessage)
        textField.text = ""
        return true
    }
}
