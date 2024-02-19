//
//  IconSettingViewController.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 10/02/2024.
//

import UIKit

final class IconSettingViewController: BackgroundViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.layer.cornerRadius = 20
        return scrollView
    }()

    private let area: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    private let titleView: UILabel = {
        let label = UILabel()
        label.setupDynamicBoldTextWith(policeName: "Symbol", size: 34, style: .largeTitle)
        label.textColor = .black
//        label.backgroundColor = .clearToEgiptienBlue
//        label.layer.cornerRadius = 20
//        label.clipsToBounds = true
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "Icone"
        label.setAccessibility(with: .header, label: "Icone", hint: "")
        return label
    }()

    private let subtitleView: UILabel = {
        let label = UILabel()
        label.setupDynamicTextWith(policeName: "Symbol", size: 20, style: .title3)
        label.textColor = .black
        label.backgroundColor = .clearToEgiptienSoft
        label.layer.cornerRadius = 20
        label.clipsToBounds = true
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "  Choisissez la couleur  "
        return label
    }()

    private let icone: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.setAccessibility(with: .image, label: "Icone", hint: "")
        return imageView
    }()

    private let colors: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white.withAlphaComponent(0.7)
        collectionView.layer.cornerRadius = 20
        collectionView.register(IconeSettingCell.self, forCellWithReuseIdentifier: IconeSettingCell.reuseIdentifier)
        return collectionView
    }()

    private let saveButton: UIButton = {
        let button = UIButton().createActionButton(color: .systemGreen)
        button.setTitle("Valider", for: .normal)
        button.setImage(UIImage(systemName: "checkmark"), for: .normal)
        button.setAccessibility(with: .button, label: "Valider", hint: "")
        return button
    }()

    private let cancelButton: UIButton = {
        let button = UIButton().createActionButton(color: .systemRed)
        button.setTitle("Retour", for: .normal)
        button.setAccessibility(with: .button, label: "Retour", hint: "")
        return button
    }()

    private let stackViewButton: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 30
        return stackView
    }()

    private let circleView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.7)
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.layer.masksToBounds = true
        return view
    }()

    // MARK: - Properties
    private let viewModel = IconSettingViewModel()
    private var delegate: UpdateInformationControllerDelegate?

    private var iconeWidthContrainte: NSLayoutConstraint?
    private var iconeWidthAccessibilityContrainte: NSLayoutConstraint?

