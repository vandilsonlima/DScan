//
//  Document.swift
//  DScan
//
//  Created by Vandilson Lima on 13/07/20.
//  Copyright © 2020 vandilson. All rights reserved.
//

import UIKit


class DocumentImage {
    let image: UIImage
    var url: URL?

    init(image: UIImage, url: URL? = nil) {
        self.image = image
        self.url = url
    }
}

class Document {
    let name: String
    let images: [DocumentImage]

    init(name: String, images: [DocumentImage]) {
        self.name = name
        self.images = images
    }
}


class DocumentCollection {
    var documents: [Document] = []
    private let directoryName = "documents"
    private let fm = FileManager.default

    private var url: URL {
        let documentDirectory = fm.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentDirectory.appendingPathComponent(directoryName)
    }

    private var defaults: UserDefaults {
        UserDefaults.standard
    }

    private var dictionary: [String: [String]] {
        get {
            let dict = defaults.object(forKey: "documentsKey") as? [String: [String]]
            return dict ?? [String: [String]]()
        }
        set {
            defaults.setValue(newValue, forKey: "documentsKey")
        }
    }

    init() {
        load()
    }

    func load() {
        documents = []
        for (docName, imagesName) in dictionary {
            let images = imagesName.map(buildImage(withName:))
            let document = Document(name: docName, images: images)
            documents.append(document)
        }
    }

    private func buildImage(withName name: String) -> DocumentImage {
        let imageURL = url.appendingPathComponent(name)
        let data = fm.contents(atPath: imageURL.path) ?? Data()
        let image = UIImage(data: data) ?? UIImage()
        return DocumentImage(image: image, url: imageURL)
    }

    private func write(_ docImage: DocumentImage, to url: URL) {
        let data = docImage.image.pngData()
        try? data?.write(to: url, options: .atomic)
    }

    private func save(_ docImage: DocumentImage, withName name: String) throws {
        if !fm.fileExists(atPath: url.path) {
            try fm.createDirectory(atPath: url.path, withIntermediateDirectories: true)
        }
        let docURL = url.appendingPathComponent(name)
        write(docImage, to: docURL)
        docImage.url = docURL
    }

    func add(_ document: Document) {
        var imagesNames = [String]()
        document.images.forEach { image in
            let name = UUID().uuidString + ".png"
            try? save(image, withName: name)
            imagesNames.append(name)
        }
        dictionary[document.name] = imagesNames
        load()
    }
}
