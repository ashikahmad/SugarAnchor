//
//  Example1VC.swift
//  SugarAnchor
//
//  Created by ashikahmad on 05/09/2017.
//  Copyright (c) 2017 ashikahmad. All rights reserved.
//

import UIKit
import SugarAnchor

class Example1VC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let redView = addedView(.red)
        let greenView = addedView(.green)
        let blueView = addedView(.blue)
        
        redView.leadingAnchor =*= view.leadingAnchor + 20
        redView.topAnchor =*= topLayoutGuide.bottomAnchor + 10
        redView.widthAnchor =*= redView.heightAnchor
        
        greenView.leadingAnchor =*= redView.trailingAnchor + 8
        greenView.topAnchor =*= redView.topAnchor
        greenView.trailingAnchor =*= view.trailingAnchor - 20
        greenView.heightAnchor =*= 30
        
        blueView.leadingAnchor =*= greenView.leadingAnchor
        blueView.topAnchor =*= greenView.bottomAnchor + 5
        blueView.widthAnchor =*= greenView.widthAnchor / 2 + 15
        blueView.heightAnchor =*= greenView.heightAnchor
        blueView.bottomAnchor =*= redView.bottomAnchor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func addedView(_ color: UIColor)-> UIView {
        let newView = UIView()
        newView.translatesAutoresizingMaskIntoConstraints = false
        newView.backgroundColor = color
        view.addSubview(newView)
        return newView
    }
}

