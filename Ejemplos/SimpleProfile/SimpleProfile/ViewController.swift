//
//  ViewController.swift
//  SimpleProfile
//
//  Created by José Brandon Vargas Mariñelarena on 02/03/18.
//  Copyright © 2018 José Brandon Vargas Mariñelarena. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var parentView: UIView!
    @IBOutlet weak var labelProfileName: UILabel!
    @IBOutlet weak var buttonEdit: UIButton!
    @IBOutlet weak var buttonSave: UIButton!
    @IBOutlet weak var buttonDelete: UIButton!
    @IBOutlet weak var buttonFun: UIButton!
    @IBOutlet weak var textViewContent: UITextView!
    var value1: Int = 0
    var value2: Int = 0
    var value3: Int = 0
    var value4: Int = 0
    var value5: Int = 0
    var value6: Int = 0
    
    var previousNumber: Int = 0
    
    var colors = ["honeydew","light-blue","queen-blue","red-desire","space-cadet"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func lestFun(_ sender: Any) {
        var shuffled = [String]()
        for _ in 0..<colors.count
        {
            let rand = Int(arc4random_uniform(UInt32(colors.count)))
            shuffled.append(colors[rand])
            colors.remove(at: rand)
        }
        
        colors = shuffled
        print("COLORVIEW \(shuffled[0])")
        parentView.backgroundColor = UIColor.init(named: shuffled[0])
        buttonEdit.backgroundColor = UIColor.init(named: shuffled[1])
        buttonSave.backgroundColor = UIColor.init(named: shuffled[1])
        buttonDelete.backgroundColor = UIColor.init(named: shuffled[1])
        buttonFun.backgroundColor = UIColor.init(named: shuffled[2])
        textViewContent.backgroundColor = UIColor.init(named: shuffled[3])
        labelProfileName.textColor = UIColor.init(named: shuffled[3])
        buttonEdit.setTitleColor(UIColor.init(named: shuffled[4]), for: .normal)
        buttonSave.setTitleColor(UIColor.init(named: shuffled[4]), for: .normal)
        buttonDelete.setTitleColor(UIColor.init(named: shuffled[4]), for: .normal)
        buttonFun.setTitleColor(UIColor.init(named: shuffled[4]), for: .normal)
        textViewContent.textColor = UIColor.init(named: shuffled[4])
        
    }
    
}

