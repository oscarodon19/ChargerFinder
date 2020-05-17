//
//  Loadable.swift
//  ChargerFinder
//
//  Created by Oscar Odon on 17/05/2020.
//  Copyright © 2020 Oscar Odon. All rights reserved.
//

import UIKit

protocol Loadable: UIViewController {
    var loadingView: LoadingView? { get set}
    func displayLoading()
    func dismissLoading()
}

extension Loadable {
    func displayLoading() {
        loadingView = LoadingView()
        guard let loadingView = loadingView else { return }
        DispatchQueue.main.async {
            loadingView.startAnimating()
            self.view.addSubview(loadingView)
        }
    }
    
    func dismissLoading() {
        guard let loadingView = loadingView else { return }
        DispatchQueue.main.async {
            loadingView.stopAnimating()
            loadingView.removeFromSuperview()
        }
    }
}
