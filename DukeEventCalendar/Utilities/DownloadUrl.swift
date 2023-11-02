//
//  DownloadJSON.swift
//  DukeEventCalendar
//
//  Created by Fall2023 on 11/2/23.
//

import Foundation

func downloadUrl(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
    let session = URLSession.shared
    let urlReq = URLRequest(url: url)
    let task = session.dataTask(with: urlReq) { (data, response, error) in
        if let error = error {
            completion(.failure(error))
            return
        }
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
            let statusError = NSError(domain: "HTTP", code: statusCode, userInfo: nil)
            completion(.failure(statusError))
            return
        }

        if let data = data {
            completion(.success(data))
        } else {
            let unknownError = NSError(domain: "UnknownError", code: -1, userInfo: nil)
            completion(.failure(unknownError))
        }
    }

    task.resume()
}
