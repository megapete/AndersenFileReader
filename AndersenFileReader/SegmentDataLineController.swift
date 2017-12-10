//
//  SegmentDataLineController.swift
//  AndersenFileReader
//
//  Created by Peter Huber on 2017-12-10.
//  Copyright © 2017 Peter Huber. All rights reserved.
//

import Cocoa

class SegmentDataLineController: NSViewController {

    @IBOutlet weak var segmentNumberFIeld: NSTextField!
    
    @IBOutlet weak var zMinField: NSTextField!
    @IBOutlet weak var zMaxField: NSTextField!
    
    @IBOutlet weak var totalTurnsField: NSTextField!
    @IBOutlet weak var activeTurnsFIeld: NSTextField!
    
    @IBOutlet weak var strandsPerTurnField: NSTextField!
    @IBOutlet weak var strandsPerLayerField: NSTextField!
    
    @IBOutlet weak var strandDimnRadialField: NSTextField!
    @IBOutlet weak var strandDimnAxialField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
