import SwiftUI

struct HintView: View {
    let text: String
    
    var body: some View {
        Text(text)
            .foregroundColor(._gray)
            .font(.body)
            .fontWeight(.light)
    }
    
    init(_ text: String) {
        self.text = text
    }
}

struct HintView_Previews: PreviewProvider {
    static var previews: some View {
        HintView("Test")
            .previewLayout(.sizeThatFits)
    }
}
