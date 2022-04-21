//
//  SendTransactionWindow.swift
//  BankSystem
//
//  Created by Maria Zyryanova on 21.04.22.
//

import Cocoa

class SendTransactionWindow: NSViewController {

    var model: CompanySpecialistModel?
    var recieverAccountId: String = ""
    var recieverName: String = ""
    var accounts = [Account]()
    
    @IBOutlet var accountCB: NSComboBox!
    @IBOutlet var sumTF: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        accountCB.dataSource = self
        accountCB.delegate = self
    }
    
    convenience init(){
        self.init(nibName: "SendTransactionWindow", bundle: nil)
    }
    
    @IBAction func sendClicked(_ sender: Any) {
        guard let model = model else {return}
        if accountCB.indexOfSelectedItem != -1{
            if sumTF.stringValue != "" && sumTF.doubleValue <= accounts[accountCB.indexOfSelectedItem].balance{
                model.transactionToCompany(recieverName, recieverAccountId, accounts[accountCB.indexOfSelectedItem].id, sumTF.doubleValue)
                let vc = InfoWindow()
                vc.content = "Trnasaction on sum \(sumTF.doubleValue) sent"
                presentAsSheet(vc)
            }
        }
    }
    
    @IBAction func returnClicked(_ sender: Any) {
        self.dismiss(self)
    }
}

extension SendTransactionWindow: NSComboBoxDataSource, NSComboBoxDelegate{
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        return accounts.count
    }
    
    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        return accounts[index].id
    }
}
