//
//  AppController.swift
//  AndersenFileReader
//
//  Created by Peter Huber on 2017-12-06.
//  Copyright © 2017 Peter Huber. All rights reserved.
//

import Cocoa

class AppController: NSObject, NSOpenSavePanelDelegate
{
    // A reference to the main window (so we don't need to make any cross-references to the app delegate)
    @IBOutlet weak var window: NSWindow!
    
    @IBOutlet weak var saveInputFileItem: NSMenuItem!
    
    // Variable used to hold the current openPanel so the delegate routine can respond correctly
    var openPanel:NSOpenPanel? = nil
    var currentMainWindowViewController:InputFileViewController? = nil
    
    var currentTransformer:PCH_FLD12_TxfoDetails? = nil
    var currentFileName:String? = nil
    
    @IBAction func handleSaveFLD12InputFile(_ sender: Any)
    {
        let savePanel = NSSavePanel()
        
        savePanel.message = "Save FLD12 Input File"
        savePanel.canCreateDirectories = true
        savePanel.allowedFileTypes = ["public.text"]
        
        if savePanel.runModal() == .OK
        {
            let fileString = PCH_FLD12_Library.createFLD12InputFile(withTxfo: self.currentTransformer!)
            
            guard let fileURL = savePanel.url else
            {
                DLog("URL not returned!")
                
                ShowSimpleCriticalPanelWithString("A serious error occurred (could not get file URL).")
                
                return
            }
            
            do
            {
                try fileString.write(to: fileURL, atomically: false, encoding: .utf8)
            }
            catch
            {
                DLog("Could not create input file!")
                ShowSimpleCriticalPanelWithString("Could not create input file!")
                return
            }
        }
    }
    
