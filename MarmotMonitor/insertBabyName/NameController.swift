//
//  NameController.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 19/11/2023.
//

import UIKit

class NameController: UIViewController {

    let roundedImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "nameMarmotte")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    let titre: UILabel = {
        let label = UILabel()
        label.text = "infos de Bébé"
         label.setupDynamicTextWith(policeName: "Symbol", size: 35, style: .body)
         label.textColor = .gray
         label.textAlignment = .left
         return label
    }()

    let area: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.white.cgColor
        view.layer.shadowOpacity = 0.8
        view.layer.shadowRadius = 30
        view.backgroundColor = .white
        return view
    }()

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()

    let babyName: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Nom du bébé"
        textField.textColor = .black
        textField.textAlignment = .left
        textField.borderStyle = .roundedRect
        textField.adjustsFontSizeToFitWidth = true
        textField.textContentType = .name
        textField.keyboardType = .default
        textField.setAccessibility(with: .header, label: "Nom du bébé", hint: "inserer le nom de Bébé")
         return textField
    }()

    let genderStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        return stackView
    }()

    let blanck1 = UIView()
    let blanck2 = UIView()

    let boyButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "boy"), for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        return button
    }()

    let girlButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "girl"), for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        return button
    }()

    let parentsName: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Nom du parent"
        textField.textColor = .black
        textField.textAlignment = .left
        textField.borderStyle = .roundedRect
        textField.adjustsFontSizeToFitWidth = true
        textField.textContentType = .name
        textField.keyboardType = .default
        textField.setAccessibility(with: .header, label: "Nom du parent", hint: "inserer le nom de Bébé")
         return textField
    }()

    let dateOfBirth: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .wheels
        picker.datePickerMode = .date
        picker.locale = .autoupdatingCurrent
        picker.date = Date()
        picker.maximumDate = Date()
        return picker
    }()

    let timeOfBirth: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .wheels
        picker.datePickerMode = .time
        picker.locale = .current
        picker.date = Date()
        picker.maximumDate = Date()
        return picker
    }()

    let saveButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "checkmark"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = .clear
        return button
    }()

    // MARK: - circle life
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupContraints()
        setupAction()

        setColorwith(pastel: .pastelBrown, dark: .darkBrown)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupImage()
    }

    // MARK: - Function

    private func setupView() {
        view.backgroundColor = .white

        [blanck1, boyButton, girlButton, blanck2].forEach {
            genderStackView.addArrangedSubview($0)
        }

        [babyName, genderStackView, parentsName, dateOfBirth, timeOfBirth].forEach {
            stackView.addArrangedSubview($0)
        }

        [area, roundedImage, titre, saveButton].forEach {
            view.addSubview($0)
        }

        area.addSubview(stackView)
    }

    private func setupContraints() {
        [titre, babyName, parentsName, dateOfBirth, timeOfBirth, saveButton, stackView, roundedImage, area].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            roundedImage.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            roundedImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            roundedImage.heightAnchor.constraint(equalToConstant: (view.frame.width / 3)),
            roundedImage.widthAnchor.constraint(equalTo: roundedImage.heightAnchor)
        ])

        NSLayoutConstraint.activate([
            titre.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            titre.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            titre.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: (50)),
            titre.heightAnchor.constraint(equalToConstant: 40)
        ])

        NSLayoutConstraint.activate([
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            saveButton.heightAnchor.constraint(equalToConstant: 40),
            saveButton.widthAnchor.constraint(equalTo: saveButton.heightAnchor)
        ])

        NSLayoutConstraint.activate([
            area.topAnchor.constraint(equalTo: titre.bottomAnchor, constant: 10),
            area.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            area.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            area.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -30)
        ])

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: area.topAnchor, constant: 10),
            stackView.leftAnchor.constraint(equalTo: area.leftAnchor, constant: 10),
            stackView.rightAnchor.constraint(equalTo: area.rightAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: area.bottomAnchor, constant: -10)
        ])

        NSLayoutConstraint.activate([
            boyButton.heightAnchor.constraint(equalToConstant: 40),
            boyButton.widthAnchor.constraint(equalTo: boyButton.heightAnchor),
            girlButton.heightAnchor.constraint(equalToConstant: 40),
            girlButton.widthAnchor.constraint(equalTo: girlButton.heightAnchor)
        ])
    }

    private func setupImage() {
        roundedImage.layer.cornerRadius = roundedImage.bounds.height / 2
        roundedImage.clipsToBounds = true

        boyButton.layer.cornerRadius = boyButton.frame.width / 2
        girlButton.layer.cornerRadius = boyButton.frame.width / 2
    }

    // MARK: - Gesture of BabyView
    private func setupAction() {
        let tapActionBoy = UIAction { [weak self] _ in
            self?.boyButtonTapped()
        }
        boyButton.addAction(tapActionBoy, for: .touchUpInside)

        let tapActionGirl = UIAction { [weak self] _ in
            self?.girlButtonTapped()
        }
        girlButton.addAction(tapActionGirl, for: .touchUpInside)
    }

    private func boyButtonTapped() {
        setColorwith(pastel: .pastelBlue, dark: .darkBlue)

        boyButton.layer.borderColor = UIColor.darkBlue.cgColor
        girlButton.layer.borderColor = UIColor.white.cgColor
    }

    private func girlButtonTapped() {
        setColorwith(pastel: .pastelPink, dark: .darkPink)

        girlButton.layer.borderColor = UIColor.darkPink.cgColor
        boyButton.layer.borderColor = UIColor.white.cgColor
    }

    // MARK: - Color Views
    private func setColorwith( pastel: UIColor, dark: UIColor) {
        area.layer.shadowColor = pastel.cgColor
        titre.textColor = dark
        babyName.textColor = dark
        saveButton.tintColor = dark
    }
}
