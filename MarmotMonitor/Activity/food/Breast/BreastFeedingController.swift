//
//  breastfeedingViewController.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 09/12/2023.
//

import UIKit

final class BreastFeedingController: ActivityController {
    /// BreastFeedingController
    /// This class is used to set the Breast time
    /// The user can put the time of the breast with
    /// - set timer
    /// - set manually
    let totalTimeBreastLabel: UILabel = {
        let label = UILabel()
        label.text = "Temps total: 0"
        label.setupDynamicTextWith(policeName: "Symbol", size: 20, style: .body)
        label.textColor = .label
        label.textAlignment = .center
        label.setAccessibility(with: .staticText, label: "temps total en minute", hint: "")
        return label
    }()

    let leftButton: UIButton =  {
        let button = UIButton()
        button.createTimerPlayBreastButton()
        button.setAccessibility(with: .button, label: "bouton gauche", hint: "lancer le chrono gauche")
        button.tag = 0
        return button
    }()

    let rightButton: UIButton =  {
        let button = UIButton()
        button.createTimerPlayBreastButton()
        button.setAccessibility(with: .button, label: "bouton droit", hint: "lancer le chrono droit")
        button.tag = 1
        return button
    }()

    let rightTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "Droit\n0 min"
        label.setupDynamicTextWith(policeName: "Symbol", size: 20, style: .body)
        label.textColor = .label
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.setAccessibility(with: .staticText, label: "0", hint: "temps sur le sein droit")
        return label
    }()

    let leftTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "Gauche\n0 min"
        label.setupDynamicTextWith(policeName: "Symbol", size: 20, style: .body)
        label.textColor = .label
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.setAccessibility(with: .staticText, label: "0", hint: "temps sur le sein gauche")
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

    let rightManuallyInput: UIButton =  {
        let button = UIButton()
        button.createBreastManuallyButton()
        return button
    }()

    let leftManuallyInput: UIButton =  {
        let button = UIButton()
        button.createBreastManuallyButton()
        return button
    }()

    // MARK: - PROPERTIES
    var viewModel: BreastFeedingChronoViewModel!

    private var buttonSelected: Position = .left

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
        addActionTo(rightButton)
        addActionTo(leftButton)

        setupManuallyAction()

        setupTimePickerAndLabel()
        setupValideButton()
    }

        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)

            setupCornerRadiusOf(rightButton)
            setupCornerRadiusOf(leftButton)
        }

    private func setupTimePickerAndLabel() {
        timeLabel.text = "Tété"
        timeLabel.setAccessibility(with: .staticText, label: "Tété", hint: "Page pour remplir l'allaitement")

        timePicker.setAccessibility(with: .selected, label: "", hint: "choisir heure de la tétée")
    }

    private func setupValideButton() {
        valideButton.setAccessibility(with: .button, label: "Valider", hint: "Valider la valeur de la tétée")
        valideButton.addTarget(self, action: #selector(valideButtonSet), for: .touchUpInside)
    }

    @objc func valideButtonSet() {
        viewModel.saveBreast(at: timePicker.date)
    }

    // MARK: - Setup UIButton
    private func setupCornerRadiusOf(_ button: UIButton) {
        button.layoutIfNeeded()
        button.layer.cornerRadius = button.frame.width/2
        button.clipsToBounds = true
    }

    private func addActionTo(_ button: UIButton) {
        let action = UIAction { _ in
            button.isSelected.toggle()
            button.configuration?.image = UIImage(systemName: button.isSelected ? "pause.fill" : "play.fill")!
                .applyingSymbolConfiguration(.init(pointSize: 30))
            let position: Position = button.tag == 0 ? .left : .right
            self.viewModel.buttonPressed(position)
        }
        button.addAction(action, for: .touchUpInside)
    }

    private func setupManuallyAction() {
        let rightButtonAction = UIAction { [weak self] _ in
            self?.buttonSelected = .right
            self?.showInputAlert()
        }

        let leftButtonAction = UIAction { [weak self] _ in
            self?.buttonSelected = .left
            self?.showInputAlert()
        }

        rightManuallyInput.addAction(rightButtonAction, for: .touchUpInside)
        leftManuallyInput.addAction(leftButtonAction, for: .touchUpInside)
    }

    private func showInputAlert() {
        let alert = UIAlertController(title: "Saisir manuellement", message: "Saisir le temps de la tétée", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "temps en minute"
            textField.keyboardType = .numberPad
        }
        alert.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Valider", style: .default, handler: { _ in
            guard let text = alert.textFields?.first?.text, let time = Int(text) else { return }
            let position: Position = self.buttonSelected
            self.viewModel.manualButtonPressed(position, time: time)
        }))
        present(alert, animated: true, completion: nil)
    }
    // MARK: - Setup function
    private func setupViews() {

        [stackView, labelStackView, leftButton, rightButton, rightManuallyInput, leftManuallyInput].forEach {
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
        [rightManuallyInput, leftManuallyInput,
         rightButton, rightTimeLabel, leftButton, leftTimeLabel,
         totalTimeBreastLabel,
         labelStackView, stackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 15),
            stackView.centerXAnchor.constraint(equalTo: scrollArea.centerXAnchor),
            stackView.widthAnchor.constraint(lessThanOrEqualTo: scrollArea.widthAnchor),
            stackView.widthAnchor.constraint(greaterThanOrEqualTo: scrollArea.widthAnchor, multiplier: 0.75),
            totalTimeBreastLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),

            leftButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            rightButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            leftButton.widthAnchor.constraint(equalTo: scrollArea.widthAnchor, multiplier: 0.2),
            rightButton.widthAnchor.constraint(equalTo: scrollArea.widthAnchor, multiplier: 0.2),
            rightButton.heightAnchor.constraint(equalTo: rightButton.widthAnchor),
            leftButton.widthAnchor.constraint(equalTo: leftButton.heightAnchor),
            leftTimeLabel.centerXAnchor.constraint(equalTo: leftButton.centerXAnchor),
            rightTimeLabel.centerXAnchor.constraint(equalTo: rightButton.centerXAnchor),

            leftManuallyInput.centerXAnchor.constraint(equalTo: leftButton.centerXAnchor),
            leftManuallyInput.topAnchor.constraint(equalTo: leftButton.bottomAnchor, constant: 20),
            leftManuallyInput.widthAnchor.constraint(equalTo: totalTimeBreastLabel.widthAnchor, multiplier: 0.47),
            leftManuallyInput.bottomAnchor.constraint(equalTo: scrollArea.bottomAnchor, constant: -30),

            rightManuallyInput.centerXAnchor.constraint(equalTo: rightButton.centerXAnchor),
            rightManuallyInput.topAnchor.constraint(equalTo: rightButton.bottomAnchor, constant: 20),
            rightManuallyInput.widthAnchor.constraint(equalTo: totalTimeBreastLabel.widthAnchor, multiplier: 0.47)
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

extension BreastFeedingController: BreastFeedingChronoDelegate {

    func updateRightButtonImage(with state: ButtonState) {
        rightButton.isSelected = state == .stop ? false : true
        rightButton.configuration?.image = UIImage(systemName: rightButton.isSelected ? "pause.fill" : "play.fill")!
            .applyingSymbolConfiguration(.init(pointSize: 30))
        let information = rightButton.isSelected ? " pause" : " play"
        leftButton.setAccessibility(with: .button, label: "Gauche" + information, hint: "Appuyer pour changer le chrono")
    }

    func updateLeftButtonImage(with state: ButtonState) {
        leftButton.isSelected = state == .stop ? false : true
        leftButton.configuration?.image = UIImage(systemName: leftButton.isSelected ? "pause.fill" : "play.fill")!
            .applyingSymbolConfiguration(.init(pointSize: 30))
        let information = leftButton.isSelected ? " pause" : " play"
        leftButton.setAccessibility(with: .button, label: "Gauche" + information, hint: "Appuyer pour changer le chrono")
    }

    func updateRightTimeLabel(with text: String) {
        rightTimeLabel.text = "Droit\n" + text
        rightTimeLabel.setAccessibility(with: .adjustable, label: "Droit" + text, hint: "")
    }

    func updateLeftTimeLabel(with text: String) {
        leftTimeLabel.text = "Gauche\n" + text
        leftTimeLabel.setAccessibility(with: .adjustable, label: "Gauche" + text, hint: "")
    }

    func updateTotalTimeLabel(with text: String) {
        totalTimeBreastLabel.text = "Temps Total : " + text
        totalTimeBreastLabel.setAccessibility(with: .adjustable, label: "Temps Total : " + text, hint: "")
    }
}
