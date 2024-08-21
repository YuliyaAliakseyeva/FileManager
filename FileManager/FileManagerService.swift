//
//  FileManagerService.swift
//  FileManager
//
//  Created by Yuliya Vodneva on 5.08.24.
//

import Foundation
import UIKit

protocol FileManagerServiceProtocol {
    
    func contentsOfDirectory() -> [String]
    
    func createDirectory(title: String)
    
    func createFile(url: URL, addedPath: String)
    
    func removeContent(index: Int)
}

final class FileManagerService: FileManagerServiceProtocol {
    
    static let shared = FileManagerService()
    
    var model = Model(path: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
    
    func contentsOfDirectory() -> [String] {
        return (try? FileManager.default.contentsOfDirectory(atPath: model.path)) ?? []
    }
    
    func createDirectory(title: String) {
        try? FileManager.default.createDirectory(atPath: model.path + "/" + title, withIntermediateDirectories: true)
    }
    
    func createFile(url: URL, addedPath: String) {
        let urlDocumentImage = URL(filePath: model.path + "/" + addedPath)
        try? FileManager.default.copyItem(at: url, to: urlDocumentImage)
    }
    
    func removeContent(index: Int) {
        let pathForDelete = model.path + "/" + model.items[index]
        try? FileManager.default.removeItem(atPath: pathForDelete)
    }
    
    func sortFilesalphabetically(data: inout [String]) {
        data.sort(by: { data1, data2 in return data1 > data2
        })
    }
    
    func sortFilesReverseAlphabetically(data: inout [String]) {
        data.sort(by: { data1, data2 in return data1 < data2
        })
    }
}
