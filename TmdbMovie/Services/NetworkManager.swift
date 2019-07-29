//
//  NetworkManager.swift
//  TmdbMovie
//
//  Created by Michael Abadi on 23/07/19.
//  Copyright © 2019 Michael Abadi Santoso. All rights reserved.
//

import Foundation

/// Protocol that managing default properties for every controller in modules
protocol BaseController {
    var isLoading: Bool { get set }
    var page: Int { get set }
    func loadData(withPage page: Int)
}

/// Handler for managing network request
protocol NetworkHandler {
    func network(_ controller: BaseController, willSendRequest request: BaseRequest, method: HttpMethod)
}

/// Observer for retrieving network response
protocol NetworkManagerObserver: AnyObject {
    func networkManager(_ manager: NetworkManager?, didRetrieveDataWith response: Any)
}

/// Class for handling all base network transaction defined by the handler
final class NetworkManager: NetworkHandler {
    
    private let observer: NetworkManagerObserver?
    
    init(observer: NetworkManagerObserver) {
        self.observer = observer
    }
    
    func network(_ controller: BaseController, willSendRequest request: BaseRequest, method: HttpMethod) {
        guard let url = URL(string: request.endpoint) else { return }
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        let task = session.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                self?.observer?.networkManager(self, didRetrieveDataWith: json)
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}

