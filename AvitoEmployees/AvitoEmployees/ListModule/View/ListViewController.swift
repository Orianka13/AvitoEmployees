//
//  ListViewController.swift
//  AvitoEmployees
//
//  Created by Олеся Егорова on 24.10.2022.
//

import UIKit

class ListViewController: UIViewController {
    
    private enum Metrics {
        static let cellHeight: CGFloat = 150
    }
    
    private enum Literal {
        static let navigationBarTitle = "Avito employees"
    }
    
    private var employees: [Employee] = []

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
                    let model = Employee(name: employee.name,
                                         phoneNumber: employee.phoneNumber,
                                         skills: employee.skills)
                    self?.employees.append(model)
                    
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                }
                
            case .failure(let error):
                print("[NETWORK] error is: \(error)")
//                DispatchQueue.main.async {
//                    print("Загрузка закончена с ошибкой \(error.localizedDescription)")
//                }
            }
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
