//
//  Post.swift
//  Navigation
//
//  Created by Евгений Стафеев on 18.11.2022.
//

import Foundation
import UIKit

public struct Post {
    public var author: String
    public var description: String
    public var image: String
    public var like: Int
    public var view: Int
    
    static func makePost() -> [Post] {
        var model = [Post]()
        
        model.append(Post(author: "В Мире Животных", description: "Котик", image: "krasivye-kartinki-kotov-31", like: 2, view: 12))
        model.append(Post(author: "Ждун", description: "Ждун-Ждуныч", image: "5631", like: 231, view: 12345))
        
        return model
        }
}

public struct PostImage {
    public var image: String
    
    public static func setupImages() -> [PostImage]{
        let data = ["pucture1","pucture2","pucture3","pucture4","pucture5",
                    "pucture6","pucture7","pucture8","pucture9","pucture10",
                    "pucture11","pucture12","pucture13","pucture14","pucture15",
                    "pucture16","pucture17","pucture18","pucture19","pucture20",]
        var tempImage = [PostImage]()
        for (_, names) in data.enumerated() {
            tempImage.append(PostImage(image: names))
        }
        return tempImage
    }
    public static func makeArrayImage() -> [UIImage] {
        var tempImages = [UIImage]()
        let data = ["pucture1","pucture2","pucture3","pucture4","pucture5",
                    "pucture6","pucture7","pucture8","pucture9","pucture10",
                    "pucture11","pucture12","pucture13","pucture14","pucture15",
                    "pucture16","pucture17","pucture18","pucture19","pucture20",]
        for (_,name) in data.enumerated() {
            tempImages.append(UIImage(named: name)!)
        }
        return tempImages
    }
    
    public static func makeArrayImage(countPhoto: Int, startIndex: Int) -> [UIImage] {
    if (startIndex < PostImage.makeArrayImage().count && startIndex >= 0)  &&  startIndex + countPhoto < PostImage.makeArrayImage().count {
                return Array(PostImage.makeArrayImage()[startIndex...countPhoto + startIndex - 1])
            }
            return PostImage.makeArrayImage()
    }
}
