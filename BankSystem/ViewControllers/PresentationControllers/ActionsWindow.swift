//
//  ActionsWindow.swift
//  BankSystem
//
//  Created by Maria Zyryanova on 18.04.22.
//

import Cocoa

class ActionsWindow: NSViewController {
    
    var actions = [String]()
    var model: PModel?
    var cancelEnabled = false

    @IBOutlet var table: NSTableView!
    @IBOutlet var cancelButton: NSButton!
    @IBOutlet var approveButton: NSButton!
    @IBOutlet var denyButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        cancelButton.isEnabled = cancelEnabled
        
        table.dataSource = self
        table.delegate = self
    }
    
    @IBAction func returnClicked(_ sender: Any) {
        self.dismiss(self)
    }
    
    @IBAction func approveClicked(_ sender: Any) {
        guard let model = model else {return}
        if table.selectedRow != -1{
            if let admin = model as? AdminModel{
                admin.approveRequest(actions[table.selectedRow])
            }
            if let manager = model as? ManagerModel{
                manager.approveRequest(actions[table.selectedRow])
            }
            if let oper = model as? OperatorModel{
                oper.approveRequest(actions[table.selectedRow])
            }
            let vc = InfoWindow()
            vc.content = "Request approved"
            presentAsSheet(vc)
            approveButton.isEnabled = false
            denyButton.isEnabled = false
        }
    }
    
    @IBAction func infoClicked(_ sender: Any) {
        guard let model = model else {return}
        if table.selectedRow != -1{
            if let admin = model as? AdminModel{
                let vc = InfoWindow()
                vc.content = admin.requestInfo(actions[table.selectedRow])
                presentAsSheet(vc)
            }
            if let manager = model as? ManagerModel{
                let vc = InfoWindow()
                vc.content = manager.requestInfo(actions[table.selectedRow])
                presentAsSheet(vc)
            }
            if let oper = model as? OperatorModel{
                let vc = InfoWindow()
                vc.content = oper.requestInfo(actions[table.selectedRow])
                presentAsSheet(vc)
            }
        }
    }
    
    @IBAction func denyClicked(_ sender: Any) {
        guard let model = model else {return}
        if table.selectedRow != -1{
            if let admin = model as? AdminModel{
                admin.denyRequest(actions[table.selectedRow])
            }
            if let manager = model as? ManagerModel{
                manager.denyRequest(actions[table.selectedRow])
            }
            if let oper = model as? OperatorModel{
                oper.denyRequest(actions[table.selectedRow])
            }
            let vc = InfoWindow()
            vc.content = "Request denied"
            presentAsSheet(vc)
            approveButton.isEnabled = false
            denyButton.isEnabled = false
        }
    }
    @IBAction func cancelClicked(_ sender: Any) {
        guard let model = model else {return}
        if table.selectedRow != -1{
            if let admin = model as? AdminModel{
                admin.db.cancelRequest(actions[table.selectedRow])
            }
            if let manager = model as? ManagerModel{
                manager.db.cancelRequest(actions[table.selectedRow])
            }
            if let oper = model as? OperatorModel{
                oper.db.cancelRequest(actions[table.selectedRow])
            }
            cancelButton.isEnabled = false
        }
    }
}

extension ActionsWindow: NSTableViewDataSource, NSTableViewDelegate{
    func numberOfRows(in tableView: NSTableView) -> Int {
        return actions.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return actions[row]
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        guard let model = model else {return}
        if table.selectedRow != -1{
            if let admin = model as? AdminModel{
                approveButton.isEnabled = admin.requests[table.selectedRow].status == "Awaiting"
                denyButton.isEnabled = admin.requests[table.selectedRow].status == "Awaiting"
                cancelButton.isEnabled = admin.requests[table.selectedRow].status != "Awaiting"
            }
            if let manager = model as? ManagerModel{
                if let request = manager.getRequest(actions[table.selectedRow]){
                    if request is Transaction{
                        cancelButton.isEnabled = true
                    }
                    else{
                        cancelButton.isEnabled = false
                    }
                }
                approveButton.isEnabled = manager.requests[table.selectedRow].status == "Awaiting"
                denyButton.isEnabled = manager.requests[table.selectedRow].status == "Awaiting"
            }
            if let oper = model as? OperatorModel{
                if oper.actionsCanceled >= 1{
                    cancelButton.isEnabled = false
                }
                approveButton.isEnabled = oper.requests[table.selectedRow].status == "Awaiting"
                denyButton.isEnabled = oper.requests[table.selectedRow].status == "Awaiting"
            }
        }
    }
}
