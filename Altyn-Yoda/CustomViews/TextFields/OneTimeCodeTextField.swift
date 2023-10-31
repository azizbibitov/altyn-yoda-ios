//
//  OneTimeCodeTextField.swift
//  Salam-beta
//
//  Created by Shirin on 13.03.2022.
//

import UIKit

public class OneTimeCodeTextField: UITextField {
    private(set) var digitLabels = [UILabel]()
    
    private lazy var oneTimeCodeDelegate = OneTimeCodeTextFieldDelegate(oneTimeCodeTextField: self)
    
    private var isConfigured = false
    private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(becomeFirstResponder))
        return recognizer
    }()
    
    public var didReceiveCode: ((String) -> Void)?
    public var notFilled: (() -> Void)?
    
    public var codeTextColor: UIColor = .textColor! {
        didSet {
            digitLabels.forEach({ $0.textColor = codeTextColor })
        }
    }

    public var codeFont: UIFont = .interBold(size: 24) {
        didSet {
            digitLabels.forEach({ $0.font = codeFont })
        }
    }

    public func configure(withSlotCount slotCount: Int = 4, andSpacing spacing: CGFloat = 8) {
        guard isConfigured == false else { return }
        isConfigured = true
        configureTextField()
        
        let slotsStackView = generateSlotsStackView(with: slotCount, spacing: spacing)
        addSubview(slotsStackView)
                
        addGestureRecognizer(tapGestureRecognizer)
        
        NSLayoutConstraint.activate([
            slotsStackView.topAnchor.constraint(equalTo: topAnchor),
            slotsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            slotsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            slotsStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func configureTextField() {
        tintColor = .clear
        textColor = .clear
        layer.borderWidth = 0
        borderStyle = .none
        keyboardType = .numberPad
        if #available(iOS 12.0, *) {
            textContentType = .oneTimeCode
        }
        
        addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        delegate = oneTimeCodeDelegate
        
        becomeFirstResponder()
    }
    
    private func generateSlotsStackView(with count: Int, spacing: CGFloat) -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = spacing
        
        for _ in 0..<count {            
            let slotLabel = generateSlotLabel()
            stackView.addArrangedSubview(slotLabel)
            digitLabels.append(slotLabel)
        }
        
        return stackView
    }
    
    private func generateSlotLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.textAlignment = .center
        label.font = codeFont
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.textColor = codeTextColor
        label.layer.masksToBounds = true
        return label
    }
    
    @objc private func textDidChange() {
        guard let code = text, code.count <= digitLabels.count else { return }
        
        for i in 0 ..< digitLabels.count {
            let currentLabel = digitLabels[i]
            
            if i < code.count {
                let index = code.index(code.startIndex, offsetBy: i)
                currentLabel.text = String(code[index])
            } else {
                currentLabel.text?.removeAll()
            }
        }
        
        if code.count == (digitLabels.count-1) { notFilled?() }
        
        if code.count == digitLabels.count { didReceiveCode?(code) }
    }
}

class OneTimeCodeTextFieldDelegate: NSObject, UITextFieldDelegate {
    let oneTimeCodeTextField: OneTimeCodeTextField
    
    init(oneTimeCodeTextField: OneTimeCodeTextField) {
        self.oneTimeCodeTextField = oneTimeCodeTextField
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string)),
              let characterCount = textField.text?.count else { return false }
        return characterCount < oneTimeCodeTextField.digitLabels.count || string == ""
    }
}

extension OneTimeCodeTextField {
    public override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool { false }
    public override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] { [] }
}
