//
//  AttributedStringFormatter.swift
//  Simple Weather
//
//  Created by Dmitry Likhaletov on 28.06.2020.
//  Copyright © 2020 Dmitry Likhaletov. All rights reserved.
//

import UIKit

class AttributedStringFormatter {
    
    private init() {}
    
    static func formatString(sourceString: String, fontSize: CGFloat, color: UIColor, alignment: NSTextAlignment = .center) -> NSAttributedString {
        
        let font = UIFont.systemFont(ofSize: fontSize)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        
        let attributes: [NSAttributedString.Key:Any] = [
            .font: font,
            .foregroundColor: color,
            .paragraphStyle: paragraphStyle
        ]
        
        let result = NSAttributedString(string: sourceString, attributes: attributes)
        
        return result
    }
    
}
