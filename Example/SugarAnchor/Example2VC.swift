//
//  Example2VC.swift
//  SugarAnchor
//
//  Created by Ashik uddin Ahmad on 5/13/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import SugarAnchor

/*
 Portrait Mode Layout      Lanscape Mode Layout
 ---------------------     --------------------------
 
 +-----------------+      +---------------------------+
 | +-----+ +-----+ |      | +-----+  +--------------+ |
 | | RED | |GREEN| |      | | RED |  |              | |
 | |     | |     | |      | |     |  |              | |
 | +-----+ +-----+ |      | +-----+  |     BLUE     | |
 | +-------------+ |      | +-----+  |              | |
 | |             | |      | |GREEN|  |              | |
 | |             | |      | |     |  |              | |
 | |     BLUE    | |      | +-----+  +--------------+ |
 | |             | |      +---------------------------+
 | |             | |
 | +-------------+ |
 +-----------------+
 
 */

class Example2VC: UIViewController {
    // Portrait-only constraints
    private var poConstraints: [NSLayoutConstraint] = []
    // Lanscape-only constraints
    private var loConstraints: [NSLayoutConstraint] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let redView = addedView(.red)
        let greenView = addedView(.green)
        let blueView = addedView(.blue)
        
        let margins = view.layoutMarginsGuide
        
        // Common
        redView.leadingAnchor =*= margins.leadingAnchor
        redView.topAnchor =*= topLayoutGuide.bottomAnchor + 8
        redView.widthAnchor =*= redView.heightAnchor
        
        greenView.widthAnchor =*= redView.widthAnchor
        greenView.widthAnchor =*= greenView.heightAnchor
        
        blueView.trailingAnchor =*= margins.trailingAnchor
        blueView.bottomAnchor =*= bottomLayoutGuide.topAnchor - 8
        
        // Portrait only
        
        let pc1 = greenView.leadingAnchor =~= redView.trailingAnchor + 8
        let pc2 = greenView.topAnchor =~= redView.topAnchor
        let pc3 = greenView.trailingAnchor =~= margins.trailingAnchor

        let pc4 = blueView.topAnchor =~= redView.bottomAnchor + 8
        let pc5 = blueView.leadingAnchor =~= margins.leadingAnchor
        
        poConstraints.append(contentsOf: [pc1, pc2, pc3, pc4, pc5])
        
        // Landscape only
        
        let lc1 = blueView.leadingAnchor =~= redView.trailingAnchor + 8
        let lc2 = blueView.topAnchor =~= redView.topAnchor
        
        let lc3 = greenView.topAnchor =~= redView.bottomAnchor + 8
        let lc4 = greenView.leadingAnchor =~= margins.leadingAnchor
        let lc5 = greenView.bottomAnchor =~= blueView.bottomAnchor
        
        loConstraints.append(contentsOf: [lc1, lc2, lc3, lc4, lc5])
        
        // To force current mode first time
        traitCollectionDidChange(traitCollection)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        // FIXME: iPad landscape is not covered!
        if traitCollection.verticalSizeClass == .regular {
            // Portrait
            loConstraints.forEach { $0.isActive = false }
            poConstraints.forEach { $0.isActive = true }
        } else {
            // Landscape
            poConstraints.forEach { $0.isActive = false }
            loConstraints.forEach { $0.isActive = true }
        }
    }
    
    func addedView(_ color: UIColor)-> UIView {
        let newView = UIView()
        newView.translatesAutoresizingMaskIntoConstraints = false
        newView.backgroundColor = color
        view.addSubview(newView)
        return newView
    }
}
