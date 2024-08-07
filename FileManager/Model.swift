//
//  Model.swift
//  FileManager
//
//  Created by Yuliya Vodneva on 5.08.24.
//

import Foundation

struct Model {
    
    var path: String
    
    var title: String {
        return NSString(string: path).lastPathComponent
    }
    
    var items: [String] {
        return (try? FileManager.default.contentsOfDirectory(atPath: path)) ?? []
    }
    
    init(path: String) {
        self.path = path
    }
    
    func isPathForItemIsFolder(index: Int) -> Bool {
        var objCBool: ObjCBool = .init(false)
        FileManager.default.fileExists(atPath: path + "/" + items[index], isDirectory: &objCBool)
        return objCBool.boolValue
    }
}
