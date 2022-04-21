//
//  OperatoAccountWindow.swift
//  BankSystem
//
//  Created by Maria Zyryanova on 18.04.22.
//

import Cocoa

class OperatoAccountWindow: NSViewController {

    var model: OperatorModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    convenience init(){
        self.init(nibName: "OperatoAccountWindow", bundle: nil)
    }
    
    @IBAction func actionsClicked(_ sender: Any) {
        guard let model = model else {return}
        
        let vc = ActionsWindow()
        vc.model = model
        vc.cancelEnabled = true
        for request in model.requests{
            vc.actions.append(request.id)
        }
        presentAsSheet(vc)
    }
    
    @IBAction func infoClicked(_ sender: Any) {
        if let oper = model{
            let vc = InfoWindow()
            vc.content = oper.info()
            presentAsSheet(vc)
        }
    }
    @IBAction func logoutClicked(_ sender: Any) {
        self.dismiss(self)
    }
}
