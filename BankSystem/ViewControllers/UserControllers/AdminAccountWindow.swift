//
//  AdminAccountWindow.swift
//  BankSystem
//
//  Created by Maria Zyryanova on 18.04.22.
//

import Cocoa

class AdminAccountWindow: NSViewController {

    var model: AdminModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    @IBAction func actionsClicked(_ sender: Any) {
        guard let model = model else {return}
        let vc = ActionsWindow()
        vc.cancelEnabled = true
        for request in model.requests{
            vc.actions.append(request.id)
        }
        vc.model = model
        presentAsSheet(vc)
    }
    @IBAction func returnClicked(_ sender: Any) {
        self.dismiss(self)
    }
    @IBAction func infoClicked(_ sender: Any) {
        if let admin = model{
            let vc = InfoWindow()
            vc.content = admin.info()
            presentAsSheet(vc)
        }
    }
    
    @IBAction func logsClicked(_ sender: Any) {
        guard let model = model else {return}
        let vc = LogWindow()
        vc.log = model.log()
        presentAsSheet(vc)
    }
}
