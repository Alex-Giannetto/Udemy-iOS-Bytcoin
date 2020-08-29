//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func updateCoin(coin: CoinData)
    func didFailWithError(_ error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate? = nil
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "F4BC1576-E797-480A-91A3-489D73510EFB"
    
    let currencyArray = ["AUD","BRL","CAD","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency: String){
        let url = "\(self.baseURL)/\(currency)?apikey=\(self.apiKey)"
        self.performRequest(for: url)
    }
    
    private func performRequest(for urlString: String) {
        if let url = URL(string: urlString) {
         
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if let e = error {
                    self.delegate?.didFailWithError(e)
                    return
                }
                
                if let safeData = data {
                    if let coinData = parseJson(safeData) {
                        delegate?.updateCoin(coin: coinData)
                    }
                    
                }
            
            }
            
            task.resume()
        }
    }
    
    private func parseJson(_ data: Data) -> CoinData? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            return decodedData
        } catch {
            self.delegate?.didFailWithError(error)
            return nil
        }
    }
}
