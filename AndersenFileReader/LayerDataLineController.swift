//
//  LayerDataLineController.swift
//  AndersenFileReader
//
//  Created by Peter Huber on 2017-12-07.
//  Copyright © 2017 Peter Huber. All rights reserved.
//

import Cocoa

class LayerDataLineController: NSViewController {

    @IBOutlet var layerNumberField: NSTextField!
    @IBOutlet var lastSegmentField: NSTextField!
    @IBOutlet var innerRadiusField: NSTextField!
    @IBOutlet var radialBuildField: NSTextField!
    @IBOutlet var parentTerminalField: NSTextField!
    @IBOutlet var numSpBlkField: NSTextField!
    @IBOutlet var spBlkWidthField: NSTextField!
    
    @IBOutlet var oneParGroupButton: NSButton!
    @IBOutlet var twoParGroupButton: NSButton!
    
    @IBOutlet var plusCurrentButton: NSButton!
    @IBOutlet var minusCurrentButton: NSButton!
    
    @IBOutlet var cuButton: NSButton!
    @IBOutlet var alButton: NSButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func handleNumParGroups(_ sender: Any)
    {
    }
    
    @IBAction func handleCurrentDirection(_ sender: Any)
    {
    }
    
    @IBAction func handleConductor(_ sender: Any)
    {
    }
    
}
