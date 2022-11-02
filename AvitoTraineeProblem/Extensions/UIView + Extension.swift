//
//  UIView + Extension.swift
//  AvitoTraineeProblem
//
//  Created by Fed on 27.10.2022.
//

import UIKit

extension UIView {
    @discardableResult
    func prepareForAutoLayOut() -> Self {
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
}
