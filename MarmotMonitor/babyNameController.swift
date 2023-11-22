//
//  babyNameController.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 22/11/2023.
//

import UIKit

class BabyNameController: UIViewController {
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
        return button
    }()

    let area: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.backgroundColor = .pastelBrown
        return view
    }()

    let roundedImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "marmotWithPen")
        imageView.contentMode = .scaleAspectFill
        return imageView
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

        [nextButton, area, roundedImage].forEach {
            view.addSubview($0)
        }

        [titre, sousTitre, babyName, babyNameTitre].forEach {
            area.addSubview($0)
        }
    }

    private func setupContraints() {
        [nextButton, area, roundedImage, titre, sousTitre, babyName, babyNameTitre].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -(view.frame.height / 3)),
            nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15),
            nextButton.widthAnchor.constraint(equalToConstant: 90),
            nextButton.heightAnchor.constraint(equalToConstant: 35)
        ])

        NSLayoutConstraint.activate([
            area.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35),
            area.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            area.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            area.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -10)
        ])

        NSLayoutConstraint.activate([
            roundedImage.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            roundedImage.bottomAnchor.constraint(equalTo: area.topAnchor, constant: 20),
            roundedImage.heightAnchor.constraint(equalToConstant: (view.frame.width / 3)),
            roundedImage.widthAnchor.constraint(equalTo: roundedImage.heightAnchor)
        ])

        NSLayoutConstraint.activate([
            titre.topAnchor.constraint(equalTo: area.topAnchor, constant: 20),
            titre.leftAnchor.constraint(equalTo: area.leftAnchor, constant: 20),
            titre.heightAnchor.constraint(equalToConstant: 50)
        ])

        NSLayoutConstraint.activate([
            sousTitre.leftAnchor.constraint(equalTo: titre.leftAnchor),
            sousTitre.topAnchor.constraint(equalTo: titre.bottomAnchor, constant: 2),
            sousTitre.rightAnchor.constraint(equalTo: area.rightAnchor, constant: -10)
        ])

        NSLayoutConstraint.activate([
            babyNameTitre.centerYAnchor.constraint(equalTo: area.centerYAnchor),
            babyNameTitre.leftAnchor.constraint(equalTo: area.leftAnchor, constant: 10),
            babyNameTitre.rightAnchor.constraint(equalTo: area.rightAnchor, constant: -10),
        ])

        NSLayoutConstraint.activate([
            babyName.topAnchor.constraint(equalTo: babyNameTitre.bottomAnchor, constant: 15),
            babyName.leftAnchor.constraint(equalTo: area.leftAnchor, constant: 10),
            babyName.rightAnchor.constraint(equalTo: area.rightAnchor, constant: -10),
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
