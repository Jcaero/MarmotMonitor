//
//  TodayViewController.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 19/11/2023.
//

import UIKit

class TodayViewController: UIViewController {

    private var babyView: UIButton = {
        let button = UIButton()
        button.backgroundColor = .lightGray
        button.setImage(UIImage(named: "todayDefault"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.imageView?.clipsToBounds = true
        button.layer.cornerRadius = 10
        return button
    }()

    private var babyName: UILabel = {
        let label = UILabel()
        label.text = "Baby Name"
        label.font = UIFont(name: "Courier New", size: 30)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    private var babyYear: UILabel = {
        let label = UILabel()
        label.text = "Baby Year"
        label.font = UIFont(name: "Courier New", size: 20)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    private var babyMonth: UILabel = {
        let label = UILabel()
        label.text = "Baby Month"
        label.font = UIFont(name: "Courier New", size: 20)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    // MARK: - Cycle of life
    override func viewDidLoad() {
        setupView()
        setupContraints()

        setupBabyView()
    }

    // MARK: - Function
    private func setupView() {
        view.addSubview(babyView)
        view.addSubview(babyName)
        view.addSubview(babyYear)
        view.addSubview(babyMonth)
    }

    private func setupContraints() {
        [babyView, babyName, babyYear, babyMonth].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            babyView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            babyView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            babyView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            babyView.heightAnchor.constraint(equalToConstant: view.frame.height / 2)
        ])

        NSLayoutConstraint.activate([
        babyName.leftAnchor.constraint(equalTo: babyView.leftAnchor, constant: 10),
        babyName.topAnchor.constraint(equalTo: babyView.topAnchor, constant: 10)
        ])

        NSLayoutConstraint.activate([
        babyYear.bottomAnchor.constraint(equalTo: babyView.bottomAnchor, constant: -10),
        babyYear.leftAnchor.constraint(equalTo: babyView.leftAnchor, constant: 10)
        ])

        NSLayoutConstraint.activate([
            babyMonth.bottomAnchor.constraint(equalTo: babyView.bottomAnchor, constant: -10),
            babyMonth.rightAnchor.constraint(equalTo: babyView.rightAnchor, constant: -10)
        ])
    }

    private func setupBabyView() {
        setupAction()

        addGradientToButton(babyView)
    }

    // MARK: - Gesture of BabyView
    private func setupAction() {
        let tapAction = UIAction { [weak self] action in
            self?.tappedButton(action.sender as? UIButton ?? UIButton())
        }
        babyView.addAction(tapAction, for: .touchUpInside)

        let holdAction = UIAction { [weak self] action in
            self?.holdDown(action.sender as? UIButton ?? UIButton())
        }
        babyView.addAction(holdAction, for: .touchDown)
    }

    private func tappedButton(_ sender: UIButton) {
        sender.transform = .identity
        sender.layer.shadowOpacity = 0.5
    }

    private func holdDown(_ sender: UIButton) {
        sender.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        sender.layer.shadowOpacity = 0
    }

    // MARK: - GradientLayer
    private func addGradientToButton(_ button: UIButton) {
        guard let imageView = button.imageView else { return }

        let gradient = CAGradientLayer()
        gradient.frame = imageView.bounds
        gradient.colors = [UIColor.black.cgColor, UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient.locations = [0.0, 0.25, 0.8, 1.0]

        imageView.layer.insertSublayer(gradient, at: 0)
    }
}
