//
//  ViewController.swift
//  JSTextView
//
//  Created by Jesse Seidman on 11/10/17.
//  Copyright © 2017 Jesse Seidman. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{

    @IBOutlet weak var textView: JSTextView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        textView.appendToLabelArray(attributeName: NSAttributedStringKey.font, attributeValue: UIFont(name: "Times New Roman", size: 43.0)!)
        textView.appendToLabelArray(attributeName: NSAttributedStringKey.foregroundColor, attributeValue: UIColor(red: 217/255.0, green: 80/255.0, blue: 0/255.0, alpha: 1.0))
        textView.appendToLabelArray(attributeName: NSAttributedStringKey.underlineStyle, attributeValue: NSUnderlineStyle.styleSingle.rawValue)
        
        textView.jumpPressEdgeSide = .right
        textView.jumpLabelPresentDuration = 0.05
        textView.jumpLabelFont = UIFont.systemFont(ofSize: 30.0)
    }
}

