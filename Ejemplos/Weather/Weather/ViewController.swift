//
//  ViewController.swift
//  Weather
//
//  Created by José Brandon Vargas Mariñelarena on 03/03/18.
//  Copyright © 2018 José Brandon Vargas Mariñelarena. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var lblTemperature: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getWheater()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func getWheater(){
        //Url para peticion
        let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=London,uk&units=metric&APPID=b857156f364f34b82adae38d2d7efc60")
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard (data != nil) else { return }
            do {
                let jsonDecoder = JSONDecoder()
                let responseModel = try jsonDecoder.decode(Response.self, from: data!)
                DispatchQueue.main.async {
                    self.lblTemperature.text = "\(String(describing: responseModel.main!.temp!)) C"
                    self.labelLocation.text = responseModel.name
                }
            }catch let e {
                print("Error retrieving weather data: \(e)")
            }
            
        }
        task.resume()
        
        /*let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if data != nil {
                do {
                    let jsonData = try JSONSerialization.jsonObject(with: data!, options: [])
                    let jsonDecoder = JSONDecoder()
                    let weather = try jsonDecoder.decode(Weather.self, from: jsonData as! Data)
                    self.labelLocation.text = weather.name
                    self.lblTemperature.text = "\(weather.temp) C"
                    /*DispatchQueue.main.async {
                        if let main = json!["main"] as! [String: Any]? {
                            let n = main["temp"] as! NSNumber
                            self.lblTemperature.text = "\(n.floatValue) C"
                        }
                        self.labelLocation.text = json!["name"] as? String
                    }*/
                } catch let e {
                    print("Error retrieving weather data: \(e)")
                }
            }
        })
        task.resume()*/
    }


}