    // take care of enabling menu items here
    override func validateMenuItem(_ menuItem: NSMenuItem) -> Bool
    {
        if menuItem == self.saveInputFileItem
        {
            return currentTransformer != nil
        }
        
        return true
    }
    
    
    @IBAction func handleOpenFLD12OutputFile(_ sender: Any)
    {
        self.openPanel = NSOpenPanel()
        
        guard let openPanel = self.openPanel else
        {
            return
        }
        
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseFiles = true
        openPanel.canChooseDirectories = false
        openPanel.message = "Open FLD12 Output File"
        openPanel.delegate = self
        openPanel.validateVisibleColumns()
        
        if openPanel.runModal() == .OK
        {
            guard let fileURL = openPanel.url else
            {
                DLog("URL not returned!")
                
                ShowSimpleCriticalPanelWithString("A serious error occurred (could not get file URL).")
                
                self.openPanel = nil
                return
            }
            
            var outputFileAsString:String = ""
            
            do
            {
                outputFileAsString = try String(contentsOfFile:fileURL.path, encoding:String.Encoding.utf8)
            }
            catch
            {
                // this shouldn't happen, since our filter has already confirmed that this is a text file
                DLog("Could not convert file")
                self.openPanel = nil
                return
            }
            
            guard let outputData = PCH_FLD12_OutputData(outputFile: outputFileAsString) else
            {
                DLog("Bad file format")
                
                ShowSimpleCriticalPanelWithString("A serious error occurred (the choice is not a valid FLD12 output file).")
                
                self.openPanel = nil
                return
            }
            
            // we only need a new InputFileViewController if there isn't already one
            var inputSubView = currentMainWindowViewController
            
            if inputSubView == nil
            {
                inputSubView = InputFileViewController(intoWindow: self.window)
                currentMainWindowViewController = inputSubView
            }
            
            let outputVC = inputSubView!
            
            ShowDetailsForTxfo(txfo: outputData.inputData!, controller: outputVC)
            
            let outputDataController = OutputDataController(nibName: nil, bundle: nil)
            
            let outputTabItem = NSTabViewItem(viewController: outputDataController)
            outputTabItem.label = "Output"
            
            if let tabView = outputVC.tabView
            {
                tabView.addTabViewItem(outputTabItem)
            }
            
            guard let segmentsAsData = outputData.segmentData as? [Data] else
            {
                DLog("Could not get segments as Data")
                
                ShowSimpleCriticalPanelWithString("A serious error occurred (could not read array as Data).")
                
                self.openPanel = nil
                return
            }
            
            // So this is the method I came up with to convert back the NSArray of SegmentData structs that I had to convert to NSData objects in the library (whew!). It's really ugly and I could probably do something a bit more efficient, but this seems to work.
            var segmentArray:[SegmentData] = []
            // we need to use stride because that is the memory "distance" between instances in an array (which is what we have in this case). The actual size of the struct is MemoryLayout<SegmentData>.size
            let segmentDataStride = MemoryLayout<SegmentData>.stride
            
            for nextData in segmentsAsData
            {
                let segmentPtr = UnsafeMutablePointer<SegmentData>.allocate(capacity: 1)
                let segmentBuffer = UnsafeMutableBufferPointer(start: segmentPtr, count: 1)
                let numBytes = nextData.copyBytes(to: segmentBuffer)
                
                if numBytes != segmentDataStride
                {
                    DLog("Stride: \(segmentDataStride); Bytes Transferred: \(numBytes)")
                    
                    ShowSimpleCriticalPanelWithString("A serious error occurred (data size does not match required size).")
                    
                    self.openPanel = nil
                    return
                }
                
                segmentArray.append(segmentBuffer[0])
                
                // since we allocated the memory for the pointer, we are responsible to deallocate it as well
                segmentPtr.deallocate(capacity: 1)
            }
            
            outputDataController.handleUpdate(segmentData: segmentArray)
            
            self.currentFileName = fileURL.deletingPathExtension().lastPathComponent
            self.currentTransformer = outputData.inputData
        }
        
        self.openPanel = nil
    }
    
    
    @IBAction func handleOpenFLD12InputFile(_ sender: Any)
    {
        self.openPanel = NSOpenPanel()
        
        guard let openPanel = self.openPanel else
        {
            return
        }
        
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseFiles = true
        openPanel.canChooseDirectories = false
        openPanel.message = "Open FLD12 Input File"
        openPanel.delegate = self
        openPanel.validateVisibleColumns()
        
        if openPanel.runModal() == .OK
        {
            guard let fileURL = openPanel.url else
            {
                DLog("URL not returned!")
                
                ShowSimpleCriticalPanelWithString("A serious error occurred (could not get file URL).")
                
                self.openPanel = nil
                return
            }
            
            guard let txfo = PCH_FLD12_TxfoDetails(url: fileURL) else
            {
                DLog("File is not in the required FLD12 format!")
                
                ShowSimpleCriticalPanelWithString("A serious error occurred (the choice is not a valid FLD12 input file).")
                
                self.openPanel = nil
                return
            }
            
            // we only need a new InputFileViewController if there isn't already one
            var inputSubView = currentMainWindowViewController
            
            if inputSubView == nil
            {
                inputSubView = InputFileViewController(intoWindow: self.window)
                currentMainWindowViewController = inputSubView
            }
            else
            {
                // remove the Output tab, if it's there
                if let tabView = inputSubView!.tabView
                {
                    if tabView.numberOfTabViewItems > PCH_INPUT_SEGMENTS_TAB + 1
                    {
                        tabView.removeTabViewItem(tabView.tabViewItem(at: PCH_INPUT_SEGMENTS_TAB + 1))
                    }
                }
            }
            
            ShowDetailsForTxfo(txfo: txfo, controller: inputSubView!)
            
            self.currentFileName = fileURL.deletingPathExtension().lastPathComponent
            self.currentTransformer = txfo
            
        } // end if openPanel
        
        self.openPanel = nil
    }
    
    func ShowSimpleWarningPanelWithString(_ wString:String)
    {
        let theAlert = NSAlert()
        theAlert.alertStyle = .warning
        theAlert.informativeText = wString
        theAlert.addButton(withTitle: "Ok")
        
        theAlert.runModal()
    }
    
    func ShowSimpleCriticalPanelWithString(_ wString:String)
    {
        let theAlert = NSAlert()
        theAlert.alertStyle = .critical
        theAlert.informativeText = wString
        theAlert.addButton(withTitle: "Ok")
        
        theAlert.runModal()
    }
    
