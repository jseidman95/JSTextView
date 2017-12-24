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
        textView.setLabelArray(attributeName: NSAttributedStringKey.font, attributeValue: UIFont(name: "Times New Roman", size: 43.0)!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

