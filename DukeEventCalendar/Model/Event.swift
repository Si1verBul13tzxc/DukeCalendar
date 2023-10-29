//
//  Event.swift
//  DukeEventCalendar
//
//  Created by xz353 on 10/29/23.
//

import Foundation

struct Event: Decodable {
    let id: String
    let start_timestamp: Date
    let end_timestamp: Date
    let summary: String
    let description: String
    let status: EventStatus
    let sponsor: String
    let co_sponsors: [String]?
    let location: Location
    let contact: Contact
    let categories: [String]?
    let link: URL
    let event_url: URL?
    let submitted_by: [String]
    let presenter: String?
    let image: URL?
    let image_alt_text: String?

    private enum CodingKeys: CodingKey {
        case id
        case start_timestamp
        case end_timestamp
        case summary
        case description
        case status
        case sponsor
        case co_sponsors
        case location
        case contact
        case categories
        case link
        case event_url
        case submitted_by
        case presenter
        case image
        case image_alt_text
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)

        let starttime_str = try container.decode(String.self, forKey: .start_timestamp)
        let endtime_str = try container.decode(String.self, forKey: .end_timestamp)

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        self.start_timestamp = dateFormatter.date(from: starttime_str)!
        self.end_timestamp = dateFormatter.date(from: endtime_str)!

        self.summary = try container.decode(String.self, forKey: .summary)
        self.description = try container.decode(String.self, forKey: .description)
        self.status = try container.decode(EventStatus.self, forKey: .status)
        self.sponsor = try container.decode(String.self, forKey: .sponsor)
        self.co_sponsors = try container.decodeIfPresent([String].self, forKey: .co_sponsors)
        self.location = try container.decode(Location.self, forKey: .location)
        self.contact = try container.decode(Contact.self, forKey: .contact)
        self.categories = try container.decodeIfPresent([String].self, forKey: .categories)
        self.link = try container.decode(URL.self, forKey: .link)
        self.event_url = try container.decodeIfPresent(URL.self, forKey: .event_url)
        self.submitted_by = try container.decode([String].self, forKey: .submitted_by)
        self.presenter = try container.decodeIfPresent(String.self, forKey: .presenter)
        self.image = try container.decodeIfPresent(URL.self, forKey: .image)
        self.image_alt_text = try container.decodeIfPresent(String.self, forKey: .image_alt_text)
    }
}

enum EventStatus: String, Decodable {
    case confirmed = "CONFIRMED"
    case cancelled = "CANCELLED"
    case tentative = "TENTATIVE"
}

struct Location: Decodable {
    let address: String
    let link: URL?
}

struct Contact: Decodable {
    let name: String
    let phone: String?
    let email: String?
}
