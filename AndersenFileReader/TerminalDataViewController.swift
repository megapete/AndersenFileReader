//
//  TerminalDataViewController.swift
//  AndersenFileReader
//
//  Created by PeterCoolAssHuber on 2017-12-06.
//  Copyright © 2017 Peter Huber. All rights reserved.
//

import Cocoa

class TerminalDataViewController: NSViewController {

    @IBOutlet var theView: NSView!
    var termDataLines:[TerminalDataLineController]?
    
    func addTerminalLines(count:Int)
    {
        // var topLevelObjects:NSArray?
        // var lastFrame = NSRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0)
        var totalHeightRequired:CGFloat = 0.0
        
        var newController = TerminalDataLineController(nibName: nil, bundle: nil)
        termDataLines = [newController]
        
        // This logic comes from my ImpulseModeler program (I don't actually understand it)
        
        let view = newController.view
        
        totalHeightRequired = CGFloat(count) * view.frame.height + 20.0
        
        let scrollView = theView.superview!
        
        if (scrollView.frame.height < totalHeightRequired)
        {
            let yOffset = totalHeightRequired - scrollView.frame.height
            
            let newFrame = NSRect(x: scrollView.frame.origin.x, y: scrollView.frame.origin.y - yOffset, width: scrollView.frame.width, height: totalHeightRequired)
            
            theView.frame = newFrame
        }
        
        let yLineOffset = newController.view.frame.height
        
        for _ in 0..<count
        {
            theView.addSubview(newController.view)
            
            let oldViewBottom = newController.view.frame.origin.y + yLineOffset
            
            newController = TerminalDataLineController(nibName: nil, bundle: nil)
            newController.view.frame.origin.y = oldViewBottom
        }
        
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do view setup here.
        
        
    }
    
}
