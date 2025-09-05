import StoreKit
import SwiftUI

struct SettingView: View {
  @Environment(\.dismiss) private var dismiss

  @State private var allowNotification = false
  @StateObject private var mailHandler = MailHandler()
    
  @State private var showMailAlert = false
  @State private var showLogoutAlert = false
  @State private var showWithdrawalAlert = false

  let supportSettings = [
    (id: 0, title: "알림 설정", subtitle: "새로운 소식을 받아보세요", hasToggle: true),
    (id: 1, title: "문의 및 피드백", subtitle: "todayscommit@gmail.com", hasToggle: false),
    (id: 2, title: "앱 평가", subtitle: "별점을 남겨주세요", hasToggle: false),
    (id: 3, title: "앱 버전", subtitle: appVersion, hasToggle: false),
    (id: 4, title: "이용약관", subtitle: "자세히 보기", hasToggle: false)
  ]
    
  var body: some View {
    VStack {
      HStack {
        Button(action: { dismiss() }) {
          Image(systemName: "chevron.left")
            .foregroundColor(.primary)
        }
        Spacer()
        Text("설정")
          .font(.headline)
          .fontWeight(.semibold)
          .foregroundColor(.primary)
        Spacer()
      }
      .padding()

      ForEach(supportSettings, id: \.id) { option in
        Button(action: {
          handleAction(for: option.id)
        }) {
          settingsRow(option: option)
        }
      }
      HStack {
        Button(action: {
          showLogoutAlert = true
        }) {
          Text("로그아웃")
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(.secondary)
        }
      
        Spacer()
          
        Button(action: {
          showWithdrawalAlert = true
        }) {
          Text("회원탈퇴")
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(.secondary)
        }
      }
      .padding()
        
      Spacer()
    }
    .sheet(isPresented: $mailHandler.showDefaultMailView) {
      MailView(mailHandler: mailHandler)
    }
    .overlay(overlayView)
  }
    
  @ViewBuilder
  private var overlayView: some View {
    Group {
      AlertDialog(
        title: "메일 보내기",
        message: "메일을 보낼 앱을 선택해주세요",
        isPresented: $showMailAlert
      ) {
        Button("Mail 앱") { mailHandler.sendViaMailApp() }
        Button("다른 메일 앱") { mailHandler.sendViaOtherMailApp() }
        Button("취소", role: .cancel) {}
      }
              
      AlertDialog(
        title: "메일 오류",
        message: mailHandler.errorMessage,
        isPresented: $mailHandler.showErrorAlert
      ) {
        Button("확인", role: .cancel) {}
      }
              
      AlertDialog(
        title: "로그아웃",
        message: "로그아웃 하시겠습니까?",
        isPresented: $showLogoutAlert
      ) {
        Button("확인") {
          Task {
            do {
              let userRes = try await UserAPI.logoutUser()
              UserSessionManager.clearStorgeData()
            } catch {
              print("Logout failed: \(error.localizedDescription)")
            }
          }
        }
        Button("취소", role: .cancel) {}
      }
              
      AlertDialog(
        title: "회원탈퇴",
        message: "회원 탈퇴를 진행하시겠어요? 모든 커밋 기록이 삭제되어 되돌릴 수 없어요.",
        isPresented: $showWithdrawalAlert
      ) {
        Button("확인") {
          Task {
            do {
              let userRes = try await UserAPI.leaveUser()
              UserSessionManager.clearStorgeData()
            } catch {
              print("leave failed: \(error.localizedDescription)")
            }
          }
        }
        Button("취소", role: .cancel) {}
      }
    }
  }
    
  private func handleAction(for id: Int) {
    switch id {
    case 1:
      let mailData = MailData(
        subject: "[문의사항] 앱 관련 문의드립니다.",
        content: "앱 사용 중 불편사항, 문의 또는 피드백을 작성해 주세요."
      )
      mailHandler.saveMailData(for: mailData)
      showMailAlert = true
     
    case 2:
      if let scene = UIApplication.shared.connectedScenes
        .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
      {
        if #available(iOS 18.0, *) {
          AppStore.requestReview(in: scene)
        } else {
          SKStoreReviewController.requestReview(in: scene)
        }
      }

    case 3:
      print("앱 버전")
        
    case 4:
      if let url = URL(string: GlobalStore.shared.termsOfUseUrl) {
        UIApplication.shared.open(url)
      }
        
    default:
      print("Action for \(id) not implemented")
    }
  }
  
  @ViewBuilder
  private func settingsRow(option: (id: Int, title: String, subtitle: String, hasToggle: Bool)) -> some View {
    HStack {
      VStack(alignment: .leading, spacing: 10) {
        Text(option.title)
          .font(.subheadline)
          .fontWeight(.semibold)
          .foregroundColor(.primary)
          
        Text(option.subtitle)
          .font(.footnote)
          .lineLimit(1)
          .foregroundColor(.gray)
      }
        
      Spacer()
      
      if option.hasToggle {
        Toggle("", isOn: $allowNotification)
          .frame(minWidth: 0, maxWidth: 50, minHeight: 0, maxHeight: 30)
      } else {
        Image(systemName: "chevron.right")
          .foregroundColor(.gray.opacity(0.4))
          .font(.system(size: 20))
          .frame(minWidth: 0, maxWidth: 10, minHeight: 0, maxHeight: 30)
      }
    }
    .padding()
    .background(Color(.systemBackground))
    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
  }
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingView()
  }
}
