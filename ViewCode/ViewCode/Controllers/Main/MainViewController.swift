//
//  ViewController.swift
//  ViewCode
//
//  Created by Carlos Marcelo Tonisso Junior on 03/08/20.
//  Copyright © 2020 Carlos Marcelo Tonisso Junior. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func loadView() {
        super.loadView()
        self.view = MainView()
    }

}
