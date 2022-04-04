//
//  PaddingTextField.swift
//  RxLectureExample
//
//  Created by iMac on 2022/04/04.
//

import UIKit

class PaddingTextField: UITextField {
    let padding = UIEdgeInsets(top: 0, left: 8.0, bottom: 0, right: 0)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
