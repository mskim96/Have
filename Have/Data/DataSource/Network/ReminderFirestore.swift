/**
 * Abstract:
 * Singleton Firebase database class.
 */

import FirebaseCore
import FirebaseFirestore

class ReminderFirestore {
    // access point for this class.
    static let shared = ReminderFirestore()
    
    // lazy init firestore
    lazy var firestore: Firestore = {
        return Firestore.firestore()
    }()
    
    private init() { }
}
