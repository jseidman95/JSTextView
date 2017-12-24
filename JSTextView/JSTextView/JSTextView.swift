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
    private let jumpingPress   = UILongPressGestureRecognizer() //The long press which activates the jump scroll
    private var jumpLabelArray = [NSRange]()                    //The array of ranges that the user can jump to
    private var jumpLabel      = JumpingLabel()                 //The label that shows up when the jumping starts
    private var startedJumping = false                          //The boolean that tells if the jump has been initiated
    private var jumpLabelColor = UIColor(red: 26/255.0, green: 140/255.0, blue: 255/255.0, alpha: 1)
    private var jumpLabelFont  = UIFont.systemFont(ofSize: 20)
    
    //INITIALIZERS
    //init from StoryBoard
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        startUp()
    }
    
    //init from code
    override init(frame: CGRect, textContainer: NSTextContainer?)
    {
        super.init(frame: frame, textContainer: textContainer)
        
        startUp()
    }
    
    //PRIVATE FUNCTIONS
    private func startUp()
    {
        // Add Long press
        jumpingPress.addTarget(self, action: #selector(handleLongPressGesture))
        jumpingPress.cancelsTouchesInView = false
        jumpingPress.delegate = self
        jumpingPress.minimumPressDuration = 0.2
        self.addGestureRecognizer(jumpingPress)
        
        // Make Jump Label
        jumpLabel = JumpingLabel(padding:UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5))
        jumpLabel.layer.backgroundColor =  jumpLabelColor.cgColor
        jumpLabel.font                  =  jumpLabelFont
        jumpLabel.textAlignment         = .left
    }
    
    private func scrollToLabel(rect:CGRect, animated:Bool)
    {
        let newPoint = CGPoint(x: self.contentOffset.x, y: rect.origin.y - 40.0)
        self.setContentOffset(newPoint, animated: false)
    }
    
    /// This function takes a yPosition and boolean as an argument and scrolls the JSTextView to the appropriate location
    private func jumpToValueAt(yPosition:CGFloat, begin:Bool)
    {
        //calculate the jump location based on screen location
        let jumpIndex = Int(yPosition / self.frame.height * CGFloat(self.jumpLabelArray.count))
        
        //if the jump index is a legal index begin jump
        if jumpIndex >= 0 && jumpIndex < jumpLabelArray.count
        {
            //calculate data for jumping
            let startPosition   = self.position(from: self.beginningOfDocument, offset: jumpLabelArray[jumpIndex].lowerBound)
            let endPosition     = self.position(from: self.beginningOfDocument, offset: jumpLabelArray[jumpIndex].upperBound)
            var textRange:UITextRange?
            
            if let startPosition = startPosition, let endPosition = endPosition
            {
                textRange = self.textRange(from: startPosition , to: endPosition)
            }
            else
            {
                print("Error finding text range")
                return;
            }
            
            //set jump label to size of label text to get the base size of the label
            
            jumpLabel.text = self.text(in: textRange!)
            jumpLabel.sizeToFit()
            
            //set new stylized dimensions of jump label
            jumpLabel.frame.size.width  = jumpLabel.frame.width + self.frame.width / 6
            jumpLabel.frame.size.height = jumpLabel.frame.height * 2
            
            //update location if location is just changing and not being presented
            if !begin && yPosition < self.frame.maxY - jumpLabel.frame.height
            {
                jumpLabel.frame.origin = CGPoint(x: self.frame.maxX - jumpLabel.frame.width, y: yPosition)
                
                //while the jump label present animation is running jump to the correct location
                self.scrollToLabel(rect: firstRect(for: textRange!), animated: false)
            }
                //if the jump label is being presented
            else if yPosition < self.frame.maxY - jumpLabel.frame.height
            {
                if let superview = self.superview
                {
                    superview.addSubview(jumpLabel)
                }
                else
                {
                    print("Error loading superview")
                    return;
                }
                
                //set jump label location to just off the screen
                jumpLabel.frame.origin = CGPoint(x: self.frame.maxX + jumpLabel.frame.width, y: yPosition)
                
                //animate the addition of jump label
                UIView.animate(withDuration: 0.15, animations:
                    {
                        //move jump label to the correct location
                        self.jumpLabel.frame.origin = CGPoint(x: self.frame.maxX - self.jumpLabel.frame.width, y: yPosition)
                })
                
                //while the jump label present animation is running jump to the correct location
                self.scrollToLabel(rect: firstRect(for: textRange!), animated: false)
            }
            else
            {
                self.jumpingPress.isEnabled = false
                self.jumpingPress.isEnabled = true
            }
        }
    }
    
    // PUBLIC FUNCTIONS
    
    /// This public function allows the user to set the attribute with which the JSTextView creates the labels
    public func setLabelArray<T:Equatable> (attributeName:NSAttributedStringKey, attributeValue:T)
    {
        let storage = self.textStorage
        
        //loop through all attributes and check if they contain the target attribute value
        storage.enumerateAttribute(attributeName, in: NSMakeRange(0, textStorage.length), options: [], using:
            {
                (value,range,stop) in
                if value as? T == attributeValue
                {
                    jumpLabelArray.append(range)
                }
        })
    }
    
    public func setJumpLabelColor(newColor:UIColor)
    {
        self.jumpLabelColor = newColor
    }
    
    public func setJumpLabelFont(newFont:UIFont)
    {
        self.jumpLabelFont = newFont
    }
    
    //GESTURE ACTION FUNCTIONS
    
    @objc func handleLongPressGesture(gesture: UILongPressGestureRecognizer)
    {
        //The x position is found relative to the JSTextView because we want to find the touch location regardless of the superview
        let xPosition = jumpingPress.location(in: self).x
        
        //The y position is found in the superview because the position of the touch relative to the JSTextView calculates in regards to the content view of the textview (way too long)
        let yPosition = jumpingPress.location(in: superview).y - self.frame.minY
        
        // Check if touch is in hot zone and the jumping press state is began
        if jumpingPress.state == .began && xPosition >= self.frame.minX + self.frame.width * 0.9 && xPosition <= self.frame.minX + self.frame.width
        {
            self.startedJumping = true
            self.isUserInteractionEnabled = false //disable scrolling
            jumpToValueAt(yPosition: yPosition, begin: true)
        }
            
            //check if the jumping press state is changed
        else if startedJumping && jumpingPress.state == .changed
        {
            jumpToValueAt(yPosition: yPosition, begin: false)
        }
        
        //check if the jumping press state is ending
        if jumpingPress.state == .ended || jumpingPress.state == .cancelled || jumpingPress.state == .failed
        {
            UIView.animate(withDuration: 0.15, delay: 0.0, options: [], animations:
                {
                    self.jumpLabel.frame.origin = CGPoint(x: self.frame.maxX + self.jumpLabel.frame.width, y: yPosition)
            },
                           completion:
                { //only remove the label once the animation finishes
                    (completed) in
                    if completed {self.jumpLabel.removeFromSuperview()}
            })
            
            self.isUserInteractionEnabled = true //enable scrolling again
            startedJumping = false
        }
    }
    
}

//the extension which ensures that the gestures are recognized in the textview
extension JSTextView: UIGestureRecognizerDelegate
{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool
    {
        return true
    }
}

