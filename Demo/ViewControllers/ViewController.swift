//
//  ViewController.swift
//  JSAnimatedView-Demo
//
//  Created by Max on 2019/3/21.
//  Copyright © 2019 Max. All rights reserved.
//

import UIKit
import JSAnimatedView

class ViewController: UIViewController {
    
    @IBOutlet weak var animatedImageView: AnimatedImageView!
    
    private var currentGIFName: String = "mugen" {
        didSet {
            self.animate()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.animate()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.animatedImageView.stopAnimating()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func animate() {
        self.animatedImageView.animate(withGIFNamed: self.currentGIFName)
    }
    
    @IBAction func toggleAnimation(_ sender: UITapGestureRecognizer) {
        self.animatedImageView.isAnimating ? self.animatedImageView.stopAnimating() : self.animatedImageView.startAnimating()
    }
    
    @IBAction func swapImage(_ sender: UISwipeGestureRecognizer) {
        switch self.currentGIFName {
        case "mugen":
            self.currentGIFName = "earth"
        default:
            self.currentGIFName = "mugen"
        }
    }
}
