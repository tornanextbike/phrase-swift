//
//  ViewController.swift
//  phrase_swift
//
//  Created by Jan Meier on 12/09/2019.
//  Copyright (c) 2019 Jan Meier. All rights reserved.
//

import UIKit
import phrase_swift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(
            Phrase(pattern: "My name is {first_name} {last_name} and I am {age} years on.")
                .put(key: "first_name", value: "Jan")
                .put(key: "last_name", value: "Meier")
                .put(key: "age", value: "18")
                .format()
        )

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

