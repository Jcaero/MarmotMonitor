//
//  ApparenceSettingViewController.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 12/02/2024.
//

import UIKit

class ApparenceSettingViewController: UIViewController {

    let moon: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.clipsToBounds = true
        return view
    }()

    let darkSide: UIView = {
        let view = UIView()
        view.backgroundColor = .egyptienBlue
        view.clipsToBounds = true
        return view
    }()

    private let titleView: UILabel = {
        let label = UILabel()
        label.setupDynamicBoldTextWith(policeName: "SF Pro Rounded", size: 40, style: .title3)
        label.textColor = .label
        label.textAlignment = .natural
        label.numberOfLines = 0
        label.text = "Apparence"
        return label
    }()

    private let subtitleView: UILabel = {
        let label = UILabel()
        label.setupDynamicTextWith(policeName: "New York", size: 35, style: .body)
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "Choisissez le mode d'apparence de l'application"
        return label
    }()

    private let selectedMode: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Auto", "Clair", "Sombre"])
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()

    private let saveButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 5)
        configuration.baseBackgroundColor = .systemGreen.withAlphaComponent(0.95)
        configuration.baseForegroundColor = UIColor.white
        configuration.background.cornerRadius = 12
        configuration.cornerStyle = .large
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { titleAttributes in
            var titleAttributes = titleAttributes
            let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .footnote).withSymbolicTraits(.traitBold)
            titleAttributes.font = UIFont(descriptor: descriptor!, size: 0)
            return titleAttributes
        }
        button.configuration = configuration
        button.setTitle("Valider", for: .normal)
        button.setImage(UIImage(systemName: "checkmark"), for: .normal)
        button.setupShadow(radius: 1, opacity: 0.5)
        button.layer.borderWidth = 4
        button.layer.borderColor = UIColor.systemGreen.cgColor
        return button
    }()

    private let cancelButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.gray()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        configuration.baseBackgroundColor = .systemRed.withAlphaComponent(0.95)
        configuration.baseForegroundColor = UIColor.white
        configuration.background.cornerRadius = 12
        configuration.cornerStyle = .large
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { titleAttributes in
            var titleAttributes = titleAttributes
            let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .footnote).withSymbolicTraits(.traitBold)
            titleAttributes.font = UIFont(descriptor: descriptor!, size: 0)
            return titleAttributes
        }
        button.configuration = configuration
        button.setTitle("Retour", for: .normal)
        button.setupShadow(radius: 1, opacity: 0.5)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemRed.cgColor
        return button
    }()

    let stackViewButton: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 50
        return stackView
    }()

    // MARK: - Properties
    private var scaleX: CGFloat = 0
    private var scaleY: CGFloat = 0

    private var viewModel = ApparenceSettingViewModel()
    private var delegate: UpdateInformationControllerDelegate?

    // MARK: - cycle life
    init(delegate: UpdateInformationControllerDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .colorForGradientStartPink
        setupViews()
        setupContraints()
        setupButtonAction()

        setupSelected()
        initApparence()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        moon.layer.cornerRadius = moon.frame.height / 2
        darkSide.layer.cornerRadius = darkSide.frame.height / 2
        selectedMode.layer.cornerRadius = selectedMode.frame.height / 2
    }

    // MARK: - Setup
    private func setupViews() {
        [moon, titleView,subtitleView, selectedMode, darkSide, stackViewButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        [cancelButton, saveButton].forEach {
            stackViewButton.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        saveButton.layer.cornerRadius = 10
        cancelButton.layer.cornerRadius = 10

        self.darkSide.transform = CGAffineTransform(translationX: 200, y: 0)
    }

    private func setupContraints() {
        NSLayoutConstraint.activate([
            moon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            moon.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.frame.height/4),
            moon.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            moon.heightAnchor.constraint(equalTo: moon.widthAnchor),

            darkSide.leftAnchor.constraint(equalTo: moon.leftAnchor, constant: view.frame.width/10),
            darkSide.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.frame.height/4),
            darkSide.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            darkSide.heightAnchor.constraint(equalTo: moon.widthAnchor),

            titleView.topAnchor.constraint(equalTo: moon.bottomAnchor, constant: 20),
            titleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),

            subtitleView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 20),
            subtitleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subtitleView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),

            selectedMode.topAnchor.constraint(equalTo: subtitleView.bottomAnchor, constant: 20),
            selectedMode.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            selectedMode.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),

            stackViewButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            stackViewButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackViewButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            cancelButton.widthAnchor.constraint(equalTo: cancelButton.heightAnchor, multiplier: 2),
            saveButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor, multiplier: 2)
        ])
    }

    private func setupSelected() {
        selectedMode.addTarget(self, action: #selector(didChangeMode), for: .valueChanged)
        selectedMode.setupShadow(radius: 1, opacity: 0.5)
        switch viewModel.apparence {
        case .light:
            selectedMode.selectedSegmentIndex = 1
        case .dark:
            selectedMode.selectedSegmentIndex = 2
        default:
            selectedMode.selectedSegmentIndex = 0
        }
    }

    private func initApparence() {
        self.overrideUserInterfaceStyle = viewModel.apparence

        if self.traitCollection.userInterfaceStyle == .dark {
            self.darkSide.isHidden = false
            UIView.animate(withDuration: 1) {
                self.darkSide.transform = CGAffineTransform(translationX: 0, y: 0)
            }
        } else {
            self.darkSide.isHidden = true
        }
    }

    // MARK: - segmentedControl
    @objc func didChangeMode(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            let previousApparence = self.traitCollection.userInterfaceStyle
            self.overrideUserInterfaceStyle = .unspecified
            let systemeApparence = self.traitCollection.userInterfaceStyle
            self.overrideUserInterfaceStyle = previousApparence

            if systemeApparence == .dark {
                self.overrideUserInterfaceStyle = .unspecified
                showDarkAnimation()
            } else {
                showLightAnimation {
                    self.overrideUserInterfaceStyle = .unspecified
                }
            }

        case 1:
            showLightAnimation {
                self.overrideUserInterfaceStyle = .light
            }
        case 2:
            self.overrideUserInterfaceStyle = .dark
            self.showDarkAnimation()

        default:
            break
        }
    }

    // MARK: - Animation
    private func showDarkAnimation() {
        self.darkSide.isHidden = false

        UIView.animate(withDuration: 1, animations: {
            self.darkSide.transform = CGAffineTransform(translationX: 0, y: 0)
            self.moon.backgroundColor = .white
        })
    }

    private func showLightAnimation(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 1, animations: {
            self.moon.backgroundColor = .red
            self.darkSide.transform = CGAffineTransform(translationX: 250, y: 0)
        }, completion: { finished in
                if finished == true {
                    self.darkSide.isHidden = true
                    completion()
                }
        })
    }

    // MARK: - TraitCollection
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if previousTraitCollection?.userInterfaceStyle == .dark {
            if self.traitCollection.userInterfaceStyle == .light {
                UIView.animate(withDuration: 1, animations: {
                    self.moon.backgroundColor = .red
                    self.darkSide.transform = CGAffineTransform(translationX: 300, y: 0)
                })
            }
        } else {
            if self.traitCollection.userInterfaceStyle == .dark {
                showDarkAnimation()
            }
        }
    }

    // MARK: - Actions
    private func setupButtonAction() {
        saveButton.addTarget(self, action: #selector(saveData), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(holdDown), for: .touchDown)

        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(holdDown), for: .touchDown)
    }

    @objc private func saveData(sender: UIButton) {
        sender.transform = .identity
        sender.layer.shadowOpacity = 0.5
        viewModel.saveAparenceSetting(type: selectedMode.selectedSegmentIndex)
        self.dismiss(animated: true, completion: nil)
    }

    @objc func cancel(sender: UIButton) {
        sender.transform = .identity
        sender.layer.shadowOpacity = 0.5
    self.dismiss(animated: true, completion: nil)
    }

    @objc func holdDown(sender: UIButton) {
        sender.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        sender.layer.shadowOpacity = 0
    }
}
