//
//  LoginViewController.swift
//  GitHubOAuth
//
//  Created by Joel Bell on 7/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Locksmith
import SafariServices

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginImageView: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var imageBackgroundView: UIView!
    
    let numberOfOctocatImages = 10
    var octocatImages: [UIImage] = []
    var svc: SFSafariViewController!
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpImageViewAnimation()
        
        NotificationCenter.default.addObserver(self, selector: #selector(safariLogin), name: .closeSafariVC, object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loginImageView.startAnimating()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.loginImageView.stopAnimating()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        configureButton()

    }
    
    // MARK: Set Up View
    
    private func configureButton() {
        
        self.imageBackgroundView.layer.cornerRadius = 0.5 * self.imageBackgroundView.bounds.size.width
        self.imageBackgroundView.clipsToBounds = true
    }
    
    private func setUpImageViewAnimation() {
        
        for index in 1...numberOfOctocatImages {
            if let image = UIImage(named: "octocat-\(index)") {
                octocatImages.append(image)
            }
        }
        
        self.loginImageView.animationImages = octocatImages
        self.loginImageView.animationDuration = 2.0
        
    }
    
    
    
    
    func safariLogin(notification: Notification) {
        
        guard let url = URL(string: String(describing: notification.object)) else {return}
        print(url)
        dismiss(animated: true) { completion in
            
            
            GitHubAPIClient.request(.token(url: url), completionHandler: { (json, starred, error) in
                print(GitHubRequestType.oauth.url)
                print("case .token: \(GitHubRequestType.token(url: url))")
                print("\n\n\n\n\n\n***********ERROR\(error)")
                if error == nil {
                    NotificationCenter.default.post(name: .closeLoginVC, object: nil)
                }
            })
            
        }
    }
    
    // MARK: Action
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        svc = SFSafariViewController(url: GitHubRequestType.oauth.url)
       
        present(svc, animated: true, completion: nil)
        
    
    }
    
    

}







