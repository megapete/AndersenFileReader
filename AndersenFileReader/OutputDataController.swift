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
    var outputDataSegments:[SegmentData]? = nil
    
    private var numLines = 0
    
    func handleUpdate(segmentData:[SegmentData])
    {
        self.outputDataLines = []
        self.outputDataSegments = segmentData
        self.numLines = segmentData.count
        
        guard self.numLines > 0 else
        {
            return
        }
        
        if self.isViewLoaded
        {
            self.theView.subviews = []
            
            doAddOutputLines(count: self.numLines)
            
            for i in 0..<self.numLines
            {
                self.setOutputDataAtLine(i, data: segmentData[i])
            }
        }
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
    
    
    private func setOutputDataAtLine(_ line:Int, data:SegmentData)
    {
        outputDataLines[line].segmentNumberLabel.stringValue = "\(data.number)"
        outputDataLines[line].ampTurnsLabel.stringValue = "\(data.ampTurns)"
        outputDataLines[line].kVALabel.stringValue = "\(data.kVA)"
        outputDataLines[line].dcLossLabel.stringValue = "\(data.dcLoss)"
        outputDataLines[line].eddyLossAxialFluxLabel.stringValue = "\(data.eddyLossAxialFlux)"
        outputDataLines[line].eddyLossRadialFluxLabel.stringValue = "\(data.eddyLossRadialFlux)"
        outputDataLines[line].eddyLossPuAverageLabel.stringValue = "\(data.eddyPUaverage)"
        outputDataLines[line].eddyLossPuMaxLabel.stringValue = "\(data.eddyPUmax)"
        outputDataLines[line].eddyLossPuMaxRectLabel.stringValue = "(\(data.eddyMaxRect.origin.x), \(data.eddyMaxRect.origin.y)) - (\(data.eddyMaxRect.origin.x + data.eddyMaxRect.width), \(data.eddyMaxRect.origin.y + data.eddyMaxRect.height))"
        outputDataLines[line].scTotalRadialLabel.stringValue = "\(data.scForceTotalRadial)"
        outputDataLines[line].scTotalAxialLabel.stringValue = "\(data.scForceTotalAxial)"
        outputDataLines[line].scMinRadialLabel.stringValue = "\(data.scMinRadially)"
        outputDataLines[line].scMaxRadialLabel.stringValue = "\(data.scMaxRadially)"
        outputDataLines[line].scMaxAccumAxialLabel.stringValue = "\(data.scMaxAccumAxially)"
        outputDataLines[line].scMaxPerVolAxialLabel.stringValue = "\(data.scAxially)"
        outputDataLines[line].scRadialTensionCompLabel.stringValue = "\(data.scMaxTensionCompression)"
        outputDataLines[line].minNumSpacerBarsLabel.stringValue = "\(data.scMinSpacerBars)"
        outputDataLines[line].axialForceInBlocksLabel.stringValue = "\(data.scForceInSpacerBlocks)"
        outputDataLines[line].combinedForceLabel.stringValue = "\(data.scCombinedForce)"
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do view setup here.
                
        if (self.numLines > 0)
        {
            doAddOutputLines(count: self.numLines)
            
            guard let data = outputDataSegments else
            {
                DLog("Data segments were not defined!")
                return
            }
            
            for i in 0..<self.numLines
            {
                self.setOutputDataAtLine(i, data: data[i])
            }
            
        }
    }
    
}
