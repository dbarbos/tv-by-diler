//
//  String+Extensions.swift
//  ShowChallenge
//
//  Created by Diler Barbosa on 26/06/21.
//

import Foundation
import UIKit

extension String {
    func asHtmlAttributed(color: UIColor) -> NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            let string = NSMutableAttributedString(attributedString: attributedString)

            let paragraphStyle =  NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = .byTruncatingTail
            string.addAttributes(
                [
                    .foregroundColor: color,
                    .paragraphStyle: paragraphStyle
                ],
                range: NSRange(location: 0, length: attributedString.length)
            )

            let regularFont = UIFont.systemFont(ofSize: 12)
            let boldFont = UIFont.systemFont(ofSize: 12, weight: .semibold)
            
            string.enumerateAttribute(.font, in: NSMakeRange(0, attributedString.length), options: NSAttributedString.EnumerationOptions(rawValue: 0), using: { (value, range, stop) -> Void in
                if let oldFont = value as? UIFont, oldFont.fontName.lowercased().contains("bold") {
                    string.removeAttribute(.font, range: range)
                    string.addAttribute(.font, value: boldFont, range: range)
                }
                else {
                    string.addAttribute(.font, value: regularFont, range: range)
                }
            })
            return string
        }
        return NSAttributedString()
    }
}
