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

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()

    let name: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Nom du bébé"
        textField.textColor = .white
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
        return button
    }()

    let girlButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "girl"), for: .normal)
        return button
    }()

    let parentsName: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Nom du parent"
        textField.textColor = .white
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
        button.setImage(UIImage(systemName: "checkmark"), for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 10
        return button
    }()

    // MARK: - circle life
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupContraints()
        setupAction()
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

        [name, genderStackView, parentsName, dateOfBirth, timeOfBirth].forEach {
            stackView.addArrangedSubview($0)
        }

        [roundedImage, titre, stackView, saveButton].forEach {
            view.addSubview($0)
        }
    }

    private func setupContraints() {
        [titre, name, parentsName, dateOfBirth, timeOfBirth, saveButton, stackView, roundedImage].forEach {
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
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            saveButton.widthAnchor.constraint(equalTo: saveButton.heightAnchor)
        ])

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: roundedImage.bottomAnchor, constant: 10),
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -30)
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
        view.backgroundColor = .blue // Changez la couleur en bleu
    }

    private func girlButtonTapped() {
        view.backgroundColor = .systemPink // Changez la couleur en rose
    }
}
