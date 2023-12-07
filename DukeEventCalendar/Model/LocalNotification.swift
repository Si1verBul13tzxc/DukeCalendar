//
//  LocalNotification.swift
//  DukeEventCalendar
//
//  Created by xz353 on 12/5/23.
//

import Foundation
import UserNotifications

//Adapted from https://medium.com/@setukanani_6029/local-notifications-with-swift-57d2e340dd1a
class LocalNotificationManager: NSObject, UNUserNotificationCenterDelegate, ObservableObject {
    var notifications = [LocalNotification]()
    @Published var notifiedNotifications = [LocalNotification]()

    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }

    //Handle with notification when the app is running foreground
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) ->
            Void
    ) {
        let id = notification.request.identifier
        print("In App: Notification ID = \(id)")
        let content = notification.request.content
        notifiedNotifications.append(
            LocalNotification(id: id, title: content.title, subtitle: content.body,datetime: notification.date)
        )
        completionHandler([.banner, .sound])
    }

    //Handle with notificaiton when the app is
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let id = response.notification.request.identifier
        print("Background: Notification ID = \(id)")
        let content = response.notification.request.content
        notifiedNotifications.append(
            LocalNotification(id: id, title: content.title, subtitle: content.body,datetime: response.notification.date)
        )
        completionHandler()
    }

    func schedule() {
        UNUserNotificationCenter.current()
            .getNotificationSettings { settings in
                switch settings.authorizationStatus {
                    case .notDetermined:
                        self.requestAuthorization()
                    case .authorized, .provisional:
                        self.scheduleNotifications()
                    default:
                        break
                }

            }
    }

    func cancelNotifications() {
        for notification in notifications {
            notification.remove()
        }
        notifications = []
    }

    private func requestAuthorization() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                if granted == true && error == nil {

                }
            }
    }

    private func scheduleNotifications() {
        for notification in notifications {
            notification.schedule()
        }
    }
}

struct LocalNotification {
    var id: String
    var title: String
    var subtitle: String
    var datetime: Date
    var repeats: Bool

    init(
        id: String,
        title: String = "",
        subtitle: String = "",
        datetime: Date = Date(),
        repeats: Bool = false
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.datetime = datetime
        self.repeats = repeats
    }

    func schedule() {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = subtitle
        content.sound = .default
        content.badge = 1
        let triggerDateTime = Calendar.current.dateComponents(
            [.hour, .minute, .second],
            from: datetime
        )
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: triggerDateTime,
            repeats: repeats
        )
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current()
            .add(request) { error in
                guard error == nil else { return }
                print("Notification scheduled! --- ID = \(self.id)")
            }
    }

    func remove() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [id])
        print("Notification removed --- ID = \(self.id)")
    }
}
