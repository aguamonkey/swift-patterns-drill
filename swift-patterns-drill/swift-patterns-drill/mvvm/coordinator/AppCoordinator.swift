//
//  AppCoordinator.swift
//  swift-patterns-drill
//
//  Created by Joshua Browne on 01/12/2025.
//

//
//  AppCoordinator.swift
//
//  Analogy:
//  - The Coordinator is like the restaurant manager.
//    ViewControllers are staff at different stations.
//    Instead of staff talking to each other directly, the manager decides:
//      “Seat them here, now send them to the bar, now to the table…”
//
//  In UIKit terms: Coordinator owns the UINavigationController,
//  creates VCs, and handles navigation so VCs stay dumb.
//

import UIKit

// MARK: - Coordinator Protocol

protocol Coordinator {
    var navigationController: UINavigationController { get }
    func start()
}

// MARK: - Simple Screens

/// A basic library screen with a "show player" callback.
final class LibraryViewController: UIViewController {

    var onShowPlayer: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Library"

        let button = UIButton(type: .system)
        button.setTitle("Open Player", for: .normal)
        button.addTarget(self, action: #selector(didTapOpenPlayer), for: .touchUpInside)

        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)

        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc private func didTapOpenPlayer() {
        onShowPlayer?()
    }
}

final class PlayerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        title = "Player"
    }
}

// MARK: - AppCoordinator

final class AppCoordinator: Coordinator {

    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let libraryVC = LibraryViewController()

        libraryVC.onShowPlayer = { [weak self] in
            self?.showPlayer()
        }

        navigationController.viewControllers = [libraryVC]
    }

    private func showPlayer() {
        let playerVC = PlayerViewController()
        navigationController.pushViewController(playerVC, animated: true)
    }
}
