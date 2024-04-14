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
        let tabBarController = UITabBarController()
        tabBarController.tabBar.backgroundColor = .black
        tabBarController.tabBar.tintColor = .white
        
        let listViewController = HaebitFilmListViewController(viewModel: viewModel)
        let list = HaebitFilmLogNavigationController(rootViewController: listViewController)
        list.tabBarItem = UITabBarItem(title: nil, image: .init(systemName: "photo.stack"), tag: 0)
        
        let mapViewController = HaebitFilmMapViewController(viewModel: viewModel)
        let map = HaebitFilmLogNavigationController(rootViewController: mapViewController)
        map.tabBarItem = UITabBarItem(title: nil, image: .init(systemName: "map.fill"), tag: 0)
        
        tabBarController.viewControllers = [list, map]
        return tabBarController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}
