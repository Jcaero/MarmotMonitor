//
//  InformationViewModel.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 05/02/2024.
//

import Foundation
class InformationViewModel {
    private let userDefaultsManager: UserDefaultManagerProtocol!

    var babyName: String = ""
    var parentName: String = ""
    var birthDay: String = ""
    var gender: String = ""

    init(userDefaultsManager: UserDefaultManagerProtocol = UserDefaultsManager()) {
        self.userDefaultsManager = userDefaultsManager
    }

    func getUserInformation() {
        babyName = userDefaultsManager.getBabyName() ?? "Entrer le nom"
        birthDay = userDefaultsManager.getBirthDay() ?? "JJ/MM/YYYY"
        parentName = userDefaultsManager.getParentName() ?? "Entrer le nom du parent"
        gender = userDefaultsManager.getGender().description
    }

    func saveUserInformation(person: Person, completionHandler: @escaping (Result<Void, ErrorSetting>) -> Void) {
        let babyName = person.name
        if babyName != "" && babyName != nil {
            if babyName!.isLengthValidAndOnlyLetters {
                userDefaultsManager.saveBabyName(babyName)
            } else {
                completionHandler(.failure(.invalideNameLength))
                return
            }
        }

        let birthDay = person.birthDay
        if birthDay != "" {
            saveDate(birthDay) { result in
                switch result {
                case .success:
                    break
                case .failure(let error):
                    completionHandler(.failure(error))
                    return
                }
            }
        }

        let parentName = person.parentName
        if parentName != "" {
            userDefaultsManager.saveParentName(parentName)
        }

        userDefaultsManager.saveGender(person.gender ?? .none)
        completionHandler(.success(()))
    }

    /// Transform the date in the correct format
    /// - Parameter dateString: the date to transform
    /// - Returns: the date in the correct format and an error if there is one
    private func saveDate(_ dateString: String?, completionHandler: @escaping (Result<Void, ErrorSetting>) -> Void) {
        guard let dateString = dateString, let date = dateString.toDate() else {
            completionHandler(.failure(.invalidDateFormat))
            return
        }

        if date > Date() {
            completionHandler(.failure(.invalidDateBirth))
            return
        }

        let birthDayDate = date.toStringWithDayMonthYear()
        userDefaultsManager.saveDateOfBirth(birthDayDate)
        completionHandler(.success(()))
    }
}
