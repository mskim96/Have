/**
 * Abstract:
 * Implementation of Reminder Network DataSource.
 */

import Foundation
import FirebaseFirestore

class DefaultReminderNetworkDataSource: ReminderNetworkDataSource {
    
    private let collectionRef = ReminderFirestore.shared.firestore.collection("Reminder")
    
    func getReminders() async throws -> [NetworkReminder] {
        do {
            let querySnapshot = try await collectionRef.order(by: "createdAt").getDocuments()
            let reminders = try querySnapshot.documents.compactMap { document in
                try document.data(as: NetworkReminder.self)
            }
            return reminders
        } catch {
            throw error
        }
    }
    
    func getReminder(withId id: NetworkReminder.ID) async throws -> NetworkReminder {
        do {
            let documentSnapshot = try await collectionRef.document(id).getDocument()
            return try documentSnapshot.data(as: NetworkReminder.self)
        } catch {
            throw error
        }
    }
    
    func insertReminder(_ reminder: NetworkReminder) async throws {
        do {
            try collectionRef.document(reminder.id).setData(from: reminder)
        } catch {
            throw error
        }
    }
    
    func updateReminder(_ reminder: NetworkReminder) async throws {
        do {
            try await collectionRef.document(reminder.id).updateData(
                [
                    "title": reminder.title,
                    "notes": reminder.notes as Any,
                    "dueDate": reminder.dueDate as Any,
                    "dueTime": reminder.dueTime as Any,
                    "isCompleted": reminder.isCompleted,
                    "isFlagged": reminder.isFlagged,
                    "reminderListRefId": reminder.reminderListRefId
                ]
            )
        } catch {
            throw error
        }
    }
    
    
    func updateCompleted(withId id: NetworkReminder.ID) async throws {
        do {
            var reminder = try await collectionRef.document(id).getDocument(as: NetworkReminder.self)
            try await collectionRef.document(id).updateData(
                ["isCompleted": !reminder.isCompleted]
            )
        } catch {
            throw error
        }
    }
    
    func updateFlagged(withId id: NetworkReminder.ID) async throws {
        do {
            var reminder = try await collectionRef.document(id).getDocument(as: NetworkReminder.self)
            try await collectionRef.document(id).updateData(
                ["isFlagged": !reminder.isFlagged]
            )
        } catch {
            throw error
        }
    }
    
    func deleteReminder(withId id: NetworkReminder.ID) async throws {
        do {
            try await collectionRef.document(id).delete()
        } catch {
            throw error
        }
    }
    
    func deleteReminder(withReminderListRef refId: NetworkReminderList.ID) async throws {
        do {
            let querySnapshot = try await collectionRef.whereField("reminderListRefId", isEqualTo: refId).getDocuments()
            for document in querySnapshot.documents {
                try await collectionRef.document(document.documentID).delete()
            }
        } catch {
            throw error
        }
    }
}
