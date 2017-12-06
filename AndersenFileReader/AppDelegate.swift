//
//  AppDelegate.swift
//  AndersenFileReader
//
//  Created by PeterCoolAssHuber on 2017-12-06.
//  Copyright © 2017 Peter Huber. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        /*
        let newInputFileVC = InputFileViewController(nibName: nil, bundle: nil)
        
        if let winView = window.contentView
        {
            winView.addSubview(newInputFileVC.view)
        }
        
        DLog("Finished successfully!")
         */
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

