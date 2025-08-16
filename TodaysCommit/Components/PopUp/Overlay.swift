import SwiftUI

final class BlockingWindow: UIWindow {
  override func point(inside _: CGPoint, with _: UIEvent?) -> Bool { true }
}

enum Overlay {
  private static var window: BlockingWindow?

  @discardableResult
  static func show(_ swiftUIView: some View) -> OverlayViewController {
    guard
      let scene = UIApplication.shared.connectedScenes
      .compactMap({ $0 as? UIWindowScene })
      .first(where: { $0.activationState == .foregroundActive })
      ?? UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene }).first
    else {
      fatalError("No active UIWindowScene found")
    }

    let hosting = UIHostingController(rootView: swiftUIView)
    hosting.view.backgroundColor = .clear

    let popupVC = OverlayViewController(contentVC: hosting)

    let w = BlockingWindow(windowScene: scene)
    w.windowLevel = .alert + 1
    w.isOpaque = false
    w.backgroundColor = .clear
    w.frame = scene.screen.bounds
    w.rootViewController = popupVC
    w.makeKeyAndVisible()

    window = w
    return popupVC
  }

  @MainActor
  static func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
    guard let w = window else {
      completion?()
      return
    }
    let cleanup = {
      window?.isHidden = true
      window = nil
      completion?()
    }
    if animated {
      UIView.animate(withDuration: 0.2, animations: { w.alpha = 0 }) { _ in
        cleanup()
      }
    } else {
      cleanup()
    }
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

  override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
    Overlay.dismiss(animated: flag, completion: completion)
  }

  @objc private func dismissSelf() {
    dismiss(animated: true)
  }
}
