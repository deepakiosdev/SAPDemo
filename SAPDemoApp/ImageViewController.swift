//
//  ImageViewController.swift
//  SAPDemoApp
//
//  Created by Dipak Pandey on 03/05/21.
//

import UIKit

class ImageViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    
    var fruit: Fruit?

    override func viewDidLoad() {
        super.viewDidLoad()
        downloadImage()
    }

    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    private func downloadImage() {
        guard let imageUrl = fruit?.url, let url = URL.init(string: imageUrl) else {
            return
        }
        activityIndicator.startAnimating()

        downloadImageUsingUrlSession(url)
        //downloadImageUsingContentData(url)

    }
    
    private func downloadImageUsingUrlSession(_ url: URL) {
        
        let request = URLRequest.init(url: url)
        
        URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            
            DispatchQueue.main.async {
                if error == nil && data != nil {
                    
                    self?.imageView.image = UIImage.init(data: data!)
                }
                self?.activityIndicator.stopAnimating()
            }
        }.resume()
        
    }
    
    
    private func downloadImageUsingContentData(_ url: URL) {
               DispatchQueue.global().async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                
                DispatchQueue.main.async {
                    self?.imageView.image = UIImage.init(data: imageData)
                    self?.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    /*private func downloadImageUsingContentData(_ url: URL) {
        
        DispatchQueue.global().async {
            if let imageData = try? Data(contentsOf: url) {    6y
                DispatchQueue.main.async {
                    self.imageView.image = UIImage.init(data: imageData)
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }*/
}
