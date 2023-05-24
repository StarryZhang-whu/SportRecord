//
//  DBService.swift
//  SportRecord
//
//  Created by 张凌浩 on 2023/5/23.
//
import SQLite
import SwiftUI
import Foundation

class DBService {
    static let shared = DBService()
    
    private var db: Connection?
    private let users = Table("users")
    private let id = Expression<Int64>("id")
    private let name = Expression<String>("name")
    private let email = Expression<String>("email")
    private let password = Expression<String>("password")
    
    let records = Table("records")
    let duration = Expression<TimeInterval>("duration")
    let image = Expression<Data>("image")
    let date = Expression<Date>("date")

    
    private init() {
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            do {
                db = try Connection("\(path)/db.sqlite3")
                print("Connect to DB")
                
                try createTableUsers()
                try createTableRecords()
                print("Create Users table")
            
            } catch {
                db = nil
                print("Unable to open database")
            }
        }
    
    func createTableUsers() throws {
            try db!.run(users.create(ifNotExists: true) { t in
                t.column(id, primaryKey: .autoincrement)
                t.column(name)
                t.column(email, unique: true)
                t.column(password)
            })
        }
    func createTableRecords() throws {
        try db!.run(records.create(ifNotExists: true){ t in
            t.column(id, primaryKey: .autoincrement)
            t.column(duration)
            t.column(image)
            t.column(date)
        })
    }
    func addUser(name: String, email: String, password: String) -> Int64? {
            do {
                let insert = users.insert(self.name <- name, self.email <- email, self.password <- password)
                let id = try db!.run(insert)
                return id
            } catch {
                print("Insert failed: \(error)")
                return nil
            }
        }
    
    func validateUser(email: String, password: String) -> Bool {
        do {
            let query = users.filter(self.email == email && self.password == password)
            let user = try db?.pluck(query)
            return user != nil
        } catch {
            return false
        }
    }
    
    func getUser(email: String) -> User? {
        do{
            let query = users.filter(self.email == email)
            if let user = try db?.pluck(query) {
                let fetchedUser = User(id: Int(user[id]), name: user[name], email: user[self.email])
                return fetchedUser
            } else {
                return nil
            }
        } catch {
            print("error when getUser")
            return nil
        }
    }
    
    func addRecord(duration: TimeInterval, image: UIImage){
        do {
            if let imageData = image.pngData() {
                let insert = records.insert(self.duration <- duration, self.image <- imageData, self.date <- Date())
                _ = try db!.run(insert)
            } else {
                print("Failed to convert image to data.")
                return
            }
        } catch {
            print("Insert failed: \(error)")
            return
        }
    }
    
    func fetchRecords() -> [Record]? {
        do {
            return try db!.prepare(records).map { row in
                let id: Int64 = try row.get(self.id)
                let duration: TimeInterval = try row.get(self.duration)
                let image = UIImage(data: try row.get(self.image))!
                let date = try row.get(self.date)
                return Record(id: id, duration: duration, image: image,date: date)
            }
        } catch {
            print("Fetch failed: \(error)")
            return nil
        }
    }

}
