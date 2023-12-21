//
//  BottleFeedingController.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 17/12/2023.
//

import Foundation
import UIKit

class BottleFeedingController: UIViewController {
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
        label.text = "Heure du biberon"
        label.setupDynamicTextWith(policeName: "Symbol", size: 25, style: .body)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        label.setAccessibility(with: .staticText, label: "heure du biberon", hint: "")
        return label
    }()

    let timePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .dateAndTime
        datePicker.maximumDate = Date()
        datePicker.tintColor = .label
        datePicker.backgroundColor = .clear
        datePicker.setAccessibility(with: .selected, label: "", hint: "choisir l'heure du biberon")
        return datePicker
    }()

    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()

    let volumeOfMilkLabel: UILabel = {
        let label = UILabel()
        label.text = "Volume: 0"
        label.setupDynamicTextWith(policeName: "Symbol", size: 20, style: .body)
        label.textColor = .label
        label.textAlignment = .center
        label.backgroundColor = .duckBlue
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        label.setAccessibility(with: .staticText, label: "volume du lait", hint: "")
        return label
    }()

    lazy var volumeSlider: UISlider = {
        let slider = UISlider()
        slider.maximumValue = 400
        slider.minimumValue = 0
        slider.maximumTrackTintColor = .label
        slider.tintColor = .duckBlue
        slider.minimumTrackTintColor = .duckBlue
        slider.thumbTintColor = .colorForDuckBlueToWhite
        slider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
        slider.setAccessibility(with: .adjustable, label: "volume du lait", hint: "")
        return slider
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

        traitCollectionDidChange(nil)

    }

    // MARK: - Setup function
    private func setupViews() {
        [scrollView, cancelButton, valideButton].forEach {
            view.addSubview($0)
        }

        scrollView.addSubview(scrollArea)

        [timeLabel, timePicker, separator, volumeOfMilkLabel, volumeSlider].forEach {
            scrollArea.addSubview($0)
        }
    }

    private func setupContraints() {
        [timeLabel, timePicker, separator,
         volumeOfMilkLabel, volumeSlider,
         scrollArea, scrollView,
         cancelButton, valideButton].forEach {
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
            timeLabel.topAnchor.constraint(equalTo: scrollArea.topAnchor),
            timeLabel.rightAnchor.constraint(equalTo: scrollArea.rightAnchor, constant: -20),
            timeLabel.leftAnchor.constraint(equalTo: scrollArea.leftAnchor, constant: 20)
        ])

        NSLayoutConstraint.activate([
            timePicker.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 20),
            timePicker.centerXAnchor.constraint(equalTo: scrollArea.centerXAnchor),
            timePicker.leftAnchor.constraint(greaterThanOrEqualTo: scrollArea.leftAnchor, constant: 20)
        ])

        NSLayoutConstraint.activate([
            separator.topAnchor.constraint(equalTo: timePicker.bottomAnchor, constant: 30),
            separator.leftAnchor.constraint(equalTo: volumeOfMilkLabel.leftAnchor, constant: 40),
            separator.rightAnchor.constraint(equalTo: volumeOfMilkLabel.rightAnchor, constant: -40),
            separator.heightAnchor.constraint(equalToConstant: 2)
        ])

        NSLayoutConstraint.activate([
            volumeOfMilkLabel.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 30),
            volumeOfMilkLabel.centerXAnchor.constraint(equalTo: scrollArea.centerXAnchor),
            volumeOfMilkLabel.widthAnchor.constraint(equalTo: scrollArea.widthAnchor, multiplier: 0.75),
            volumeOfMilkLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 50)
        ])

        NSLayoutConstraint.activate([
            volumeSlider.topAnchor.constraint(equalTo: volumeOfMilkLabel.bottomAnchor, constant: 30),
            volumeSlider.leftAnchor.constraint(equalTo: volumeOfMilkLabel.leftAnchor),
            volumeSlider.rightAnchor.constraint(equalTo: volumeOfMilkLabel.rightAnchor),
            volumeSlider.bottomAnchor.constraint(equalTo: scrollArea.bottomAnchor, constant: -30)
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

    // MARK: - Actions
    @objc func sliderValueDidChange(_ sender:UISlider!) {
            // Use this code below only if you want UISlider to snap to values step by step
            let roundedStepValue = round(sender.value / 5) * 5
            volumeOfMilkLabel.text = "Volume: \(Int(roundedStepValue)) ml"
        }

    @objc private func closeView() {
            self.dismiss(animated: true, completion: nil)
        }

}

// MARK: - accessibility
extension BottleFeedingController {
    /// Update the display when the user change the size of the text in the settings
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        let currentCategory = traitCollection.preferredContentSizeCategory
        let previousCategory = previousTraitCollection?.preferredContentSizeCategory

        guard currentCategory != previousCategory else { return }
        let isAccessibilityCategory = currentCategory.isAccessibilityCategory
        timeLabel.text = isAccessibilityCategory ? "Heure" : "Heure du biberon"
    }
}
