import SwiftUI

struct FixtureView: View {

    var body: some View {
        VStack {
            Text("Hello, World!")
        }
    }
    
    private func formatDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "MMM d, yyyy 'at' h:mm a"
            return dateFormatter.string(from: date)
        } else {
            return "Invalid Date"
        }
    }
}
