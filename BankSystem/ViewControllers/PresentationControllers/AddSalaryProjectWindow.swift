//
//  AddSalaryProjectWindow.swift
//  BankSystem
//
//  Created by Maria Zyryanova on 21.04.22.
//

import Cocoa

class AddSalaryProjectWindow: NSViewController {

    var salaryProjects = [SalaryProject]()
    var model: CompanySpecialistModel?
    
    @IBOutlet var table: NSTableView!
    
    @IBOutlet var titleTF: NSTextField!
    @IBOutlet var descriptionTF: NSTextField!
    @IBOutlet var sumTF: NSTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
        // Do view setup here.
    }
    
    convenience init(){
        self.init(nibName: "AddSalaryProjectWindow", bundle: nil)
    }
    
    @IBAction func appendClicked(_ sender: Any) {
        
        guard let model = model else {return}
        
        if titleTF.stringValue != "" && descriptionTF.stringValue != "" && sumTF.stringValue != ""{
            model.addSalaryProject(titleTF.stringValue, descriptionTF.stringValue, sumTF.doubleValue)
            let vc = InfoWindow()
            vc.content = "Salary project added"
            presentAsSheet(vc)
            model.updateSalaryProjects()
            salaryProjects = model.company.salaryProjects
            table.reloadData()
        }
    }
    
    @IBAction func removeClicked(_ sender: Any) {
        
        guard let model = model else {return}
        
        if table.selectedRow != -1{
            model.removeSalaryProject(salaryProjects[table.selectedRow])
            let vc = InfoWindow()
            vc.content = "Salary project removed"
            presentAsSheet(vc)
            model.updateSalaryProjects()
            salaryProjects = model.company.salaryProjects
            table.reloadData()
        }
    }
    
    @IBAction func infoClicked(_ sender: Any) {
        if table.selectedRow != -1{
            let vc = InfoWindow()
            vc.content = salaryProjects[table.selectedRow].info()
            presentAsSheet(vc)
        }
    }
    
    @IBAction func returnClicked(_ sender: Any) {
        self.dismiss(self)
    }

}

extension AddSalaryProjectWindow: NSTableViewDelegate, NSTableViewDataSource{
    func numberOfRows(in tableView: NSTableView) -> Int {
        return salaryProjects.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return salaryProjects[row].title
    }
}
