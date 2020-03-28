//
//  UIViewControllerExtension.swift
//  CravableWeatherAppTests
//
//  Created by Elijah Tristan Huey Chan on 27/03/2020.
//  Copyright © 2020 Elijah Tristan Huey Chan. All rights reserved.
//

import UIKit

extension UIViewController {
    func setupForTest() {
        //UIApplication.shared.delegate = AppDelegate()
        UIApplication.shared.keyWindow?.rootViewController = self
        let _ = self.view
    }
}
