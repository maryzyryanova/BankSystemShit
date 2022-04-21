//
//  AccountsWindow.swift
//  BankSystem
//
//  Created by Maria Zyryanova on 18.04.22.
//

import Cocoa

class AccountsWindow: NSViewController {

    var model: PModel?
    var accounts = [String]()
    
    @IBOutlet var table: NSTableView!
    @IBOutlet var sumTF: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.dataSource = self
        table.delegate = self
        // Do view setup here.
    }
    
    
    @IBAction func infoClicked(_ sender: Any) {
        guard let model = model else {return}
        
        if table.selectedRow != -1{
            if let client = model as? ClientModel{
                if let account = client.getAccount(accounts[table.selectedRow]){
                    let vc = InfoWindow()
                    vc.content = account.info()
                    presentAsSheet(vc)
                }
            }
            if let specialist = model as? CompanySpecialistModel{
                if let account = specialist.getAccount(accounts[table.selectedRow]){
                    let vc = InfoWindow()
                    vc.content = account.info()
                    presentAsSheet(vc)
                }
            }
        }
    }
    @IBAction func withdrawClicked(_ sender: Any) {
        guard let model = model else {return}
        
        if table.selectedRow != -1{
            if let client = model as? ClientModel{
                client.withdrawAccount(accounts[table.selectedRow])
                client.updateAccounts()
            }
            if let specialist = model as? CompanySpecialistModel{
                specialist.withdrawAccount(accounts[table.selectedRow])
                specialist.updateAccounts()
            }
        }
    }
    
    @IBAction func openClicked(_ sender: Any) {
        guard let model = model else {return}
        
        if let client = model as? ClientModel{
            client.addAccount()
            let vc = InfoWindow()
            vc.content = "Request sent"
            presentAsSheet(vc)
        }
        
        if let spec = model as? CompanySpecialistModel{
            spec.addAccount()
            let vc = InfoWindow()
            vc.content = "Request sent"
            presentAsSheet(vc)
        }
    }
    @IBAction func closeClicked(_ sender: Any) {
        guard let model = model else {return}
        
        if table.selectedRow != -1{
            if let client = model as? ClientModel{
                client.closeAccount(accounts[table.selectedRow])
                let vc = InfoWindow()
                vc.content = "Request sent"
                presentAsSheet(vc)
            }
            if let specialist = model as? CompanySpecialistModel{
                specialist.closeAccount(accounts[table.selectedRow])
                let vc = InfoWindow()
                vc.content = "Request sent"
                presentAsSheet(vc)
            }
        }
    }
    
    @IBAction func topupCLicked(_ sender: Any) {
        guard let model = model else {return}
        if table.selectedRow != -1{
            if let client = model as? ClientModel{
                client.topUpAccount(accounts[table.selectedRow], sumTF.doubleValue)
                client.updateAccounts()
                let vc = InfoWindow()
                vc.content = "+\(sumTF.doubleValue)"
                presentAsSheet(vc)
            }
            if let specialist = model as? CompanySpecialistModel{
                specialist.topUpAccount(accounts[table.selectedRow], sumTF.doubleValue)
                specialist.updateAccounts()
                let vc = InfoWindow()
                vc.content = "+\(sumTF.doubleValue)"
                presentAsSheet(vc)
            }
        }
    }
    
    @IBAction func returnClicked(_ sender: Any) {
        self.dismiss(self)
    }
}

extension AccountsWindow: NSTableViewDataSource, NSTableViewDelegate{
    func numberOfRows(in tableView: NSTableView) -> Int {
        return accounts.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return accounts[row]
    }
    
}
