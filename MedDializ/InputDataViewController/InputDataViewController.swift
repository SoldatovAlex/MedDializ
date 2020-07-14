//
//  InputDataViewController.swift
//  MedDializ
//

import UIKit

final class InputDataViewController: UIViewController, NibInit {
    
    //MARK: Outlets
    @IBOutlet private weak var nextButton: RoundedButton!
    @IBOutlet private weak var repeatButton: RoundedButton!
    @IBOutlet private weak var continueButton: RoundedButton!
    @IBOutlet private weak var weightLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private var isStartState: Bool = true {
        willSet {
            repeatButton.isHidden = newValue
            continueButton.isHidden = newValue
            weightLabel.isHidden = newValue
            nextButton.isEnabled = newValue
        }
    }
    
    var weight: Double = 0

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        switchSpinner(isOn: false)
        isStartState = true
    }
    
    //MARK: Actions
    @IBAction private func nextButtonTapped(_ sender: Any) {
        initProcess()
    }
    
    @IBAction private func continueButtonTapped(_ sender: Any) {
        let controller = StartDializViewController.initFromNib()
        controller.initialWeight = weight
        navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: Functions
    private func setupInformation() {
        switchSpinner(isOn: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UIView.animate(withDuration: 1, animations: {
                self.isStartState = false
                self.weightLabel.text = String(format: TextConstants.inputDataViewController, "\(self.weight)")
            }, completion: { _ in
                self.switchSpinner(isOn: false)
            })
        }
    }
    
    private func switchSpinner(isOn: Bool) {
        isOn ? activityIndicator.stopAnimating() : activityIndicator.startAnimating()
        activityIndicator.isHidden = !isOn
    }
        
    private func initProcess() {
        networkService.request(url: URLs.initObj) { _ in
            networkService.request(url: URLs.getWeight) { [weak self] str in
                guard let result = Double(str) else {
                    return
                }
                self?.weight = result
                self?.setupInformation()
            }
        }
    }
}
