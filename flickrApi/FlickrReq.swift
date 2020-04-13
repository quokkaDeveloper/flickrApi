//
//  FlickrReq.swift
//
//  Created by 이규민 on 2020/04/12.
//  Copyright © 2020 quokka. All rights reserved.
//

import Foundation

struct Req {
    let baseUrl = "https://www.flickr.com/services/rest"
    let method = "flickr.photos.search"
    let apikey = "127486bde7272f95e36489f787794c58"
    let format = "json"
    let nojsoncallback = 1
    
    enum CodingKeys : String, CodingKey {
        case baseUrl, method, apikey = "api_key", format, nojsoncallback
    }
}



