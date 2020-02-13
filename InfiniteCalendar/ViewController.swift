//
//  ViewController.swift
//  InfiniteCalendar
//
//  Created by Geoffroy on 23/11/2019.
//  Copyright © 2019 Geoffroy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var infiniteGrid: InfiniteGrid?
    let layout = UICollectionViewLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.infiniteGrid = InfiniteGrid(hostView: self.view)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        infiniteGrid?.scrollToCenter()
    }

}

