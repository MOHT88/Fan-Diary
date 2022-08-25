//
//  StadiumModel.swift
//  Fan Diary
//
//  Created by Сергей Иванов on 25.08.2022.
//

import Foundation

struct Club {
    
    var clubName: String
    var stadium: String
    var location: String
    var image: String
    
    
    static let clubs = ["ЦСКА", "Спартак", "Арсенал", "Локомотив", "Динамо", "Рубин"]
    
   static func getClubs() -> [Club] {
        var clubs = [Club]()
        
        for club in self.clubs {
            clubs.append(Club(clubName: club, stadium: "VEB Arena", location: "Moscow", image: club))
        }
        
        
        return clubs
    }
}
