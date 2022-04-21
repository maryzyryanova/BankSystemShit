//
//  SalaryProjectsWindow.swift
//  BankSystem
//
//  Created by Maria Zyryanova on 18.04.22.
//

import Cocoa

class SalaryProjectsWindow: NSViewController {
    var model: PModel?
    var salaryProjects = [SalaryProject]()
    var companies = [Company]()
    
    @IBOutlet var companiesCB: NSComboBox!
    
    @IBOutlet var tableview: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        tableview.dataSource = self
        tableview.delegate = self
        
        companiesCB.dataSource = self
        companiesCB.delegate = self
    }
    @IBAction func applyforClicked(_ sender: Any) {
        guard let model = model else {return}
        if companiesCB.indexOfSelectedItem != -1{
            if tableview.selectedRow != -1{
                if let client = model as? ClientModel{
                    let vc = SalaryProjectRequestWindow()
                    for account in client.user.accounts{
                        vc.accounts.append(account.id)
                    }
                    vc.model = client
                    vc.company = companies[companiesCB.indexOfSelectedItem]
                    vc.salaryProject = salaryProjects[tableview.selectedRow]
                    presentAsSheet(vc)
                }
            }
        }
    }
    
    @IBAction func infoClicked(_ sender: Any) {
    }
    
    @IBAction func returnClicked(_ sender: Any) {
        self.dismiss(self)
    }
    
}

extension SalaryProjectsWindow: NSTableViewDataSource, NSTableViewDelegate{
    func numberOfRows(in tableView: NSTableView) -> Int {
        return salaryProjects.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return salaryProjects[row].title
    }
    
}

extension SalaryProjectsWindow: NSComboBoxDelegate, NSComboBoxDataSource{
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        return companies.count
    }
    
    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        return companies[index].name
    }
    
    func comboBoxSelectionDidChange(_ notification: Notification) {
        if companiesCB.indexOfSelectedItem != -1{
            salaryProjects = companies[companiesCB.indexOfSelectedItem].salaryProjects
            tableview.reloadData()
        }
    }
}
