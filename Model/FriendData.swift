//
//  FriendData.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 30.01.2021.
//

import Foundation

struct Friend {
    let name: String
    let surname: String
    
    let photoName: String
    
    init(name: String, surname: String, photoName: String) {
        self.name = name
        self.surname = surname
        self.photoName = photoName
    }
    
    func getFullName() -> String {
        return name + " " + surname
    }
}

let friendsArray = [
    Friend(name: "Katherine", surname: "Adams", photoName: "srvpgeneralcounsel_image"),
    Friend(name: "Eddy", surname: "Cue", photoName: "srvpinternetsoftwareandservices_image"),
    Friend(name: "Craig", surname: "Federighi", photoName: "srvpsoftwareengineering_image"),
    Friend(name: "John", surname: "Giannandrea", photoName: "svpmachinelearningaistrategy_image"),
    Friend(name: "Greg “Joz”", surname: "Joswiak", photoName: "greg-joswiak"),
    Friend(name: "Sabih", surname: "Khan", photoName: "Sabih_Khan_image"),
    Friend(name: "Luca", surname: "Maestri", photoName: "srvpcfo_image"),
    Friend(name: "Deirdre", surname: "O’Brien", photoName: "srvpretailpeople_image"),
    Friend(name: "Dan", surname: "Riccio", photoName: "srvphardwareengineering_image"),
    Friend(name: "Johny", surname: "Srouji", photoName: "srvphardwaretech_image"),
    Friend(name: "Jeff ", surname: "Williams", photoName: "cco"),
    Friend(name: "Lisa", surname: "Jackson", photoName: "environmentalpolicysocial_image"),
    Friend(name: "Isabel", surname: "Ge Mahe", photoName: "greaterchina_image"),
    Friend(name: "Tor", surname: "Myhren", photoName: "marcom_image"),
    Friend(name: "Adrian", surname: "Perica", photoName: "corporatedevelopment_image"),
    Friend(name: "Phill", surname: "Schiller", photoName: "srvpworldwidemarketing_image")
]
