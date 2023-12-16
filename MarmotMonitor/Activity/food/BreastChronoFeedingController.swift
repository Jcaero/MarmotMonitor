//
//  BreastChronoFeedingController.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 14/12/2023.
//

import Foundation
import UIKit

class BreastChronoFeedingController: UIViewController {
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

    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "Heure du debut"
        label.setupDynamicTextWith(policeName: "Symbol", size: 25, style: .body)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        label.setAccessibility(with: .staticText, label: "heure de la tétée", hint: "")
        return label
    }()

    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()

    let timePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .dateAndTime
        datePicker.maximumDate = Date()
        datePicker.tintColor = .label
        datePicker.backgroundColor = .clear
        datePicker.setAccessibility(with: .selected, label: "", hint: "choisir l'heure de la tétée")
        return datePicker
    }()

    let totalTimeBreastLabel: UILabel = {
        let label = UILabel()
        label.text = "Temps total: 0"
        label.setupDynamicTextWith(policeName: "Symbol", size: 25, style: .body)
        label.textColor = .label
        label.textAlignment = .center
        label.backgroundColor = .duckBlue
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        label.setAccessibility(with: .staticText, label: "", hint: "")
        return label
    }()

    let leftButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.backgroundColor = .duckBlue
        button.tintColor = .black
        return button
    }()

    let rightButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
        button.backgroundColor = .duckBlue
        button.tintColor = .black
        return button
    }()

    let rightTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "Droit\n0 min"
        label.setupDynamicTextWith(policeName: "Symbol", size: 25, style: .body)
        label.textColor = .label
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.setAccessibility(with: .staticText, label: "", hint: "")
        return label
    }()

    let leftTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "Gauche\n0 min"
        label.setupDynamicTextWith(policeName: "Symbol", size: 25, style: .body)
        label.textColor = .label
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.setAccessibility(with: .staticText, label: "", hint: "")
        return label
    }()

    let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillProportionally
        view.spacing = 20
        return view
    }()

    let labelStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillProportionally
        return view
    }()

    // MARK: - PROPERTIES

    // MARK: - Cycle life
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .colorForGradientStart

        setupViews()
        setupContraints()
        setupNavigationBar()

        traitCollectionDidChange(nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        rightButton.layer.cornerRadius = rightButton.frame.width/2
        rightButton.clipsToBounds = true
        leftButton.layer.cornerRadius = leftButton.frame.width/2
        leftButton.clipsToBounds = true
        leftButton.imageView?.contentMode = .scaleAspectFit
    }

    // MARK: - Setup function
    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(scrollArea)

        [timeLabel, timePicker, separator, stackView, labelStackView,leftButton, rightButton].forEach {
            scrollArea.addSubview($0)
        }

        [totalTimeBreastLabel, labelStackView].forEach {
            stackView.addArrangedSubview($0)
        }

        [leftTimeLabel, rightTimeLabel].forEach {
            labelStackView.addArrangedSubview($0)
        }
    }

    private func setupContraints() {
        [timeLabel, timePicker, separator,
         rightButton, rightTimeLabel, leftButton, leftTimeLabel,
         totalTimeBreastLabel,
         scrollArea, scrollView, labelStackView, stackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
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
            timeLabel.topAnchor.constraint(equalTo: scrollArea.topAnchor),
            timeLabel.rightAnchor.constraint(equalTo: scrollArea.rightAnchor, constant: -20),
            timeLabel.leftAnchor.constraint(equalTo: scrollArea.leftAnchor, constant: 20)
        ])

        NSLayoutConstraint.activate([
            timePicker.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 30),
            timePicker.centerXAnchor.constraint(equalTo: scrollArea.centerXAnchor),
            timePicker.leftAnchor.constraint(greaterThanOrEqualTo: scrollArea.leftAnchor, constant: 20)
        ])

        NSLayoutConstraint.activate([
            separator.topAnchor.constraint(equalTo: timePicker.bottomAnchor, constant: 15),
            separator.leftAnchor.constraint(equalTo: totalTimeBreastLabel.leftAnchor, constant: 40),
            separator.rightAnchor.constraint(equalTo: totalTimeBreastLabel.rightAnchor, constant: -40),
            separator.heightAnchor.constraint(equalToConstant: 2)
        ])

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 15),
            stackView.centerXAnchor.constraint(equalTo: scrollArea.centerXAnchor),
            stackView.widthAnchor.constraint(lessThanOrEqualTo: scrollArea.widthAnchor),
            stackView.widthAnchor.constraint(greaterThanOrEqualTo: scrollArea.widthAnchor, multiplier: 0.75),
            totalTimeBreastLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 50)
        ])

        NSLayoutConstraint.activate([
            leftButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 30),
            rightButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 30),
            leftButton.widthAnchor.constraint(equalTo: scrollArea.widthAnchor, multiplier: 0.25),
            rightButton.widthAnchor.constraint(equalTo: scrollArea.widthAnchor, multiplier: 0.25),
            rightButton.heightAnchor.constraint(equalTo: rightButton.widthAnchor),
            leftButton.widthAnchor.constraint(equalTo: leftButton.heightAnchor),
            leftTimeLabel.centerXAnchor.constraint(equalTo: leftButton.centerXAnchor),
            rightTimeLabel.centerXAnchor.constraint(equalTo: rightButton.centerXAnchor),
            leftButton.bottomAnchor.constraint(equalTo: scrollArea.bottomAnchor, constant: -30)
        ])
    }

    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .none
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}
