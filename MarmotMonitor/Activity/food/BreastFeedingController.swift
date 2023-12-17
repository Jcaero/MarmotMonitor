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

    let typeSegmented: UISegmentedControl = {
        let segmented = UISegmentedControl(items: ["Chronometre", "Saisie Manuelle"])
        segmented.backgroundColor = .clear
        segmented.selectedSegmentTintColor = .duckBlueAlpha
        segmented.tintColor = .colorForBreastButton
        segmented.selectedSegmentIndex = 0 // Gauche
        return segmented
    }()

    let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Annuler", for: .normal)
        button.setTitleColor(.duckBlue, for: .normal)
        button.setupDynamicTextWith(policeName: "Symbol", size: 20, style: .body)
        button.setAccessibility(with: .button, label: "Annuler les informations", hint: "")
        return button
    }()

    let valideButton: UIButton = {
        let button = UIButton()
        button.tintColor = .duckBlue
        button.setBackgroundImage(UIImage(systemName: "checkmark"), for: .normal)
        button.setAccessibility(with: .button, label: "valider les informations", hint: "")
        return button
    }()

    // MARK: - PROPERTIES
    var pageVC: BreastPageViewController!

    var segmentedHeightConstraint: NSLayoutConstraint?

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

        [scrollArea, valideButton, cancelButton, typeSegmented].forEach {
            scrollView.addSubview($0)
        }
    }

    private func setupPageController() {
        pageVC = BreastPageViewController(pages: [BreastFeedingChronoController(), BreastFeedingManualController()])
        addChild(pageVC)
        pageVC.view?.translatesAutoresizingMaskIntoConstraints = false
        scrollArea.addSubview(pageVC.view)
        NSLayoutConstraint.activate([
            pageVC.view.topAnchor.constraint(equalTo: scrollArea.topAnchor),
            pageVC.view.bottomAnchor.constraint(equalTo: scrollArea.bottomAnchor),
            pageVC.view.leftAnchor.constraint(equalTo: scrollArea.leftAnchor),
            pageVC.view.rightAnchor.constraint(equalTo: scrollArea.rightAnchor)
        ])
        pageVC.delegate = self
        pageVC.didMove(toParent: self)
    }

    private func setupContraints() {
        [typeSegmented,
         scrollArea, scrollView, valideButton, cancelButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])

        segmentedHeightConstraint = typeSegmented.heightAnchor.constraint(equalToConstant: 40)
        NSLayoutConstraint.activate([
            segmentedHeightConstraint!,
            typeSegmented.topAnchor.constraint(equalTo: scrollView.topAnchor),
            typeSegmented.rightAnchor.constraint(equalTo: view.rightAnchor),
            typeSegmented.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])

        NSLayoutConstraint.activate([
            scrollArea.topAnchor.constraint(equalTo: typeSegmented.bottomAnchor, constant: 10),
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
        // cancel
        let action = UIAction { _ in
            self.dismiss(animated: true, completion: nil)
        }
        cancelButton.addAction(action, for: .touchUpInside)

        typeSegmented.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
    }

    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        self.pageVC.changePage(to: self.typeSegmented.selectedSegmentIndex)
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
        segmentedHeightConstraint?.constant = isAccessibilityCategory ? 80 : 40

        if isAccessibilityCategory {
            typeSegmented.setTitleTextAttributes([.font: UIFont.preferredFont(forTextStyle: .body)], for: .normal)
            typeSegmented.setupSegmentedTitle(with: ["Chrono", "Manuel"])
        } else {
            typeSegmented.setTitleTextAttributes([.font: UIFont(name: "Symbol", size: 15)!], for: .normal)
            typeSegmented.setupSegmentedTitle(with: ["Chronometre", "Saisie Manuelle"])
        }
    }
}

extension BreastFeedingController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let currentPage = pageViewController.viewControllers?.first, let index = pageVC.pages.firstIndex(of: currentPage) {
            typeSegmented.selectedSegmentIndex = index
        }
    }
}
