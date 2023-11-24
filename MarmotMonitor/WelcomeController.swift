//
//  babyNameController.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 22/11/2023.
//

import UIKit

class WelcomeController: UIViewController {
    // MARK: - Properties
    let titre: UILabel = {
        let label = UILabel()
        label.text = "Bonjour"
        label.setupDynamicTextWith(policeName: "Symbol", size: 40, style: .body)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()

    let sousTitre: UILabel = {
        let label = UILabel()
        label.text = "Nous allons créer ton espace personnalisé"
        label.setupDynamicTextWith(policeName: "Symbol", size: 17, style: .body)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()

    let babyNameTitre: UILabel = {
        let label = UILabel()
        label.text = "Quel est le nom de la petite marmotte ?"
        label.setupDynamicTextWith(policeName: "Symbol", size: 25, style: .body)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()

    let babyName: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Nom du bébé"
        textField.textColor = .black
        textField.textAlignment = .left
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor.black.cgColor
        textField.tintColor = .black
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 15
        textField.adjustsFontSizeToFitWidth = true
        textField.textContentType = .name
        textField.backgroundColor = .pastelBrown
        
        textField.setAccessibility(with: .header, label: "Nom du bébé", hint: "inserer le nom de Bébé")
        return textField
    }()

    let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Suivant", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
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

        [titre,sousTitre, babyNameTitre, babyName].forEach {
            stackView.addArrangedSubview($0)
        }

        pastelArea.addSubview(stackView)

        schrollView.addSubview(pastelArea)
        schrollView.addSubview(nextButton)
    }

    private func setupContraints() {
        [nextButton, roundedImage, titre, sousTitre, babyName, babyNameTitre, schrollView, stackView, pastelArea, nextButton].forEach {
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
            schrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor , constant: -20),
            schrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            schrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10)
        ])

        NSLayoutConstraint.activate([
            pastelArea.topAnchor.constraint(equalTo: schrollView.topAnchor, constant: 10),
            pastelArea.rightAnchor.constraint(equalTo: schrollView.rightAnchor, constant: -10),
            pastelArea.leftAnchor.constraint(equalTo: schrollView.leftAnchor, constant: 10),
            pastelArea.widthAnchor.constraint(equalToConstant: (view.frame.width - 40)),
//            pastelArea.bottomAnchor.constraint(equalTo: schrollView.bottomAnchor, constant: -10)
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

        NSLayoutConstraint.activate([
            babyName.heightAnchor.constraint(greaterThanOrEqualToConstant: 50)
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
