//
//  DocumentFullViewController.swift
//  DScan
//
//  Created by Vandilson Lima on 14/07/20.
//  Copyright © 2020 vandilson. All rights reserved.
//

import UIKit

class ImageFullViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!

    var image: DocumentImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image.image
    }

    @IBAction func didTapCloseButton(_ sender: Any) {
        dismiss(animated: true)
    }
}
