//
//  DownloadJSON.swift
//  DukeEventCalendar
//
//  Created by Fall2023 on 11/2/23.
//

import Foundation
import SwiftSoup
import WebKit

func downloadUrl(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
    let session = URLSession.shared
    let urlReq = URLRequest(url: url)
    let task = session.dataTask(with: urlReq) { (data, response, error) in
        if let error = error {
            completion(.failure(error))
            return
        }
        guard let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode)
        else {
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
            let statusError = NSError(domain: "HTTP", code: statusCode, userInfo: nil)
            completion(.failure(statusError))
            return
        }

        if let data = data {
            completion(.success(data))
        }
        else {
            let unknownError = NSError(domain: "UnknownError", code: -1, userInfo: nil)
            completion(.failure(unknownError))
        }
    }

    task.resume()
}

/*
 // Example usage:
 if let url = URL(string: "https://calendar.duke.edu/events/index.json?&future_days=45&feed_type=simple") {
     downloadJSON(from: url) { result in
         switch result {
         case .success(let data):
             // Process the JSON data here
             do {
                 let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                 if let jsonDictionary = jsonObject as? [String: Any] {
                     // Access JSON data as needed
                     print(jsonDictionary)
                 } else {
                     print("JSON data is not a dictionary")
                 }
             } catch {
                 print("Error parsing JSON: \(error)")
             }

         case .failure(let error):
             print("Error downloading JSON: \(error)")
         }
     }
 }
 */

func saveOptions(options: [String], withFileName fileName: String) {
    guard
        let documentDirectory = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask).first
    else { return }

    let fileURL = documentDirectory.appendingPathComponent(fileName)
    do {
        let data = try JSONSerialization.data(withJSONObject: options, options: [])
        try data.write(to: fileURL, options: .atomicWrite)
        print("Options saved to: \(fileURL)")
    }
    catch {
        print("Failed to save options: \(error.localizedDescription)")
    }
}

func generateAndFetchEvents(
    groups: [String]?,
    categories: [String]?,
    futureDays: Int,
    dataModel: DataModel
) {
    var components = URLComponents(string: "https://calendar.duke.edu/events/index.json")

    var queryItems: [URLQueryItem] = []

    // 添加 category 参数
    if let categories = categories, !categories.isEmpty {
        let categoryItems = categories.map { URLQueryItem(name: "cfu[]", value: $0) }
        queryItems.append(contentsOf: categoryItems)
    }

    // 添加 group 参数
    if let groups = groups, !groups.isEmpty {
        let groupItems = groups.map { URLQueryItem(name: "gfu[]", value: $0) }
        queryItems.append(contentsOf: groupItems)
    }

    // 添加 future_days 和 feed_type 参数
    queryItems.append(URLQueryItem(name: "future_days", value: String(futureDays)))
    queryItems.append(URLQueryItem(name: "feed_type", value: "simple"))

    components?.queryItems = queryItems

    guard let url = components?.url else {
        print("Invalid URL")
        return
    }

    // 开始下载
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        // 确保没有错误，并且数据非空
        guard let data = data, error == nil else {
            print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
            // load previous saved json
            dataModel.loadEvents()
            return
        }

        // 尝试将数据保存到本地文件
        saveDataToLocalFile(data: data, filename: "events.json")
        dataModel.loadEvents()
    }

    // 启动任务
    task.resume()
}

func saveDataToLocalFile(data: Data, filename: String) {
    do {
        let fileURL = try FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(filename)

        // 写入数据到文件
        try data.write(to: fileURL, options: .atomic)
        print("File saved: \(fileURL.absoluteString)")
    }
    catch {
        print("Error saving file: \(error.localizedDescription)")
    }
}

func load<T: Decodable>(_ filename: String) throws -> T {
    let data: Data

    let fileURL = try? FileManager.default
        .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        .appendingPathComponent(filename)

    guard let file = fileURL else {
        throw Myerror.fileError("Cannot find file: \(filename)")
    }

    data = try Data(contentsOf: file)
    let decoder = JSONDecoder()
    return try decoder.decode(T.self, from: data)
}

func loadCateAndGroup(){
    var loader1 = WebPageLoader()
    var loader2 = WebPageLoader()
    let urlString = "https://urlbuilder.calendar.duke.edu/"
    if let url = URL(string: urlString) {
        loader1.loadOptions(from: url, selectElementID: "categorieselect") {
            (options, error) in
            if let options = options {
                // Output to console
                saveOptions(options: options, withFileName: "Categories.json")
                //print(options.count)
            }
            else if let error = error {
                print("Error: \(error)")
            }
        }
        loader2.loadOptions(from: url, selectElementID: "groupselect") { (options, error) in
            if let options = options {
                // Output to console
                saveOptions(options: options, withFileName: "Groups.json")
                //print(options.count)
            }
            else if let error = error {
                print("Error: \(error)")
            }
        }
    }
}

enum Myerror: Error {
    case fileError(String)
}
