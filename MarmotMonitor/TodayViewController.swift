//
//  TodayViewController.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 19/11/2023.
//

import UIKit

class TodayViewController: UIViewController {

    private var babyView: UIView = {
       let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 10
        return view
    }()

    private var babyName: UILabel = {
        let label = UILabel()
        label.text = "Baby Name"
        label.font = UIFont(name: "Courier New", size: 20)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    private var babyYear: UILabel = {
        let label = UILabel()
        label.text = "Baby Year"
        label.font = UIFont(name: "Courier New", size: 20)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    private var babyMonth: UILabel = {
        let label = UILabel()
        label.text = "Baby Month"
        label.font = UIFont(name: "Courier New", size: 20)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    // MARK: - Proprietie
    private let viewModel = TodayViewModel()

    // MARK: - Cycle of life
    override func viewDidLoad() {
        setupView()
        setupContraints()
    }

    // MARK: - Function

    private func setupView() {
        view.addSubview(babyView)
        babyView.addSubview(babyName)
        babyView.addSubview(babyYear)
        babyView.addSubview(babyMonth)
    }

    private func setupContraints() {
        [babyView, babyName, babyYear, babyMonth].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            babyView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            babyView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            babyView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            babyView.heightAnchor.constraint(greaterThanOrEqualToConstant: 150)
        ])

        NSLayoutConstraint.activate([
        babyName.leftAnchor.constraint(equalTo: babyView.leftAnchor, constant: 10),
        babyName.topAnchor.constraint(equalTo: babyView.topAnchor, constant: 10)
        ])

        NSLayoutConstraint.activate([
        babyYear.bottomAnchor.constraint(equalTo: babyView.bottomAnchor, constant: -10),
        babyName.leftAnchor.constraint(equalTo: babyView.leftAnchor, constant: 10)
        ])

        NSLayoutConstraint.activate([
            babyMonth.bottomAnchor.constraint(equalTo: babyView.bottomAnchor, constant: -10),
            babyMonth.rightAnchor.constraint(equalTo: babyView.rightAnchor, constant: -10)
            ])
    }
}
