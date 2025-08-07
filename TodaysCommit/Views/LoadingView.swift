import Lottie
import SwiftUI

struct LoadingView: UIViewRepresentable {
  func makeUIView(context _: Context) -> UIView {
    let container = UIView()

    let animationView = LottieAnimationView(name: "loading")
    animationView.loopMode = .loop
    animationView.contentMode = .scaleAspectFit
    animationView.translatesAutoresizingMaskIntoConstraints = false
    animationView.play()

    container.addSubview(animationView)

    NSLayoutConstraint.activate([
      animationView.widthAnchor.constraint(equalToConstant: 95),
      animationView.heightAnchor.constraint(equalToConstant: 95),
      animationView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
      animationView.centerYAnchor.constraint(equalTo: container.centerYAnchor)
    ])
    
    return container
  }

  func updateUIView(_: UIView, context _: Context) {}
}