// MARK: - Circle Life
    init(delegate: UpdateInformationControllerDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupContraints()

        colors.delegate = self
        colors.dataSource = self

        setupButtonAction()
    }

    override func viewWillAppear(_ animated: Bool) {
        circleView.layer.cornerRadius = view.frame.width/2
    }

    // MARK: - Setup
    private func setupViews() {
        [circleView, scrollView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        scrollView.addSubview(area)
        area.translatesAutoresizingMaskIntoConstraints = false

        [titleView,subtitleView, icone, colors, stackViewButton].forEach {
            area.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        [cancelButton, saveButton].forEach {
            stackViewButton.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        setupViewInformation()

        icone.setupShadow(radius: 2, opacity: 0.5)
        saveButton.layer.cornerRadius = 10
        cancelButton.layer.cornerRadius = 10
    }

    private func setupContraints() {
        iconeWidthContrainte = icone.widthAnchor.constraint(equalTo: area.widthAnchor, multiplier: 0.35)
        iconeWidthAccessibilityContrainte = icone.widthAnchor.constraint(equalTo: area.widthAnchor, multiplier: 0.7)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor , constant: -20),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),

            area.topAnchor.constraint(equalTo: scrollView.topAnchor),
            area.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            area.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            area.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            area.widthAnchor.constraint(equalToConstant: (view.frame.width - 20)),
            area.heightAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.heightAnchor),

            circleView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            circleView.centerYAnchor.constraint(equalTo: view.topAnchor),
            circleView.widthAnchor.constraint(equalTo: view.widthAnchor),
            circleView.heightAnchor.constraint(equalTo: view.widthAnchor),

            titleView.topAnchor.constraint(equalTo: area.topAnchor, constant: 20),
            titleView.leadingAnchor.constraint(equalTo: area.leadingAnchor, constant: 40),
            titleView.trailingAnchor.constraint(lessThanOrEqualTo: area.trailingAnchor, constant: -40),
            titleView.heightAnchor.constraint(greaterThanOrEqualToConstant: 60),

            subtitleView.topAnchor.constraint(equalTo: titleView.bottomAnchor),
            subtitleView.leadingAnchor.constraint(equalTo: area.leadingAnchor, constant: 40),
            subtitleView.trailingAnchor.constraint(lessThanOrEqualTo: area.trailingAnchor, constant: -40),
            subtitleView.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),

            icone.topAnchor.constraint(equalTo: subtitleView.bottomAnchor, constant: 40),
            icone.centerXAnchor.constraint(equalTo: area.centerXAnchor),
            iconeWidthContrainte!,
            icone.heightAnchor.constraint(equalTo: icone.widthAnchor),

            colors.topAnchor.constraint(equalTo: icone.bottomAnchor, constant: 20),
            colors.centerXAnchor.constraint(equalTo: area.centerXAnchor),
            colors.widthAnchor.constraint(equalTo: area.widthAnchor, multiplier: 0.8),
            colors.heightAnchor.constraint(greaterThanOrEqualTo: saveButton.heightAnchor),
            colors.heightAnchor.constraint(lessThanOrEqualTo: colors.widthAnchor, multiplier: 0.136),

            stackViewButton.topAnchor.constraint(greaterThanOrEqualTo: colors.bottomAnchor, constant: 20),
            stackViewButton.centerXAnchor.constraint(equalTo: area.centerXAnchor),
            stackViewButton.bottomAnchor.constraint(lessThanOrEqualTo: area.bottomAnchor, constant: -20),
            stackViewButton.widthAnchor.constraint(equalTo: area.widthAnchor, multiplier: 0.8)
        ])

        setupAccessibilityUI()
    }

    private func setupViewInformation() {
        icone.image = UIImage(named: viewModel.getIconeImageName())
    }

    // MARK: - Actions
    private func setupButtonAction() {
        saveButton.addTarget(self, action: #selector(saveData), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(holdDown), for: .touchDown)

        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(holdDown), for: .touchDown)
    }

    @objc private func saveData(sender: UIButton) {
        sender.transform = .identity
        sender.layer.shadowOpacity = 0.5
        setIcon(viewModel.iconeName) { [weak self] _ in
            if let name = self?.viewModel.iconeName {
                self?.viewModel.saveIconeName(name: name)
            } else {
                self?.viewModel.saveIconeName(name: NIAppIconType.defaultIcon.name)
            }

            self?.delegate?.updateInformation()
            self?.dismiss(animated: true, completion: nil)
        }
    }

    @objc func cancel(sender: UIButton) {
        sender.transform = .identity
        sender.layer.shadowOpacity = 0.5
        self.dismiss(animated: true, completion: nil)
    }

    @objc func holdDown(sender: UIButton) {
        sender.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        sender.layer.shadowOpacity = 0
    }

    // MARK: - Icon
    private func setIcon(_ appIconName: String?, completion: @escaping (Error?) -> Void) {
        if UIApplication.shared.supportsAlternateIcons {
            UIApplication.shared.setAlternateIconName(appIconName) { error in
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        } else {
            DispatchQueue.main.async {
                completion(nil)
            }
        }
    }

    // MARK: - CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IconeSettingCell.reuseIdentifier, for: indexPath) as? IconeSettingCell else {
            print("erreur de cell")
            return UICollectionViewCell()
        }
        switch indexPath.row {
        case 0:
            cell.setupColor(in: .black)
            cell.setAccessibility(with: .button, label: "Noir", hint: "")
        case 1:
            cell.setupColor(in: .pastelPink)
            cell.setAccessibility(with: .button, label: "rose", hint: "")
        case 2:
            cell.setupColor(in: .red)
            cell.setAccessibility(with: .button, label: "rouge", hint: "")
        case 3:
            cell.setupColor(in: .green)
            cell.setAccessibility(with: .button, label: "vert", hint: "")
        case 4:
            cell.setupColor(in: .lightBlue)
            cell.setAccessibility(with: .button, label: "bleu clair", hint: "")
        case 5:
            cell.setupColor(in: .blue)
            cell.setAccessibility(with: .button, label: "bleu", hint: "")
        default:
            break
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard collectionView.cellForItem(at: indexPath) is IconeSettingCell else { return }
        var iconName: String?
        switch indexPath.row {
        case 0:
            iconName = "AppIconImage"
            viewModel.setIconeName(name: nil)
        case 1:
            iconName = "iconeRoseImage"
            viewModel.setIconeName(name: NIAppIconType.appiconPink.name)
        case 2:
            iconName = "iconeRougeImage"
            viewModel.setIconeName(name: NIAppIconType.appiconRed.name)
        case 3:
            iconName = "iconeVerteImage"
            viewModel.setIconeName(name: NIAppIconType.appiconGreen.name)
        case 4:
            iconName = "iconeBleueImage"
            viewModel.setIconeName(name: NIAppIconType.appiconBlue.name)
        case 5:
            iconName = "iconeBleueFonceImage"
            viewModel.setIconeName(name: NIAppIconType.appiconDarkBlue.name)
        default:
            break
        }

        if let iconName = iconName, let newImage = UIImage(named: iconName) {
            icone.image = newImage
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 6 - 9
        return CGSize(width: width, height: width)
    }

    // MARK: - TraitCollection
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        let currentCategory = traitCollection.preferredContentSizeCategory
        let previousCategory = previousTraitCollection?.preferredContentSizeCategory
        guard currentCategory != previousCategory else { return }
        setupAccessibilityUI()
    }

    private func setupAccessibilityUI() {
        let isAccessibilityCategory = traitCollection.preferredContentSizeCategory.isAccessibilityCategory
        switch isAccessibilityCategory {
        case true:
            stackViewButton.axis = .vertical
            iconeWidthContrainte?.isActive = false
            iconeWidthAccessibilityContrainte?.isActive = true
        case false:
            stackViewButton.axis = .horizontal
            iconeWidthContrainte?.isActive = true
            iconeWidthAccessibilityContrainte?.isActive = false
        }
    }
}
