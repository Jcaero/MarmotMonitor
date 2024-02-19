//
//  UserDefaultsManagerMock.swift
//  MarmotMonitorTests
//
//  Created by pierrick viret on 06/01/2024.
//


import UIKit
@testable import MarmotMonitor

final class UserDefaultsManagerMock: UserDefaultManagerProtocol {
    
    private var babyName: String?
    private var gender: Gender
    private var parentName: String?
    private var birthDay: String?
    private var appIconName: String?
    private var appTheme: Int?
    private var graphType: GraphType?
    
    init(mockPerson: Person, iconName: String? = nil, graphType: GraphType? = nil, appTheme: Int? = nil) {
        self.babyName = mockPerson.name
        self.gender = mockPerson.gender ?? .none
        self.birthDay = mockPerson.birthDay
        self.parentName = mockPerson.parentName
        self.appIconName = iconName ?? nil
        self.appTheme = appTheme ?? 0
        self.graphType = graphType
    }

    // Set Value
    func saveBabyName(_ name: String?) {
        self.babyName = name
    }

    func saveGender(_ gender: MarmotMonitor.Gender) {
        switch gender {
        case .boy:
            self.gender = .boy
        case .girl:
            self.gender = .girl
        case .none:
            self.gender = .none
        }
    }

    func saveParentName(_ name: String?) {
        self.parentName = name
    }

    func saveDateOfBirth(_ date: String?) {
        self.birthDay = date
    }

    // Get Value
    func getBabyName() -> String? {
        return babyName
    }
 
    func getGender() -> MarmotMonitor.Gender {
        return gender
    }

    func getParentName() -> String? {
        return parentName
    }

    func getBirthDay() -> String? {
        return birthDay
    }

    func saveAppIconName(_ name: String) {
        self.appIconName = name
    }
    
    func saveApparenceSetting(_ type: UIUserInterfaceStyle) {
        self.appTheme = type.rawValue
    }
    
    func getGraphType() -> MarmotMonitor.GraphType? {
        return self.graphType
    }
    
    func getAppIconName() -> String? {
        return self.appIconName
    }
    
    func getApparenceSetting() -> UIUserInterfaceStyle {
        guard let appTheme = appTheme else { return .unspecified }
        return UIUserInterfaceStyle(rawValue: appTheme) ?? .unspecified
    }
    
    func saveGraphType(_ graphType: MarmotMonitor.GraphType) {
    }
    
    func getGraphType() -> String? {
        return nil
    }
}

