//
//  GenderViewModel.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 25/11/2023.
//
import Foundation

protocol GenderDelegate: AnyObject {
    func showGender(_ gender: Gender)
}

final class GenderViewModel {
    var gender: Gender = .none

    private weak var delegate: GenderDelegate?

    // MARK: - init
    // init for test
    init(delegate: GenderDelegate?) {
        self.delegate = delegate
    }

    func buttonTappedWithGender(_ gender: Gender) {
        self.gender = gender != self.gender ? gender : .none
        delegate?.showGender(self.gender)
    }
}

enum Gender {
    case boy, girl, none

    var description: String {
        switch self {
        case .boy:
            return "Garçon"
        case .girl:
            return "Fille"
        case .none:
            return ""
        }
    }
}
