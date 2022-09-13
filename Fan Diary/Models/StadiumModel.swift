//
//  StadiumModel.swift
//  Fan Diary
//
//  Created by Сергей Иванов on 25.08.2022.
//

import Foundation
import RealmSwift
import SwiftUI

class Club: Object {
    
    @objc dynamic var clubName = ""
    @objc dynamic var stadium: String?
    @objc dynamic var location: String?
    @objc dynamic var imageData: Data?
    @objc dynamic var date = Date()
    @objc dynamic var rating = 0.0
    
    convenience init(clubName: String, stadium: String?, location: String?, imageData: Data?, rating: Double) {
        self.init()
        self.clubName = clubName
        self.stadium = stadium
        self.location = location
        self.imageData = imageData
        self.rating = rating
    }
}
