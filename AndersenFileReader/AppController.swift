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
    
    // Variable used to hold the current openPanel so the delegate routine can respond correctly
    var openPanel:NSOpenPanel? = nil
    // var currentMainWindowViewController:NSViewController? = nil
    
    
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
                self.openPanel = nil
                return
            }
            
            let outputVC = InputFileViewController(intoWindow: self.window)
            
            ShowDetailsForTxfo(txfo: outputData.inputData!, controller: outputVC)
            
            let outputTabItem = NSTabViewItem(viewController: OutputDataController(nibName: nil, bundle: nil))
            outputTabItem.label = "Output"
            
            if let tabView = outputVC.tabView
            {
                tabView.addTabViewItem(outputTabItem)
            }
            
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
                self.openPanel = nil
                return
            }
            
            guard let txfo = PCH_FLD12_TxfoDetails(url: fileURL) else
            {
                DLog("File is not in the required FLD12 format!")
                self.openPanel = nil
                return
            }
            
            let inputVC = InputFileViewController(intoWindow: self.window)
            
            ShowDetailsForTxfo(txfo: txfo, controller: inputVC)
            
        } // end if openPanel
        
        self.openPanel = nil
    }
    
    
    func ShowDetailsForTxfo(txfo:PCH_FLD12_TxfoDetails, controller:InputFileViewController)
    {
        guard let generalVC = controller.generalDataController else
        {
            DLog("Could not access General Data View")
            return
        }
        
        generalVC.idField.stringValue = txfo.identification
        
        if (txfo.inputUnits == 1)
        {
            generalVC.mmInputButton.state = .on
        }
        else if (txfo.inputUnits == 2)
        {
            generalVC.inchInputButton.state = .on
        }
        else
        {
            DLog("An illegal input unit was encountered - ignoring!")
        }
        
        if txfo.numPhases == 1
        {
            generalVC.onePhaseButton.state = .on
        }
        else if txfo.numPhases == 3
        {
            generalVC.threePhaseButton.state = .on
        }
        else
        {
            DLog("We only build single- and three-phase transformers - ignoring!")
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
        }
        else
        {
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
        }
        else if (txfo.dispElon == 1)
        {
            generalVC.offsetButton.state = .on
        }
        else if (txfo.dispElon == 2)
        {
            generalVC.elongButton.state = .on
        }
        else
        {
            DLog("Illegal value for offset/elongation - setting to none")
            generalVC.offsetElongNoneButton.state = .on
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
            return
        }
        
        guard txfo.numTerminals > 0 else
        {
            DLog("Illegal terminal count!")
            return
        }
        
        terminalVC.addTerminalLines(count: Int(txfo.numTerminals))
        
        guard let terminalArray = txfo.terminals as? [PCH_FLD12_Terminal] else
        {
            DLog("Problem with terminal array")
            return
        }
        
        for i in 0..<terminalArray.count
        {
            let line = terminalVC.termDataLines[i]
            let terminal = terminalArray[i]
            line.termNumberField.stringValue = "\(terminal.number)"
            line.mvaField.stringValue = "\(terminal.mva)"
            line.kvField.stringValue = "\(terminal.kv)"
            
            if (terminal.connection == 1)
            {
                line.wyeConnectionButton.state = .on
            }
            else if (terminal.connection == 2)
            {
                line.deltaConnectionButton.state = .on
            }
            else
            {
                DLog("Unimplemented connection code")
            }
        }
        
        // Layers
        guard let layerVC = controller.layerDataController else
        {
            DLog("Could not access Layers Data View")
            return
        }
        
        guard txfo.numLayers > 0 else
        {
            DLog("Illegal layer count!")
            return
        }
        
        layerVC.addLayerLines(count: Int(txfo.numLayers))
        
        guard let layerArray = txfo.layers as? [PCH_FLD12_Layer] else
        {
            DLog("Problem with layer array")
            return
        }
        
        // we'll be looping through the layers so we'll grab the segments as we go
        var segmentArray:[PCH_FLD12_Segment] = []
        
        for i in 0..<layerArray.count
        {
            let line = layerVC.layerDataLines[i]
            let layer = layerArray[i]
            
            if let layerSegments = layerArray[i].segments as? [PCH_FLD12_Segment]
            {
                segmentArray.append(contentsOf: layerSegments)
            }
            
            line.layerNumberField.stringValue = "\(layer.number)"
            line.lastSegmentField.stringValue = "\(layer.lastSegment)"
            line.innerRadiusField.stringValue = "\(layer.innerRadius)"
            line.radialBuildField.stringValue = "\(layer.radialBuild)"
            line.parentTerminalField.stringValue = "\(layer.terminal)"
            line.numSpBlkField.stringValue = "\(layer.numSpacerBlocks)"
            line.spBlkWidthField.stringValue = "\(layer.spBlkWidth)"
            
            if layer.numParGroups == 1
            {
                line.oneParGroupButton.state = .on
            }
            else if layer.numParGroups == 2
            {
                line.twoParGroupButton.state = .on
            }
            else
            {
                ALog("Illegal number of parallel groups")
            }
            
            if layer.currentDirection > 0
            {
                line.plusCurrentButton.state = .on
            }
            else if layer.currentDirection < 0
            {
                line.minusCurrentButton.state = .on
            }
            else
            {
                ALog("0 current is not allowed")
            }
            
            if layer.cuOrAl == 1
            {
                line.cuButton.state = .on
            }
            else if layer.cuOrAl == 2
            {
                line.alButton.state = .on
            }
            else
            {
                ALog("Illegal conductor specification")
            }
        }
        
        // And finally, terminals
        guard let segmentVC = controller.segmentDataController else
        {
            DLog("Could not access Segments Data View")
            return
        }
        
        guard segmentArray.count >= layerArray.count else
        {
            DLog("Illegal segment count!")
            return
        }
        
        segmentVC.addSegmentLines(count: Int(segmentArray.count))
        
        for i in 0..<segmentArray.count
        {
            let line = segmentVC.segmentDataLines[i]
            let segment = segmentArray[i]
            
            line.segmentNumberFIeld.stringValue = "\(segment.segmentNumber)"
            line.zMinField.stringValue = "\(segment.zMin)"
            line.zMaxField.stringValue = "\(segment.zMax)"
            line.totalTurnsField.stringValue = "\(segment.turns)"
            line.activeTurnsFIeld.stringValue = "\(segment.activeTurns)"
            line.strandsPerTurnField.stringValue = "\(segment.strandsPerTurn)"
            line.strandsPerLayerField.stringValue = "\(segment.strandsPerLayer)"
            line.strandDimnRadialField.stringValue = "\(segment.strandR)"
            line.strandDimnAxialField.stringValue = "\(segment.strandA)"
        }
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
