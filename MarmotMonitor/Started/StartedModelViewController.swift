//
//  standardStartedViewController.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 24/11/2023.
//
import UIKit

class StartedModelViewController: BackgroundViewController {
    // MARK: - Properties

    let nextButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        configuration.title = "Commencer"
        configuration.baseForegroundColor = .colorForLabelNextButtonDefault
        configuration.baseBackgroundColor = .colorForNextButton
        configuration.background.strokeColor = .label
        configuration.background.strokeWidth = 1
        configuration.background.cornerRadius = 10
        configuration.cornerStyle = .large
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { titleAttributes in
            var titleAttributes = titleAttributes
            titleAttributes.font = UIFont.preferredFont(forTextStyle: .title1)
            return titleAttributes
        }
        button.configuration = configuration
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        return button
    }()

    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.layer.cornerRadius = 20
        return scrollView
    }()

    let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillProportionally
        view.spacing = 20
        return view
    }()

    let roundedImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "marmotWithPen")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    let pastelArea: UIView = {
        let view = UIView()
        view.backgroundColor = .colorForPastelArea
        view.layer.cornerRadius = 20
        return view
    }()

    // MARK: - Properties
    var roundedImageTopConstraint: NSLayoutConstraint?

    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupContraints()

        let isAccessibilityCategory = traitCollection.preferredContentSizeCategory.isAccessibilityCategory
        setupTopContraintWith(height: isAccessibilityCategory ? view.frame.height / 6 : view.frame.height / 4)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        roundedImage.layer.cornerRadius = roundedImage.bounds.height / 2
        roundedImage.clipsToBounds = true
    }

    // MARK: - function

        private func setupViews() {
            view.backgroundColor = .white

            [scrollView, roundedImage].forEach {
                view.addSubview($0)
            }

            pastelArea.addSubview(stackView)

            scrollView.addSubview(pastelArea)
            scrollView.addSubview(nextButton)
        }

        private func setupContraints() {
            [nextButton, roundedImage, scrollView, stackView, pastelArea, nextButton].forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
            }

            roundedImageTopConstraint = roundedImage.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.frame.height/4 )

            NSLayoutConstraint.activate([
                roundedImage.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
                roundedImageTopConstraint!,
                roundedImage.heightAnchor.constraint(equalToConstant: (view.frame.width / 3)),
                roundedImage.widthAnchor.constraint(equalTo: roundedImage.heightAnchor)
            ])

            NSLayoutConstraint.activate([
                scrollView.topAnchor.constraint(equalTo: roundedImage.bottomAnchor, constant: -20),
                scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
                scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
                scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10)
            ])

            NSLayoutConstraint.activate([
                pastelArea.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
                pastelArea.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -10),
                pastelArea.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 10),
                pastelArea.widthAnchor.constraint(equalToConstant: (view.frame.width - 40))
            ])

            NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: pastelArea.topAnchor, constant: 20),
                stackView.rightAnchor.constraint(equalTo: pastelArea.rightAnchor, constant: -10),
                stackView.leftAnchor.constraint(equalTo: pastelArea.leftAnchor, constant: 10),
                stackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
                stackView.bottomAnchor.constraint(equalTo: pastelArea.bottomAnchor, constant: -20)
            ])

            NSLayoutConstraint.activate([
                nextButton.topAnchor.constraint(equalTo: pastelArea.bottomAnchor, constant: 20),
                nextButton.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -10),
                nextButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
                nextButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
                nextButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20)
            ])
        }
}

extension StartedModelViewController {

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        let currentCategory = traitCollection.preferredContentSizeCategory
        let previousCategory = previousTraitCollection?.preferredContentSizeCategory

        guard currentCategory != previousCategory else { return }
        let isAccessibilityCategory = currentCategory.isAccessibilityCategory
        setupTopContraintWith(height: isAccessibilityCategory ? view.frame.height / 6 : view.frame.height / 4)
    }

    func setupTopContraintWith (height: CGFloat) {
        roundedImageTopConstraint?.constant = height
        view.layoutIfNeeded()
    }
}
