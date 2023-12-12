/**
 * Abstract - Actions for ReminderViewController.
 */

import UIKit

extension ReminderViewController {
    
    /// Called when the user clicks save button.
    @objc func didPressSaveButton(_ sender: UIBarButtonItem) {
        if workingReminder != reminder {
            reminder = workingReminder
        }
        dismiss(animated: true)
    }
    
    /// Called when the user clicks cancel button.
    @objc func didPressCancelButton(_ sender: UIBarButtonItem) {
        workingReminder = reminder
        dismiss(animated: true)
    }
    
    /// Called when the user clicks the switch button in Date row.
    @objc func didToggleDateSwitch(_ sender: UISwitch) {
        if sender.isOn {
            // Set date value to today. (nil -> Today)
            updateDate(to: Date())
        } else {
            // Set date and time values to nil.
            // If there is a time but no date, treat them both as nil.
            timeSwitch.isOn = false
            updateDate(to: nil)
            updateTime(to: nil)
        }
        toggleSwitchSnapshot(for: .date, isOn: sender.isOn)
    }
    
    /// Called when the user clicks the switch button in Time row.
    @objc func didToggleTimeSwitch(_ sender: UISwitch) {
        if sender.isOn {
            // if date does not exist.
            if workingReminder.dueDate == nil {
                dateSwitch.isOn = true
                updateDate(to: Date())
            }
            updateTime(to: Date())
        } else {
            updateTime(to: nil)
        }
        toggleSwitchSnapshot(for: .time, isOn: sender.isOn)
    }
    
    @objc func didToggleFlagSwitch(_ sender: UISwitch) {
        updateFlagged(to: sender.isOn)
    }
}
