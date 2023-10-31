//
//  LinkTextView.swift
//  SalamExpress
//
//  Created by Parahat Caryyew on 16.02.2023.
//

import UIKit

class LinkTextView: UITextView, UITextViewDelegate {
    
    typealias Links = [String: String]
    
    typealias UnderLinedTexts = [String]
    
    typealias OnLinkTap = (URL) -> Bool
    
    var onLinkTap: OnLinkTap?
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        isEditable = false
        isSelectable = true
        isScrollEnabled = false //to have own size and behave like a label
        delegate = self
        backgroundColor = .whiteBlackColor
        font = .interMedium(size: 14)
        textColor = .textColor
        textAlignment = .center
        self.textContainer.lineFragmentPadding = 0
        self.textContainer.lineBreakMode = .byWordWrapping
        self.textContainerInset = .zero
        self.textContainer.maximumNumberOfLines = 0
        self.translatesAutoresizingMaskIntoConstraints  = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func addLinks(_ links: Links, _ underLinedTexts: UnderLinedTexts) {
        guard attributedText.length > 0  else {
            return
        }
        let mText = NSMutableAttributedString(attributedString: attributedText)
        
        for (linkText, urlString) in links {
            if linkText.count > 0 {
                let linkRange = mText.mutableString.range(of: linkText)
                mText.addAttribute(.link, value: urlString, range: linkRange)
            }
        }
        
        for underLinedText in underLinedTexts {
            if underLinedText.count > 0 {
                let range = mText.mutableString.range(of: underLinedText)
                mText.addAttributes([NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue], range: range)
            }
        }
        
        attributedText = mText
    }
    
    func addGoldenWayLinks(_ links: Links, _ underLinedTexts: UnderLinedTexts) {
        guard attributedText.length > 0  else {
            return
        }
        let mText = NSMutableAttributedString(attributedString: attributedText)
        
        for (linkText, urlString) in links {
            if linkText.count > 0 {
                let linkRange = mText.mutableString.range(of: linkText)
                mText.addAttribute(NSAttributedString.Key.link, value: urlString, range: linkRange)
                
                
            }
        }
        
        for underLinedText in underLinedTexts {
            if underLinedText.count > 0 {
                let range = mText.mutableString.range(of: underLinedText)
                mText.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.primaryColor!], range: range)
            }
        }
        let linkAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.textColor!,
            NSAttributedString.Key.underlineColor: UIColor.textColor!,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
        ]

        // textView is a UITextView
        self.linkTextAttributes = linkAttributes
        attributedText = mText
    }
    
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        return onLinkTap?(URL) ?? true
    }
    
    // to disable text selection
    func textViewDidChangeSelection(_ textView: UITextView) {
        textView.selectedTextRange = nil
    }
}
