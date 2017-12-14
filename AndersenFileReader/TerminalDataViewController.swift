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
    var termDataLines:[TerminalDataLineController] = []
    var terminalData:[PCH_FLD12_Terminal]? = nil
    
    private var numLines = 0
    
    
    func handleUpdate(terminalData:[PCH_FLD12_Terminal])
    {
        self.termDataLines = []
        self.terminalData = terminalData
        self.numLines = terminalData.count
        
        guard self.numLines > 0 else
        {
            return
        }
        
        if self.isViewLoaded
        {
            self.theView.subviews = []
            
            doAddTerminalLines(count: self.numLines)
            
            for i in 0..<self.numLines
            {
                self.setTerminalDataAtLine(i, data: terminalData[i])
            }
        }
    }
    
    private func setTerminalDataAtLine(_ line:Int, data:PCH_FLD12_Terminal)
    {
        termDataLines[line].termNumberField.stringValue = "\(data.number)"
        termDataLines[line].mvaField.stringValue = "\(data.mva)"
        termDataLines[line].kvField.stringValue = "\(data.kv)"
        
        if data.connection == 1
        {
            termDataLines[line].wyeConnectionButton.state = .on
            termDataLines[line].deltaConnectionButton.state = .off
        }
        else if data.connection == 2
        {
            termDataLines[line].wyeConnectionButton.state = .off
            termDataLines[line].deltaConnectionButton.state = .on
        }
        else
        {
            termDataLines[line].wyeConnectionButton.state = .off
            termDataLines[line].deltaConnectionButton.state = .off
        }
    }
    
    func doAddTerminalLines(count:Int)
    {
        // var topLevelObjects:NSArray?
        // var lastFrame = NSRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0)
        var totalHeightRequired:CGFloat = 0.0
        
        var newController = TerminalDataLineController(nibName: nil, bundle: nil)
        
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
            termDataLines.append(newController)
            theView.addSubview(newController.view)
            
            let nextLineBottom = newController.view.frame.origin.y - yLineOffset
            
            newController = TerminalDataLineController(nibName: nil, bundle: nil)
            newController.view.frame.origin.y = nextLineBottom
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do view setup here.
        
        if (self.numLines > 0)
        {
            doAddTerminalLines(count: self.numLines)
            
            guard let data = terminalData else
            {
                DLog("Terminal data was not defined!")
                return
            }
            
            for i in 0..<self.numLines
            {
                self.setTerminalDataAtLine(i, data: data[i])
            }
            
        }
    }
    
}
