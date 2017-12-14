//
//  SegmentDataController.swift
//  AndersenFileReader
//
//  Created by PeterCoolAssHuber on 2017-12-06.
//  Copyright © 2017 Peter Huber. All rights reserved.
//

import Cocoa



class SegmentDataController: NSViewController {

    @IBOutlet weak var theView: NSView!
    var segmentDataLines:[SegmentDataLineController] = []
    var segmentData:[PCH_FLD12_Segment]? = nil
    
    private var numLines = 0

    
    func handleUpdate(segmentData:[PCH_FLD12_Segment])
    {
        self.segmentDataLines = []
        self.segmentData = segmentData
        self.numLines = segmentData.count
        
        guard self.numLines > 0 else
        {
            return
        }
        
        if self.isViewLoaded
        {
            self.theView.subviews = []
            
            doAddSegmentLines(count: self.numLines)
            
            for i in 0..<self.numLines
            {
                self.setSegmentDataAtLine(i, data: segmentData[i])
            }
        }
    }
    
    private func setSegmentDataAtLine(_ line:Int, data:PCH_FLD12_Segment)
    {
        segmentDataLines[line].segmentNumberFIeld.stringValue = "\(data.segmentNumber)"
        segmentDataLines[line].zMinField.stringValue = "\(data.zMin)"
        segmentDataLines[line].zMaxField.stringValue = "\(data.zMax)"
        segmentDataLines[line].totalTurnsField.stringValue = "\(data.turns)"
        segmentDataLines[line].activeTurnsFIeld.stringValue = "\(data.activeTurns)"
        segmentDataLines[line].strandsPerTurnField.stringValue = "\(data.strandsPerTurn)"
        segmentDataLines[line].strandsPerLayerField.stringValue = "\(data.strandsPerLayer)"
        segmentDataLines[line].strandDimnAxialField.stringValue = "\(data.strandA)"
        segmentDataLines[line].strandDimnRadialField.stringValue = "\(data.strandR)"
    }
    
    
    func doAddSegmentLines(count:Int)
    {
        // var topLevelObjects:NSArray?
        // var lastFrame = NSRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0)
        var totalHeightRequired:CGFloat = 0.0
        
        var newController = SegmentDataLineController(nibName: nil, bundle: nil)
        
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
            segmentDataLines.append(newController)
            theView.addSubview(newController.view)
            
            let nextLineBottom = newController.view.frame.origin.y - yLineOffset
            
            newController = SegmentDataLineController(nibName: nil, bundle: nil)
            newController.view.frame.origin.y = nextLineBottom
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do view setup here.
        
        // self.viewIsValid = true
        
        if (self.numLines > 0)
        {
            doAddSegmentLines(count: self.numLines)
            
            guard let data = segmentData else
            {
                DLog("Segment data was not defined!")
                return
            }
            
            for i in 0..<self.numLines
            {
                self.setSegmentDataAtLine(i, data: data[i])
            }
            
        }
    }
    
}
