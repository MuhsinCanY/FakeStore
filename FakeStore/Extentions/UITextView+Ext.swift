//
//  UITextView+Ext.swift
//  FakeStore
//
//  Created by Muhsin Can Yılmaz on 28.03.2023.
//

import UIKit


extension UITextView {
    static func createTextViewWithUpperText(_ upperText: String, lowerText: String, upperFont: UIFont = .boldSystemFont(ofSize: 20), lowerFont: UIFont = .systemFont(ofSize: 14), upperTextColor: UIColor = .black, lowerTextColor: UIColor = .lightGray) -> UITextView {
        let textView = UITextView()
        
        // Set upper text attributes
        let upperTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: upperTextColor,
            .font: upperFont
        ]
        let upperAttributedString = NSAttributedString(string: upperText, attributes: upperTextAttributes)

        // Set lower text attributes
        let lowerTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: lowerTextColor,
            .font: lowerFont
        ]
        let lowerAttributedString = NSAttributedString(string: lowerText, attributes: lowerTextAttributes)

        // Combine upper and lower text into one attributed string
        let attributedString = NSMutableAttributedString()
        attributedString.append(upperAttributedString)
        attributedString.append(NSAttributedString(string: "\n")) // Add line break between upper and lower text
        attributedString.append(lowerAttributedString)

        // Set the attributed string as the text view's text
        textView.attributedText = attributedString
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isSelectable = false
        return textView
    }
}
