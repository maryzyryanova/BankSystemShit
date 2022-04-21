//
//  ClientAccountWindow.swift
//  BankSystem
//
//  Created by Maria Zyryanova on 18.04.22.
//

import Cocoa

class ClientAccountWindow: NSViewController {

    var model: ClientModel?
    var accounts = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func accountsClicked(_ sender: Any) {
        if let model = model {
            let vc = AccountsWindow()
            for account in model.user.accounts{
                vc.accounts.append(account.id)
            }
            vc.model = model
            presentAsSheet(vc)
        }
    }
    @IBAction func infoClicked(_ sender: Any) {
        if let client = model{
            let vc = InfoWindow()
            vc.content = client.info()
            presentAsSheet(vc)
        }
    }
    
    @IBAction func salaryProjectsClicked(_ sender: Any) {
        if let model = model {
            let vc = SalaryProjectsWindow()
            if let bank = model.getBank(){
                for company in bank.companies
                {
                    vc.companies.append(company)
                }
            }
            
            for projects in model.salaryProjects{
                vc.salaryProjects.append(projects)
            }
            vc.model = model
            presentAsSheet(vc)
        }
    }
    
    
    @IBAction func creditsClicked(_ sender: Any) {
        if let model = model {
            let vc = CreditsWindow()
            for credit in model.user.credits{
                vc.credits.append(credit)
            }
            for account in model.user.accounts {
                vc.accounts.append(account)
            }
            vc.model = model
            presentAsSheet(vc)
        }
    }
    
    @IBAction func installmentsClicked(_ sender: Any) {
        if let model = model {
            let vc = InstallmentWindow()
            for installment in model.user.installments{
                vc.installments.append(installment)
            }
            for account in model.user.accounts {
                vc.accounts.append(account)
            }
            vc.model = model
            presentAsSheet(vc)
        }
    }
    
    
    @IBAction func returnClicked(_ sender: Any) {
        self.dismiss(self)
    }
}