    // This routine returns the number of segments in the model, which is not easily retrieved from the PCH_FLD12_TxfoDetails
    func ShowDetailsForTxfo(txfo:PCH_FLD12_TxfoDetails, controller:InputFileViewController)
    {
        guard let generalVC = controller.generalDataController else
        {
            DLog("Could not access General Data View")
            
            ShowSimpleCriticalPanelWithString("A serious error occurred (could not access General Data View).")
            
            return
        }
        
        generalVC.idField.stringValue = txfo.identification
        
        if (txfo.inputUnits == 1)
        {
            generalVC.mmInputButton.state = .on
            generalVC.inchInputButton.state = .off
        }
        else if (txfo.inputUnits == 2)
        {
            generalVC.mmInputButton.state = .off
            generalVC.inchInputButton.state = .on
        }
        else
        {
            DLog("An illegal input unit was encountered - ignoring!")
            
            ShowSimpleWarningPanelWithString("An illegal input unit was encountered - ignoring.")
            
            generalVC.mmInputButton.state = .off
            generalVC.inchInputButton.state = .off
        }
        
        if txfo.numPhases == 1
        {
            generalVC.onePhaseButton.state = .on
            generalVC.threePhaseButton.state = .off
        }
        else if txfo.numPhases == 3
        {
            generalVC.onePhaseButton.state = .off
            generalVC.threePhaseButton.state = .on
        }
        else
        {
            DLog("We only build single- and three-phase transformers - ignoring!")
            
            ShowSimpleWarningPanelWithString("We only build single- and three-phase transformers - ignoring number of phases!")
            
            generalVC.onePhaseButton.state = .off
            generalVC.threePhaseButton.state = .off
        }
        
        generalVC.frequencyField.stringValue = "\(txfo.frequency)"
        generalVC.numWoundLimbsField.stringValue = "\(txfo.numberOfWoundLimbs)"
        generalVC.fullWindHttButton.state = .on
        generalVC.zLowerField.stringValue = "\(txfo.lowerZ)"
        generalVC.zUpperField.stringValue = "\(txfo.upperZ)"
        generalVC.coreDiaField.stringValue = "\(txfo.coreDiameter)"
        generalVC.tankDistanceField.stringValue = "\(txfo.distanceToTank)"
        
        if (txfo.alcuShield == 0)
        {
            generalVC.alcuNoButton.state = .on
            generalVC.alcuYesButton.state = .off
        }
        else
        {
            generalVC.alcuNoButton.state = .off
            generalVC.alcuYesButton.state = .on
        }
        
        generalVC.sysGVAField.stringValue = "\(txfo.sysSCgva)"
        generalVC.impedanceField.stringValue = "\(txfo.puImpedance)"
        generalVC.peakFactorField.stringValue = "\(txfo.peakFactor)"
        generalVC.numTerminalsField.stringValue = "\(txfo.numTerminals)"
        generalVC.numLayersField.stringValue = "\(txfo.numLayers)"
        
        if (txfo.dispElon == 0)
        {
            generalVC.offsetElongNoneButton.state = .on
            generalVC.offsetButton.state = .off
            generalVC.elongButton.state = .off
        }
        else if (txfo.dispElon == 1)
        {
            generalVC.offsetElongNoneButton.state = .off
            generalVC.offsetButton.state = .on
            generalVC.elongButton.state = .off
        }
        else if (txfo.dispElon == 2)
        {
            generalVC.offsetElongNoneButton.state = .off
            generalVC.offsetButton.state = .off
            generalVC.elongButton.state = .on
        }
        else
        {
            DLog("Illegal value for offset/elongation - setting to none")
            
            ShowSimpleWarningPanelWithString("Illegal value for offset/elongation - setting to none")
            
            generalVC.offsetElongNoneButton.state = .on
            generalVC.offsetButton.state = .off
            generalVC.elongButton.state = .off
        }
        
        if (generalVC.offsetElongNoneButton.state == .on)
        {
            generalVC.offsetElongAmountField.stringValue = ""
        }
        else
        {
            generalVC.offsetElongAmountField.stringValue = "\(txfo.deAmount)"
        }
        
        generalVC.tankFactorField.stringValue = "\(txfo.tankFactor)"
        generalVC.legFactorField.stringValue = "\(txfo.legFactor)"
        generalVC.yokeFactorField.stringValue = "\(txfo.yokeFactor)"
        generalVC.scaleField.stringValue = "\(txfo.scale)"
        generalVC.numFluxLinesField.stringValue = "\(txfo.numFluxLines)"
        
        // Now terminals
        guard let terminalVC = controller.terminalDataController else
        {
            DLog("Could not access Terminals Data View")
            
            ShowSimpleCriticalPanelWithString("A serious error occurred (could not access Terminal Data View).")
            
            return
        }
        
        guard txfo.numTerminals > 0 else
        {
            DLog("Illegal terminal count!")
            
            ShowSimpleCriticalPanelWithString("A serious error occurred (illegal terminal count of \(txfo.numTerminals) in file).")
            
            return
        }
        
        
        guard let terminalArray = txfo.terminals as? [PCH_FLD12_Terminal] else
        {
            DLog("Problem with terminal array")
            
            ShowSimpleCriticalPanelWithString("A serious error occurred (could not read terminal array).")
            
            return
        }
        
        terminalVC.handleUpdate(terminalData: terminalArray)
        
        
        // Layers
        guard let layerVC = controller.layerDataController else
        {
            DLog("Could not access Layers Data View")
            
            ShowSimpleCriticalPanelWithString("A serious error occurred (could not access Layer Data View).")
            
            return
        }
        
        guard txfo.numLayers > 0 else
        {
            DLog("Illegal layer count!")
            
            ShowSimpleCriticalPanelWithString("A serious error occurred (illegal layer count of \(txfo.numLayers) in file).")
            
            return
        }
        
        // layerVC.addLayerLines(count: Int(txfo.numLayers))
        
        guard let layerArray = txfo.layers as? [PCH_FLD12_Layer] else
        {
            DLog("Problem with layer array")
            
            ShowSimpleCriticalPanelWithString("A serious error occurred (could not read layer array).")
            
            return
        }
        
        layerVC.handleUpdate(layerData: layerArray)
        
        // we'll loop through the layers and grab the segments
        var segmentArray:[PCH_FLD12_Segment] = []
        
        for nextLayer in layerArray
        {
            if let layerSegments = nextLayer.segments as? [PCH_FLD12_Segment]
            {
                segmentArray.append(contentsOf: layerSegments)
            }
            else
            {
                DLog("Problem with segment array")
                
                ShowSimpleCriticalPanelWithString("A serious error occurred (could not read segment array for layer \(nextLayer.number).")
                
                return
            }
        }
        
        // And finally, segments
        guard let segmentVC = controller.segmentDataController else
        {
            DLog("Could not access Segments Data View")
            
            ShowSimpleCriticalPanelWithString("A serious error occurred (could not access Segment Data View).")
            
            return
        }
        
        guard segmentArray.count >= layerArray.count else
        {
            DLog("Illegal segment count!")
            
            ShowSimpleCriticalPanelWithString("A serious error occurred (illegal segment count of \(segmentArray.count) in file).")
            
            return
        }
        
        segmentVC.handleUpdate(segmentData: segmentArray)
        
    }
    
    
    // Delegate method to allow the program to choose ANY text file as input
    func panel(_ sender: Any, shouldEnable url: URL) -> Bool
    {
        // Always enable directories so that the user can actually go into them
        if url.hasDirectoryPath
        {
            return true
        }
        
        // We only scan if the sender is actually the currently visible Open Panel. I don't know if this is really required or not.
        if (self.openPanel?.isEqual(sender))!
        {
            do
            {
                let sharedWs = NSWorkspace.shared
                let uti = try sharedWs.type(ofFile: url.path)
                
                // Start out the easy way and hope that the file bing scanned conforms to the "public.text" UTI
                if sharedWs.type(uti, conformsToType: "public.text")
                {
                    return true
                }
                
                // The AndersenFE program defaults to the extension .inp for its input files
                if url.pathExtension == "inp"
                {
                    // DLog("Got a .imp")
                    return true
                }
            }
            catch
            {
                return false
            }
            
            do
            {
                // We get here if the UTI of the file did not conform to public.text -  most probably this will be called a hell of a lot. Note that this will only work if App Sanbox is set to NO in the .entitlements file.
                let _ = try String(contentsOfFile:url.path, encoding:String.Encoding.utf8)
            }
            catch
            {
                return false
            }
            
            return true
        }
        
        return false
    }
    
}
