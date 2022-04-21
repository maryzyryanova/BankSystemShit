//
//  InstallmentsWindow.swift
//  BankSystem
//
//  Created by Maria Zyryanova on 18.04.22.
//

import Cocoa

class InstallmentsWindow: NSViewController {
    @IBOutlet var installmentsTW: NSTableView!
    @IBOutlet var sumTB: NSTextField!
    @IBOutlet var accountCB: NSComboBox!
    @IBOutlet var conditionsCB: NSComboBox!
    
    
    var model: PModel?
    var installments = [Installment]()
    var accounts = [Account]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        installmentsTW.dataSource = self
        installmentsTW.delegate = self
        
        accountCB.dataSource = self
        accountCB.delegate = self
        
        // Не ебу че тут падает, пересоздай вью-контроллер
        // Кароч удаляй ксибу и класс, пересоздай всё с нуля и не делай cmd c и cmd v
        // Всё ручками
    }
    
    convenience init(){
        self.init(nibName: "InstallmentsWindow", bundle: nil)
    }
    
    @IBAction func addClicked(_ sender: Any) {
        guard let model = model else {return}
        
        if let sum = Double(sumTB.stringValue){
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
            if installmentsTW.selectedRow != -1{
                if accountCB.indexOfSelectedItem != -1{
                    if installments[installmentsTW.selectedRow].getMonthSum() <= accounts[accountCB.indexOfSelectedItem].balance{
                        client.payCredit(installments[installmentsTW.selectedRow].id, installments[installmentsTW.selectedRow].getMonthSum(), accounts[accountCB.indexOfSelectedItem].id)
                        let vc = InfoWindow()
                        vc.content = "Sum \(installments[installmentsTW.selectedRow].getMonthSum()) payed from account: \(accounts[accountCB.indexOfSelectedItem].id)"
                        presentAsSheet(vc)
                        installments = client.updateInstallments()
                        installmentsTW.reloadData()
                    }
                }
            }
        }
    }
    @IBAction func infoClicked(_ sender: Any) {
        guard let model = model else {return}
        if let client = model as? ClientModel{
            if installmentsTW.selectedRow != -1{
                let vc = InfoWindow()
                vc.content = client.creditInfo(installments[installmentsTW.selectedRow].id)
                presentAsSheet(vc)
            }
        }
    }
    @IBAction func returnClicked(_ sender: Any) {
        self.dismiss(self)
    }
}

extension InstallmentsWindow: NSTableViewDataSource, NSTableViewDelegate{
    func numberOfRows(in tableView: NSTableView) -> Int {
        return installments.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return installments[row].id
    }
    
}

extension InstallmentsWindow: NSComboBoxDelegate, NSComboBoxDataSource{
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        return accounts.count
    }
    
    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        return accounts[index].id
    }
}
