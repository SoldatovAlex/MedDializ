//
//  SplashViewController.swift
//  MedDializ
//

import UIKit

final class SplashViewController: UIViewController, NibInit {

    @IBOutlet private weak var thermometerView: ThermometerView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        thermometerView.startAnimation(completion: {
            let controller = InputDataViewController.initFromNib()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.navigationController?.pushViewController(controller, animated: true)
            }
        })
    }
}
