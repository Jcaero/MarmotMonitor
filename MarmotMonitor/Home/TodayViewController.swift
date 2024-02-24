//
//  HomeViewController.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 04/12/2023.
//

import UIKit
/// HomeViewController
/// This class is used to display the home screen of the application
/// The user can see the last date of all activity
/// the user can select an activity to enter the data
final class TodayViewController: BackgroundViewController {

    let currentDate: UILabel = {
        let label = UILabel()
        let date = Date().toDateFormat("EEEE dd MMMM")
        label.text = date
        label.setupDynamicTextWith(policeName: "Symbol", size: 20, style: .body)
        label.textColor = .colorForDate
        label.textAlignment = .left
        label.numberOfLines = 0
        label.setAccessibility(with: .header, label: "\(date)", hint: "date du jour")
        return label
    }()

    let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.setupDynamicBoldTextWith(policeName: "Symbol", size: 30, style: .title3)
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()

    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.backgroundColor = .clear
        scrollView.layer.cornerRadius = 20
        return scrollView
    }()

    let scrollArea: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

     let babyImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "todayDefault")
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
         imageView.setupShadow(radius: 1, opacity: 0.5)
        return imageView
    }()

    let imageGradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient.locations = [0.0, 0.4, 1.0]
        return gradient
    }()

    let babyYearFirstElement: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 0
        label.setupDynamicTextWith(policeName: "Symbol", size: 40, style: .body)
        return label
    }()

    let bayYearSecondElement: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .right
        label.numberOfLines = 0
        label.setupDynamicTextWith(policeName: "Symbol", size: 40, style: .body)
        return label
    }()

    let tableViewArea: UIView = {
        let view = UIView()
        view.backgroundColor = .colorForPastelArea
        view.layer.cornerRadius = 20
        view.setupShadow(radius: 1, opacity: 0.5)
        return view
    }()

    let tableViewName: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Activités"
        label.setupDynamicTextWith(policeName: "Symbol", size: 30, style: .body)
        label.setAccessibility(with: .staticText, label: "Activités de bébé", hint: "")
        return label
    }()

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .colorForPastelArea
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .singleLine
        tableView.layer.cornerRadius = 20
        return tableView
    }()

    // MARK: - Properties
    let viewModel = TodayViewModel()
    var baby: Person!

    var tableViewHeightConstraint: NSLayoutConstraint?

    // MARK: - Cycle Life

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupContraints()

        navigationController?.navigationBar.isHidden = true

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = UITableView.automaticDimension

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let welcomeTexte = viewModel.welcomeTexte()
        welcomeLabel.text = welcomeTexte
        welcomeLabel.setAccessibility(with: .staticText, label: welcomeTexte, hint: "")

        babyYearFirstElement.text = viewModel.babyFirstElement()
        if let element = babyYearFirstElement.text {
            babyYearFirstElement.setAccessibility(with: .staticText, label: element, hint: "")
        }
        bayYearSecondElement.text = viewModel.babySecondElement()
        if let element = bayYearSecondElement.text {
            bayYearSecondElement.setAccessibility(with: .staticText, label: element, hint: "age du bébé")
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        imageGradient.frame = babyImage.bounds

        viewModel.fetchLastActivities()
        tableView.reloadData()
        setupTableViewHeight()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageGradient.frame = babyImage.bounds

        setupTableViewHeight()
    }

    // MARK: - Setup
    private func setupViews() {

        [scrollView, currentDate, welcomeLabel].forEach {
            view.addSubview($0)
        }

        babyImage.layer.addSublayer(imageGradient)

        babyImage.addSubview(babyYearFirstElement)
        babyImage.addSubview(bayYearSecondElement)

        scrollView.addSubview(scrollArea)
        scrollArea.addSubview(babyImage)

        tableViewArea.addSubview(tableViewName)
        tableViewArea.addSubview(tableView)

        scrollArea.addSubview(tableViewArea)
    }

    private func setupContraints() {
        [scrollView, currentDate, welcomeLabel,
         babyImage, babyYearFirstElement, bayYearSecondElement,
         scrollArea, tableView, tableViewArea, tableViewName].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),

            scrollArea.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            scrollArea.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0),
            scrollArea.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: 0),
            scrollArea.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 0),

            currentDate.leftAnchor.constraint(equalTo: scrollArea.leftAnchor, constant: 10),
            currentDate.rightAnchor.constraint(equalTo: scrollArea.rightAnchor, constant: -10),
            currentDate.topAnchor.constraint(equalTo: scrollArea.topAnchor),

            welcomeLabel.leftAnchor.constraint(equalTo: scrollArea.leftAnchor, constant: 10),
            welcomeLabel.rightAnchor.constraint(equalTo: scrollArea.rightAnchor, constant: -10),
            welcomeLabel.topAnchor.constraint(equalTo: currentDate.bottomAnchor, constant: 10),
            welcomeLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),

            babyImage.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor),
            babyImage.rightAnchor.constraint(equalTo: scrollArea.rightAnchor, constant: -10),
            babyImage.leftAnchor.constraint(equalTo: scrollArea.leftAnchor, constant: 10),
            babyImage.widthAnchor.constraint(equalToConstant: (view.frame.width - 40)),
            babyImage.heightAnchor.constraint(equalToConstant: ((view.frame.width - 40)/3)*2),

            babyYearFirstElement.bottomAnchor.constraint(equalTo: babyImage.bottomAnchor, constant: -2),
            babyYearFirstElement.leftAnchor.constraint(equalTo: babyImage.leftAnchor, constant: 10),

            bayYearSecondElement.bottomAnchor.constraint(equalTo: babyImage.bottomAnchor, constant: -2),
            bayYearSecondElement.rightAnchor.constraint(equalTo: babyImage.rightAnchor, constant: -10),

            tableViewArea.topAnchor.constraint(equalTo: babyImage.bottomAnchor, constant: 30),
            tableViewArea.rightAnchor.constraint(equalTo: scrollArea.rightAnchor, constant: -10),
            tableViewArea.leftAnchor.constraint(equalTo: scrollArea.leftAnchor, constant: 10),
            tableViewArea.bottomAnchor.constraint(equalTo: scrollArea.bottomAnchor, constant: -20),
            tableViewArea.widthAnchor.constraint(equalToConstant: (view.frame.width - 40)),

            tableViewName.topAnchor.constraint(equalTo: tableViewArea.topAnchor, constant: 10),
            tableViewName.rightAnchor.constraint(equalTo: tableViewArea.rightAnchor),
            tableViewName.leftAnchor.constraint(equalTo: tableViewArea.leftAnchor)
        ])

        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 1000)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: tableViewName.bottomAnchor, constant: 5),
            tableView.rightAnchor.constraint(equalTo: tableViewArea.rightAnchor),
            tableView.leftAnchor.constraint(equalTo: tableViewArea.leftAnchor),
            tableViewHeightConstraint!,
            tableView.bottomAnchor.constraint(equalTo: tableViewArea.bottomAnchor)
        ])

        setupTableViewHeight()
    }

    /// setup the height of the tableview
    /// - Note: show all cells with big height before celculate
    private func setupTableViewHeight() {
        tableViewHeightConstraint?.constant = 1000

        var height: CGFloat = 0
        for index in 0...3 {
            guard let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0))
            else { return }
            height += cell.frame.size.height
        }
        tableViewHeightConstraint?.constant = height
        tableView.layoutIfNeeded()
    }
}

extension TodayViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let next = FoodTapBar()
            present(next, animated: true, completion: nil)
        case 1:
            let next = SleepController()
            present(next, animated: true, completion: nil)
        case 2:
            let next = DiaperController()
            present(next, animated: true, completion: nil)
        case 3:
            let next = GrowthController()
            present(next, animated: true, completion: nil)
        default:
            break
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}

extension TodayViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let activitie = viewModel.activities[indexPath.row]
        cell.textLabel?.text = activitie.cellTitle
        cell.detailTextLabel?.text = activitie.cellSubTitle
        cell.detailTextLabel?.numberOfLines = 0
        cell.imageView?.image = UIImage(named: activitie.imageName)
        cell.imageView?.backgroundColor = .white
        cell.imageView?.layer.cornerRadius = cell.frame.size.height/2
        cell.imageView?.layer.borderColor = UIColor.black.cgColor
        cell.imageView?.layer.borderWidth = 1
        cell.backgroundColor = .clear
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}
