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
        scrollView.backgroundColor = .clear
        return scrollView
    }()

    let scrollArea: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()

    let typeButton: UIButton = {
        let button = UIButton()
        button.setTitle("saisir manuellement", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .duckBlue
        button.setupDynamicTextWith(policeName: "Symbol", size: 20, style: .body)
        return button
    }()

    let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Annuler", for: .normal)
        button.setTitleColor(.duckBlue, for: .normal)
        button.setupDynamicTextWith(policeName: "Symbol", size: 20, style: .body)
        return button
    }()

    let valideButton: UIButton = {
        let button = UIButton()
        button.tintColor = .duckBlue
        button.setBackgroundImage(UIImage(systemName: "checkmark"), for: .normal)
        return button
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

        [scrollArea, valideButton, cancelButton, typeButton].forEach {
            scrollView.addSubview($0)
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
        [typeButton,
         scrollArea, scrollView, valideButton, cancelButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])

        NSLayoutConstraint.activate([
            typeButton.topAnchor.constraint(equalTo: scrollView.topAnchor),
            typeButton.rightAnchor.constraint(equalTo: view.rightAnchor),
            typeButton.leftAnchor.constraint(equalTo: view.leftAnchor),
        ])

        NSLayoutConstraint.activate([
            scrollArea.topAnchor.constraint(equalTo: typeButton.bottomAnchor, constant: 10),
            scrollArea.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -10),
            scrollArea.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor, multiplier: 0.5),
            scrollArea.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollArea.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])

        NSLayoutConstraint.activate([
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            cancelButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20)
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
        if isAccessibilityCategory {
            typeButton.setTitle("Manuel", for: .normal)
        } else {
            typeButton.setTitle("saisir manuellement", for: .normal)
        }

    }
}
