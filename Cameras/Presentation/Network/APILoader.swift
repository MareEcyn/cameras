import Foundation

/// Provides a set of methods for loading data through HTTP protocol.
final class APILoader {
    private func load(url: URL, completion: @escaping (Data?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            DispatchQueue.main.async { completion(data) }
        }
        .resume()
    }

    func loadImage(url: URL, completion: @escaping (Data?) -> Void) {
        load(url: url) { data in
            completion(data)
        }
    }

    func loadObjects<T: Decodable>(url: URL, completion: @escaping ([T]?) -> Void) {
        load(url: url) { data in
            guard let data = data else {
                completion(nil)
                return
            }
            let container = try? JSONDecoder().decode([T].self, from: data)
            completion(container)
        }
    }
}
