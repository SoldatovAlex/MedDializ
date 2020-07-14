//
//  StartDializViewController.swift
//  MedDializ
//

import UIKit
import Alamofire

let networkService =  NetworkServiceImpl()

final class StartDializViewController: UIViewController, NibInit {
    
    private enum DataType {
        case procent
        case kilo
        
        func isProcent() -> Bool {
            switch self {
            case .procent:
                return true
            case .kilo:
                return false
            }
        }
    }
    
    //MARK: Outlets
    @IBOutlet private weak var firstMeasureResultLabel: UILabel!
    @IBOutlet private weak var weightDifferenceLabel: UILabel!
    @IBOutlet private weak var weigtDifferenceProcentageLabel: UILabel!
    @IBOutlet private weak var targetWeightLabel: UILabel!
    @IBOutlet private weak var procenatgeLabel: UILabel!
    @IBOutlet private weak var weightLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var currentResultLabel: UILabel!
    @IBOutlet private weak var settingsSlider: UISlider!
    @IBOutlet private weak var startButton: RoundedButton! 
    
    private var isStarted = false
    private var availableWeightChanging: Double = 0
    private var currentWeight = 0.0
    private var targetWeight = 0.0
    private var timer: Timer?
    
    var initialWeight: Double = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        settingsSlider.value = 0
        setupView(initialWeight: initialWeight)
        targetWeight = initialWeight
    }

    //MARK: Actions
    @IBAction private func startButtonTapped(_ sender: Any) {
        dializ()
    }
    
    @IBAction private func settingsSliderMoved(_ sender: UISlider) {
        let maxWeightChanging = availableWeightChanging * Double(sender.value)
        let procent = maxWeightChanging / initialWeight * 100
        targetWeight = initialWeight - maxWeightChanging
        weigtDifferenceProcentageLabel.text = doubleValidator(value: procent, type: .procent)
        weightDifferenceLabel.text = "-" + doubleValidator(value: maxWeightChanging, type: .kilo)
        targetWeightLabel.text = doubleValidator(value: initialWeight - maxWeightChanging, type: .kilo)
    }
    
    //MARK: Private functions
    
    private func setupView(initialWeight: Double) {
        firstMeasureResultLabel.text =  doubleValidator(value: initialWeight, type: .kilo)
        weigtDifferenceProcentageLabel.text = doubleValidator(value: 0.0, type: .procent)
        weightDifferenceLabel.text = doubleValidator(value: 0.0, type: .kilo)
        targetWeightLabel.text = doubleValidator(value: initialWeight, type: .kilo)
        availableWeightChanging = initialWeight / 10
    }
    
    private func doubleValidator(value: Double, type: DataType) -> String {
        return type.isProcent() ? String(format: "%.1f", value) + " %" : String(format: "%.1f", value) + " кг"
    }
    
    private func dializ() {
        
        guard !initialWeight.isEqual(to: targetWeight) else {
            showAlert(title: "Внимание!", message: "Вес уже достигнут")
            return
        }

        isStarted.toggle()
        
        currentResultLabel.text = ""
        timer?.invalidate()
        currentWeight = initialWeight
        weightDifferenceLabel.isHidden = isStarted
        weigtDifferenceProcentageLabel.isHidden = isStarted
        procenatgeLabel.isHidden = isStarted
        weightLabel.isHidden = isStarted
        currentResultLabel.isHidden = !isStarted
        settingsSlider.isHidden = isStarted
        
        titleLabel.text = isStarted ? TextConstants.startDializConttorllerLabel : TextConstants.startDializParam
        startButton.setTitle(isStarted ? "Стоп" : "Начать", for: .normal)
        isStarted ? startDializ() : stopDializ()
    }
    
    private func startDializ() {

        networkService.request(url: URLs.start, completion: {_ in})
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            networkService.request(url: URLs.getWeight) { [weak self] weight in
                self?.currentWeight =  Double(weight)!
                if self!.currentWeight.isLessThanOrEqualTo(self!.targetWeight) {
                    DispatchQueue.main.async {
                        self?.currentResultLabel.text = self?.doubleValidator(value: Double(self!.targetWeight), type: .kilo)
                    }
                    self?.stopDializ()
                } else {
                    DispatchQueue.main.async {
                        self?.currentResultLabel.text = self?.doubleValidator(value: Double(weight)!, type: .kilo)
                    } 
                }
            }
        }
    }
    
    private func stopDializ() {
        networkService.request(url: URLs.end, completion: {_ in})
        timer?.invalidate()
        
        if !currentWeight.isLessThanOrEqualTo(targetWeight) {
            showAlert(title: "Внимание!", message: "Процедура прервана!") {
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            startButton.isHidden = true
            showAlert(title: "Поздравляем!", message: "Цель достигнута!")
        }
    }
    
    private func showAlert(title: String, message: String, completion: (() -> ())? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            completion?()
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
