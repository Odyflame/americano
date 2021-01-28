//
//  BaseEditableStudyDetailView.swift
//  Terminal-iOS
//
//  Created by 정재인 on 2021/01/19.
//  Copyright © 2021 정재인. All rights reserved.
//

import UIKit

class BaseEditableStudyDetailView: UIViewController {
    
    let screenSize = UIScreen.main.bounds
    var keyboardHeight: CGFloat = 0.0
    let mainImageView = MainImageView(frame: CGRect.zero)
    let studyTitleTextField = UITextField()
    var selectedCategory: String?
    var studyIntroduceView = TitleWithTextView(title: "스터디 소개")
    var SNSInputView = IdInputView()
    var studyInfoView = TitleWithTextView(title: "스터디 진행")
    var locationView = LocationUIView()
    var timeView = TimeUIView()
    var button = UIButton()
    var mainImageTapGesture = UITapGestureRecognizer()
    var locationTapGesture = UITapGestureRecognizer()
    
    var studyDetailPost: StudyDetailPost?
    var backgroundView = UIView()
    let scrollView = UIScrollView()
    let picker = UIImagePickerController()
    var clickedView: UIView?
    var currentScrollViewMinY: CGFloat = 0
    var currentScrollViewMaxY: CGFloat = 0
    var selectedLocation: StudyDetailLocationPost?
    var textViewTapFlag = false
    var scrollViewOffsetElement: CGFloat = 0.0
    var accessoryCompletButton = UIButton()
    var viewDidAppearFlag = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
        setDelegate()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if viewDidAppearFlag {
            studyTitleTextField.becomeFirstResponder()
            viewDidAppearFlag.toggle()
        }
        scrollViewOffsetElement = 0
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame: NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        keyboardHeight = keyboardRectangle.height
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        button.alpha = 1
        scrollView.contentSize.height -= scrollViewOffsetElement
        scrollViewOffsetElement = 0
    }
    
    func setDelegate(completion: (() -> Void)? = nil) {
        scrollView.delegate = self
        studyTitleTextField.delegate = self
        studyIntroduceView.textView.delegate = self
        studyInfoView.textView.delegate = self
        SNSInputView.notion.textField.delegate = self
        SNSInputView.evernote.textField.delegate = self
        SNSInputView.web.textField.delegate = self
        locationView.detailAddress.delegate = self
        timeView.detailTime.delegate = self
        picker.delegate = self
        
        SNSInputView.notion.textField.debounce(delay: 1) { [weak self] text in
            //첫 로드 시 한번 실행되는 거는 분기처리를 해주자 text.isEmpty 등등으로 해결볼 수 있을 듯
            guard let text = self?.SNSInputView.notion.textField.text else { return }
            if text.notionCheck() {
                if text.isEmpty {
                    self!.SNSInputView.notion.textField.layer.borderColor = .none
                } else {
                    self!.SNSInputView.notion.textField.layer.borderColor = UIColor.systemBlue.cgColor
                }
            } else {
                self!.SNSInputView.notion.textField.layer.borderColor = UIColor.systemRed.cgColor
            }
        }
        SNSInputView.evernote.textField.debounce(delay: 1) { [weak self] text in
            guard let text = self?.SNSInputView.evernote.textField.text else { return }
            if text.evernoteCheck() {
                if text.isEmpty {
                    self!.SNSInputView.evernote.textField.layer.borderColor = .none
                } else {
                    self!.SNSInputView.evernote.textField.layer.borderColor = UIColor.systemBlue.cgColor
                }
            } else {
                self!.SNSInputView.evernote.textField.layer.borderColor = UIColor.systemRed.cgColor
            }
        }
        SNSInputView.web.textField.debounce(delay: 1) { [weak self] text in
            guard let text = self?.SNSInputView.web.textField.text else { return }
            if text.webCheck() {
                if text.isEmpty {
                    self!.SNSInputView.web.textField.layer.borderColor = .none
                } else {
                    self!.SNSInputView.web.textField.layer.borderColor = UIColor.systemBlue.cgColor
                }
            } else {
                self!.SNSInputView.web.textField.layer.borderColor = UIColor.systemRed.cgColor
            }
        }
    }
    
    func attribute() {
        view.do {
            $0.backgroundColor = UIColor.appColor(.testColor)
        }
        backgroundView.do {
            $0.backgroundColor = .cyan
        }
        scrollView.do {
            $0.backgroundColor = UIColor.appColor(.testColor)
            $0.showsVerticalScrollIndicator = false
        }
        backgroundView.do {
            $0.backgroundColor = UIColor.appColor(.testColor)
        }
        mainImageView.do {
            $0.alpha = 0.7
            $0.image = #imageLiteral(resourceName: "swift")
            mainImageTapGesture = UITapGestureRecognizer(target: self, action: #selector(didImageViewClicked))
            $0.addGestureRecognizer(mainImageTapGesture)
        }
        studyTitleTextField.do {
            $0.tag = 1
            $0.placeholder = "스터디 이름을 입력하세요"
            $0.backgroundColor = UIColor.appColor(.InputViewColor)
            $0.textAlignment = .center
            $0.textColor = .white
            $0.layer.cornerRadius = 10
            $0.dynamicFont(fontSize: $0.font!.pointSize, weight: .semibold)
            $0.inputAccessoryView = accessoryCompletButton
        }
        studyIntroduceView.do {
            $0.backgroundColor = UIColor.appColor(.testColor)
            $0.categoryLabel.text = selectedCategory
            $0.textView.inputAccessoryView = accessoryCompletButton
        }
        SNSInputView.do {
            $0.backgroundColor = UIColor.appColor(.testColor)
            $0.notion.textField.inputAccessoryView = accessoryCompletButton
            $0.evernote.textField.inputAccessoryView = accessoryCompletButton
            $0.web.textField.inputAccessoryView = accessoryCompletButton
        }
        studyInfoView.do {
            $0.backgroundColor = UIColor.appColor(.testColor)
            $0.textView.inputAccessoryView = accessoryCompletButton
        }
        locationView.do {
            $0.backgroundColor = UIColor.appColor(.testColor)
            locationTapGesture = UITapGestureRecognizer(target: self, action: #selector(didLocationViewClicked))
            $0.addGestureRecognizer(locationTapGesture)
            $0.detailAddress.inputAccessoryView = accessoryCompletButton
        }
        timeView.do {
            $0.backgroundColor = UIColor.appColor(.testColor)
            $0.detailTime.inputAccessoryView = accessoryCompletButton
        }
        button.do {
            $0.setTitle("완료", for: .normal)
            $0.backgroundColor = UIColor.appColor(.mainColor)
            $0.layer.cornerRadius = 10
            $0.layer.masksToBounds = true
        }
        accessoryCompletButton.do {
            $0.setTitle("완료", for: .normal)
            $0.backgroundColor = UIColor.appColor(.mainColor)
            $0.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 45)
        }
    }
    
    func layout() {
        view.addSubview(scrollView)
        [mainImageView, studyTitleTextField, studyIntroduceView, SNSInputView, studyInfoView, locationView, timeView, button].forEach { scrollView.addSubview($0)}
        
        scrollView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            $0.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            $0.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            $0.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        }
        mainImageView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.widthAnchor.constraint(equalToConstant: screenSize.width).isActive = true
            $0.heightAnchor.constraint(equalToConstant: Terminal.convertHeigt(value: 170)).isActive = true
            $0.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
            $0.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        }
        studyTitleTextField.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: -((((55/667) * screenSize.height) * 16) / 55)).isActive = true
            $0.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
            $0.widthAnchor.constraint(equalToConstant: (300/375) * screenSize.width).isActive = true
            $0.heightAnchor.constraint(equalToConstant: (55/667) * screenSize.height).isActive = true
        }
        studyIntroduceView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: studyTitleTextField.bottomAnchor, constant: Terminal.convertHeigt(value: 23)).isActive = true
            $0.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor, constant: Terminal.convertWidth(value: 15) ).isActive = true
            $0.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor, constant: Terminal.convertWidth(value: -15) ).isActive = true
            $0.heightAnchor.constraint(equalToConstant: Terminal.convertHeigt(value: 141)).isActive = true
        }
        SNSInputView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: studyIntroduceView.bottomAnchor, constant: Terminal.convertHeigt(value: 23)).isActive = true
            $0.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor, constant: Terminal.convertWidth(value: 15) ).isActive = true
            $0.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor, constant: Terminal.convertWidth(value: -15) ).isActive = true
            $0.heightAnchor.constraint(equalToConstant: Terminal.convertHeigt(value: 141)).isActive = true
        }
        studyInfoView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: SNSInputView.bottomAnchor, constant: Terminal.convertHeigt(value: 23)).isActive = true
            $0.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor, constant: Terminal.convertWidth(value: 15) ).isActive = true
            $0.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor, constant: Terminal.convertWidth(value: -15) ).isActive = true
            $0.heightAnchor.constraint(equalToConstant: Terminal.convertHeigt(value: 141)).isActive = true
        }
        locationView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: studyInfoView.bottomAnchor, constant: Terminal.convertHeigt(value: 23)).isActive = true
            $0.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor, constant: Terminal.convertWidth(value: 15) ).isActive = true
            $0.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor, constant: Terminal.convertWidth(value: -15) ).isActive = true
            $0.heightAnchor.constraint(equalToConstant: Terminal.convertHeigt(value: 141)).isActive = true
        }
        timeView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: locationView.bottomAnchor, constant: Terminal.convertHeigt(value: 23)).isActive = true
            $0.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor, constant: Terminal.convertWidth(value: -15) ).isActive = true
            $0.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor, constant: Terminal.convertWidth(value: 15) ).isActive = true
            $0.heightAnchor.constraint(equalToConstant: Terminal.convertHeigt(value: 100)).isActive = true
        }
        button.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: timeView.bottomAnchor, constant: Terminal.convertHeigt(value: 23)).isActive = true
            $0.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor, constant: Terminal.convertWidth(value: -15) ).isActive = true
            $0.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor, constant: Terminal.convertWidth(value: 15) ).isActive = true
            $0.heightAnchor.constraint(equalToConstant: Terminal.convertHeigt(value: 50)).isActive = true
            $0.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        }
    }
    
    @objc func didImageViewClicked() {
        let alert =  UIAlertController(title: "대표 사진 설정", message: nil, preferredStyle: .actionSheet)
        let library =  UIAlertAction(title: "사진앨범", style: .default) { _ in self.openLibrary() }
        let camera =  UIAlertAction(title: "카메라", style: .default) { _ in self.openCamera() }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    @objc func didLocationViewClicked() {
        //
    }
    func openLibrary() {
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    func openCamera() {
        //시뮬에서 앱죽는거 에러처리 해야함
        picker.sourceType = .camera
        present(picker, animated: true, completion: nil)
    }
    
    func editableViewDidTap(textView: UIView, viewMinY: CGFloat, viewMaxY: CGFloat) {
        var parentView = UIView()
        if type(of: textView) == SNSInputUITextField.self {
            parentView = (textView.superview?.superview)!
        } else {
            parentView = textView.tag == 1 ? textView : textView.superview!
        }
        if viewMinY >= (parentView.frame.minY) {
            let distance = (parentView.frame.minY) - viewMinY
            self.viewSetTop(distance: distance - 10)
        } else if viewMaxY <= (parentView.frame.maxY) {
            let distance = (parentView.frame.maxY) - viewMaxY
            if distance > (scrollView.contentSize.height - (scrollView.contentOffset.y + scrollView.frame.height)) {
                scrollViewOffsetElement = distance
            }
            self.viewSetBottom(distance: distance + 10)
        } else {
        }
    }
    
    func viewSetTop(distance: CGFloat) {
        
        UIView.animate(withDuration: 0.2) {
            self.button.alpha = 0
            self.scrollView.contentOffset.y += distance
        } completion: { _ in
            self.textViewTapFlag = true
            self.clickedView?.becomeFirstResponder()
        }
    }
    func viewSetBottom(distance: CGFloat) {
        
        UIView.animate(withDuration: 0.2) {
            self.button.alpha = 0
            self.scrollView.contentSize.height += distance
            self.scrollView.contentOffset.y += distance
            self.scrollViewOffsetElement = distance
        } completion: { _ in
            self.clickedView?.becomeFirstResponder()
            self.textViewTapFlag = true
        }
    }
}
extension BaseEditableStudyDetailView:  UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            mainImageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}

extension BaseEditableStudyDetailView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        clickedView = textField
            self.editableViewDidTap(textView: textField, viewMinY: CGFloat(currentScrollViewMinY), viewMaxY: CGFloat(currentScrollViewMaxY))
    }
}

extension BaseEditableStudyDetailView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        clickedView = textView
        self.editableViewDidTap(textView: clickedView!, viewMinY: CGFloat(currentScrollViewMinY), viewMaxY: CGFloat(currentScrollViewMaxY))
    }
}

extension BaseEditableStudyDetailView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if type(of: scrollView) == UIScrollView.self {
            view.endEditing(true)
        }
        currentScrollViewMinY = scrollView.contentOffset.y
        currentScrollViewMaxY = (scrollView.contentOffset.y + scrollView.frame.height) - keyboardHeight
    }
}

extension BaseEditableStudyDetailView: selectLocationDelegate {
    func passLocation(location: StudyDetailLocationPost) {
        selectedLocation = location
        locationView.address.text = "\(location.address)"
        guard let detail = location.detailAddress else { return }
        locationView.detailAddress.text = detail
    }
}
