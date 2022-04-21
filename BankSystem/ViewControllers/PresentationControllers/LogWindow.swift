//
//  LogWindow.swift
//  BankSystem
//
//  Created by Maria Zyryanova on 20.04.22.
//

import Cocoa

class LogWindow: NSViewController {
    
    var log = ""
    
    @IBOutlet var logView: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logView.string = log
        // Do view setup here.
    }
    
    convenience init(){
        self.init(nibName: "LogWindow", bundle: nil)
    }
    
    @IBAction func returnClicked(_ sender: Any) {
        self.dismiss(self)
    }
    
}
