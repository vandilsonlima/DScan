//
//  DocumentViewController.swift
//  DScan
//
//  Created by Vandilson Lima on 14/07/20.
//  Copyright © 2020 vandilson. All rights reserved.
//

import UIKit

class DocumentViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!

    var document: Document!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = document.name
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = collectionView.indexPath(for: sender as! UICollectionViewCell)!
        let vc = segue.destination as! ImageFullViewController
        vc.image = document.images[indexPath.row]
    }

    @IBAction func didTapShareButton(_ sender: Any) {
        let items = document.images.map { $0.image }
        let activity = UIActivityViewController(activityItems: items, applicationActivities: nil)
        self.present(activity, animated: true)
    }
}

extension DocumentViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return document.images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DocumentCollectionViewCell
        let image = document.images[indexPath.row]

        cell.imageView.image = image.image
        cell.textLabel.text = ""

        return cell
    }
}

extension DocumentViewController: UICollectionViewDelegateFlowLayout {

    var margin: CGFloat { 5 }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        CGSize(
            width: collectionView.frame.width / 3 - margin * 2,
            height: collectionView.frame.width / 3 - margin * 2
        )
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        margin
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        margin
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets
    {
        .init(top: 0, left: margin, bottom: 0, right: margin)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "document", sender: collectionView.cellForItem(at: indexPath))
    }
}
