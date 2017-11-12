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
    
  private let jumpingPress   = UILongPressGestureRecognizer()
  private var jumpLabelArray = [NSRange]()
  private var segmentLength  = CGFloat()
  
  //INITIALIZERS
    
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
    // Add Long press
    jumpingPress.addTarget(self, action: #selector(handleLongPressGesture))
    jumpingPress.cancelsTouchesInView = false
    jumpingPress.delegate = self
    self.addGestureRecognizer(jumpingPress)
  }
    
  private func createLabelArray<T:Equatable> (attributeName:NSAttributedStringKey, attributeValue:T)
  {
    let storage = self.textStorage
        
    storage.enumerateAttribute(attributeName, in: NSMakeRange(0, textStorage.length), options: [], using:
        {
            (value,range,stop) in
                if value as? T == attributeValue
                {
                    jumpLabelArray.append(range)
                }
        })
  }
  
  private func jumpToValueAt(yPosition:CGFloat)
  {
    let jumpIndex = Int(yPosition/segmentLength)
    
    if jumpIndex >= 0 && jumpIndex < jumpLabelArray.count
    {
        let startPosition = self.position(from: self.beginningOfDocument, offset: jumpLabelArray[jumpIndex].lowerBound)
        let endPosition   = self.position(from: self.beginningOfDocument, offset: jumpLabelArray[jumpIndex].upperBound)
        let textRange     = self.textRange(from: startPosition! , to: endPosition!)
        print("jumping to \(jumpIndex)")
        self.scrollRectToVisible(firstRect(for: textRange!), animated: false)
    }
  }
    
  // PUBLIC FUNCTIONS
    
  public func setLabelArray<T:Equatable> (attributeName:NSAttributedStringKey, attributeValue:T)
  {
    createLabelArray(attributeName: attributeName, attributeValue: attributeValue)
    
    if jumpLabelArray.count > 0
    {
        segmentLength = self.frame.height / CGFloat(jumpLabelArray.count)
    }
  }
    
  //GESTURE ACTION FUNCTIONS
    
  @objc func handleLongPressGesture(gesture: UILongPressGestureRecognizer)
  {
    let xPosition = jumpingPress.location(in: self).x
    let yPosition = jumpingPress.location(in: superview).y
    
    // Check if touch is in hot zone and the jumping press state is began
    if jumpingPress.state == .began && xPosition >= self.frame.width * 0.9 && xPosition <= self.frame.maxX
    {
      self.isUserInteractionEnabled = false
      jumpToValueAt(yPosition: yPosition)
    }
    
    //check if the jumping press state is changed
    else if jumpingPress.state == .changed
    {
      jumpToValueAt(yPosition: yPosition)
    }
    
    //check if the jumping press state is ending
    else if jumpingPress.state == .ended || jumpingPress.state == .cancelled || jumpingPress.state == .failed
    {
      self.isUserInteractionEnabled = true
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

extension UILabel
{
    func layoutLabelView(corners: UIRectCorner, radius:CGFloat)
    {
      
      // Apply corner radius for background fill only
      let cornerRadii = CGSize(width: radius, height: radius)
      let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: cornerRadii)
      
      let mask = CAShapeLayer()
      mask.path = path.cgPath
      
      layer.mask = mask
      
      // Apply shadow with rounded path
      layer.shadowColor = UIColor.black.cgColor
      layer.shadowOpacity = 0.30
      layer.shadowRadius = 2.0
      layer.shadowOffset = CGSize(width: 0.5, height: 2.0)
      layer.shadowPath = path.cgPath
      
    }
}

