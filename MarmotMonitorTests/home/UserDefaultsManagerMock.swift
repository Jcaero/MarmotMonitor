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
    private var gender: String?
    private var parentName: String?
    private var birthDay: String?
    private var appIconName: String?
    private var appTheme: Int?
    
    init(mockPerson: Person) {
        self.babyName = mockPerson.name
        self.gender = mockPerson.gender
        self.birthDay = mockPerson.birthDay
        self.parentName = mockPerson.parentName
        self.appIconName = "AppIcon"
        self.appTheme = 0
    }

    // Set Value
    func saveBabyName(_ name: String?) {
        self.babyName = name
    }

    func saveGender(_ gender: MarmotMonitor.Gender) {
        switch gender {
        case .boy:
            self.gender = "Garçon"
        case .girl:
            self.gender = "Fille"
        case .none:
            self.gender = nil
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

    func getGender() -> String? {
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
        return nil
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

