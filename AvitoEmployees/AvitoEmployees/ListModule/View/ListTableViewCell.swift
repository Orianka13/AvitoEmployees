//
//  ListTableViewCell.swift
//  AvitoEmployees
//
//  Created by Олеся Егорова on 24.10.2022.
//

import UIKit

protocol IListTableViewCell {
    func setName(_ name: String)
    func setPhoneNumber(_ phoneNumber: String)
    func setSkills(_ skills: [String])
}

final class ListTableViewCell: UITableViewCell {
    
    static let identifier = "Cell"
    
    private enum Literal {
        static let phoneNumberText = "Phone number: "
        static let skillsText = "Skils: "
    }
    
    private enum Metrics {
        static let standartSpacing: CGFloat = 20
        static let heightOfLabel: CGFloat = 30
        static let topSpacing: CGFloat = 10
    }
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var phoneNumberLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var skillsLabel: UILabel = {
        let label = UILabel()
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
        self.addSubview(nameLabel)
        self.addSubview(phoneNumberLabel)
        self.addSubview(skillsLabel)
    }
    
    private func setupViews() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: Metrics.standartSpacing).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Metrics.standartSpacing).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Metrics.standartSpacing).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: Metrics.heightOfLabel).isActive = true
        
        phoneNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneNumberLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Metrics.topSpacing).isActive = true
        phoneNumberLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Metrics.standartSpacing).isActive = true
        phoneNumberLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Metrics.standartSpacing).isActive = true
        phoneNumberLabel.heightAnchor.constraint(equalToConstant: Metrics.heightOfLabel).isActive = true
        
        skillsLabel.translatesAutoresizingMaskIntoConstraints = false
        skillsLabel.topAnchor.constraint(equalTo: phoneNumberLabel.bottomAnchor, constant: Metrics.topSpacing).isActive = true
        skillsLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Metrics.standartSpacing).isActive = true
        skillsLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Metrics.standartSpacing).isActive = true
        skillsLabel.heightAnchor.constraint(equalToConstant: Metrics.heightOfLabel).isActive = true
    }
}

// MARK: - IListTableViewCell

extension ListTableViewCell: IListTableViewCell {
    
    func setName(_ name: String) {
        self.nameLabel.text = name
    }
    
    func setPhoneNumber(_ phoneNumber: String) {
        self.phoneNumberLabel.text = Literal.phoneNumberText + phoneNumber
    }
    
    func setSkills(_ skills: [String]) {
        let skills = skills.joined(separator: ", ")
        self.skillsLabel.text = Literal.skillsText + skills
    }
}
