/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Configures the scene.
*/

import Foundation
import ARKit

// MARK: - AR scene view extensions

extension ARSCNView {
	
	func setup() {
		antialiasingMode = .multisampling4X
		automaticallyUpdatesLighting = false
		
		preferredFramesPerSecond = 60
		contentScaleFactor = 1.3
		
		if let camera = pointOfView?.camera {
			camera.wantsHDR = true
			camera.wantsExposureAdaptation = true
			camera.exposureOffset = -1
			camera.minimumExposure = -1
			camera.maximumExposure = 3
		}
	}
}

// MARK: - Scene extensions

extension SCNScene {
	func enableEnvironmentMapWithIntensity(_ intensity: CGFloat, queue: DispatchQueue) {
		queue.async {
			if self.lightingEnvironment.contents == nil {
				if let environmentMap = UIImage(named: "Models.scnassets/sharedImages/environment_blur.exr") {
					self.lightingEnvironment.contents = environmentMap
				}
			}
			self.lightingEnvironment.intensity = intensity
		}
	}
}

extension SCNNode {
  func createExplosion(in scene: SCNScene) {
    guard let explosion = SCNParticleSystem(named: "Explode.scnp", inDirectory: nil) else {
      return
    }
    
    var particleGeometry: SCNGeometry?
    if let geo = geometry {
      particleGeometry = geo
    } else {
      var existingGeometries = [SCNGeometry]()
      enumerateChildNodes({ (node, _) in
        if let geo = node.geometry {
          existingGeometries.append(geo)
        }
      })
      particleGeometry = existingGeometries.first
    }
    
    explosion.emitterShape = particleGeometry ?? SCNSphere(radius: CGFloat(boundingSphere.radius))
    explosion.birthLocation = .surface
    let rotation = presentation.rotation
    let position = presentation.position
    let rotationMatrix = SCNMatrix4MakeRotation(rotation.w, rotation.x, rotation.y, rotation.z)
    let translationMatrix = SCNMatrix4MakeTranslation(position.x, position.y, position.z)
    let transformMatrix = SCNMatrix4Mult(rotationMatrix, translationMatrix)
    scene.addParticleSystem(explosion, transform: transformMatrix)
  }
}
