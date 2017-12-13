//
//  OutputDataLineController.swift
//  AndersenFileReader
//
//  Created by PeterCoolAssHuber on 2017-12-12.
//  Copyright © 2017 Peter Huber. All rights reserved.
//

import Cocoa

class OutputDataLineController: NSViewController {

    @IBOutlet weak var segmentNumberLabel: NSTextField!
    @IBOutlet weak var ampTurnsLabel: NSTextField!
    @IBOutlet weak var kVALabel: NSTextField!
    @IBOutlet weak var dcLossLabel: NSTextField!
    
    @IBOutlet weak var eddyLossAxialFluxLabel: NSTextField!
    @IBOutlet weak var eddyLossRadialFluxLabel: NSTextField!
    @IBOutlet weak var eddyLossPuAverageLabel: NSTextField!
    @IBOutlet weak var eddyLossPuMaxLabel: NSTextField!
    @IBOutlet weak var eddyLossPuMaxRectLabel: NSTextField!
    
    @IBOutlet weak var scTotalRadialLabel: NSTextField!
    @IBOutlet weak var scTotalAxialLabel: NSTextField!
    @IBOutlet weak var scMinRadialLabel: NSTextField!
    @IBOutlet weak var scMaxRadialLabel: NSTextField!
    @IBOutlet weak var scMaxAccumAxialLabel: NSTextField!
    @IBOutlet weak var scMaxPerVolAxialLabel: NSTextField!
    
    @IBOutlet weak var scRadialTensionCompLabel: NSTextField!
    @IBOutlet weak var minNumSpacerBarsLabel: NSTextField!
    @IBOutlet weak var axialForceInBlocksLabel: NSTextField!
    @IBOutlet weak var combinedForceLabel: NSTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
