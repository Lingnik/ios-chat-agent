//
//  User.swift
//  iantha
//
//  Created by Taylor Meek on 4/4/23.
//

import Foundation

struct User: Identifiable {
    let id: UUID
    let username: String
    let email: String

    init(id: UUID = UUID(), username: String, email: String) {
        self.id = id
        self.username = username
        self.email = email
    }
}
