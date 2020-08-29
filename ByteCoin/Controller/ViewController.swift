//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, CoinManagerDelegate {
    
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currencyPicker.dataSource = self
        self.currencyPicker.delegate = self
        self.coinManager.delegate = self
        
        if let firstCurrency = self.coinManager.currencyArray.first {
            self.coinManager.getCoinPrice(for: firstCurrency)
        }
    }
    
    //MARK: - HeadingUIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.coinManager.currencyArray.count
    }
    
    //MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let currency = self.coinManager.currencyArray[row]
        self.coinManager.getCoinPrice(for: currency)
    }
    
    func updateCoin(coin: CoinData) {
        DispatchQueue.main.async {
            self.bitcoinLabel.text = String(format: "%.2f", arguments: [coin.rate])
            self.currencyLabel.text = coin.asset_id_quote
        }
    }
    
    func didFailWithError(_ error: Error) {
        print(error)
    }
    
}

