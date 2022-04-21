//
//  MainWindow.swift
//  BankSystem
//
//  Created by Maria Zyryanova on 18.04.22.
//

import Cocoa

class MainWindow: NSViewController {
    
    @IBOutlet var combobox: NSComboBox!
    
    var banks = [String]()
    var model = LoginModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        for bank in model.db.banks{
            banks.append(bank.name)
        }
        
        combobox.delegate = self
        combobox.dataSource = self
    }
    
    convenience init(){
        self.init(nibName: "MainWindow", bundle: nil)
    }
    @IBAction func loginClick(_ sender: Any) {
        if combobox.indexOfSelectedItem != -1{
            let vc = LogInWindow()
            vc.bank = banks[combobox.indexOfSelectedItem]
            presentAsSheet(vc)
        }
    }
    @IBAction func signupClick(_ sender: Any) {
        presentAsSheet(SignUpWindow())
    }
}

extension MainWindow: NSComboBoxDelegate, NSComboBoxDataSource{
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        return banks.count
    }
    
    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        return banks[index]
    }
}

