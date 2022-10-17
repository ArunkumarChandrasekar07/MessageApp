//
//  BaseViewController.swift
//  Messaging
//
//  Created by Arunkumar Chandrasekar on 14/10/22.
//

import UIKit

class BaseViewController: UIViewController {
    
    lazy var topBarView: UIView! = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.view.backgroundColor = .systemBackground
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.view.addSubview(topBarView)
        
        NSLayoutConstraint.activate([
            self.topBarView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.topBarView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.topBarView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.topBarView.heightAnchor.constraint(equalToConstant: self.topbarHeight + 20)
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let gradient: CAGradientLayer = CAGradientLayer()
        
        gradient.colors     = [UIColor(named: "GradiantOne")!.cgColor, UIColor(named: "GradiantTwo")!.cgColor]
        gradient.locations  = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x : 0.0, y : 0)
        gradient.endPoint   = CGPoint(x :1.0, y: 1.0)
        gradient.frame      = self.topBarView.bounds
        self.topBarView.layer.addSublayer(gradient)
    }
    
    func addTapGesture() {
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func didTapView() {
        self.view.endEditing(true)
    }
}
