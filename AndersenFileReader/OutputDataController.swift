//
//  OutputDataController.swift
//  AndersenFileReader
//
//  Created by Peter Huber on 2017-12-11.
//  Copyright © 2017 Peter Huber. All rights reserved.
//

import Cocoa

class OutputDataController: NSViewController {

    @IBOutlet var theView: NSView!
    var outputDataLines:[OutputDataLineController] = []
    
    private var numLines = 0
    
    // Since this controller is added programmatically, we need to do some fancier footwork than the other tab views. NSViewController loads the view lazily, so unless the view is actually loaded, we defer actually adding the data lines until the viewDidLoad() call.
    func addOutputLines(count: Int)
    {
        if self.isViewLoaded
        {
            self.doAddOutputLines(count: count)
        }
        
        numLines = count
    }
    
    private func doAddOutputLines(count:Int)
    {
        // var topLevelObjects:NSArray?
        // var lastFrame = NSRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0)
        var totalHeightRequired:CGFloat = 0.0
        
        var newController = OutputDataLineController(nibName: nil, bundle: nil)
        
        // This logic comes from my ImpulseModeler program. Don't forget that on MacOS, the origin is in the BOTTOM-left corner.
        
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
        newController.view.frame.origin.y = /* theView.frame.origin.y + */ theView.frame.height - yLineOffset
        
        // DLog("scrollView.frame: \(scrollView.frame); theView.frame: \(theView.frame); line.frame: \(newController.view.frame)")
        
        for _ in 0..<count
        {
            outputDataLines.append(newController)
            theView.addSubview(newController.view)
            
            let nextLineBottom = newController.view.frame.origin.y - yLineOffset
            
            newController = OutputDataLineController(nibName: nil, bundle: nil)
            newController.view.frame.origin.y = nextLineBottom
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        DLog("Output view did load")
        
        if (self.numLines > 0)
        {
            doAddOutputLines(count: self.numLines)
        }
    }
    
}
