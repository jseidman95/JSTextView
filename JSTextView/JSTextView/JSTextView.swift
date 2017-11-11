//
//  JSTextView.swift
//  JSTextView
//
//  Created by Jesse Seidman on 11/10/17.
//  Copyright © 2017 Jesse Seidman. All rights reserved.
//

import UIKit

class JSTextView: UITextView
{
    //PRIVATE VARIABLES
    private let newView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 200.0, height: 200.0))
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        startUp()
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?)
    {
        super.init(frame: frame, textContainer: textContainer)
        
        startUp()
    }
    
    //PRIVATE FUNCTIONS
    private func startUp()
    {
        //configure new view
        newView.backgroundColor = UIColor.blue
    }
    
    override func didMoveToSuperview()
    {
        self.superview?.addSubview(newView)
        
        //make constraints
        newView.translatesAutoresizingMaskIntoConstraints = false
        
        self.superview?.addConstraint(NSLayoutConstraint(item: newView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.1, constant: 0))
        self.superview?.addConstraint(NSLayoutConstraint(item: newView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 0))
        self.superview?.addConstraint(NSLayoutConstraint(item: newView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
        self.superview?.addConstraint(NSLayoutConstraint(item: newView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
        self.superview?.addConstraint(NSLayoutConstraint(item: newView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0))
    }
}
