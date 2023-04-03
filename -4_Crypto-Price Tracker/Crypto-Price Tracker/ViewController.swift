//
//  ViewController.swift
//  Crypto-Price Tracker
//
//  Created by Omar-Mac on 03/04/2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var btcPrice: UILabel!
    @IBOutlet weak var ethPrice: UILabel!
    @IBOutlet weak var usdPrice: UILabel!
    @IBOutlet weak var audPrice: UILabel!
    @IBOutlet weak var lastUpdatedLabel: UILabel!
    
    let urlString = "https://api.coingecko.com/api/v3/exchange_rates"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData(with: urlString)
        
        let timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(refreshData), userInfo: nil, repeats: true)

    }
    
    @objc func refreshData(){
        fetchData(with: urlString)
    }
    
    func fetchData(with urlString: String){
        let url = URL(string: urlString)!
        let urlRequest = URLRequest(url: url)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: urlRequest){ data, response, error in
            guard error == nil else{
                print("problem with fetching data : \(error!.localizedDescription)")
                
                return
            }
            guard let data = data else {return}
            
            do {
                
                let jsonDecoder = JSONDecoder()
                let data = try jsonDecoder.decode(Rates.self, from: data)
                self.setPrices(rates: data.rates)
            } catch(let error){
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func formatDate(date: Date) -> String{
        let formater = DateFormatter()
        formater.dateFormat = "dd MMM y HH:mm:ss"
        return formater.string(from: date)
    }
    
    func setPrices(rates: Currency){
        
        DispatchQueue.main.async {
            
            self.btcPrice.text = self.formatPrice(price: rates.btc)
            self.ethPrice.text = self.formatPrice(price: rates.eth)
            self.usdPrice.text = self.formatPrice(price: rates.usd)
            self.audPrice.text = self.formatPrice(price: rates.aud)
            self.lastUpdatedLabel.text = self.formatDate(date: Date())
        }
    }
    
    func formatPrice(price: Price) -> String{
        return String(format: "%@ %.4f", price.unit, price.value)
    }

    struct Rates: Codable{
        let rates: Currency
    }
    struct Currency: Codable{
        let btc: Price
        let eth: Price
        let usd: Price
        let aud: Price
    }
    struct Price: Codable{
        let name: String
        let unit: String
        let value: Double
        let type: String
    }
}

