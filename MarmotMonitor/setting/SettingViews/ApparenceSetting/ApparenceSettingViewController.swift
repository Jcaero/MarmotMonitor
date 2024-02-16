//
//  ApparenceSettingViewController.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 12/02/2024.
//

import UIKit

final class ApparenceSettingViewController: UIViewController {

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.layer.cornerRadius = 20
        return scrollView
    }()

    private let area: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    private let moon: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.clipsToBounds = true
        return view
    }()

    private let darkSide: UIView = {
        let view = UIView()
        view.backgroundColor = .egyptienBlue
        view.clipsToBounds = true
        return view
    }()

    private let titleView: UILabel = {
        let label = UILabel()
        label.setupDynamicBoldTextWith(policeName: "Symbol", size: 34, style: .largeTitle)
        label.textColor = .label
        label.textAlignment = .natural
        label.numberOfLines = 0
        label.text = "Apparence"
        label.setAccessibility(with: .header, label: "Apparence", hint: "")
        return label
    }()

    private let subtitleView: UILabel = {
        let label = UILabel()
        label.setupDynamicTextWith(policeName: "Symbol", size: 20, style: .title3)
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "Choisissez le mode d'apparence de l'application"
        return label
    }()

    private let selectedMode: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Auto", "Clair", "Sombre"])
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)], for: .normal)
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()

    private let saveButton: UIButton = {
        let button = UIButton().createActionButton(color: .systemGreen)
        button.setTitle("Valider", for: .normal)
        button.setImage(UIImage(systemName: "checkmark"), for: .normal)
        return button
    }()

    private let cancelButton: UIButton = {
        let button = UIButton().createActionButton(color: .systemRed)
        button.setTitle("Retour", for: .normal)
        return button
    }()

    private let stackViewButton: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 30
        return stackView
    }()

    // MARK: - Properties
    private var scaleX: CGFloat = 0
    private var scaleY: CGFloat = 0

    private var viewModel = ApparenceSettingViewModel()
    private var delegate: UpdateInformationControllerDelegate?

    private var buttonAccessibiltyContraints: [NSLayoutConstraint]?

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
        view.backgroundColor = viewModel.colorOfBackground

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
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        area.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(area)

        [moon, titleView,subtitleView, selectedMode, darkSide, stackViewButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            area.addSubview($0)
        }

        [cancelButton, saveButton].forEach {
            stackViewButton.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        saveButton.layer.cornerRadius = 10
        cancelButton.layer.cornerRadius = 10

        self.darkSide.transform = CGAffineTransform(translationX: 250, y: 0)
    }

    private func setupContraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor , constant: -20),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),

            area.topAnchor.constraint(equalTo: scrollView.topAnchor),
            area.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            area.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            area.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            area.widthAnchor.constraint(equalToConstant: (view.frame.width - 20)),
            area.heightAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.heightAnchor),

            moon.centerXAnchor.constraint(equalTo: area.centerXAnchor),
            moon.centerYAnchor.constraint(equalTo: area.topAnchor, constant: view.frame.height/4),
            moon.widthAnchor.constraint(equalTo: area.widthAnchor, multiplier: 0.5),
            moon.heightAnchor.constraint(equalTo: moon.widthAnchor),

            darkSide.leftAnchor.constraint(equalTo: moon.leftAnchor, constant: view.frame.width/10),
            darkSide.centerYAnchor.constraint(equalTo: area.topAnchor, constant: view.frame.height/4),
            darkSide.widthAnchor.constraint(equalTo: area.widthAnchor, multiplier: 0.5),
            darkSide.heightAnchor.constraint(equalTo: moon.widthAnchor),

            titleView.topAnchor.constraint(equalTo: moon.bottomAnchor, constant: 20),
            titleView.centerXAnchor.constraint(equalTo: area.centerXAnchor),
            titleView.widthAnchor.constraint(equalTo: area.widthAnchor, multiplier: 0.8),

            subtitleView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 20),
            subtitleView.centerXAnchor.constraint(equalTo: area.centerXAnchor),
            subtitleView.widthAnchor.constraint(equalTo: area.widthAnchor, multiplier: 0.8),

            selectedMode.topAnchor.constraint(equalTo: subtitleView.bottomAnchor, constant: 20),
            selectedMode.centerXAnchor.constraint(equalTo: area.centerXAnchor),
            selectedMode.widthAnchor.constraint(equalTo: area.widthAnchor, multiplier: 0.8),
            selectedMode.heightAnchor.constraint(equalTo: cancelButton.heightAnchor),

            stackViewButton.topAnchor.constraint(greaterThanOrEqualTo: selectedMode.bottomAnchor, constant: 20),
            stackViewButton.centerXAnchor.constraint(equalTo: area.centerXAnchor),
            stackViewButton.bottomAnchor.constraint(lessThanOrEqualTo: area.bottomAnchor, constant: -20),
            stackViewButton.widthAnchor.constraint(equalTo: area.widthAnchor, multiplier: 0.8)
        ])

        setStackViewAxis()
    }

    private func setupSelected() {
        selectedMode.addTarget(self, action: #selector(didChangeMode), for: .valueChanged)
        selectedMode.setupShadow(radius: 1, opacity: 0.5)
        selectedMode.selectedSegmentIndex = viewModel.getInitPositionOfSelected()
    }

    private func initApparence() {
        self.overrideUserInterfaceStyle = viewModel.apparence

        if self.traitCollection.userInterfaceStyle == .dark {
            showDarkAnimation()
        } else {
            self.darkSide.isHidden = true
        }
    }

    // MARK: - segmentedControl
    @objc func didChangeMode(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            let systemeApparence = getSystemeApparenceConfiguration()
            if  systemeApparence == .dark {
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

    private func getSystemeApparenceConfiguration() -> UIUserInterfaceStyle {
        let previousApparence = self.traitCollection.userInterfaceStyle
        self.overrideUserInterfaceStyle = .unspecified
        let systemeApparence = self.traitCollection.userInterfaceStyle
        self.overrideUserInterfaceStyle = previousApparence

        return systemeApparence
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
        // color animation
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

        let currentCategory = traitCollection.preferredContentSizeCategory
        let previousCategory = previousTraitCollection?.preferredContentSizeCategory
        guard currentCategory != previousCategory else { return }
        setStackViewAxis()
    }

    private func setStackViewAxis() {
        let isAccessibilityCategory = traitCollection.preferredContentSizeCategory.isAccessibilityCategory
        switch isAccessibilityCategory {
        case true:
            stackViewButton.axis = .vertical
            selectedMode.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25)], for: .normal)
        case false:
            stackViewButton.axis = .horizontal
            selectedMode.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)], for: .normal)
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
        delegate?.updateInformation()
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
