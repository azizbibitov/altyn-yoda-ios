//
//  CustomActionPopupVC.swift
//  MIU-LOVE
//
//  Created by Aziz's MacBook Air on 09.03.2023.
//

import UIKit
import EasyPeasy

class GoldenWayActionPopupVC: UIViewController {
    
    var delegate: ActionPopupProtocol?
    var indexPath: IndexPath = IndexPath(item: 0, section: 0)
    
    var actionLabelText: String = ""
    var yesActionText: String = ""
    var noActionText: String = ""
    
    init (actionLabelText: String, yesActionText: String, noActionText: String) {
        self.actionLabelText = actionLabelText
        self.yesActionText = yesActionText
        self.noActionText = noActionText

        super.init(nibName: nil, bundle: nil)
    }

    
    var mainView: GoldenWayActionPopupView {
        return view as! GoldenWayActionPopupView
    }
    
    override func loadView() {
        super.loadView()
        view = GoldenWayActionPopupView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCallbacks()
        mainView.actionLabel.text = actionLabelText
        mainView.yesBtn.setTitle(yesActionText, for: .normal)
        mainView.noBtn.setTitle(noActionText, for: .normal)
    }
    

   
    
    
    func setupCallbacks(){
        mainView.yesActionCallback = { [weak self] in
            self?.delegate?.action(isTrue: true, indexPath: self!.indexPath)
            self?.dismiss(animated: true)
        }
        
        mainView.noActionCallback = { [weak self] in
            self?.delegate?.action(isTrue: false, indexPath: self!.indexPath)
            self?.dismiss(animated: true)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


