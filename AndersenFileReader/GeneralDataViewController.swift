//
//  GeneralDataViewController.swift
//  AndersenFileReader
//
//  Created by PeterCoolAssHuber on 2017-12-06.
//  Copyright © 2017 Peter Huber. All rights reserved.
//

import Cocoa

class GeneralDataViewController: NSViewController {

    @IBOutlet var idField: NSTextField!
    
    @IBOutlet var mmInputButton: NSButton!
    @IBOutlet var inchInputButton: NSButton!
    
    @IBOutlet var onePhaseButton: NSButton!
    @IBOutlet var threePhaseButton: NSButton!
    
    @IBOutlet var frequencyField: NSTextField!
    @IBOutlet var numWoundLimbsField: NSTextField!
    
    @IBOutlet var halfWindHtButton: NSButton!
    @IBOutlet var fullWindHttButton: NSButton!
    
    @IBOutlet var zLowerField: NSTextField!
    @IBOutlet var zUpperField: NSTextField!
    
    @IBOutlet var coreDiaField: NSTextField!
    
    @IBOutlet var tankDistanceField: NSTextField!
    
    @IBOutlet var alcuYesButton: NSButton!
    @IBOutlet var alcuNoButton: NSButton!
    
    @IBOutlet var sysGVAField: NSTextField!
    @IBOutlet var impedanceField: NSTextField!
    @IBOutlet var peakFactorField: NSTextField!
    
    @IBOutlet var numTerminalsField: NSTextField!
    @IBOutlet var numLayersField: NSTextField!
    
    @IBOutlet var offsetElongNoneButton: NSButton!
    @IBOutlet var offsetButton: NSButton!
    @IBOutlet var elongButton: NSButton!
    @IBOutlet var offsetElongAmountField: NSTextField!
    
    @IBOutlet var tankFactorField: NSTextField!
    @IBOutlet var legFactorField: NSTextField!
    @IBOutlet var yokeFactorField: NSTextField!
    
    @IBOutlet var scaleField: NSTextField!
    @IBOutlet var numFluxLinesField: NSTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    
    // These routine don't do anything, but are required to make radio button groups function properly
    
    @IBAction func handleOffsetElong(_ sender: NSButton)
    {
    }
    
    @IBAction func handleWindHtButton(_ sender: NSButton)
    {
    }
    
    @IBAction func handleNumPhases(_ sender: NSButton)
    {
    }
    
    @IBAction func handleInputUnits(_ sender: NSButton)
    {
    }
    
}
