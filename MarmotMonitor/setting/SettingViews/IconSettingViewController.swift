//
//  IconSettingViewController.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 10/02/2024.
//

import UIKit

class IconSettingViewController: BackgroundViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.layer.cornerRadius = 20
        return scrollView
    }()

    let area: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    private let titleView: UILabel = {
        let label = UILabel()
        label.setupDynamicBoldTextWith(policeName: "SF Pro Rounded", size: 40, style: .title3)
        label.textColor = .colorForLabelBlackToBlue
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()

    private let subtitleView: UILabel = {
        let label = UILabel()
        label.setupDynamicTextWith(policeName: "New York", size: 35, style: .body)
        label.textColor = .colorForLabelBlackToBlue
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()

    let icone: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()

    let colors: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white.withAlphaComponent(0.7)
        collectionView.layer.cornerRadius = 20
        collectionView.register(IconeSettingCell.self, forCellWithReuseIdentifier: IconeSettingCell.reuseIdentifier)
        return collectionView
    }()

    private let saveButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 5)
        configuration.baseBackgroundColor = .systemGreen.withAlphaComponent(0.95)
        configuration.baseForegroundColor = UIColor.white
        configuration.background.cornerRadius = 12
        configuration.cornerStyle = .large
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { titleAttributes in
            var titleAttributes = titleAttributes
            let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .footnote).withSymbolicTraits(.traitBold)
            titleAttributes.font = UIFont(descriptor: descriptor!, size: 0)
            return titleAttributes
        }
        button.configuration = configuration
        button.setTitle("Valider", for: .normal)
        button.setImage(UIImage(systemName: "checkmark"), for: .normal)
        button.setupShadow(radius: 1, opacity: 0.5)
        button.layer.borderWidth = 4
        button.layer.borderColor = UIColor.systemGreen.cgColor
        return button
    }()

    private let cancelButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.gray()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        configuration.baseBackgroundColor = .systemRed.withAlphaComponent(0.95)
        configuration.baseForegroundColor = UIColor.white
        configuration.background.cornerRadius = 12
        configuration.cornerStyle = .large
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { titleAttributes in
            var titleAttributes = titleAttributes
            let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .footnote).withSymbolicTraits(.traitBold)
            titleAttributes.font = UIFont(descriptor: descriptor!, size: 0)
            return titleAttributes
        }
        button.configuration = configuration
        button.setTitle("retour", for: .normal)
        button.setupShadow(radius: 1, opacity: 0.5)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemRed.cgColor
        return button
    }()

    let stackViewButton: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 50
        return stackView
    }()

    let circleView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.7)
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.layer.masksToBounds = true
        return view
    }()

    // MARK: - Properties
    let viewModel = IconSettingViewModel()
    private var delegate: UpdateInformationControllerDelegate?

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
            titleView.trailingAnchor.constraint(equalTo: area.trailingAnchor, constant: -40),
            titleView.heightAnchor.constraint(greaterThanOrEqualToConstant: 60),

            subtitleView.topAnchor.constraint(equalTo: titleView.bottomAnchor),
            subtitleView.leadingAnchor.constraint(equalTo: area.leadingAnchor, constant: 40),
            subtitleView.trailingAnchor.constraint(equalTo: area.trailingAnchor, constant: -40),
            subtitleView.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),

            icone.topAnchor.constraint(equalTo: subtitleView.bottomAnchor, constant: 40),
            icone.centerXAnchor.constraint(equalTo: area.centerXAnchor),
            icone.widthAnchor.constraint(equalTo: area.widthAnchor, multiplier: 0.5),
            icone.heightAnchor.constraint(equalTo: icone.widthAnchor),

            colors.topAnchor.constraint(equalTo: icone.bottomAnchor, constant: 20),
            colors.centerXAnchor.constraint(equalTo: area.centerXAnchor),
            colors.widthAnchor.constraint(equalTo: area.widthAnchor, multiplier: 0.9),
            colors.heightAnchor.constraint(equalTo: colors.widthAnchor, multiplier: 0.2),

            stackViewButton.topAnchor.constraint(greaterThanOrEqualTo: colors.bottomAnchor, constant: 20),
            stackViewButton.centerXAnchor.constraint(equalTo: area.centerXAnchor),
            stackViewButton.bottomAnchor.constraint(lessThanOrEqualTo: area.bottomAnchor, constant: -20),
            stackViewButton.widthAnchor.constraint(equalTo: area.widthAnchor, multiplier: 0.8),
            cancelButton.widthAnchor.constraint(equalTo: cancelButton.heightAnchor, multiplier: 2),
            saveButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor, multiplier: 2)
        ])
    }

    private func setupViewInformation() {
        titleView.text = "Icone"
        subtitleView.text = "Choisissez la couleur"
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
    func setIcon(_ appIconName: String?, completion: @escaping (Error?) -> Void) {
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
        case 1:
            cell.setupColor(in: .pastelPink)
        case 2:
            cell.setupColor(in: .red)
        case 3:
            cell.setupColor(in: .green)
        case 4:
            cell.setupColor(in: .lightBlue)
        case 5:
            cell.setupColor(in: .blue)
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
}
