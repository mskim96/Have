/**
 * Abstract:
 * Implementation of ReminderList Network Datasource.
 */

import Foundation
import FirebaseFirestore

class DefaultReminderListNetworkDataSource: ReminderListNetworkDataSource {
    
    private let collectionRef = ReminderFirestore.shared.firestore.collection("ReminderList")
    
    func getReminderLists() async throws -> [NetworkReminderList] {
        do {
            let querySnapshot = try await collectionRef.order(by: "createdAt").getDocuments()
            let reminderLists = try querySnapshot.documents.compactMap { document in
                try document.data(as: NetworkReminderList.self)
            }
            return reminderLists
        } catch {
            throw error
        }
    }
    
    func getReminderList(withId id: NetworkReminder.ID) async throws -> NetworkReminderList {
        do {
            let documentSnapshot = try await collectionRef.document(id).getDocument()
            return try documentSnapshot.data(as: NetworkReminderList.self)
        } catch {
            throw error
        }
    }
    
    func insertReminderList(_ reminderList: NetworkReminderList) async throws {
        do {
            try collectionRef.document(reminderList.id).setData(from: reminderList)
        } catch {
            throw error
        }
    }
    
    func updateReminderList(_ reminderList: NetworkReminderList) async throws {
        do {
            try await collectionRef.document(reminderList.id).updateData(
                [
                    "name": reminderList.name,
                    "imageName": reminderList.imageName,
                    "type": reminderList.type.rawValue,
                    "color": reminderList.color
                ]
            )
        }
    }
    
    func deleteReminderList(withId id: String) async throws {
        do {
            try await collectionRef.document(id).delete()
        } catch {
            throw error
        }
    }
}
