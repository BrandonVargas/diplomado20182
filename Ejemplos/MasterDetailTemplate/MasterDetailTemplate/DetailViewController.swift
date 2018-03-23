//
//  DetailViewController.swift
//  MasterDetailTemplate
//
//  Created by José Brandon Vargas Mariñelarena on 17/03/18.
//  Copyright © 2018 José Brandon Vargas Mariñelarena. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!


    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let label = detailDescriptionLabel {
                label.text = detail.name! + " / " + detail.email! + " / " + "prro"
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: User? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

