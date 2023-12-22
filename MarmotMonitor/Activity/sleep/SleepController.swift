//
//  SleepController.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 22/12/2023.
//

import UIKit

class SleepController: UIViewController {
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.backgroundColor = .clear
        return scrollView
    }()

    let scrollArea: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    let firstTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "Début du sommeil"
        label.setupDynamicTextWith(policeName: "Symbol", size: 15, style: .body)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        label.setAccessibility(with: .staticText, label: "debut du sommeil", hint: "")
        return label
    }()

    let firstTimePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .dateAndTime
        datePicker.maximumDate = Date()
        datePicker.tintColor = .label
        datePicker.backgroundColor = .clear
        datePicker.setAccessibility(with: .selected, label: "", hint: "choisir l'heure du debut")
        return datePicker
    }()

    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()

    let secondTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "Heure de fin"
        label.setupDynamicTextWith(policeName: "Symbol", size: 15, style: .body)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        label.setAccessibility(with: .staticText, label: "choisir l'heure de fin", hint: "")
        return label
    }()

    let secondTimePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .dateAndTime
        datePicker.maximumDate = Date()
        datePicker.tintColor = .label
        datePicker.backgroundColor = .clear
        datePicker.setAccessibility(with: .selected, label: "", hint: "choisir l'heure de la tétée")
        return datePicker
    }()

    let totalTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "Temps total: 0"
        label.setupDynamicTextWith(policeName: "Symbol", size: 20, style: .body)
        label.textColor = .label
        label.textAlignment = .center
        label.backgroundColor = .duckBlue
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        label.setAccessibility(with: .staticText, label: "temps total en minute", hint: "")
        return label
    }()

    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Annuler", for: .normal)
        button.setTitleColor(.colorForDuckBlueToWhite, for: .normal)
        button.setupDynamicTextWith(policeName: "Symbol", size: 20, style: .body)
        button.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        button.setAccessibility(with: .button, label: "Annuler les informations", hint: "")
        return button
    }()

    let valideButton: UIButton = {
        let button = UIButton()
        button.tintColor = .colorForDuckBlueToWhite
        button.setBackgroundImage(UIImage(systemName: "checkmark"), for: .normal)
        button.setAccessibility(with: .button, label: "valider les informations", hint: "")
        return button
    }()

    // MARK: - PROPERTIES


    // MARK: - Cycle life
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .colorForGradientStart

        setupViews()
        setupContraints()
        setupNavigationBar()

    }

    // MARK: - Setup function
    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(scrollArea)

        [firstTimeLabel, firstTimePicker, secondTimeLabel, secondTimePicker, separator, totalTimeLabel].forEach {
            scrollArea.addSubview($0)
        }

        view.addSubview(cancelButton)
        view.addSubview(valideButton)
    }

    private func setupContraints() {
        [firstTimeLabel, firstTimePicker, secondTimeLabel, secondTimePicker, separator, totalTimeLabel,
         cancelButton, valideButton,
         scrollArea, scrollView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -10),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])

        NSLayoutConstraint.activate([
            scrollArea.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollArea.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10),
            scrollArea.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 10),
            scrollArea.widthAnchor.constraint(equalToConstant: (view.frame.width - 20))
        ])

        NSLayoutConstraint.activate([
            firstTimeLabel.topAnchor.constraint(equalTo: scrollArea.topAnchor, constant: 15),
            firstTimeLabel.rightAnchor.constraint(equalTo: scrollArea.rightAnchor, constant: -20),
            firstTimeLabel.leftAnchor.constraint(equalTo: scrollArea.leftAnchor, constant: 20)
        ])

        NSLayoutConstraint.activate([
            firstTimePicker.topAnchor.constraint(equalTo: firstTimeLabel.bottomAnchor, constant: 30),
            firstTimePicker.centerXAnchor.constraint(equalTo: scrollArea.centerXAnchor),
            firstTimePicker.leftAnchor.constraint(greaterThanOrEqualTo: scrollArea.leftAnchor, constant: 20)
        ])

        NSLayoutConstraint.activate([
            separator.topAnchor.constraint(equalTo: firstTimePicker.bottomAnchor, constant: 15),
            separator.leftAnchor.constraint(equalTo: totalTimeLabel.leftAnchor, constant: 40),
            separator.rightAnchor.constraint(equalTo: totalTimeLabel.rightAnchor, constant: -40),
            separator.heightAnchor.constraint(equalToConstant: 2)
        ])

        NSLayoutConstraint.activate([
            secondTimeLabel.topAnchor.constraint(equalTo: separator.topAnchor, constant: 20),
            secondTimeLabel.rightAnchor.constraint(equalTo: scrollArea.rightAnchor, constant: -20),
            secondTimeLabel.leftAnchor.constraint(equalTo: scrollArea.leftAnchor, constant: 20)
        ])

        NSLayoutConstraint.activate([
            secondTimePicker.topAnchor.constraint(equalTo: secondTimeLabel.bottomAnchor, constant: 30),
            secondTimePicker.centerXAnchor.constraint(equalTo: scrollArea.centerXAnchor),
            secondTimePicker.leftAnchor.constraint(greaterThanOrEqualTo: scrollArea.leftAnchor, constant: 20)
        ])

        NSLayoutConstraint.activate([
            totalTimeLabel.topAnchor.constraint(equalTo: secondTimePicker.bottomAnchor, constant: 30),
            totalTimeLabel.centerXAnchor.constraint(equalTo: scrollArea.centerXAnchor),
            totalTimeLabel.leftAnchor.constraint(greaterThanOrEqualTo: scrollArea.leftAnchor, constant: 20),
            totalTimeLabel.bottomAnchor.constraint(equalTo: scrollArea.bottomAnchor, constant: -30)
        ])

        NSLayoutConstraint.activate([
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            cancelButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20)
        ])

        NSLayoutConstraint.activate([
            valideButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            valideButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            valideButton.widthAnchor.constraint(equalTo: valideButton.heightAnchor),
            valideButton.heightAnchor.constraint(equalTo: cancelButton.heightAnchor)
        ])
    }

    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .none
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

    // MARK: - Action
    @objc private func closeView() {
            self.dismiss(animated: true, completion: nil)
        }

}
