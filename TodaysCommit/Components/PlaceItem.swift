import SwiftUI

struct PlaceItem: View {
  var onTap: () async -> Void
  let placeName: String
  let distance: String
  let commitCount: Int
  let grassColor: Color
    
  var body: some View {
    Button(action: {
      Task {
        await onTap()
      }
    }) {
      HStack {
        VStack(alignment: .leading, spacing: 20) {
          Text(placeName)
            .font(.headline)
            .foregroundColor(.primary)
            .lineLimit(1)
              
          HStack {
            HStack(spacing: 4) {
              Image(systemName: "location.fill")
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(.secondary)
              Text(distance)
                .font(.caption)
                .foregroundColor(.secondary)
            }

            HStack(spacing: 4) {
              Image("icon_commit")
                .renderingMode(.template)
                .foregroundColor(.secondary)
                .aspectRatio(contentMode: .fit)
                .frame(height: 10)
               
              Text("\(commitCount)회")
                .font(.caption)
                .foregroundColor(.secondary)
            }
          }
        }
         
        Spacer()

        Image(systemName: "chevron.right")
          .font(.system(size: 12, weight: .semibold))
          .foregroundColor(.gray.opacity(0.6))
      }
      .padding()
      .background(Color(.systemBackground))
      .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
      .overlay(
        RoundedRectangle(cornerRadius: 16, style: .continuous)
          .stroke(grassColor.opacity(0.3), lineWidth: 1)
      )
      .shadow(color: grassColor.opacity(0.1), radius: 6, x: 0, y: 0)
    }
    .buttonStyle(.plain)
  }
}

struct PlaceItem_Previews: PreviewProvider {
  static var previews: some View {
    VStack(spacing: 20) {
      PlaceItem(onTap: {}, placeName: "커피스토어", distance: "123m", commitCount: 125, grassColor: .lv_4)
      PlaceItem(onTap: {}, placeName: "스타벅스 성신여대점", distance: "9m", commitCount: 42, grassColor: .lv_1)
    }
    .padding()
  }
}
