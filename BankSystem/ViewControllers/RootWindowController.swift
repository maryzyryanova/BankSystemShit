//
//  RootWindowController.swift
//  BankSystem
//
//  Created by Maria Zyryanova on 18.04.22.
//

import Cocoa

class RootWindowController: NSWindowController {
    
    override func windowDidLoad() {
        super.windowDidLoad()
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
    convenience init(){
        self.init(windowNibName: "RootWindowController")
    }
}
