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
    private let network = NetworkManager()
    
    private var employees: [Employee] = []

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Avito employees"
        loadDataNetwork()
    }
    
    func loadDataNetwork() {
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
                    
                    print("\(model.name) добавлен в сотрудники!")
                    
                    DispatchQueue.main.async {
                     //вызвать метод по обновлению вьюшек
                    }
                }
                
            case .failure(let error):
                print("[NETWORK] error is: \(error)")
                DispatchQueue.main.async {
                    print("Загрузка закончена с ошибкой \(error.localizedDescription)")
                }
            }
        }
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as! ListTableViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Metrics.cellHeight
    }
}
