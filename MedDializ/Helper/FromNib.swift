//
//  FromNib.swift
//  MedDializ


import UIKit

protocol NibInit {}
extension NibInit where Self: UIView {
    static func initFromNib() -> Self {
        let nibName = String(describing: Self.self)
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: nil, options: nil)[0] as! Self
    }
}

extension NibInit where Self: UIViewController {
    static func initFromNib() -> Self {
        let nibName = String(describing: Self.self)
        return self.init(nibName: nibName, bundle: nil)
    }
}
