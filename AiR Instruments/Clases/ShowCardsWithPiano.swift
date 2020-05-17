//
//  ShowCardsWithPiano.swift
//  AiR Instruments
//
//  Created by omar on 9/22/18.
//  Copyright © 2018 omar. All rights reserved.
//

import Foundation
import ARKit
import UIKit
extension TheSetupArea {
    
   func showCards(card1 : UIView , card2 : UIView , card3 : UIView ){
        
        
    
        
        let scnCard1 = SCNNode()
        let scnCard2 = SCNNode()
        let scnCard3 = SCNNode()
    
    
        
        let scnPlane1 = SCNPlane()
        let scnPlane2 = SCNPlane()
        let scnPlane3 = SCNPlane()
    
    
        
        scnPlane1.firstMaterial?.diffuse.contents = card1
        scnPlane2.firstMaterial?.diffuse.contents = card2
        scnPlane3.firstMaterial?.diffuse.contents = card3
    
        
        scnPlane1.cornerRadius = 0.1
        scnPlane2.cornerRadius = 0.1
        scnPlane3.cornerRadius = 0.1
    

       
        
        
        scnCard1.geometry = scnPlane1
        scnCard2.geometry = scnPlane2
        scnCard3.geometry = scnPlane3
    
        
        
        scnCard1.position = SCNVector3(arrayOfLocations[0].position.x - 0.2 , arrayOfLocations[0].position.y + 0.09, arrayOfLocations[0].position.z - 0.5)
    
    
        scnCard2.position = SCNVector3(arrayOfLocations[0].position.x + 0.05, arrayOfLocations[0].position.y + 0.09, arrayOfLocations[0].position.z - 0.5)
    
    
        scnCard3.position = SCNVector3(arrayOfLocations[0].position.x + 0.30, arrayOfLocations[0].position.y + 0.09, arrayOfLocations[0].position.z  - 0.5)
    
        
        
        
        
        scnCard1.scale = SCNVector3(0.25,0.2,0.25)
        scnCard2.scale = SCNVector3(0.25,0.2,0.25)
        scnCard3.scale = SCNVector3(0.25,0.2,0.25)
    
        sceneCard1 = scnCard1
        sceneCard2 = scnCard2
        sceneCard3 = scnCard3
    
        
        sceneCard1.rotation = SCNVector4Make(0, 1, 0, .pi / 5)
        sceneCard3.rotation = SCNVector4Make(0, -1, 0, .pi / 3.5)
        
        
        
        sceneView.scene.rootNode.addChildNode(sceneCard1)
        sceneView.scene.rootNode.addChildNode(sceneCard2)
        sceneView.scene.rootNode.addChildNode(sceneCard3)

    }
    
    
    
    
}
