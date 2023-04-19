//
//  SessionStorage.swift
//  iantha
//
//  Created by Taylor Meek on 4/4/23.
//

// TODO:
/*
I recommend using CoreData for session persistence. CoreData is a powerful and flexible framework provided by Apple for storing structured data on iOS devices. It's well-suited for this task as it provides a robust, scalable, and efficient way to store and manage session data.

Using CoreData, you can easily store complex data structures, relationships between objects, and even perform complex queries to retrieve data. Moreover, CoreData supports automatic data migration and is optimized for low memory usage, making it an excellent choice for both small and large applications.

To implement CoreData for session persistence, follow these steps:

Add a CoreData model to your project: In Xcode, go to File > New > File, select "Data Model" and name it "Model". This will create a .xcdatamodeld file.

Create a Session entity: In the data model editor, click on the "+" button at the bottom and create a new entity named "Session". Add attributes like id, date, and relationships to other entities like ChatMessage as needed.

Set up a Core Data stack: This involves setting up a NSPersistentContainer instance in your AppDelegate or @main file, and injecting it into your SwiftUI environment.

Update SessionStorage to use CoreData: Modify the SessionStorage class to use CoreData for storing and retrieving sessions. This will involve creating NSManagedObject subclasses for your entities, and using NSFetchRequest to query the data.

Migrate existing data: If you have existing session data stored in-memory or using another method, you'll need to migrate this data to CoreData.

By following these steps, you can implement a robust and scalable persistence solution for your session data using CoreData.
                                */

import Foundation

class SessionStorage {
    private var sessions: [Session] = []
    
    func saveSession(_ session: Session) {
        sessions.append(session)
    }
    
    func getSessions() -> [Session] {
        return sessions
    }
    
    func getSession(withId id: UUID) -> Session? {
        return sessions.first { $0.id == id }
    }
    
    func deleteSession(withId id: UUID) {
        sessions.removeAll { $0.id == id }
    }
}
