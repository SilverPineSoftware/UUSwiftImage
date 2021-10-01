//
//  ViewController.swift
//  UUSwiftImageSampleApplication
//
//  Created by Jonathan Hays on 10/1/21.
//

import UIKit
import UUSwiftImage

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		if let mask = UIImage(named: "mask"),
		   let image = UIImage(named: "olive")
		{
			let maskedImage = image.uuMakeMaskedImage(mask: mask)
			let imageView = UIImageView(image: maskedImage)
			self.view.addSubview(imageView)
			imageView.translatesAutoresizingMaskIntoConstraints = false
			imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
			imageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
		}

		if let animatedImage = UUImage.uuGIFImage(named: "pug") {
			let imageView = UIImageView(image: animatedImage)
			self.view.addSubview(imageView)
			imageView.translatesAutoresizingMaskIntoConstraints = false
			imageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
			imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
		}
	}


}

