//
//  JSTextView.swift
//  JSTextView
//
//  Created by Jesse Seidman on 11/10/17.
//  Copyright © 2017 Jesse Seidman. All rights reserved.
//

import UIKit

enum Edge
{
    case right,left
}

class JSTextView: UITextView
{
    //PRIVATE VARIABLES
    private let jumpingPress   = UILongPressGestureRecognizer() //The long press which activates the jump scroll
    private var jumpLabelArray = [NSRange]()                    //The array of ranges that the user can jump to
    private var jumpLabel      = JumpingLabel()                 //The label that shows up when the jumping starts
    private var startedJumping = false                          //The boolean that tells if the jump has been initiated
    
    //CUSTOMIZABLE PUBLIC VARS
    public var jumpPressEdgePercentage  :CGFloat = 0.1   //The percentage of the screen that should be the 'hot zone'
    public var jumpTextDistanceFromTop  :CGFloat = 40.0  //The amount of space that should be left between the text and top of the screen
    public var labelTextDistanceFromEdge:CGFloat = 100.0 //The space left for the user's thumb
    public var jumpLabelTextColor:UIColor = UIColor()    //The color of the text of the label
    {
        didSet { jumpLabel.textColor = jumpLabelTextColor}
    }
    public var jumpLabelFont  = UIFont() //The font of the label text
    {
        didSet { jumpLabel.font = jumpLabelFont}
    }
    public var jumpPressEdgeSide:Edge = .right //The side of the screen from which the label is presented
    {
        didSet
        {
            jumpLabel = JumpingLabel(padding:UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5), edge: jumpPressEdgeSide)
            jumpLabel.layer.backgroundColor =  jumpLabelColor.cgColor
            jumpLabel.font                  =  jumpLabelFont
            jumpLabel.textAlignment         =  jumpPressEdgeSide == .right ? .left : .right
        }
    }
    public var jumpLabelColor:UIColor = UIColor() //The color of the label
    {
        didSet { self.jumpLabel.backgroundColor = jumpLabelColor }
    }
    public var showsIndicatorOnJump:Bool = false  //This boolean tells the textview to show or not show the indicator when it is jumping
    {
        didSet { self.showsVerticalScrollIndicator = showsIndicatorOnJump }
    }
    public var jumpLabelPresentDuration: CFTimeInterval = 0.0 //The amount of time to hold down on the 'hot zone' to present the label
    {
        didSet { self.jumpingPress.minimumPressDuration = jumpLabelPresentDuration }
    }
    
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
        jumpingPress.delegate             = self
        
        //initialize here so the didSet is called
        jumpLabelPresentDuration = 0.2
        showsIndicatorOnJump     = false
        jumpLabelFont            = UIFont.systemFont(ofSize: 20)
        jumpLabelColor           = UIColor(red:   26/255.0,
                                           green: 140/255.0,
                                           blue:  255/255.0,
                                           alpha: 1.0)
        jumpPressEdgeSide = .right
        
        self.addGestureRecognizer(jumpingPress)
    }
    
    //This function provides the jumping feature in which the text jumps to the proper location
    private func scrollToLabel(rect:CGRect, animated:Bool)
    {
        let newPoint = CGPoint(x: self.contentOffset.x, y: rect.origin.y - jumpTextDistanceFromTop)
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
            let startPosition   = self.position(from: self.beginningOfDocument,
                                                offset: jumpLabelArray[jumpIndex].lowerBound)
            let endPosition     = self.position(from: self.beginningOfDocument,
                                                offset: jumpLabelArray[jumpIndex].upperBound)
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
            
            //these variables hold the buffer zones for the touch using the jump label frame
            let topYPosition    = yPosition + self.frame.minY + jumpLabel.frame.height / 2
            let bottomYPosition = yPosition + self.frame.minY - jumpLabel.frame.height / 2
            
            if topYPosition < self.frame.maxY && bottomYPosition > self.frame.minY
            {
                //set jump label to size of label text to get the base size of the label
                jumpLabel.text = self.text(in: textRange!)
                jumpLabel.sizeToFit()
                
                //set new stylized dimensions of jump label
                jumpLabel.frame.size.width  = jumpLabel.frame.width  + labelTextDistanceFromEdge
                jumpLabel.frame.size.height = jumpLabel.frame.height * 2
            
                //update location if location is just changing and not being presented
                if !begin
                {
                    //present the jump label at the origin of bottom y position so it is in the middle
                    //of the user's finger
                    jumpLabel.frame.origin = CGPoint(x: jumpPressEdgeSide == .right ? self.frame.maxX - self.jumpLabel.frame.width :
                                                                                      self.frame.minX,
                                                     y: bottomYPosition)
                    
                    //while the jump label present animation is running jump to the correct location
                    self.scrollToLabel(rect: firstRect(for: textRange!), animated: false)
                }
                //if the jump label is being presented
                else
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
                    jumpLabel.frame.origin = CGPoint(x: jumpPressEdgeSide == .right ? self.frame.maxX + jumpLabel.frame.width :
                                                                                      self.frame.minY - jumpLabel.frame.width,
                                                     y: bottomYPosition)
                    
                    //animate the addition of jump label
                    UIView.animate(withDuration: 0.15, animations: {
                        //move jump label to the correct location
                        self.jumpLabel.frame.origin = CGPoint(x: self.jumpPressEdgeSide == .right ? self.frame.maxX - self.jumpLabel.frame.width :
                                                                                                    self.frame.minX,
                                                              y: bottomYPosition)
                    })
                    
                    //while the jump label present animation is running jump to the correct location
                    self.scrollToLabel(rect: firstRect(for: textRange!), animated: false)
                }
            }
        }
    }
    
    // PUBLIC FUNCTIONS
    /// This public function allows the user to set the attribute with which the JSTextView creates the labels
    public func appendToLabelArray<T:Equatable> (attributeName:NSAttributedStringKey, attributeValue:T)
    {
        //get the storage to be able to enumerate the attributed text within it
        let storage = self.textStorage
        
        //loop through all attributes and check if they contain the target attribute value
        storage.enumerateAttribute(attributeName, in: NSMakeRange(0, textStorage.length), options: [], using:
            {
                (value,range,stop) in

                //we need a special case for UIColor because of rounding error in RGB values
                if let colorValue = value as? UIColor, let colorAttributeValue = attributeValue as? UIColor
                {
                    for n in 0..<colorValue.cgColor.components!.count
                    {
                        //This might seem like a hack but its really just avoiding rounding error
                        if round(255 * colorValue.cgColor.components![n])
                           != round(255 * colorAttributeValue.cgColor.components![n])
                        {
                            return
                        }
                    }
                    
                    //if the loop goes to completion all RGB values are equal, add to array
                    if !jumpLabelArray.contains(range)
                    {
                        jumpLabelArray.append(range)
                    }
                }
                else if value as? T == attributeValue
                {
                    if !jumpLabelArray.contains(range)
                    {
                        jumpLabelArray.append(range)
                    }
                }
        })
        
        jumpLabelArray.sort(by: { $1.location > $0.location })
    }
    
    //GESTURE ACTION FUNCTIONS
    @objc func handleLongPressGesture(gesture: UILongPressGestureRecognizer)
    {
        //The x position is found relative to the JSTextView because we want to find the touch location regardless of the superview
        let xPosition = jumpingPress.location(in: self).x
        
        //The y position is found in the superview because the position of the touch relative to the JSTextView calculates in
        //regards to the content view of the textview (way too long)
        let yPosition = jumpingPress.location(in: superview).y - self.frame.minY
        
        // Check if touch is in hot zone and the jumping press state is began
        if jumpingPress.state == .began && xPosition >= self.frame.minX +
                                            (jumpPressEdgeSide == .right ?  self.frame.width * (1-jumpPressEdgePercentage) : 0)
                                        && xPosition <= self.frame.minX +
                                            (jumpPressEdgeSide == .right ? self.frame.width : self.frame.width * jumpPressEdgePercentage)
        {
            self.startedJumping = true
            self.showsVerticalScrollIndicator = self.showsIndicatorOnJump
            self.isUserInteractionEnabled = false //disable scrolling
            jumpToValueAt(yPosition: yPosition, begin: true)
        }
            
            //check if the jumping press state is changed
        else if startedJumping && jumpingPress.state == .changed
        {
            jumpToValueAt(yPosition: yPosition, begin: false)
        }
        
        //check if the jumping press state is ending
        else if jumpingPress.state == .ended || jumpingPress.state == .cancelled || jumpingPress.state == .failed
        {
            UIView.animate(withDuration: 0.15, delay: 0.0, options: [], animations: {
                self.jumpLabel.frame.origin = CGPoint(x: self.jumpPressEdgeSide == .right ? self.frame.maxX + self.jumpLabel.frame.width :
                                                                                           self.frame.minX - self.jumpLabel.frame.width,
                                                          y: yPosition +  self.frame.minY)
            }, completion: { //only remove the label once the animation finishes
                    (completed) in
                        if completed { self.jumpLabel.removeFromSuperview() }
            })
            
            //enable scrolling again
            self.isUserInteractionEnabled     = true
            startedJumping                    = false
            self.showsVerticalScrollIndicator = !showsIndicatorOnJump
        }
    }
    
}

//the extension which ensures that the gestures are recognized in the textview
extension JSTextView: UIGestureRecognizerDelegate
{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                             shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool
    {
        return true
    }
}

