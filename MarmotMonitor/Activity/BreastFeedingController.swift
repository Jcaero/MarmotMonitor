//
//  breastfeedingViewController.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 09/12/2023.
//

import UIKit

class BreastFeedingController: UIViewController {
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.backgroundColor = .green
        return scrollView
    }()

    let scrollArea: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()

    let manualButton: UIButton = {
        let button = UIButton()
        button.setTitle("manuellement", for: .normal)
        button.setTitleColor(.duckBlue, for: .normal)
        button.setupDynamicTextWith(policeName: "Symbol", size: 25, style: .body)
        return button
    }()

    let chronoButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("Chrono", for: .normal)
        button.setTitleColor(.duckBlue, for: .normal)
        button.setupDynamicTextWith(policeName: "Symbol", size: 25, style: .body)
        return button
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

    let typeStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 20
        view.distribution = .fillProportionally
        return view
    }()

    // MARK: - PROPERTIES
    var thePageVC: BreastPageViewController!

    // MARK: - Cycle life
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .colorForGradientStart

        setupViews()
        setupContraints()
        setupPageController()
        setupNavigationBar()
        setupButton()

    }

    // MARK: - Setup function
    private func setupViews() {
        view.addSubview(scrollView)

        [typeStackView, scrollArea, valideButton, cancelButton  ].forEach {
            scrollView.addSubview($0)
        }

        [manualButton,chronoButton].forEach {
            typeStackView.addArrangedSubview($0)
        }
    }

    private func setupPageController() {
        thePageVC = BreastPageViewController(pages: [BreastFeedingManualController(), BreastChronoFeedingController()])
        addChild(thePageVC)
        thePageVC.view?.translatesAutoresizingMaskIntoConstraints = false
        scrollArea.addSubview(thePageVC.view)
        NSLayoutConstraint.activate([
            thePageVC.view.topAnchor.constraint(equalTo: scrollArea.topAnchor),
            thePageVC.view.bottomAnchor.constraint(equalTo: scrollArea.bottomAnchor),
            thePageVC.view.leftAnchor.constraint(equalTo: scrollArea.leftAnchor),
            thePageVC.view.rightAnchor.constraint(equalTo: scrollArea.rightAnchor)
        ])

        thePageVC.didMove(toParent: self)
    }

    private func setupContraints() {
        [manualButton, chronoButton,
         scrollArea, scrollView, valideButton, cancelButton, typeStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])

        NSLayoutConstraint.activate([
            typeStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            typeStackView.rightAnchor.constraint(equalTo: view.rightAnchor),
            typeStackView.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])
        
//        NSLayoutConstraint.activate([
//            manualButton.topAnchor.constraint(equalTo: scrollView.topAnchor),
//            manualButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10)
//        ])
//
//        NSLayoutConstraint.activate([
//            chronoButton.topAnchor.constraint(equalTo: scrollView.topAnchor),
//            chronoButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
//            chronoButton.leftAnchor.constraint(greaterThanOrEqualTo: manualButton.rightAnchor, constant: 5)
//        ])

        NSLayoutConstraint.activate([
            scrollArea.topAnchor.constraint(equalTo: typeStackView.bottomAnchor, constant: 10),
            scrollArea.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -10),
            scrollArea.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor, multiplier: 0.5),
            scrollArea.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollArea.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])

        NSLayoutConstraint.activate([
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            cancelButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
//            cancelButton.rightAnchor.constraint(greaterThanOrEqualTo: valideButton.leftAnchor, constant: 10)
        ])

        NSLayoutConstraint.activate([
            valideButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            valideButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            valideButton.widthAnchor.constraint(equalTo: valideButton.heightAnchor),
            valideButton.heightAnchor.constraint(equalTo: cancelButton.heightAnchor)
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
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}

extension BreastFeedingController: UIPickerViewAccessibilityDelegate {

    /// Update the display when the user change the size of the text in the settings
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        let currentCategory = traitCollection.preferredContentSizeCategory
        let previousCategory = previousTraitCollection?.preferredContentSizeCategory

        guard currentCategory != previousCategory else { return }
        let isAccessibilityCategory = currentCategory.isAccessibilityCategory
        cancelButton.setupDynamicTextWith(policeName: "Symbol", size: isAccessibilityCategory ? 15 : 25, style: .body)
        manualButton.setupDynamicTextWith(policeName: "Symbol", size: isAccessibilityCategory ? 15 : 25, style: .body)
        chronoButton.setupDynamicTextWith(policeName: "Symbol", size: isAccessibilityCategory ? 15 : 25, style: .body)
    }
}
