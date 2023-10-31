//
//  ErrorMessageView.swift
//  Salam
//
//  Created by Begga on 2/16/21.
//

import UIKit

class ErrorMessageView: UIView {

    lazy var beginningPositionY: CGFloat = 0
    
    private var errorMessageLabel: UILabel = {
        let lb = UILabel()
        lb.font = .interRegular(size: 14)
        lb.textColor = UIColor.white
        lb.numberOfLines = 0
        lb.textAlignment = .center
        return lb
    }()
    
    lazy var closeButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "close-error"), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
        btn.addTarget(self, action: #selector(close), for: .touchUpInside)
        return btn
    }()
    
    var interactionCallback: ( () -> Void )?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
        
        layer.cornerRadius = 6
        backgroundColor = .red
        
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture)))
        
        addSubview(errorMessageLabel)
        addSubview(closeButton)
    }
    
    override func layoutSubviews() {
        errorMessageLabel.frame = CGRect(x: 15, y: 17, width: frame.width - 10 - 40, height: 30)
        errorMessageLabel.sizeToFit()
        
        closeButton.frame = CGRect(x: frame.width - 40, y: 0, width: 40, height: frame.height)
        
        frame.size.height = errorMessageLabel.frame.height + 32
    }
    
    func set(errorMessage: String) {
        errorMessageLabel.text = errorMessage
        
        self.layoutSubviews()
    }
    
    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self)
        self.interactionCallback?()
        
        switch recognizer.state {
        case .began:
            
            beginningPositionY = self.frame.minY
            break
            
        case .changed:
            
            if self.frame.origin.y + translation.y < beginningPositionY {
                self.frame.origin.y += translation.y / 5
            } else {
                self.frame.origin.y = min(self.frame.origin.y + translation.y, 70)
            }
            
            recognizer.setTranslation(.zero, in: self)
            
        case .ended:
            if self.frame.origin.y < beginningPositionY {
                UIView.animate(withDuration: 0.2) {
                    self.frame.origin.y = -100
                }
                
            } else {
                UIView.animate(withDuration: 0.2) {
                    self.frame.origin.y = (UIApplication.shared.windows.first?.frame.minY ?? 0) + 60
                }
            }
            
        default:
            break
        }
    }
    
    @objc func close() {
        UIView.animate(withDuration: 0.2) {
            self.frame.origin.y = -100
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

