//
//  Person.swift
//  HallOfFame
//
//  Created by Uzo on 1/23/20.
//  Copyright © 2020 Uzo. All rights reserved.
//

import Foundation

struct Person: Codable {
    let personID: Int?
    let firstName: String
    let lastName: String
    let cohort: String?
    
    enum CodingKeys: String, CodingKey {
        case personID = "person_id"
        case lastName = "last_name"
        case firstName = "first_name"
        case cohort = "cohort"
    }
}
