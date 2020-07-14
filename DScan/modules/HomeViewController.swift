//
//  ViewController.swift
//  DScan
//
//  Created by Vandilson Lima on 09/07/20.
//  Copyright © 2020 vandilson. All rights reserved.
//

import UIKit
import VisionKit
import Vision

class DocumentCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
}

class HomeViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!

    let collection = DocumentCollection()

    var documents: [Document] {
        return collection.documents
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    @IBAction func addButtonTapped(_ sender: Any) {
        let scannerViewController = VNDocumentCameraViewController()
        scannerViewController.delegate = self
        present(scannerViewController, animated: true)
    }
}

extension HomeViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return documents.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DocumentCollectionViewCell
        let document = documents[indexPath.row]

        cell.imageView.image = document.images.first?.image
        cell.textLabel.text = document.name

        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {

    var margin: CGFloat { 1 }

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
}

extension HomeViewController: VNDocumentCameraViewControllerDelegate {

    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true)
    }

    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        controller.dismiss(animated: true)
    }

    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        controller.dismiss(animated: true)
        collectionView.reloadData()

        var images = [DocumentImage]()
        for i in 0..<scan.pageCount {
            let img = scan.imageOfPage(at: i)
            images.append(DocumentImage(image: img))
        }

        let name = UUID().uuidString
        let doc = Document(name: name, images: images)
        collection.add(doc)
        collectionView.reloadData()
    }
}

