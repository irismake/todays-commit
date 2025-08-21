import SwiftUI

struct PlaceDetailView: View {
  @Environment(\.dismiss) private var dismiss
  @EnvironmentObject var placeManager: PlaceManager
  @State private var placeData: AddPlaceData?
        
  var body: some View {
    if let placeDetail = placeManager.placeDetail {
      VStack(alignment: .leading) {
        HStack {
          Button(action: { dismiss() }) {
            Image(systemName: "chevron.left")
              .foregroundColor(.primary)
              .padding(.vertical)
          }
          Spacer()
        }
        .padding(.top)
        ScrollView {
          VStack(alignment: .leading) {
            HStack {
              HStack(spacing: 4) {
                Image(systemName: "location.fill")
                  .font(.system(size: 10, weight: .semibold))
                  .foregroundColor(.secondary)
                Text(placeDetail.distance ?? "")
                  .font(.caption)
                  .foregroundColor(.secondary)
              }
                            
              HStack(spacing: 4) {
                Image("icon_commit")
                  .renderingMode(.template)
                  .foregroundColor(.secondary)
                  .aspectRatio(contentMode: .fit)
                  .frame(height: 10)
                                
                Text("\(placeDetail.commitCount ?? 0)회")
                  .font(.caption)
                  .foregroundColor(.secondary)
              }
            }
                        
            Text(placeDetail.name)
              .font(.title2)
              .fontWeight(.bold)
                        
            VStack(spacing: 10) {
              Button(action: {
                print("주소 버튼 탭됨")
              }) {
                HStack(spacing: 8) {
                  Image(systemName: "arrow.up.forward")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.primary)
                                    
                  Text(placeDetail.address)
                    .font(.caption)
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.clear)
                .overlay(
                  RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.primary.opacity(0.3), lineWidth: 1)
                )
              }
              .buttonStyle(PlainButtonStyle())
              .scaleEffect(1.0)
              .animation(.easeInOut(duration: 0.1), value: false)
              .padding(.horizontal, 1)
                            
              KakaoMapButton()
            }
            .padding(.vertical)
                        
            Text("커밋 내역")
              .font(.headline)
              .fontWeight(.bold)
              .padding(.vertical)

            ForEach(placeDetail.commits, id: \.commitId) { commit in
              CommitAuthItem(createdAt: commit.createdAt, userName: commit.userName)
            }
          }
        }

        CompleteButton(onComplete: {
          let name = placeDetail.name
          let pnu = placeDetail.pnu
          let address = placeDetail.address
          let x = placeDetail.x
          let y = placeDetail.y
          placeData = AddPlaceData(pnu: pnu, name: name, address: address, x: x, y: y)
        }, title: "커밋하기", color: Color.green)
          .padding(.bottom)
      }
      .padding(.horizontal)
      .sheet(item: $placeData) { data in
        CommitView(placeData: data) {
          dismiss()
        }
      }
       
    } else {
      ProgressView("Loading...")
    }
  }
}

struct PlaceDetailView_Previews: PreviewProvider {
  static var previews: some View {
    PlaceDetailView()
  }
}
