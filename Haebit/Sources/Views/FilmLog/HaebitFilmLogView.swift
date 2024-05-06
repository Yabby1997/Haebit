//
//  HaebitFilmLogView.swift
//  HaebitDev
//
//  Created by Seunghun on 4/10/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI
import UIKit

struct HaebitFilmLogView: UIViewControllerRepresentable {
    @StateObject var viewModel: HaebitFilmLogViewModel
    
    func makeUIViewController(context: Context) -> some UIViewController {
        context.coordinator.viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(viewModel: viewModel)
    }
    
    @MainActor
    class Coordinator: NSObject, UITabBarControllerDelegate {
        let viewModel: HaebitFilmLogViewModel
        
        private lazy var listViewController: HaebitFilmListViewController = {
            HaebitFilmListViewController(viewModel: viewModel)
        }()
        
        private lazy var mapViewController: HaebitFilmMapViewController = {
            HaebitFilmMapViewController(viewModel: viewModel)
        }()
        
        private lazy var listNavigationController: UINavigationController = {
            let list = HaebitFilmLogNavigationController(rootViewController: listViewController)
            list.tabBarItem = UITabBarItem(title: nil, image: .init(systemName: "photo.stack"), tag: 0)
            return list
        }()
        
        private lazy var mapNavigationController: UINavigationController = {
            let map = HaebitFilmLogNavigationController(rootViewController: mapViewController)
            map.tabBarItem = UITabBarItem(title: nil, image: .init(systemName: "map.fill"), tag: 0)
            return map
        }()
        
        lazy var viewController: UIViewController = {
            let tabBarController = UITabBarController()
            tabBarController.tabBar.backgroundColor = .black
            tabBarController.tabBar.tintColor = .white
            tabBarController.delegate = self
            tabBarController.viewControllers = [listNavigationController, mapNavigationController]
            return tabBarController
        }()
        
        init(viewModel: HaebitFilmLogViewModel) {
            self.viewModel = viewModel
        }
        
        func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
            if viewController == listNavigationController {
                listViewController.updateCurrentIndexIfNeeded()
            } else if viewController == mapNavigationController {
                mapViewController.setRegionIfNeeded()
            }
        }
    }
}
