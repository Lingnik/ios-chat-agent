//
//  Session.swift
//  iantha
//
//  Created by Taylor Meek on 4/4/23.
//

import Foundation

struct Session: Identifiable {
    let id: UUID
    let date: Date
    let transcript: String

    init(id: UUID = UUID(), date: Date = Date(), transcript: String) {
        self.id = id
        self.date = date
        self.transcript = transcript
    }
}
