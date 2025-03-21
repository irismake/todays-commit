import ARKit
import RealityKit
import SwiftUI

struct Model3DView: View {
  let modelName: String
  @State private var modelEntity: Entity?
  @State private var rotation: Float = 0.0
  let scaleFactor: Float = 0.05

  var body: some View {
    GeometryReader { _ in
      RealityView { content in
        do {
          let anchor = AnchorEntity(world: SIMD3(x: 0, y: 0, z: 10))
          let model = try await Entity.load(named: modelName)
          modelEntity = model
          model.setScale(SIMD3(repeating: scaleFactor), relativeTo: anchor)
          anchor.addChild(model)

          let camera = PerspectiveCamera()
          camera.transform.translation = SIMD3(x: 0, y: 0.2, z: 1.2)
          anchor.addChild(camera)

          content.add(anchor)
        } catch {
          print("❌ 모델 로드 실패: \(error)")
        }
      }
      .gesture(DragGesture(minimumDistance: 0)
        .onChanged { value in
          let rotationAngle = Float(value.translation.width / 100)
          modelEntity?.transform.rotation = simd_quatf(angle: rotationAngle, axis: [0, 1, 0])
        })
    }
  }
}
