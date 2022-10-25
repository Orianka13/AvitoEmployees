//
//  DTOModel.swift
//  AvitoEmployees
//
//  Created by Олеся Егорова on 24.10.2022.
//

import Foundation

struct Company: Decodable {
    
    let company: String
    let name: String
    let employees: [EmployeeData]
    
}

struct EmployeeData: Decodable {
    
    let name: String
    let phoneNumber: String
    let skills: [String]
    
}

