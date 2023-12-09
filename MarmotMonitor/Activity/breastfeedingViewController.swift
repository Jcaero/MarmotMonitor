//
//  breastfeedingViewController.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 09/12/2023.
//

import UIKit

class BreastfeedingViewController: BackgroundViewController {
    let rightBreastButton: UIButton = {
        let button = UIButton()
        button.setTitle("R", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
//        button.addTarget(self, action: #selector(rightBreastButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Cycle life
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
}
