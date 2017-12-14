//
//  LayerDataViewController.swift
//  AndersenFileReader
//
//  Created by PeterCoolAssHuber on 2017-12-06.
//  Copyright © 2017 Peter Huber. All rights reserved.
//

import Cocoa

class LayerDataViewController: NSViewController {

    @IBOutlet var theView: NSView!
    var layerDataLines:[LayerDataLineController] = []
    var layerData:[PCH_FLD12_Layer]? = nil
    
    private var numLines = 0
    
    
    func handleUpdate(layerData:[PCH_FLD12_Layer])
    {
        self.layerDataLines = []
        self.layerData = layerData
        self.numLines = layerData.count
        
        guard self.numLines > 0 else
        {
            return
        }
        
        if self.isViewLoaded
        {
            self.theView.subviews = []
            
            doAddLayerLines(count: self.numLines)
            
            for i in 0..<self.numLines
            {
                self.setLayerDataAtLine(i, data: layerData[i])
            }
        }
    }
    
    private func setLayerDataAtLine(_ line:Int, data:PCH_FLD12_Layer)
    {
        layerDataLines[line].layerNumberField.stringValue = "\(data.number)"
        layerDataLines[line].lastSegmentField.stringValue = "\(data.lastSegment)"
        layerDataLines[line].innerRadiusField.stringValue = "\(data.innerRadius)"
        layerDataLines[line].radialBuildField.stringValue = "\(data.radialBuild)"
        layerDataLines[line].parentTerminalField.stringValue = "\(data.terminal)"
        layerDataLines[line].numSpBlkField.stringValue = "\(data.numSpacerBlocks)"
        layerDataLines[line].spBlkWidthField.stringValue = "\(data.spBlkWidth)"
        
        if data.numParGroups == 1
        {
            layerDataLines[line].oneParGroupButton.state = .on
            layerDataLines[line].twoParGroupButton.state = .off
        }
        else if data.numParGroups == 2
        {
            layerDataLines[line].oneParGroupButton.state = .off
            layerDataLines[line].twoParGroupButton.state = .on
        }
        else
        {
            layerDataLines[line].oneParGroupButton.state = .off
            layerDataLines[line].twoParGroupButton.state = .off
        }
        
        if data.currentDirection > 0
        {
            layerDataLines[line].plusCurrentButton.state = .on
            layerDataLines[line].minusCurrentButton.state = .off
        }
        else if data.currentDirection < 0
        {
            layerDataLines[line].plusCurrentButton.state = .off
            layerDataLines[line].minusCurrentButton.state = .on
        }
        else
        {
            layerDataLines[line].plusCurrentButton.state = .off
            layerDataLines[line].minusCurrentButton.state = .off
        }
        
        if data.cuOrAl == 1
        {
            layerDataLines[line].cuButton.state = .on
            layerDataLines[line].alButton.state = .off
        }
        else if data.cuOrAl == 2
        {
            layerDataLines[line].cuButton.state = .off
            layerDataLines[line].alButton.state = .on
        }
        else
        {
            layerDataLines[line].cuButton.state = .off
            layerDataLines[line].alButton.state = .off
        }
        
    }
    
    func doAddLayerLines(count:Int)
    {
        // var topLevelObjects:NSArray?
        // var lastFrame = NSRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0)
        var totalHeightRequired:CGFloat = 0.0
        
        var newController = LayerDataLineController(nibName: nil, bundle: nil)
        
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
            layerDataLines.append(newController)
            theView.addSubview(newController.view)
            
            let nextLineBottom = newController.view.frame.origin.y - yLineOffset
            
            newController = LayerDataLineController(nibName: nil, bundle: nil)
            newController.view.frame.origin.y = nextLineBottom
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do view setup here.
        
        if (self.numLines > 0)
        {
            doAddLayerLines(count: self.numLines)
            
            guard let data = layerData else
            {
                DLog("Segment data was not defined!")
                return
            }
            
            for i in 0..<self.numLines
            {
                self.setLayerDataAtLine(i, data: data[i])
            }
            
        }
    }
    
}
