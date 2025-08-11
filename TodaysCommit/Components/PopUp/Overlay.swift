import SwiftUI

enum Overlay {
  @discardableResult
  static func show(_ swiftUIView: some View) -> OverlayViewController {
    guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let rootVC = scene.windows.first?.rootViewController
    else {
      fatalError("No root view controller found")
    }

    let hosting = UIHostingController(rootView: swiftUIView)
    hosting.view.backgroundColor = .clear

    let popupVC = OverlayViewController(contentVC: hosting)
    rootVC.present(popupVC, animated: true)
    return popupVC
  }
}

final class OverlayViewController: UIViewController {
  private let contentVC: UIViewController

  init(contentVC: UIViewController) {
    self.contentVC = contentVC
    super.init(nibName: nil, bundle: nil)
    modalPresentationStyle = .overCurrentContext
    modalTransitionStyle = .crossDissolve
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) { fatalError("init(coder:) has not been implemented") }

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = UIColor.black.withAlphaComponent(0.4)

    let tap = UITapGestureRecognizer(target: self, action: #selector(dismissSelf))
    view.addGestureRecognizer(tap)

    addChild(contentVC)
    let contentView = contentVC.view!
    contentView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(contentView)

    NSLayoutConstraint.activate([
      contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      contentView.widthAnchor.constraint(lessThanOrEqualToConstant: 300)
    ])

    contentVC.didMove(toParent: self)
  }

  @objc private func dismissSelf() {
    dismiss(animated: true)
  }
}
