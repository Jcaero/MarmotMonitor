//
//  UserDefault+.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 25/11/2023.
//

import Foundation

enum UserInfoKey: String {
    case babyName, gender, parentName, birthDay, graphType

    var rawValue: String {
        switch self {
        case .babyName:
            return "babyName"
        case .gender:
            return "gender"
        case .parentName:
            return "parentName"
        case .birthDay:
            return "birthDay"
        case .graphType:
            return "graphType"
        }
    }
}
