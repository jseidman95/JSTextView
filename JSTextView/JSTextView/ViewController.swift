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
        textView.appendToLabelArray(attributeName: NSAttributedStringKey.font, attributeValue: UIFont(name: "Times New Roman", size: 24.0)!)

    }
}

