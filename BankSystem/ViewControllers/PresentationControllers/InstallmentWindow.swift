//
//  InstallmentWindow.swift
//  BankSystem
//
//  Created by Maria Zyryanova on 20.04.22.
//

import Cocoa

class InstallmentWindow: NSViewController {

    @IBOutlet var tableview: NSTableView!
    @IBOutlet var conditionsCB: NSComboBox!
    @IBOutlet var sumTF: NSTextField!
    @IBOutlet var accountCB: NSComboBox!
    
    var model: PModel?
    var accounts = [Account]()
    var installments = [Installment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        tableview.dataSource = self
        tableview.delegate = self
    
        accountCB.dataSource = self
        accountCB.delegate = self
        
        
        
    }
    
    convenience init(){
        self.init(nibName: "InstallmentWindow", bundle: nil)
    }
    
    @IBAction func addClicked(_ sender: Any) {
        guard let model = model else {return}
        
        if let sum = Double(sumTF.stringValue){
            if let client = model as? ClientModel{
                client.addInstallment(conditionsCB.stringValue, sum)
                let vc = InfoWindow()
                vc.content = "Request sent"
                presentAsSheet(vc)
            }
        }
    }
    
    
    @IBAction func payClicked(_ sender: Any) {
        guard let model = model else {return}
        if let client = model as? ClientModel{
            if tableview.selectedRow >= 0{ //cумма счёта не сохраняется почему-то при пополнении, тут прога падает
                if accountCB.indexOfSelectedItem != -1{
                    if installments[tableview.selectedRow].getMonthSum() <= accounts[accountCB.indexOfSelectedItem].balance{
                        client.payInstallment(installments[tableview.selectedRow].id, installments[tableview.selectedRow].getMonthSum(), accounts[accountCB.indexOfSelectedItem].id)
                        let vc = InfoWindow()
                        vc.content = "Sum \(installments[tableview.selectedRow].getMonthSum()) payed from account: \(accounts[accountCB.indexOfSelectedItem].id)"
                        presentAsSheet(vc)
                        installments = client.updateInstallments()
                        tableview.reloadData()
                    }
                }
            }
        }
    }
    @IBAction func infoClicked(_ sender: Any) {
        guard let model = model else {return}
        if let client = model as? ClientModel{
            if tableview.selectedRow != -1{
                let vc = InfoWindow()
                vc.content = client.installmentInfo(installments[tableview.selectedRow].id)
                presentAsSheet(vc)
            }
        }
        
    }
    @IBAction func returnClicked(_ sender: Any) {
        self.dismiss(self)
    }
}

extension InstallmentWindow: NSTableViewDataSource, NSTableViewDelegate{
    func numberOfRows(in tableView: NSTableView) -> Int {
        return installments.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return installments[row].id
    }
    
}

extension InstallmentWindow: NSComboBoxDelegate, NSComboBoxDataSource{
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        return accounts.count
    }
    
    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        return accounts[index].id
    }
}
