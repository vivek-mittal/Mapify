//
//  CustomButton.swift
//  Mapify
//
//  Created by Vivek on 29/01/20.
//  Copyright © 2020 Vivek. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.layer.cornerRadius = 6.0
        self.backgroundColor = .systemBlue
    }
}
