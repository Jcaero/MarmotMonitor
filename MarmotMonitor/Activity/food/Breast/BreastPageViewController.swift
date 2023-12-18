//
//  BreastPageViewController.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 15/12/2023.
//

import Foundation
import UIKit

class BreastPageViewController: UIPageViewController {

    var pages: [UIViewController] = [UIViewController]()

    init(pages: [UIViewController]) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pages = pages
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = nil
        view.backgroundColor = .colorForGradientStart
        setViewControllers([pages[0]], direction: .forward, animated: false, completion: nil)
    }
}

// typical Page View Controller Data Source
extension BreastPageViewController: UIPageViewControllerDataSource {

    func changePage(to index: Int) {
        guard index >= 0 && index < pages.count else { return }
        setViewControllers([pages[index]], direction: .forward, animated: false, completion: nil)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else { return pages.last }
        guard pages.count > previousIndex else { return nil }
        return pages[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < pages.count else { return pages.first }
        guard pages.count > nextIndex else { return nil }
        return pages[nextIndex]
    }
}

extension BreastPageViewController: UIPageViewControllerDelegate {

    private func setupPageControl() {
            let appearance = UIPageControl.appearance()
            appearance.pageIndicatorTintColor = .white
            appearance.currentPageIndicatorTintColor = .duckBlue
            appearance.backgroundColor = .clear
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        setupPageControl()
        return pages.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstVC = pageViewController.viewControllers?.first else {
            return 0
        }
        guard let firstVCIndex = pages.firstIndex(of: firstVC) else {
            return 0
        }
        return firstVCIndex
    }
}
