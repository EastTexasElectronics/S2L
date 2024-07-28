import Foundation

func fetchAppStoreVersion(completion: @escaping (String?) -> Void) {
    let appID = "6581479697" // Your app's Apple ID
    let urlString = "https://itunes.apple.com/lookup?id=\(appID)"
    
    guard let url = URL(string: urlString) else {
        completion(nil)
        return
    }
    
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data, error == nil else {
            completion(nil)
            return
        }
        
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let results = json["results"] as? [[String: Any]],
               let appStoreVersion = results.first?["version"] as? String {
                completion(appStoreVersion)
            } else {
                completion(nil)
            }
        } catch {
            completion(nil)
        }
    }
    
    task.resume()
}
