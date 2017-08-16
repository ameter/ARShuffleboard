/*
See LICENSE folder for this sample’s licensing information.

Abstract:
SceneKit node wrapper for plane geometry detected in AR.
*/

import Foundation
import ARKit

enum CollisionType: Int {
  case object = 0b0001
  case plane = 0b0010
}

class Plane: SCNNode {
    
    // MARK: - Properties
    
	var anchor: ARPlaneAnchor
	var focusSquare: FocusSquare?
  var planeGeometry: SCNPlane
    
    // MARK: - Initialization
    
	init(_ anchor: ARPlaneAnchor) {
		self.anchor = anchor
    self.planeGeometry = SCNPlane(width: CGFloat(self.anchor.extent.x), height: CGFloat(self.anchor.extent.z))
		super.init()
    setup()
  }
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
    
    // MARK: - ARKit
	
	func update(_ anchor: ARPlaneAnchor) {
		self.anchor = anchor
    self.planeGeometry.width = CGFloat(anchor.extent.x);
    self.planeGeometry.height = CGFloat(anchor.extent.z);
    geometry = self.planeGeometry
    //      planeNode.transform = SCNMatrix4MakeRotation(Float(-Double.pi / 2.0), 1.0, 0.0, 0.0);
    self.transform = SCNMatrix4MakeRotation(Float(-Double.pi / 2.0), 1.0, 0.0, 0.0);
    self.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z);
    physicsBody?.physicsShape = SCNPhysicsShape(geometry: self.planeGeometry, options: nil)

	}
  
  fileprivate func setup() {
    let material = SCNMaterial()
    material.diffuse.contents = #imageLiteral(resourceName: "shuff")
    self.planeGeometry.materials = [material]
    geometry = self.planeGeometry
    physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: self.planeGeometry, options: nil))
    physicsBody?.friction = 0.5
    physicsBody?.categoryBitMask = CollisionType.plane.rawValue
    
//    name = Plane.nodeName
    physicsBody?.contactTestBitMask = CollisionType.plane.rawValue | CollisionType.object.rawValue
    physicsBody?.isAffectedByGravity = false
    
    //    planeNode.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z);
    transform = SCNMatrix4MakeRotation(Float(-Double.pi / 2.0), 1.0, 0.0, 0.0);
  }
		
}

