//
//  InputFileViewController.swift
//  AndersenFileReader
//
//  Created by PeterCoolAssHuber on 2017-12-06.
//  Copyright © 2017 Peter Huber. All rights reserved.
//

import Cocoa

// constants for input file views
let PCH_INPUT_GENERAL_TAB = 0
let PCH_INPUT_TERMINALS_TAB = 1
let PCH_INPUT_LAYERS_TAB = 2
let PCH_INPUT_SEGMENTS_TAB = 3


class InputFileViewController: NSViewController {

    var tabView:NSTabView? = nil
    var generalDataController:GeneralDataViewController? = nil
    var terminalDataController:TerminalDataViewController? = nil
    var layerDataController:LayerDataViewController? = nil
    var segmentDataController:SegmentDataController? = nil
    
    // Initializer to stick the new input file view right into a window
    convenience init(intoWindow:NSWindow)
    {
        if !intoWindow.isVisible
        {
            intoWindow.makeKeyAndOrderFront(nil)
        }
        
        // DLog("Is the window visible: \(intoWindow.isVisible)")
        self.init(nibName: nil, bundle: nil)
        
        if let winView = intoWindow.contentView
        {
            if winView.subviews.count > 0
            {
                // DLog("Window already has subview! Removing...")
                winView.subviews = []
            }
            
            winView.addSubview(self.view)
        }
    }
    
    override func viewWillAppear()
    {
        // make the view take up the entire bounds of its parent
        self.view.frame = self.view.superview!.bounds
        
        // get the actual tab view
        self.tabView = self.view.subviews[0] as? NSTabView
        
        guard let tabView = self.tabView else
        {
            ALog("No tab view found!")
            return
        }
        
        self.generalDataController = GeneralDataViewController(nibName: nil, bundle: nil)
        let generalTab = tabView.tabViewItem(at: PCH_INPUT_GENERAL_TAB)
        generalTab.view = self.generalDataController!.view
        
        self.terminalDataController = TerminalDataViewController(nibName: nil, bundle: nil)
        let terminalTab = tabView.tabViewItem(at: PCH_INPUT_TERMINALS_TAB)
        terminalTab.view = self.terminalDataController!.view
        
        self.layerDataController = LayerDataViewController(nibName: nil, bundle: nil)
        let layerTab = tabView.tabViewItem(at: PCH_INPUT_LAYERS_TAB)
        layerTab.view = self.layerDataController!.view
        
        self.segmentDataController = SegmentDataController(nibName: nil, bundle: nil)
        let segmentTab = tabView.tabViewItem(at: PCH_INPUT_SEGMENTS_TAB)
        segmentTab.view = self.segmentDataController!.view
        
        // DLog("Index of General Tab: \(genIndex)")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
