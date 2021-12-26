import SwiftUI

@main
struct CamerasApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                CamerasListView(model: CamerasViewModel())
            }
        }
    }
}
