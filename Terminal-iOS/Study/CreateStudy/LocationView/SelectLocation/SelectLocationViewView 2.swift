//
//  SelectLocationViewViewController.swift
//  Terminal-iOS
//
//  Created by 정재인 on 2020/09/27.
//  Copyright © 2020 정재인. All rights reserved.
//

import UIKit
import NMapsMap

protocol selectLocationDelegate: class {
    func passLocation(location: StudyDetailLocationPost)
}

class SelectLocationView: UIViewController {
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    var presenter: SelectLocationPresenterProtocol?
    let pin = UIImageView()
    var task: DispatchWorkItem?
    var mapView = NMFMapView()
    var bottomView = BottomView()
    var location: StudyDetailLocationPost?
    var animationFlag = true
    var isMoving = false
    var delegate: selectLocationDelegate?
    var keyboardHeight: CGFloat = 0.0
    var bottomAnchor: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        guard let item = location else { return }
        presenter?.viewDidLoad(item: item)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        bottomView.detailAddress.becomeFirstResponder()
        mapView.moveCamera(NMFCameraUpdate(scrollTo: NMGLatLng(lat: Double(location!.lat), lng: Double(location!.lng)), zoomTo: 17))
        location?.lng = mapView.cameraPosition.target.lng
        location?.lat = mapView.cameraPosition.target.lat
    }
    
    override func viewWillAppear(_ animated: Bool) {
        animationFlag = isBeingPresented
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame: NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        keyboardHeight = keyboardRectangle.height
        
        if animationFlag == false {
            bottomAnchor?.constant -= keyboardHeight
            bottomAnchor?.isActive = true
            view.layoutIfNeeded()
        }
        bottomView.detailAddress.becomeFirstResponder()
        animationFlag = false
    }
    
    @objc func keyboardWillHide() {
        if animationFlag == false {
            bottomAnchor?.constant = 0
            bottomAnchor?.isActive = true
            view.layoutIfNeeded()
        }
    }
    
    func attribute() {
        self.do {
            $0.view.backgroundColor = UIColor.appColor(.terminalBackground)
        }
        mapView.do {
            $0.mapType = .basic
            $0.symbolScale = 0.7
            $0.addCameraDelegate(delegate: self)
        }
        pin.do {
            $0.image = #imageLiteral(resourceName: "marker")
        }
        bottomView.do {
            $0.completeButton.addTarget(self, action: #selector(didCompleteButtonClicked), for: .touchUpInside)
            $0.address.text = location?.address
            $0.layer.cornerRadius = 10
            $0.layer.masksToBounds = true
            $0.detailAddress.delegate = self
        }
    }
    
    func layout() {
        [mapView, pin, bottomView].forEach { view.addSubview($0) }
        
        mapView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            $0.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            $0.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            $0.bottomAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        }
        pin.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.centerXAnchor.constraint(equalTo: mapView.centerXAnchor).isActive = true
            $0.bottomAnchor.constraint(equalTo: mapView.centerYAnchor).isActive = true
            $0.widthAnchor.constraint(equalToConstant: Terminal.convertWidth(value: 35)).isActive = true
            $0.heightAnchor.constraint(equalToConstant: Terminal.convertWidth(value: 50)).isActive = true
        }
        bottomAnchor = bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        bottomView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            bottomAnchor?.isActive = true
            $0.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            $0.heightAnchor.constraint(equalToConstant: Terminal.convertHeight(value: 202)).isActive = true
        }
    }
    
    @objc func didCompleteButtonClicked() {
        if let detailAddress = bottomView.detailAddress.text {
            location?.detailAddress = detailAddress
        }
        passLocationToParent()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isMoving = true
    }
    
    func passLocationToParent() {
        delegate?.passLocation(location: location!)
        dismiss(animated: false)
        presentingViewController?.dismiss(animated: false)
    }
}

extension SelectLocationView: NMFMapViewCameraDelegate {
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        task = DispatchWorkItem { [self] in
            self.pin.alpha = 1
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                self.pin.transform = CGAffineTransform(translationX: 0, y: 0)
                location?.lng = mapView.cameraPosition.target.lng
                location?.lat = mapView.cameraPosition.target.lat
                location?.category = ""
                if isMoving {
                    presenter?.getAddress(item: location!)
                }
            })
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: task!)
    }
    
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
        self.view.endEditing(true)
        task?.cancel()
        pin.alpha = 0.5
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.pin.transform = CGAffineTransform(translationX: 0, y: -10)
        })
    }
    
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        print(location?.placeName)
    }
}

extension SelectLocationView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

extension SelectLocationView: SelectLocationViewProtocol {
    func setViewWithResult(item: StudyDetailLocationPost) {
        bottomView.address.text = item.address
        location = item
    }
    
    func setLocaionOnce(sido: String, sigungu: String) {
        location?.sido = sido
        location?.sigungu = sigungu
    }
}