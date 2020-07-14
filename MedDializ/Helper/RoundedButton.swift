//
//  RoundedButton.swift
//  MedDializ
//

import UIKit


final class RoundedButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.frame.height / 2
        backgroundColor = UIColor.systemIndigo
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
    }
}
