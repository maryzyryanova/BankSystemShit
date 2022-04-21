//
//  SalaryProjectRequestWindow.swift
//  BankSystem
//
//  Created by Maria Zyryanova on 21.04.22.
//

import Cocoa

class SalaryProjectRequestWindow: NSViewController {

    var accounts = [String]()
    var model: ClientModel?
    var company: Company?
    var salaryProject: SalaryProject?
    
    @IBOutlet var accountsCB: NSComboBox!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accountsCB.dataSource = self
        accountsCB.delegate = self
        // Do view setup here.
    }
    
    convenience init(){
        self.init(nibName: "SalaryProjectRequestWindow", bundle: nil)
    }
    @IBAction func applyClicked(_ sender: Any) {
        guard let model = model else {self.dismiss(self); return}
        guard let company = company else {self.dismiss(self); return}
        guard let salaryProject = salaryProject else {self.dismiss(self); return}
        if accountsCB.indexOfSelectedItem != -1{
            model.requestSalaryProject(company, salaryProject, accounts[accountsCB.indexOfSelectedItem])
            let vc = InfoWindow()
            vc.content = "Salary project request sent"
            presentAsSheet(vc)
        }
    }
    @IBAction func returnClicked(_ sender: Any) {
        self.dismiss(self)
    }
}

extension SalaryProjectRequestWindow: NSComboBoxDelegate, NSComboBoxDataSource{
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        return accounts.count
    }
    
    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        return accounts[index]
    }
}
