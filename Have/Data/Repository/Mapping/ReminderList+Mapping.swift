/**
 * Abstract:
 * Extensions for Mapping ReminderList.
 */

import UIKit

// MARK: - Network to external

extension NetworkReminderList {
    /// Mapping the network model to external model.
    func toExternalModel() -> ReminderList {
        return ReminderList(
            id: self.id,
            name: self.name,
            imageName: self.imageName,
            type: self.type,
            color: self.color.toUIColor()
        )
    }
}

extension [NetworkReminderList] {
    /// Mapping the network models to external models.
    func toExternalModel() -> [ReminderList] {
        return self.isEmpty ? [] : self.map { $0.toExternalModel() }
    }
}

// MARK: - External to network

extension ReminderList {
    /// Mapping the external model to network model.
    func toNetworkModel() -> NetworkReminderList {
        return NetworkReminderList(
            id: self.id,
            name: self.name,
            imageName: self.imageName,
            type: self.type,
            color: self.color.toHexString(),
            createdAt: Date()
        )
    }
}

extension [ReminderList] {
    /// Mapping the external models to network models.
    func toNetworkModel() -> [NetworkReminderList] {
        return self.isEmpty ? [] : self.map { $0.toNetworkModel() }
    }
}
