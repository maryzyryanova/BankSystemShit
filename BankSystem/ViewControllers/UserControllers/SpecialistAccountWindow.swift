//
//  SpecialistAccountWindow.swift
//  BankSystem
//
//  Created by Maria Zyryanova on 18.04.22.
//

import Cocoa

class SpecialistAccountWindow: NSViewController {

    var model: CompanySpecialistModel?
    var accounts = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func accountsClicked(_ sender: Any) {
        if let model = model {
            let vc = AccountsWindow()
            for account in model.company.accounts{
                vc.accounts.append(account.id)
            }
            vc.model = model
            presentAsSheet(vc)
        }
    }
    
    @IBAction func infoClicked(_ sender: Any) {
        if let spec = model{
            let vc = InfoWindow()
            vc.content = spec.info()
            presentAsSheet(vc)
        }
    }
    
    @IBAction func salaryprojectsClicked(_ sender: Any) {
        if let spec = model{
            let vc = AddSalaryProjectWindow()
            vc.salaryProjects = spec.company.salaryProjects
            vc.model = spec
            presentAsSheet(vc)
        }
    }
    @IBAction func transactionClicked(_ sender: Any) {
        if let spec = model{
            let vc = TransacrionWindow()
            vc.model = spec
            vc.companies = spec.getCompanies()
            presentAsSheet(vc)
        }
    }
    
    @IBAction func returnClicked(_ sender: Any) {
        self.dismiss(self)
    }
}
