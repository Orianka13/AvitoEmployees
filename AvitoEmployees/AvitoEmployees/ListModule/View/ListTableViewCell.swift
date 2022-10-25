//
//  ListTableViewCell.swift
//  AvitoEmployees
//
//  Created by Олеся Егорова on 24.10.2022.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    static let identifier = "Cell"
    
    private enum Literal {
        static let phoneNumberText = "Phone number: "
        static let skilsText = "Skils: "
    }
    
    private enum Metrics {
        static let standartSpacing: CGFloat = 20
        static let heightOfLabel: CGFloat = 30
        static let topSpacing: CGFloat = 10
    }
    
    private lazy var name: UILabel = {
        let label = UILabel()
        label.text = "Name"
        return label
    }()
    
    private lazy var phoneNumber: UILabel = {
        let label = UILabel()
        label.text = Literal.phoneNumberText
        return label
    }()
    
    private lazy var skils: UILabel = {
        let label = UILabel()
        label.text = Literal.skilsText
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addViews()
        setupViews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func addViews() {
        self.addSubview(name)
        self.addSubview(phoneNumber)
        self.addSubview(skils)
    }
    
    private func setupViews() {
        name.translatesAutoresizingMaskIntoConstraints = false
        name.topAnchor.constraint(equalTo: self.topAnchor, constant: Metrics.standartSpacing).isActive = true
        name.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Metrics.standartSpacing).isActive = true
        name.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Metrics.standartSpacing).isActive = true
        name.heightAnchor.constraint(equalToConstant: Metrics.heightOfLabel).isActive = true
        
        phoneNumber.translatesAutoresizingMaskIntoConstraints = false
        phoneNumber.topAnchor.constraint(equalTo: name.bottomAnchor, constant: Metrics.topSpacing).isActive = true
        phoneNumber.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Metrics.standartSpacing).isActive = true
        phoneNumber.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Metrics.standartSpacing).isActive = true
        phoneNumber.heightAnchor.constraint(equalToConstant: Metrics.heightOfLabel).isActive = true
        
        skils.translatesAutoresizingMaskIntoConstraints = false
        skils.topAnchor.constraint(equalTo: phoneNumber.bottomAnchor, constant: Metrics.topSpacing).isActive = true
        skils.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Metrics.standartSpacing).isActive = true
        skils.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Metrics.standartSpacing).isActive = true
        skils.heightAnchor.constraint(equalToConstant: Metrics.heightOfLabel).isActive = true
    }
}
