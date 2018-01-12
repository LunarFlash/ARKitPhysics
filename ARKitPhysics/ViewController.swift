//
//  ViewController.swift
//  ARKitPhysics
//
//  Created by Jayven Nhan on 12/24/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    
    // TODO: Declare rocketship node name constant
    
    // TODO: Initialize an empty array of type SCNNode
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTapGestureToSceneView()
        configureLighting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpSceneView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    func setUpSceneView() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        sceneView.session.run(configuration)
        
        sceneView.delegate = self
    }
    
    func configureLighting() {
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
    }
    
    func addTapGestureToSceneView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.addRocketshipToSceneView(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // TODO: Create add swipe gestures to scene view method

    @objc func addRocketshipToSceneView(withGestureRecognizer recognizer: UIGestureRecognizer) {
        let tapLocation = recognizer.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
        guard let hitTestResult = hitTestResults.first else { return }
        
        let translation = hitTestResult.worldTransform.translation
        let x = translation.x
        let y = translation.y + 0.1
        let z = translation.z
        
        guard let rocketshipScene = SCNScene(named: "rocketship.scn"),
            let rocketshipNode = rocketshipScene.rootNode.childNode(withName: "rocketship", recursively: false)
            else { return }
        
        rocketshipNode.position = SCNVector3(x,y,z)
        
        // TODO: Attach physics body to rocketship node
        
        sceneView.scene.rootNode.addChildNode(rocketshipNode)
    }
    
    // TODO: Create get rocketship node from swipe location method
    
    // TODO: Create apply force to rocketship method
    
    // TODO: Create launch rocketship method
    
}

extension ViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        let plane = SCNPlane(width: width, height: height)
        
        plane.materials.first?.diffuse.contents = UIColor.transparentWhite
        
        var planeNode = SCNNode(geometry: plane)
        
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        planeNode.position = SCNVector3(x,y,z)
        planeNode.eulerAngles.x = -.pi / 2
        
        // TODO: Update plane node
        
        node.addChildNode(planeNode)
        
        // TODO: Append plane node to plane nodes array if appropriate
    }
    
    // TODO: Remove plane node from plane nodes array if appropriate
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as?  ARPlaneAnchor,
            var planeNode = node.childNodes.first,
            let plane = planeNode.geometry as? SCNPlane
            else { return }

        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        plane.width = width
        plane.height = height

        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        
        planeNode.position = SCNVector3(x, y, z)

        // TODO: Update plane node
    }
    
    // TODO: Create update plane node method
    func update(_ node: inout SCNNode, withGeometry geometry: SCNGeometry, type: SCNPhysicsBodyType) {
        
    }
    
}

extension float4x4 {
    var translation: float3 {
        let translation = self.columns.3
        return float3(translation.x, translation.y, translation.z)
    }
}

extension UIColor {
    open class var transparentWhite: UIColor {
        return UIColor.white.withAlphaComponent(0.20)
    }
}
