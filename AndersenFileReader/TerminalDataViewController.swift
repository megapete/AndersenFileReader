//
//  TerminalDataViewController.swift
//  AndersenFileReader
//
//  Created by PeterCoolAssHuber on 2017-12-06.
//  Copyright © 2017 Peter Huber. All rights reserved.
//

import Cocoa

class TerminalDataViewController: NSViewController {

    
    
    func addTerminalLines(count:Int)
    {
        var topLevelObjects:NSArray?
        var lastFrame = NSRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0)
        
        for _ in 0..<count
        {
            if Bundle.main.loadNibNamed(NSNib.Name(rawValue: "TerminalDataLine"), owner: self, topLevelObjects: &topLevelObjects)
            {
                if let view = topLevelObjects!.first(where: { $0 is NSView }) as? NSView
                {
                    if lastFrame.height == 0.0
                    {
                        
                    }
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
