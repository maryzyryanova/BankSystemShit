//
//  ManagerAccountWindow.swift
//  BankSystem
//
//  Created by Maria Zyryanova on 18.04.22.
//

import Cocoa

class ManagerAccountWindow: NSViewController {

    var model: ManagerModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    @IBAction func actionsClicked(_ sender: Any) {
        guard let model = model else {return}
        
        let vc = ActionsWindow()
        vc.model = model
        vc.cancelEnabled = false
        for request in model.requests{
            vc.actions.append(request.id)
        }
        presentAsSheet(vc)
    }
    
    convenience init(){
        self.init(nibName: "ManagerAccountWindow", bundle: nil)
    }
    
    @IBAction func logoutClicked(_ sender: Any) {
        self.dismiss(self)
    }
    
    @IBAction func infoClicked(_ sender: Any) {
        if let manager = model{
            let vc = InfoWindow()
            vc.content = manager.info()
            presentAsSheet(vc)
        }
    }
    
}
