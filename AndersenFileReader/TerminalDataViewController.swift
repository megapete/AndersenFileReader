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
    
    func addTerminalLines(count:Int)
    {
        var topLevelObjects:NSArray?
        var lastFrame = NSRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0)
        var totalHeightRequired:CGFloat = 0.0
        
        // This logic comes from my ImpulseModeler program (I don't actually understand it)
        if Bundle.main.loadNibNamed(NSNib.Name(rawValue: "TerminalDataLine"), owner: self, topLevelObjects: &topLevelObjects)
        {
            if let view = topLevelObjects!.first(where: { $0 is NSView }) as? NSView
            {
                totalHeightRequired = CGFloat(count) * view.frame.height
                
                let scrollView = theView.superview!
                
                if (scrollView.frame.height < totalHeightRequired)
                {
                    let yOffset = totalHeightRequired - scrollView.frame.height
                    
                    let newFrame = NSRect(x: scrollView.frame.origin.x, y: scrollView.frame.origin.y - yOffset, width: scrollView.frame.width, height: totalHeightRequired)
                    
                    theView.frame = newFrame
                }
            }
        }
        
        for _ in 0..<count
        {
            if Bundle.main.loadNibNamed(NSNib.Name(rawValue: "TerminalDataLine"), owner: self, topLevelObjects: &topLevelObjects)
            {
                if let view = topLevelObjects!.first(where: { $0 is NSView }) as? NSView
                {
                    if lastFrame.height != 0.0
                    {
                        view.frame = lastFrame.offsetBy(dx: 0.0, dy: lastFrame.height)
                    }
                    
                    theView.addSubview(view)
                    lastFrame = view.frame
                }
            }
        }
        
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do view setup here.
        
        
    }
    
}
