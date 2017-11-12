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
  // PRIVATE VARIABLES
  let jumpingPan: UIPanGestureRecognizer
  let jumpingPress: UILongPressGestureRecognizer
  
  // Pan Active Bool
  var panActive: Bool
  
  required init?(coder aDecoder: NSCoder)
  {
    jumpingPan = UIPanGestureRecognizer()
    jumpingPress = UILongPressGestureRecognizer()
    panActive = false
    super.init(coder: aDecoder)
    startUp()
  }
  
  override init(frame: CGRect, textContainer: NSTextContainer?)
  {
    jumpingPan = UIPanGestureRecognizer()
    jumpingPress = UILongPressGestureRecognizer()
    panActive = false
    super.init(frame: frame, textContainer: textContainer)
    startUp()
  }
  
  //PRIVATE FUNCTIONS
  private func startUp()
  {
    // Set up and add pan and press gesture rec.
    self.isSelectable = false
    // Long press
    jumpingPress.addTarget(self, action: #selector(handleLongPressGesture))
    jumpingPress.cancelsTouchesInView = false
    jumpingPress.delegate = self
    self.addGestureRecognizer(jumpingPress)
    
    // Pan
    jumpingPan.addTarget(self, action: #selector(handlePanGesture))
    jumpingPan.delegate = self
    self.addGestureRecognizer(jumpingPan)
    
    // Set enabled to false until long press activates it
    //self.jumpingPan.isEnabled = false
    
    
  }
  @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
    // Perform pan
    
    if panActive
    {
      print("Panning")

    }
    
    if jumpingPan.state == .ended || jumpingPan.state == .cancelled || jumpingPan.state == .failed {
      print("Pan and Press ended")
      self.isScrollEnabled  = true
      self.jumpingPress.isEnabled = true
      panActive = false
    }
    
  }
  
  @objc func handleLongPressGesture(gesture: UILongPressGestureRecognizer) {
    let loc = jumpingPress.location(in: self)
    
    // Create hotZone
    let hotZone = CGRect(x: self.frame.width-self.frame.width/10, y: 0, width: self.frame.width/10, height: self.frame.height)
    
    // Check if touch is in hot zone
    if hotZone.contains(loc) {
      print("Go for pan")
      self.isScrollEnabled  = false
      self.jumpingPress.isEnabled = false
      panActive = true
    }
    
  }
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    //print("MOVED")
  }
  
  
}
extension JSTextView: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
}

