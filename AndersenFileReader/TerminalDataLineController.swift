//
//  TerminalDataLineController.swift
//  AndersenFileReader
//
//  Created by PeterCoolAssHuber on 2017-12-07.
//  Copyright © 2017 Peter Huber. All rights reserved.
//

import Cocoa

class TerminalDataLineController: NSViewController {

    @IBOutlet weak var termNumberField: NSTextField!
    
    @IBOutlet weak var wyeConnectionButton: NSButton!
    @IBOutlet weak var deltaConnectionButton: NSButton!
    
    @IBOutlet weak var mvaField: NSTextField!
    @IBOutlet weak var kvField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func handleConnectionButtons(_ sender: Any)
    {
    }
    
    
}
