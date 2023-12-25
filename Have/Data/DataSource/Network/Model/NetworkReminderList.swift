/**
 * Abstract:
 * ReminderList model for network layer.
 */

import Foundation
import FirebaseFirestore

/// Model class for a reminder list on the network layer.
///
/// - Parameters:
///     - id: id of network reminder list.
///     - name: name of network reminder list.
///     - imageName: image name of network reminder list.
///     - type: reminder list type of network reminder list.
///     - color: hex code of color for the network reminder list.
///     - createdAt: the timestamp when network reminder list was created.
///
struct NetworkReminderList: Codable, Identifiable {
    var id: String
    var name: String
    var imageName: String
    var type: ReminderListType
    var color: String
    @ServerTimestamp var createdAt: Date?
}
