//
//  eventEditView.swift
//  DukeEventCalendar
//
//  Created by Oli 奥利奥 on 11/1/23.
//
// adapted from https://github.com/HuangRunHua/wwdc23-code-notes/tree/main/discover-calendar-and-eventkit

import SwiftUI
import EventKitUI

struct EventEditViewController: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    typealias UIViewControllerType = EKEventEditViewController
    
    let ticket: Ticket
    
    private let store = EKEventStore()
    private var event: EKEvent {
        let event = EKEvent(eventStore: store)
        event.title = ticket.title
        if let startDate = ticket.startDate, let endDate = ticket.endDate {
            let startDateComponents = DateComponents(year: startDate.year,
                                                     month: startDate.month,
                                                     day: startDate.day,
                                                     hour: startDate.hour,
                                                     minute: startDate.minute)
            event.startDate = Calendar.current.date(from: startDateComponents)!
            let endDateComponents = DateComponents(year: endDate.year,
                                                     month: endDate.month,
                                                     day: endDate.day,
                                                     hour: endDate.hour,
                                                     minute: endDate.minute)
            event.endDate = Calendar.current.date(from: endDateComponents)!
            event.location = ticket.location
            event.notes = ticket.notes
        }
        return event
    }
    
    func makeUIViewController(context: Context) -> EKEventEditViewController {
        let eventEditViewController = EKEventEditViewController()
        eventEditViewController.event = event
        eventEditViewController.eventStore = store
        eventEditViewController.editViewDelegate = context.coordinator
        return eventEditViewController
    }
    
    func updateUIViewController(_ uiViewController: EKEventEditViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, EKEventEditViewDelegate {
        var parent: EventEditViewController
        
        init(_ controller: EventEditViewController) {
            self.parent = controller
        }
        
        func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
