//
//  ViewController.swift
//  ARKitScratch
//
//  Created by Akash Bakshi on 2018-03-02.
//  Copyright © 2018 Akash Bakshi. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class ViewController: UIViewController {
    @IBOutlet weak var arView: ARSCNView!
    
    struct camCoordinates{
        var x = Float()
        var y = Float()
        var z = Float()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = .horizontal
        
        arView.session.run(config)
        arView.showsStatistics = true
    }
    
    func getCamCoordinates(sceneView: ARSCNView)->camCoordinates{
        let cameraTransform = sceneView.session.currentFrame?.camera.transform
        let cameraCoord = MDLTransform(matrix: cameraTransform!)
        
        var cc = camCoordinates()
        cc.x = cameraCoord.translation.x
        cc.y = cameraCoord.translation.y
        cc.z = cameraCoord.translation.z
        
        return cc
        
    }
    
    func randomColor() ->SCNMaterial {
        let material = SCNMaterial()
        let r = randomFloat(min: 0, max: 255)
        let g = randomFloat(min: 0, max: 255)
        let b = randomFloat(min: 0, max: 255)
        
        material.diffuse.contents = UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1.0)
        
        return material
    }
    @IBAction func btnAddSphere(_ sender: UIButton) {
        let cupNode = SCNNode()
        
        let cc = getCamCoordinates(sceneView: arView)
        
        cupNode.position = SCNVector3Make(0.2, -0.3, 0.1)
        cupNode.geometry?.firstMaterial = randomColor()
        
        guard let virtualCupScene =  SCNScene(named: "basketball_net.scn", inDirectory: "cup")else{
            return
        }
        
        let wrapperNode = SCNNode()
        for child in virtualCupScene.rootNode.childNodes {
            child.geometry?.firstMaterial?.lightingModel = .physicallyBased
            wrapperNode.addChildNode(child)
        }
        cupNode.addChildNode(wrapperNode)
        arView.scene.rootNode.addChildNode(cupNode)
    }
    
    func randomFloat(min: Float, max: Float) -> Float {
        return (Float(arc4random()) / 0xFFFFFFFF) * (max - min) + min
    }
    
    @IBAction func btnAddCube(_ sender: UIButton) {
        
        let cubeNode = SCNNode(geometry: SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0 ))
        let planeNode = SCNNode(geometry: SCNPlane(width: 0.2, height: 0.2))
        let cc = getCamCoordinates(sceneView: arView)
        cubeNode.position = SCNVector3(cc.x,cc.y,cc.z)
        cubeNode.geometry?.firstMaterial = randomColor()
        cubeNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        
        planeNode.position = SCNVector3(cc.x,(cc.y-1.0),cc.z)
        planeNode.rotation = SCNVector4(90.0, 0, 0, 0)
        arView.scene.rootNode.addChildNode(cubeNode)
        arView.scene.rootNode.addChildNode(planeNode)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

