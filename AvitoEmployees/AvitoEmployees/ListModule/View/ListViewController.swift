//
//  ListViewController.swift
//  AvitoEmployees
//
//  Created by Олеся Егорова on 24.10.2022.
//

import UIKit
import CoreData

final class ListViewController: UIViewController {
    
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
    private var employeesCD: [Employee] = []
    private let coreDS = CoreDataStack()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = Literal.navigationBarTitle
        
        fetchData()
        if employees.isEmpty {
            loadDataNetwork()
            deleteCashFromeCD()
        }
    }
}

// MARK: - Private extension
private extension ListViewController {
    
    func fetchData() {
        let context = coreDS.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Employee> = Employee.fetchRequest()
        
        do {
            employeesCD = try context.fetch(fetchRequest)
            var fetchedEmployees = [EmployeeModel]()
            
            employeesCD.forEach { employee in
                guard let name = employee.name else { return }
                guard let phoneNumber = employee.phoneNumber else { return }
                guard let skills = employee.skills else { return }
                
                let modelObject = EmployeeModel(name: name,
                                                      phoneNumber: phoneNumber,
                                                      skills: skills)
                fetchedEmployees.append(modelObject)
            }
            employees = fetchedEmployees
            
            if !fetchedEmployees.isEmpty {
                deleteCashFromeCD()
            }
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        } catch let error as NSError {
            DispatchQueue.main.async { [weak self] in
                self?.showAlert(message: Literal.alertMessage + error.localizedDescription)
            }
        }
    }
    
    func loadDataNetwork() {
        let network = NetworkManager()
        let url = network.getUrl()
        
        network.loadData(url: url) { [weak self] (result: Result<DTOModel, Error>) in
            switch result {
            case .success(let model):
                let company = model.company
                let employees = company.employees
                employees.forEach { employee in
                    let loadedEmployee = EmployeeModel(name: employee.name,
                                         phoneNumber: employee.phoneNumber,
                                         skills: employee.skills)
                    
                    self?.employees.append(loadedEmployee)
                    
                    self?.coreDS.saveEmployee(name: employee.name,
                                              phoneNumber: employee.phoneNumber,
                                              skills: employee.skills,
                                              doCompletion: { taskObject in
                        self?.employeesCD.append(taskObject)
                    }, errorCompletion: { error in
                        DispatchQueue.main.async {
                            self?.showAlert(message: Literal.alertMessage + error.localizedDescription)
                        }
                    })
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
    
    func deleteCashFromeCD() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3600) { [weak self] in
            self?.coreDS.remove {
                self?.fetchData()
            }
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: Literal.alertTitle, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: Literal.alertAction, style: .default)
        alert.addAction(action)
        self.present(alert, animated: true)
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
