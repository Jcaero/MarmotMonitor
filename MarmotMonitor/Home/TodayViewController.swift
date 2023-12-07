//
//  HomeViewController.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 04/12/2023.
//

import UIKit

class TodayViewController: BackgroundViewController {

    let currentDate: UILabel = {
        let label = UILabel()
        label.text = Date().toDateFormat("EEEE dd MMMM")
        label.setupDynamicTextWith(policeName: "Symbol", size: 20, style: .body)
        label.textColor = .colorForDate
        label.textAlignment = .left
        label.numberOfLines = 0
        label.setAccessibility(with: .header, label: "date du jour", hint: "")
        return label
    }()

    let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.setupDynamicTextWith(policeName: "Symbol", size: 30, style: .body)
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 0
        label.setAccessibility(with: .staticText, label: "", hint: "")
        return label
    }()

    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.layer.cornerRadius = 20
        return scrollView
    }()

    let pastelArea: UIView = {
        let view = UIView()
        view.backgroundColor = .colorForPastelArea
        view.layer.cornerRadius = 20
        return view
    }()

    let babyImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "todayDefault")
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    let imageGradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient.locations = [0.0, 0.4, 1.0]
        return gradient
    }()

    let babyYear: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 0
        label.setAccessibility(with: .staticText, label: "", hint: "age du bébé")
        return label
    }()

    let babyMonth: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .right
        label.numberOfLines = 0
        label.setAccessibility(with: .staticText, label: "", hint: "age du bébé")
        return label
    }()

    // MARK: - Properties
    let viewModel = TodayViewModel()
    var baby: Person!

    // MARK: - Cycle Life

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupContraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        welcomeLabel.text = viewModel.welcomeTexte()

        babyYear.attributedText = transformInAttributedString(viewModel.babyYear())
        babyMonth.attributedText = transformInAttributedString(viewModel.babyMonth())
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        imageGradient.frame = babyImage.bounds
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageGradient.frame = babyImage.bounds
    }

    // MARK: - Setup function

    private func setupViews() {

        [scrollView, currentDate, welcomeLabel].forEach {
            view.addSubview($0)
        }

        pastelArea.addSubview(babyImage)
        babyImage.layer.addSublayer(imageGradient)
        babyImage.addSubview(babyYear)
        babyImage.addSubview(babyMonth)
        scrollView.addSubview(pastelArea)
    }

    private func setupContraints() {
        [scrollView, pastelArea, currentDate, babyImage, welcomeLabel, babyYear, babyMonth].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            currentDate.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            currentDate.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])

        NSLayoutConstraint.activate([
            welcomeLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            welcomeLabel.topAnchor.constraint(equalTo: currentDate.bottomAnchor, constant: 10)
        ])

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 5),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10)
        ])

        NSLayoutConstraint.activate([
            pastelArea.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            pastelArea.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -10),
            pastelArea.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 10),
            pastelArea.widthAnchor.constraint(equalToConstant: (view.frame.width - 40)),
            pastelArea.heightAnchor.constraint(equalToConstant: ((view.frame.width - 40)/3)*2),
            pastelArea.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20)
        ])

        NSLayoutConstraint.activate([
            babyImage.topAnchor.constraint(equalTo: pastelArea.topAnchor),
            babyImage.bottomAnchor.constraint(equalTo: pastelArea.bottomAnchor),
            babyImage.leftAnchor.constraint(equalTo: pastelArea.leftAnchor),
            babyImage.rightAnchor.constraint(equalTo: pastelArea.rightAnchor)
        ])

        NSLayoutConstraint.activate([
            babyYear.bottomAnchor.constraint(equalTo: babyImage.bottomAnchor, constant: -2),
            babyYear.leftAnchor.constraint(equalTo: babyImage.leftAnchor, constant: 10),
            babyMonth.bottomAnchor.constraint(equalTo: babyImage.bottomAnchor, constant: -2),
            babyMonth.rightAnchor.constraint(equalTo: babyImage.rightAnchor, constant: -10)
        ])
    }

    // MARK: - SetupTexte

    private func transformInAttributedString(_ text: String) -> NSMutableAttributedString {
        guard !text.isEmpty else { return NSMutableAttributedString(string: "") }

        let parts = text.split(separator: "\n", maxSplits: 1, omittingEmptySubsequences: false)
        let attributedString = NSMutableAttributedString()

        if let firstPart = parts.first {
            let attributedFirstString = NSMutableAttributedString(string: String(firstPart))
            if let largeBoldFont = getFont(style: .largeTitle, traits: .traitBold, scale: 1.5) {
                attributedFirstString.addAttribute(.font, value: largeBoldFont, range: NSRange(location: 0, length: firstPart.count))
            }
            attributedString.append(attributedFirstString)
        }

        if parts.count > 1 {
            let attributedSecondString = NSMutableAttributedString(string: "\n" + String(parts[1]))
            if let smallFont = getFont(style: .body, scale: 1.5) {
                attributedSecondString.addAttribute(.font, value: smallFont, range: NSRange(location: 0, length: parts[1].count + 1))
            }
            attributedString.append(attributedSecondString)
        }

        return attributedString
    }

    private func getFont(style: UIFont.TextStyle, traits: UIFontDescriptor.SymbolicTraits? = nil, scale: CGFloat) -> UIFont? {
        let fontDescriptor = UIFont.preferredFont(forTextStyle: style).fontDescriptor
        let descriptor = traits != nil ? fontDescriptor.withSymbolicTraits(traits!) : fontDescriptor
        let pointSize = UIFont.preferredFont(forTextStyle: style).pointSize * scale
        return descriptor != nil ? UIFont(descriptor: descriptor!, size: pointSize) : nil
    }
}
