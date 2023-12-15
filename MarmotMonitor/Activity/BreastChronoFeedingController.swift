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

    let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Annuler", for: .normal)
        button.setTitleColor(.duckBlue, for: .normal)
        button.setupDynamicTextWith(policeName: "Symbol", size: 25, style: .body)
        return button
    }()

    let valideButton: UIButton = {
        let button = UIButton()
        button.tintColor = .duckBlue
        button.setBackgroundImage(UIImage(systemName: "checkmark"), for: .normal)
        return button
    }()

    let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillProportionally
        view.spacing = 20
        return view
    }()

    // MARK: - PROPERTIES

    // MARK: - Cycle life
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .colorForGradientStart

        setupViews()
        setupContraints()
        setupButton()
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

        [timeLabel, timePicker, separator, totalTimeBreastLabel, rightButton, rightTimeLabel, leftButton, leftTimeLabel, valideButton, cancelButton].forEach {
            scrollArea.addSubview($0)
        }
    }

    private func setupContraints() {
        [timeLabel, timePicker, separator,
         rightButton, rightTimeLabel, leftButton, leftTimeLabel,
         valideButton, cancelButton, totalTimeBreastLabel,
         scrollArea, scrollView].forEach {
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
            timeLabel.topAnchor.constraint(equalTo: scrollArea.topAnchor, constant: view.frame.height/20),
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
            totalTimeBreastLabel.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 15),
            totalTimeBreastLabel.centerXAnchor.constraint(equalTo: scrollArea.centerXAnchor),
            totalTimeBreastLabel.widthAnchor.constraint(lessThanOrEqualTo: scrollArea.widthAnchor),
            totalTimeBreastLabel.widthAnchor.constraint(greaterThanOrEqualTo: scrollArea.widthAnchor, multiplier: 0.75),
            totalTimeBreastLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 50)
        ])

        NSLayoutConstraint.activate([
            rightTimeLabel.topAnchor.constraint(equalTo: totalTimeBreastLabel.bottomAnchor, constant: 30),
            rightTimeLabel.leftAnchor.constraint(equalTo: scrollArea.centerXAnchor),
            rightTimeLabel.rightAnchor.constraint(equalTo: scrollArea.rightAnchor, constant: -20)
        ])

        NSLayoutConstraint.activate([
            leftTimeLabel.topAnchor.constraint(equalTo: rightTimeLabel.topAnchor),
            leftTimeLabel.leftAnchor.constraint(equalTo: scrollArea.leftAnchor, constant: 20),
            leftTimeLabel.rightAnchor.constraint(equalTo: scrollArea.centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            rightButton.topAnchor.constraint(greaterThanOrEqualTo: rightTimeLabel.bottomAnchor, constant: 20),
            rightButton.topAnchor.constraint(greaterThanOrEqualTo: leftTimeLabel.bottomAnchor, constant: 20),
            rightButton.centerXAnchor.constraint(equalTo: rightTimeLabel.centerXAnchor),
            rightButton.heightAnchor.constraint(equalTo: rightButton.widthAnchor),
            rightButton.widthAnchor.constraint(equalTo: scrollArea.widthAnchor, multiplier: 0.25)
        ])

        NSLayoutConstraint.activate([
            leftButton.topAnchor.constraint(equalTo: rightButton.topAnchor),
            leftButton.centerXAnchor.constraint(equalTo: leftTimeLabel.centerXAnchor),
            leftButton.heightAnchor.constraint(equalTo: leftButton.widthAnchor),
            leftButton.widthAnchor.constraint(equalTo: rightButton.widthAnchor)
        ])

        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: valideButton.topAnchor),
            cancelButton.leftAnchor.constraint(equalTo: scrollArea.leftAnchor),
            cancelButton.rightAnchor.constraint(equalTo: scrollArea.centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            valideButton.topAnchor.constraint(greaterThanOrEqualTo: leftButton.bottomAnchor, constant: 30),
            valideButton.topAnchor.constraint(greaterThanOrEqualTo: scrollArea.topAnchor, constant: view.frame.height*0.65),
            valideButton.centerXAnchor.constraint(equalTo: rightButton.centerXAnchor),
            valideButton.widthAnchor.constraint(equalTo: valideButton.heightAnchor),
            valideButton.heightAnchor.constraint(equalTo: cancelButton.heightAnchor),
            valideButton.bottomAnchor.constraint(equalTo: scrollArea.bottomAnchor, constant: -30)
        ])
    }

    private func setupButton() {
        let action = UIAction { _ in
            self.dismiss(animated: true, completion: nil)
        }
        cancelButton.addAction(action, for: .touchUpInside)
    }

    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .none
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}

// MARK: - Picker Acessibility
extension BreastChronoFeedingController: UIPickerViewAccessibilityDelegate {

    /// Update the display when the user change the size of the text in the settings
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        let currentCategory = traitCollection.preferredContentSizeCategory
        let previousCategory = previousTraitCollection?.preferredContentSizeCategory

        guard currentCategory != previousCategory else { return }
        let isAccessibilityCategory = currentCategory.isAccessibilityCategory
        cancelButton.setupDynamicTextWith(policeName: "Symbol", size: isAccessibilityCategory ? 15 : 25, style: .body)
    }
}
