//
//  LoginTextFields.swift
//  OnTheMap
//
//  Created by Geoffrey_Ching on 7/1/16.
//  Copyright © 2016 Geoffrey Ching. All rights reserved.
//

import UIKit

class LoginTextFields: UITextField {

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
            NSForegroundColorAttributeName : UIColor.whiteColor(),
        ]
        
        let temp = placeholder
        
        attributedPlaceholder = NSAttributedString(string: temp!, attributes: placeholderStrokeTextAttributes)
        
    }
    
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5);
    
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
