//
//  ViewController.swift
//  ProgrammaticSegues
//
//  Created by José Brandon Vargas Mariñelarena on 09/03/18.
//  Copyright © 2018 José Brandon Vargas Mariñelarena. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var segueSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func blueClicked(_ sender: UIButton) {
        if (switchEnabled()) {
            performSegue(withIdentifier: "blue", sender: nil)
        }
    }
    
    @IBAction func blackClicked(_ sender: UIButton) {
        if (switchEnabled()) {
            performSegue(withIdentifier: "black", sender: nil)
        }
    }
    
    private func switchEnabled() -> Bool {
        return segueSwitch.isOn
    }
}

