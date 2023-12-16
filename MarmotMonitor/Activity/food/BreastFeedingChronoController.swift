//
//  BreastChronoFeedingController.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 14/12/2023.
//

import Foundation
import UIKit

class BreastFeedingChronoController: UIViewController {
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

    let leftButton: UIButton =  {
        var configuration = UIButton.Configuration.filled()
        configuration.image = UIImage(systemName: "play.fill")!
            .applyingSymbolConfiguration(.init(pointSize: 40))
        configuration.cornerStyle = .capsule
        configuration.baseBackgroundColor = .duckBlue
        configuration.contentInsets = .zero
        let button = UIButton(configuration: configuration)
        button.setAccessibility(with: .button, label: "bouton gauche", hint: "lancer le chrono gauche")
        button.tag = 0
        return button
    }()

    let rightButton: UIButton =  {
        var configuration = UIButton.Configuration.filled()
        configuration.image = UIImage(systemName: "play.fill")!
            .applyingSymbolConfiguration(.init(pointSize: 40))
        configuration.cornerStyle = .capsule
        configuration.baseBackgroundColor = .duckBlue
        configuration.contentInsets = .zero
        let button = UIButton(configuration: configuration)
        button.setAccessibility(with: .button, label: "bouton droit", hint: "lancer le chrono droit")
        button.tag = 1
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
    var viewModel: BreastFeedingChronoViewModel!

    // MARK: - Cycle life
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .colorForGradientStart

        setupViews()
        setupContraints()
        setupNavigationBar()

        traitCollectionDidChange(nil)

        // Delegate
        viewModel = BreastFeedingChronoViewModel(delegate: self)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        setupCornerRadiusOf(rightButton)
        setupCornerRadiusOf(leftButton)
    }

    // MARK: - Setup UIButton
    private func setupCornerRadiusOf(_ button: UIButton) {
        button.layoutIfNeeded()
        button.layer.cornerRadius = button.frame.width/2
        button.clipsToBounds = true
        addActionTo(button)
    }

    private func addActionTo(_ button: UIButton) {
        let action = UIAction { _ in
            button.isSelected.toggle()
            button.configuration?.image = UIImage(systemName: button.isSelected ? "pause.fill" : "play.fill")!
                .applyingSymbolConfiguration(.init(pointSize: 40))
            let position: Position = button.tag == 0 ? .left : .right
            self.viewModel.buttonPressed(position)
        }
        button.addAction(action, for: .touchUpInside)
    }

    // MARK: - Setup function
    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(scrollArea)

        [timeLabel, timePicker, separator, stackView, labelStackView, leftButton, rightButton].forEach {
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

extension BreastFeedingChronoController: BreastFeedingChronoDelegate {
    func updateRightTimeLabel(with text: String) {
        rightTimeLabel.text = "Droit\n" + text
    }

    func updateLeftTimeLabel(with text: String) {
        leftTimeLabel.text = "Gauche\n" + text
    }

    func updateTotalTimeLabel(with text: String) {
        totalTimeBreastLabel.text = "Temps Total : " + text
    }
}
