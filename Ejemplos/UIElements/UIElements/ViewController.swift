//
//  ViewController.swift
//  UIElements
//
//  Created by José Brandon Vargas Mariñelarena on 09/03/18.
//  Copyright © 2018 José Brandon Vargas Mariñelarena. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func toggleSwitch(_ sender: UISwitch) {
        if sender.isOn {
            print("ALV COMPA")
        }
    }
    
    @IBAction func sliderAction(_ sender: UISlider) {
        print(sender.value)
    }
    
    @IBAction func keyboardReturnKey(_ sender: UITextField) {
        if let text = sender.text {
            print(text)
        }
    }
    
    @IBAction func unwind(for unwindSegue: UIStoryboardSegue) { }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.navigationItem.title = textField.text
    }
    
}

