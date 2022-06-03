//
//  AppButton.swift
//  issuerdemo
//
//  Created by Rebel, Chris on 6/3/22.
//  Copyright © 2022 Fitpay. All rights reserved.
//

import UIKit

class AppButton: UIButton {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        setBackgroundColor(.systemBlue, forState: .normal)
        let highlightColor = UIColor(red: 5.0/255.0, green: 80.0/255.0, blue: 204.0/255.0, alpha: 1.0)
        setBackgroundColor(highlightColor, forState: .highlighted)

        setTitleColor(.white, for: .normal)

        clipsToBounds = true
        layer.cornerRadius = 4
    }

    func setBackgroundColor(_ color: UIColor, forState controlState: UIControl.State) {
        let colorImage = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1)).image { _ in
            color.setFill()
            UIBezierPath(rect: CGRect(x: 0, y: 0, width: 1, height: 1)).fill()
        }

        setBackgroundImage(colorImage, for: controlState)
    }
}
