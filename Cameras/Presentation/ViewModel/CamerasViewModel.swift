import Foundation
import UIKit

struct CameraData {
    let id: Int
    let title: String
    let preview: UIImage
}

final class CamerasViewModel: ObservableObject {
    enum Status {
        case initial, loading, complete, error
    }
    
    /// Items loading status
    @Published private(set) var status: Status = .initial
    private(set) var items: [CameraData] = []
    
    private let manager = APILoader()
    private let camerasListURL = URL(string: "https://orionnet.online/api/v1/cameras/public")!
    private let cameraPreviewURL = URL(string: "https://orionnet.online/api/v2/preview_images/")!
    
    func getPreviewRequest(forCamera id: Int) -> URLRequest {
        let url = URL(string: "https://krkvideo1.orionnet.online/cam\(id)/embed.html")!
        let request = URLRequest(url: url)
        return request
    }
    
    func fetch(itemsCount: Int) {
        guard items.isEmpty else { return }
        status = .loading
        manager.loadObjects(url: camerasListURL) { [weak self] (data: [Camera]?) in
            guard let self = self, let cameras = data else {
                self?.status = .error
                return
            }
            let count = itemsCount > cameras.count ? cameras.count : itemsCount
            for camera in cameras.prefix(count) {
                self.fetchImage(camera: camera)
            }
        }
    }
    
    private func fetchImage(camera: Camera) {
        let url = cameraPreviewURL.appendingPathComponent("\(camera.id)")
        manager.loadImage(url: url) { imageData in
            guard let imageData = imageData,
                  let image = UIImage(data: imageData)
            else { return }
            let item = CameraData(id: camera.id, title: camera.title, preview: image)
            self.items.append(item)
            self.status = .complete
        }
    }
}
