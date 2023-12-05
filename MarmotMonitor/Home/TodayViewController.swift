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
        label.textColor = .systemGray5
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
        imageView.contentMode = .scaleAspectFill
        return imageView
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
        welcomeLabel.text = viewModel.welcomeTexte()
    }

    // MARK: - Setup function

        private func setupViews() {

            [scrollView, currentDate, welcomeLabel].forEach {
                view.addSubview($0)
            }

            pastelArea.addSubview(babyImage)
            scrollView.addSubview(pastelArea)
        }

    private func setupContraints() {
        [scrollView, pastelArea, currentDate, babyImage, welcomeLabel].forEach {
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
    }
}
