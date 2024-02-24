//
//  BackGroundActivity.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 22/12/2023.
//

import UIKit
/// BackGroundActivity
/// This class is used to create a background for the application
/// It is used in activity controller
class BackGroundActivity: BackgroundViewController {
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
    var scrollViewTopConstraint: NSLayoutConstraint?

    // MARK: - Cycle life
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .colorForGradientStart

        setupViews()
        setupContraints()
        setupNavigationBar()
    }

    // MARK: - Setup function
    private func setupViews() {
        [scrollView, cancelButton, valideButton].forEach {
            view.addSubview($0)
        }

        scrollView.addSubview(scrollArea)
    }

    private func setupContraints() {
        [scrollArea, scrollView,
         cancelButton, valideButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        scrollViewTopConstraint = scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        NSLayoutConstraint.activate([
            scrollViewTopConstraint!,
            scrollView.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -10),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),

            scrollArea.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollArea.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10),
            scrollArea.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 10),
            scrollArea.widthAnchor.constraint(equalToConstant: (view.frame.width - 20)),

            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            cancelButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),

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
    @objc private func closeView() {
            self.dismiss(animated: true, completion: nil)
        }
}
