//
//  LogInWindow.swift
//  BankSystem
//
//  Created by Maria Zyryanova on 18.04.22.
//

import Cocoa

class LogInWindow: NSViewController {

    var model = LoginModel()
    var bank = ""
    
    @IBOutlet var loginTF: NSTextField!
    @IBOutlet var passwordTF: NSSecureTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    @IBAction func submitClicked(_ sender: Any) {
        guard let user = self.model.loginMethod(loginTF.stringValue, passwordTF.stringValue, bank) else {
            presentError(LoginError(error: "User not exist"))
            return
        }
        if let client = user as? ClientModel{
            let vc = ClientAccountWindow()
            vc.model = client
            presentAsSheet(vc)
            return
        }
        if let _operator = user as? OperatorModel{
            let vc = OperatoAccountWindow()
            vc.model = _operator
            presentAsSheet(vc)
            return
        }
        if let manager = user as? ManagerModel{
            let vc = ManagerAccountWindow()
            vc.model = manager
            presentAsSheet(vc)
            return
        }
        if let specialist = user as? CompanySpecialistModel{
            let vc = SpecialistAccountWindow()
            vc.model = specialist
            presentAsSheet(vc)
            return
        }
        if let admin = user as? AdminModel{
            let vc = AdminAccountWindow()
            vc.model = admin
            presentAsSheet(vc)
            return
        }
    }
    
    @IBAction func returnClicked(_ sender: Any) {
        self.dismiss(self)
    }
}

class LoginError: Error{
    var error: String
    init(error: String){
        self.error = error
    }
}
