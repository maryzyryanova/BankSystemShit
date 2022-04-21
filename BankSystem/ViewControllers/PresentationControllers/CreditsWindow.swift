//
//  CreditsWindow.swift
//  BankSystem
//
//  Created by Maria Zyryanova on 18.04.22.
//

import Cocoa

class CreditsWindow: NSViewController {
    
    @IBOutlet var table: NSTableView!
    @IBOutlet var sumTF: NSTextField!
    @IBOutlet var conditionsCB: NSComboBox!
    @IBOutlet var accountsCB: NSComboBox!
    
    var model: PModel?
    var credits = [Credit]()
    var accounts = [Account]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        table.dataSource = self
        table.delegate = self
        
        accountsCB.dataSource = self
        accountsCB.delegate = self
        
        conditionsCB.selectItem(at: 0)
    }
    
    convenience init(){
        self.init(nibName: "CreditsWindow", bundle: nil)
    }
    
    @IBAction func addClicked(_ sender: Any) {
        guard let model = model else {return}
        
        if let client = model as? ClientModel{
            client.addCredit(conditionsCB.stringValue, sumTF.doubleValue)
            let vc = InfoWindow()
            vc.content = "Request sent"
            presentAsSheet(vc)
        }
    }
    
    @IBAction func payClicked(_ sender: Any) {
        guard let model = model else {return}
        if let client = model as? ClientModel{
            if table.selectedRow != -1{
                if accountsCB.indexOfSelectedItem != -1{
                    if credits[table.selectedRow].getMonthSum() <= accounts[accountsCB.indexOfSelectedItem].balance{
                        client.payCredit(credits[table.selectedRow].id, credits[table.selectedRow].getMonthSum(), accounts[accountsCB.indexOfSelectedItem].id)
                        let vc = InfoWindow()
                        vc.content = "Sum \(credits[table.selectedRow].getMonthSum()) payed from account: \(accounts[accountsCB.indexOfSelectedItem].id)"
                        presentAsSheet(vc)
                        credits = client.updateCredits()
                        table.reloadData()
                    }
                }
            }
        }
    }
    
    @IBAction func infoClicked(_ sender: Any) {
        guard let model = model else {return}
        if let client = model as? ClientModel{
            if table.selectedRow != -1{
                let vc = InfoWindow()
                vc.content = client.creditInfo(credits[table.selectedRow].id)
                presentAsSheet(vc)
            }
        }
    }
    
    @IBAction func returnClicked(_ sender: Any) {
        self.dismiss(self)
    }
    
}

extension CreditsWindow: NSComboBoxDelegate, NSComboBoxDataSource{
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        return accounts.count
    }
    
    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        return accounts[index].id
    }
}

extension CreditsWindow: NSTableViewDataSource, NSTableViewDelegate{
    func numberOfRows(in tableView: NSTableView) -> Int {
        return credits.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return credits[row].id
    }
    
}
