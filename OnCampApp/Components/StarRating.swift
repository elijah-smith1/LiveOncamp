import SwiftUI

struct StarRating: View {
    var vendor: Vendor
    var maximumRating: Int = 5
    let onImage = Image(systemName: "star.fill")
    let offImage = Image(systemName: "star")
    let halfImage = Image(systemName: "star.leadinghalf.filled")

    func image(for number: Int) -> Image {
        if Double(number) > vendor.rating {
            return offImage
        } else if Double(number) > vendor.rating - 0.5 {
            return halfImage
        } else {
            return onImage
        }
    }

    var body: some View {
        HStack(spacing: -1) { // No spacing between stars
            ForEach(1...maximumRating, id: \.self) { number in
                self.image(for: number)
                    .foregroundColor(.yellow)
            }
        }
    }
}
