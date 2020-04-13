//
//  Flickr.swift
//  flickrApi
//
//  Created by 이규민 on 2020/04/12.
//  Copyright © 2020 quokka. All rights reserved.
//

struct Flickr: Codable {
    var photos: Photos
}

struct Photos: Codable {
    var photo : [Photo]
}

struct Photo: Codable {
    let id: String
    let title: String
    let server: String
    let farm: Int
    let secret: String
}


//    https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}.jpg
