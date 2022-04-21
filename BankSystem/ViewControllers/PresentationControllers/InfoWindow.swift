//
//  InfoWindow.swift
//  BankSystem
//
//  Created by Maria Zyryanova on 18.04.22.
//

import Cocoa

class InfoWindow: NSViewController {
    
    var content: String = ""
    @IBOutlet var contentLable: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentLable.stringValue = content
        // Do view setup here.
    }
    @IBAction func returnClicked(_ sender: Any) {
        self.dismiss(self)
    }
    
}
