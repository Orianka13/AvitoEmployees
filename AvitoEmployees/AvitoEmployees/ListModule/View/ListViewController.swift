//
//  ListViewController.swift
//  AvitoEmployees
//
//  Created by Олеся Егорова on 24.10.2022.
//

import UIKit
import CoreData

class ListViewController: UIViewController {
    
    private enum Metrics {
        static let cellHeight: CGFloat = 150
    }
    
    private enum Literal {
        static let navigationBarTitle = "Avito employees"
        static let alertMessage = "Getting data ended with an error \n"
        static let alertTitle = "Error"
        static let alertAction = "Ok"
        static let employeeEntityName = "Employee"
    }
    
    private var employees: [EmployeeModel] = []
    private let coreDS = CoreDataStack()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = Literal.navigationBarTitle
        
        loadDataNetwork()
    }
    
    private func loadDataNetwork() {
        let network = NetworkManager()
        let url = network.getUrl()
        
        network.loadData(url: url) { [weak self] (result: Result<DTOModel, Error>) in
            switch result {
            case .success(let model):
                
                let company = model.company
                let employees = company.employees
                employees.forEach { employee in
                    let model = EmployeeModel(name: employee.name,
                                         phoneNumber: employee.phoneNumber,
                                         skills: employee.skills)
                    self?.employees.append(model)
                    
                    self?.saveEmployee(name: employee.name,
                                       phoneNumber: employee.phoneNumber,
                                       skills: employee.skills)
                    
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(message: Literal.alertMessage + error.localizedDescription)
                }
            }
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: Literal.alertTitle, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: Literal.alertAction, style: .default)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    private func getContext() -> NSManagedObjectContext {
        coreDS.persistentContainer.viewContext
    }
    
    private func saveEmployee(name: String, phoneNumber: String, skills: [String]) {
        let context = getContext()
        guard let entity = NSEntityDescription.entity(forEntityName: Employee.description(), in: context) else { return }
        let taskObject = Employee(entity: entity, insertInto: context)
        taskObject.name = name
        taskObject.phoneNumber = phoneNumber
        taskObject.skills = skills
        
        do {
            try context.save()
            DispatchQueue.main.async { [weak self] in
                self?.showAlert(message: "Data saved!")
            }
        } catch let error as NSError {
            DispatchQueue.main.async { [weak self] in
                self?.showAlert(message: error.localizedDescription)
            }
            
            //print(error.localizedDescription)
        }
    }
}



//MARK: - UITableViewDelegate, UITableViewDataSource

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        employees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as! ListTableViewCell
        
        let sortedEmployee = self.employees.sorted(by: { $0.name < $1.name })
        let employee = sortedEmployee[indexPath.row]
        
        cell.setName(employee.name)
        cell.setPhoneNumber(employee.phoneNumber)
        
        cell.setSkills(employee.skills)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Metrics.cellHeight
    }
}
