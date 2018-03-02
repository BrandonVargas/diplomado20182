//
//  ViewController.swift
//  prueba
//
//  Created by markmota on 2/24/18.
//  Copyright © 2018 markmota. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    /* Elimine un boton y un text fiel que estaban de sobre en el story board,
    asigne el outlet para el textfield y la action para el button */
    @IBOutlet weak var outtletText: UITextField!
    @IBOutlet weak var aoutletButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        aoutletButton.setTitle("Touch me!", for: .normal)
    }

    @IBAction func actionButton(_ sender: Any) {
        outtletText.text = "You are a genius"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

