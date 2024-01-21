//
//  breastfeedingViewController.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 09/12/2023.
//

import UIKit

class BreastFeedingController: ActivityController {

    let totalTimeBreastLabel: UILabel = {
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

    let leftButton: UIButton =  {
        var configuration = UIButton.Configuration.filled()
        configuration.image = UIImage(systemName: "play.fill")!
            .applyingSymbolConfiguration(.init(pointSize: 30))
        configuration.cornerStyle = .capsule
        configuration.baseBackgroundColor = .duckBlue
        configuration.baseForegroundColor = .label
        configuration.contentInsets = .zero
        let button = UIButton(configuration: configuration)
        button.setAccessibility(with: .button, label: "bouton gauche", hint: "lancer le chrono gauche")
        button.tag = 0
        return button
    }()

    let rightButton: UIButton =  {
        var configuration = UIButton.Configuration.filled()
        configuration.image = UIImage(systemName: "play.fill")!
            .applyingSymbolConfiguration(.init(pointSize: 30))
        configuration.cornerStyle = .capsule
        configuration.baseBackgroundColor = .duckBlue
        configuration.baseForegroundColor = .label
        configuration.contentInsets = .zero
        let button = UIButton(configuration: configuration)
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
        label.setAccessibility(with: .staticText, label: "", hint: "")
        return label
    }()

    let leftTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "Gauche\n0 min"
        label.setupDynamicTextWith(policeName: "Symbol", size: 20, style: .body)
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

    let rightManuallyInput: UIButton =  {
        let button = UIButton()
        var configuration = UIButton.Configuration.bordered()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        configuration.title = "Saisir Manuellement"
        configuration.baseForegroundColor = .duckBlue
        configuration.baseBackgroundColor = .clear
        configuration.background.strokeColor = .duckBlue
        configuration.background.strokeWidth = 1
        configuration.background.cornerRadius = 10
        configuration.cornerStyle = .large
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { titleAttributes in
            var titleAttributes = titleAttributes
            let fontMetrics = UIFontMetrics(forTextStyle: .body)
            titleAttributes.font = fontMetrics.scaledFont(for: UIFont(name: "Symbol", size: 11)!)
            return titleAttributes
        }
        button.configuration = configuration
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        return button
    }()

    let leftManuallyInput: UIButton =  {
        let button = UIButton()
        var configuration = UIButton.Configuration.bordered()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        configuration.title = "Saisir Manuellement"
        configuration.baseForegroundColor = .duckBlue
        configuration.baseBackgroundColor = .clear
        configuration.background.strokeColor = .duckBlue
        configuration.background.strokeWidth = 1
        configuration.background.cornerRadius = 10
        configuration.cornerStyle = .large
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { titleAttributes in
            var titleAttributes = titleAttributes
            let fontMetrics = UIFontMetrics(forTextStyle: .body)
            titleAttributes.font = fontMetrics.scaledFont(for: UIFont(name: "Symbol", size: 11)!)
            return titleAttributes
        }
        button.configuration = configuration
        button.titleLabel?.adjustsFontForContentSizeCategory = true
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
        timeLabel.setAccessibility(with: .staticText, label: "heure de la tétée", hint: "")

        timePicker.setAccessibility(with: .selected, label: "", hint: "choisir heure de la tétée")
    }

    private func setupValideButton() {
        valideButton.setAccessibility(with: .button, label: "Valider", hint: "Valider le choix de la couche")
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
            totalTimeBreastLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 50)
        ])

        NSLayoutConstraint.activate([
            leftButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            rightButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            leftButton.widthAnchor.constraint(equalTo: scrollArea.widthAnchor, multiplier: 0.2),
            rightButton.widthAnchor.constraint(equalTo: scrollArea.widthAnchor, multiplier: 0.2),
            rightButton.heightAnchor.constraint(equalTo: rightButton.widthAnchor),
            leftButton.widthAnchor.constraint(equalTo: leftButton.heightAnchor),
            leftTimeLabel.centerXAnchor.constraint(equalTo: leftButton.centerXAnchor),
            rightTimeLabel.centerXAnchor.constraint(equalTo: rightButton.centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            leftManuallyInput.centerXAnchor.constraint(equalTo: leftButton.centerXAnchor),
            leftManuallyInput.topAnchor.constraint(equalTo: leftButton.bottomAnchor, constant: 20),
            leftManuallyInput.widthAnchor.constraint(equalTo: totalTimeBreastLabel.widthAnchor, multiplier: 0.47),
            leftManuallyInput.bottomAnchor.constraint(equalTo: scrollArea.bottomAnchor, constant: -30)
        ])

        NSLayoutConstraint.activate([
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
    func nextView() {
        self.dismiss(animated: true, completion: nil)
    }

    func alert(title: String, description: String) {
        let alertVC = UIAlertController(title: title, message: description, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }

    func updateRightButtonImage(with state: ButtonState) {
        rightButton.isSelected = state == .stop ? false : true
        rightButton.configuration?.image = UIImage(systemName: rightButton.isSelected ? "pause.fill" : "play.fill")!
            .applyingSymbolConfiguration(.init(pointSize: 30))
    }

    func updateLeftButtonImage(with state: ButtonState) {
        leftButton.isSelected = state == .stop ? false : true
        leftButton.configuration?.image = UIImage(systemName: leftButton.isSelected ? "pause.fill" : "play.fill")!
            .applyingSymbolConfiguration(.init(pointSize: 30))
    }

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
