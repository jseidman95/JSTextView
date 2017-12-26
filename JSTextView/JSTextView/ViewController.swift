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
        let color = UIColor(red: 217/255.0, green: 80/255.0, blue: 0/255.0, alpha: 1.0)
        textView.appendToLabelArray(attributeName: NSAttributedStringKey.foregroundColor, attributeValue: color)
        textView.appendToLabelArray(attributeName: NSAttributedStringKey.underlineStyle, attributeValue: NSUnderlineStyle.styleSingle.rawValue)
    }
}

