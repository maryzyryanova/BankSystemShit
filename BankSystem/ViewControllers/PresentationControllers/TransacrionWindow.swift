//
//  TransacrionWindow.swift
//  BankSystem
//
//  Created by Maria Zyryanova on 21.04.22.
//

import Cocoa

class TransacrionWindow: NSViewController {

    var model: CompanySpecialistModel?
    var companies = [Company]()
    var accounts = [String]()
    
    @IBOutlet var table: NSTableView!
    @IBOutlet var companiesCB: NSComboBox!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.dataSource = self
        table.delegate = self
        
        companiesCB.dataSource = self
        companiesCB.delegate = self 
        // Do view setup here.
    }
    
    convenience init(){
        self.init(nibName: "TransacrionWindow", bundle: nil)
    }
    
    @IBAction func newClicked(_ sender: Any) {
        guard let model = model else {return}
        if table.selectedRow != -1 && companiesCB.indexOfSelectedItem != -1{
            let vc = SendTransactionWindow()
            vc.model = model
            vc.accounts = model.company.accounts
            vc.recieverName = companies[companiesCB.indexOfSelectedItem].name
            vc.recieverAccountId = accounts[table.selectedRow]
            presentAsSheet(vc)
        }
    }
    
    @IBAction func returnClicked(_ sender: Any) {
        self.dismiss(self)
    }
    
}

extension TransacrionWindow: NSComboBoxDelegate, NSComboBoxDataSource{
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        return companies.count
    }
    
    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        return companies[index].name
    }
    
    func comboBoxSelectionDidChange(_ notification: Notification) {
        if companiesCB.indexOfSelectedItem != -1{
            var accs = [String]()
            for account in companies[companiesCB.indexOfSelectedItem].accounts{
                accs.append(account.id)
            }
            self.accounts = accs
            table.reloadData()
        }
    }
}

extension TransacrionWindow: NSTableViewDelegate, NSTableViewDataSource{
    func numberOfRows(in tableView: NSTableView) -> Int {
        return accounts.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return accounts[row]
    }
}
