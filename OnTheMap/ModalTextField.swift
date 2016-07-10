//
//  ModalTextField.swift
//  OnTheMap
//
//  Created by Geoffrey_Ching on 7/8/16.
//  Copyright © 2016 Geoffrey Ching. All rights reserved.
//

import UIKit

class ModalTextField: UITextField {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        borderStyle = .None
        
        textColor = UIColor.whiteColor()
        
        let placeholderStrokeTextAttributes: [String: AnyObject] = [
            NSForegroundColorAttributeName : UIColor.lightGrayColor(),
            ]
        
        let temp = placeholder
        
        attributedPlaceholder = NSAttributedString(string: temp!, attributes: placeholderStrokeTextAttributes)
        
    }
    
    let padding = UIEdgeInsets(top: 20, left: 5, bottom: 20, right: 5);
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}
