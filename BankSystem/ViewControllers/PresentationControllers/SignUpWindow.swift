//
//  SignUpWindow.swift
//  BankSystem
//
//  Created by Maria Zyryanova on 18.04.22.
//

import Cocoa

class SignUpWindow: NSViewController {
    
    var model = LoginModel()
    
    @IBOutlet var combobox: NSComboBox!
    @IBOutlet var nameTF: NSTextField!
    @IBOutlet var seriesTF: NSTextField!
    @IBOutlet var idTF: NSTextField!
    @IBOutlet var emailTF: NSTextField!
    @IBOutlet var phoneTF: NSTextField!
    @IBOutlet var loginTF: NSTextField!
    @IBOutlet var passwordTF: NSSecureTextField!
    
    var banks = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        super.viewDidLoad()
        // Do view setup here.
        let db = JSONDatabase.shared
        for bank in db.banks {
            banks.append(bank.name)
        }
        
        combobox.delegate = self
        combobox.dataSource = self
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        if combobox.indexOfSelectedItem != -1{
            let client = Client(login: loginTF.stringValue, password: passwordTF.stringValue, name: nameTF.stringValue, passportData: seriesTF.stringValue, passportId: idTF.stringValue, phone: phoneTF.stringValue, email: emailTF.stringValue, credits: [], installments: [], accounts: [])
            model.registerMethod(client, banks[combobox.indexOfSelectedItem])
            let vc = InfoWindow()
            vc.content = "Request sent"
            presentAsSheet(vc)
        }
    }
    
    
    @IBAction func returnCLicked(_ sender: Any) {
        self.dismiss(self)
    }
    
}

extension SignUpWindow: NSComboBoxDelegate, NSComboBoxDataSource{
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        return banks.count
    }
    
    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        return banks[index]
    }
}
