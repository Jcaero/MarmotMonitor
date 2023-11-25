//
//  standardStartedViewController.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 24/11/2023.
//
import UIKit

class StandardStartedViewController: UIViewController {
        // MARK: - Properties
        let nextButton: UIButton = {
            let button = UIButton()
            button.setTitle("Commencer", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.layer.borderColor = UIColor.black.cgColor
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 10
            button.titleLabel?.adjustsFontForContentSizeCategory = true
            button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
            button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            return button
        }()

        let schrollView: UIScrollView = {
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
            view.backgroundColor = .pastelBrown
            view.layer.cornerRadius = 20
            return view
        }()

        // MARK: - ViewDidLoad
        override func viewDidLoad() {
            super.viewDidLoad()
            setupViews()
            setupContraints()
            setupGradient()
        }

        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            roundedImage.layer.cornerRadius = roundedImage.bounds.height / 2
            roundedImage.clipsToBounds = true
        }

        // MARK: - function

        private func setupViews() {
            view.backgroundColor = .white

            [schrollView, roundedImage].forEach {
                view.addSubview($0)
            }

            pastelArea.addSubview(stackView)

            schrollView.addSubview(pastelArea)
            schrollView.addSubview(nextButton)
        }

        private func setupContraints() {
            [nextButton, roundedImage, schrollView, stackView, pastelArea, nextButton].forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
            }

            NSLayoutConstraint.activate([
                roundedImage.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
                roundedImage.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.frame.height/4),
                roundedImage.heightAnchor.constraint(equalToConstant: (view.frame.width / 3)),
                roundedImage.widthAnchor.constraint(equalTo: roundedImage.heightAnchor)
            ])

            NSLayoutConstraint.activate([
                schrollView.topAnchor.constraint(equalTo: roundedImage.bottomAnchor, constant: -20),
                schrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
                schrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
                schrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10)
            ])

            NSLayoutConstraint.activate([
                pastelArea.topAnchor.constraint(equalTo: schrollView.topAnchor, constant: 10),
                pastelArea.rightAnchor.constraint(equalTo: schrollView.rightAnchor, constant: -10),
                pastelArea.leftAnchor.constraint(equalTo: schrollView.leftAnchor, constant: 10),
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
                nextButton.rightAnchor.constraint(equalTo: schrollView.rightAnchor, constant: -10),
                nextButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
                nextButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
                nextButton.bottomAnchor.constraint(equalTo: schrollView.bottomAnchor, constant: -20)
            ])
        }

        private func setupGradient() {
            let gradient = CAGradientLayer()
            gradient.frame = view.bounds
            gradient.colors = [UIColor.mediumBrown.cgColor, UIColor.pastelBrown.cgColor]
            gradient.locations = [0.0, 1.0]
            view.layer.insertSublayer(gradient, at: 0)
        }
}
