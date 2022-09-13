//
//  StorageManager.swift
//  Fan Diary
//
//  Created by Сергей Иванов on 27.08.2022.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static func saveObject(_ club: Club) {
        try! realm.write {
            realm.add(club)
        }
    }
    
    static func deleteObject(_ club: Club) {
        try! realm.write {
            realm.delete(club)
        }
    }
}
