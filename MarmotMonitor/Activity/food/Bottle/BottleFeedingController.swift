//
//  BottleFeedingController.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 17/12/2023.
//

import UIKit

class BottleFeedingController: ActivityController, BottleFeedingDelegate {
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

    // MARK: - PROPERTIES
    var viewModel : BottleFeedingViewModel!

    // MARK: - Cycle life
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = BottleFeedingViewModel(delegate: self)

        setupViews()
        setupContraints()

        setupTimePickerAndLabel()
        setupValideButton()

        traitCollectionDidChange(nil)
    }

    // MARK: - Setup function
    private func setupViews() {
        [volumeOfMilkLabel, volumeSlider].forEach {
            scrollArea.addSubview($0)
        }
    }

    private func setupContraints() {
        [volumeOfMilkLabel, volumeSlider].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

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
    }

    private func setupTimePickerAndLabel() {
        timeLabel.text = "Heure du biberon"
        timeLabel.setAccessibility(with: .staticText, label: "heure du biberon", hint: "")

        timePicker.setAccessibility(with: .selected, label: "", hint: "choisir l'heure du biberon")
    }

    private func setupValideButton() {
        valideButton.setAccessibility(with: .button, label: "Valider", hint: "Valider le choix de la couche")
        valideButton.addTarget(self, action: #selector(valideButtonSet), for: .touchUpInside)
    }

    @objc func valideButtonSet() {
        viewModel.saveBottle(at: timePicker.date)
    }

    // MARK: - Actions
    @objc func sliderValueDidChange(_ sender:UISlider!) {
        let roundedStepValue = round(sender.value / 5) * 5
        let value = Int(roundedStepValue)
        viewModel.setQuantity(value)
        volumeOfMilkLabel.text = "Volume: \(value) ml"
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
