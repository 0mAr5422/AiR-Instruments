//
//  ViewController.swift
//  AiR Instruments
//
//  Created by omar on 9/21/18.
//  Copyright © 2018 omar. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import AudioKit
import AVFoundation


class TheSetupArea: UIViewController, ARSCNViewDelegate , CanRecieve , SynthModelDelegate {
   
    func getNoteNum(with indexPath: Int) -> Int {
        var freq = 0
        switch indexPath {
        
        case 1: freq = 60
        case 2: freq = 59
        case 3: freq = 58
        case 4: freq = 57
        case 5: freq = 56
        case 6: freq = 55
        case 7: freq = 54
        case 8: freq = 53
        case 9: freq = 52
        case 10: freq = 51
        case 11: freq = 50
        case 12: freq = 49
        case 13: freq = 48
        case 14: freq = 47
        case 15: freq = 46
        case 16: freq = 61
        case 17: freq = 41
        default: freq = 0
        }
        return freq
    }
    
    
    func getPadNoteNumber(tappedPadButton : Int) -> Int{
        var noteNum = 0
        
   
        switch tappedPadButton {
        case 1: noteNum = 36
        case 2: noteNum = 37
        case 3: noteNum = 38
        case 4: noteNum = 40
        case 5: noteNum = 41
        case 6: noteNum = 42
        case 7: noteNum = 43
        case 8: noteNum = 44
        case 9: noteNum = 45
        case 10: noteNum = 46
        case 11: noteNum = 47
        case 12: noteNum = 48
        case 13: noteNum = 49
        case 14: noteNum = 50
        case 15: noteNum = 51
        case 16: noteNum = 52
            
            
        default: noteNum = 36
        }
        
        
        return noteNum
    }
    
    
    
    
    func didHitKey(_ synthModel: SynthModel, at index: Int) {
        synthModel.playKey(noteNum: Double(getNoteNum(with: index)))
        
    }
    
    func didStopKey(_ synthModel: SynthModel, at index: Int) {
        synthModel.stopKey(noteNum : getNoteNum(with: index))
        
    }
    
   

    
    
    //    MARK: CARDS VARIABLES
    
    var attackValue = 0.1
    var decayValue = 0.2
    var sustainValue = 0.5
    var releaseValue = 0.1
    var frequency = 6000.0
    var resonance = 1000.0
    var filterSelection = 0
    var synthModel = SynthModel()
    let midi = AKMIDI()
    let drumMidi = AKMIDI()
    let drumMidiSequencer = AKSequencer()
    let drumMidiSampler = AKMIDISampler()
    var sendMidiNoteNumber = 0
    var sendCCNoteNumber = 0
    var velocity = 100
    var channelNumber = 1
    
    
    

    
    /************************************/
    
    
    //    MARK: PROTOCOL ADOPTION

func passData(instrumentName: String, didPickInstrument: Bool) {
    sceneNameThatWillBeRecieveFromPreviousView = instrumentName
    userDidPickInstrument = didPickInstrument
    
}
    /**************************************/
    var segmented = UISegmentedControl()
    
    //    MARK: VARIABLES AND CONSTANYS
    
    var sceneNameThatWillBeRecieveFromPreviousView = " "
    var instrumentAllowedInScene = true
    let sceneNode = SCNNode()
    var scene = SCNScene()
    var arrayOfLocations = [SCNNode]()
    var userDidPickInstrument = false
    var hideAndShowButtonState = true
    var inSoundMode = true
    var tappedNode : String = " "
    var lastTappedNode : String = " "
    var notFirstView = true
    var firstTimePlacingAnInstrument : Bool = true
    
    //    MARK: CARDS VARIABLES
    var sceneCard1 = SCNNode()
    var sceneCard2 = SCNNode()
    var sceneCard3 = SCNNode()
    var sceneButton = SCNNode()
  
    
    // MARK:  Pad Sound files holders
    var fileExtenson = "wav"
    var button12IsOn = true
    
    
    /**************************************/
    
   
    
    //  MARK: IBOUTLETS
    @IBOutlet var sceneView: ARSCNView!
    
    @IBOutlet weak var refresh: UIButton!
    
    @IBOutlet weak var switchToMidi: UIButton!
    
   
    

    @IBOutlet weak var myCardView1: UIView!
    
    @IBOutlet weak var myCardView2: UIView!
    
    @IBOutlet weak var myCardView3: UIView!
    
    @IBOutlet weak var hideAndShowButton: UIButton!
    
    /**************************************/
    //    MARK: IBACTIONS
        @IBAction func hideAndShowButton(_ sender: UIButton) {

        if hideAndShowButtonState == true {
            sender.setBackgroundImage(UIImage(named: "Arrow Up"), for: .normal)
            hideArCards()
            hideAndShowButtonState = false
        }
        else {
            sender.setBackgroundImage(UIImage(named: "Arrow Down"), for: .normal)
            showCards(card1: myCardView1, card2: myCardView2, card3: myCardView3)
            hideAndShowButtonState = true
        }
        
    }
    @IBAction func userWantsToAddNewInstrument(_ sender: UIButton) {
        performSegue(withIdentifier: "WantToPickNewInstrument", sender: self)
        removeInstrumentsFromScreen()
        hideAndShowButton.isHidden = true
    }
 
    @IBAction func refresh(_ sender: UIButton) {
        removeInstrumentsFromScreen()
    }
    @IBAction func switchToMidi(_ sender: UIButton) {

        if sender.currentImage == UIImage(named: "Sound Icon"){
            sender.setImage(UIImage(named: "MIDI Icon"), for: .normal)
            inSoundMode = true
            
            midi.destroyVirtualOutputPort()
            drumMidi.destroyVirtualOutputPort()
            drumMidi.destroyVirtualPorts()
            midi.destroyVirtualPorts()
            
            if sceneNameThatWillBeRecieveFromPreviousView != "pad" {
                showCards(card1: myCardView1, card2: myCardView2, card3: myCardView3)
                hideAndShowButton.isHidden = false
            }
        }
        
        else if sender.currentImage == UIImage(named: "MIDI Icon") {
            sender.setImage(UIImage(named: "Sound Icon"), for: .normal)
            hideArCards()
            hideAndShowButton.isHidden = true
            midi.openOutput()
            drumMidi.openOutput()
            
            do {
                try AudioKit.start()
            }
            catch {
                print("there was a problem starting audio kit ")
            }
            inSoundMode = false
            notFirstView = false
            firstTimePlacingAnInstrument = false
        }
        
        
        
    }

    /**************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       
        inSoundMode = true
        
        hideAndShowButton.isHidden = true
        
//        removing any scene node in the screen
         removeInstrumentsFromScreen()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false
//        setting the tappingRecognizer
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))

//        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        let longTapRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longTapRecognizer.minimumPressDuration = 0.01
        self.sceneView.addGestureRecognizer(longTapRecognizer)
//        showing and hiding UIElements
        
        if userDidPickInstrument == false {
            midi.destroyVirtualOutputPort()
            
            refresh.isHidden = true
            switchToMidi.isHidden = true
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)

       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    //    MARK: GETTING TO THE INSTRUMENT PICK UP VIEW
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "WantToPickNewInstrument"{
            let pickNewInstrument = segue.destination as! PickNewInstrument
            pickNewInstrument.delegate = self
        }
        
    }
    
    
    
    
    //    MARK: AR ASSOCITATED RENDERING AND OBJECT PLACING
    
    
    
    
    
//    rendering function which detects the flat surface
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        if userDidPickInstrument{
            self.sceneView.debugOptions = .showFeaturePoints
            if anchor is ARPlaneAnchor {
                if instrumentAllowedInScene == true{
                    let planeAnchor = anchor as! ARPlaneAnchor
                    let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
                    
                    sceneNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
                    sceneNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
                    let material = SCNMaterial()
                    material.diffuse.contents = UIImage(named: "art.scnassets/AddInstrument.png")
                    plane.materials = [material]
                    sceneNode.geometry = plane
                    node.addChildNode(sceneNode)
                }
                return
            }
        }
    }
    
//    Instrument Removing function
    func removeInstrumentsFromScreen(){
        if !arrayOfLocations.isEmpty {
            do {
                try AudioKit.stop()
            }
            catch {
                print("there was a problem with audioKit ")
            }
            hideAndShowButton.isHidden = true
            instrumentAllowedInScene = true
            arrayOfLocations.removeAll()
            sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
                node.removeFromParentNode()
            sceneNode.removeFromParentNode()
            }
        }
    }
    
    
//    Instrument placment function
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if userDidPickInstrument{
            refresh.isHidden = false
            switchToMidi.isHidden = false
            self.sceneView.debugOptions = []
            sceneNode.removeFromParentNode()
            scene = SCNScene(named: "art.scnassets/\(sceneNameThatWillBeRecieveFromPreviousView).scn")!
            if let touch = touches.first{
                let touchlocation = touch.location(in: sceneView)
                let results = sceneView.hitTest(touchlocation, types: .existingPlaneUsingExtent)
                if let result = results.first{
                    do {
                        try AudioKit.start()
                    }
                    catch {
                        print("there was a problem with audioKit ")
                    }
                    if let  sceneNode = (scene.rootNode.childNode(withName: "\(sceneNameThatWillBeRecieveFromPreviousView)", recursively: true)){
                        
                        if instrumentAllowedInScene{
                            sceneNode.position = SCNVector3((result.worldTransform.columns.3.x), (result.worldTransform.columns.3.y ), (result.worldTransform.columns.3.z))
                            
                            sceneView.scene.rootNode.addChildNode(sceneNode)
                            switchToMidi.setImage(UIImage(named: "MIDI Icon"), for: .normal)
                            inSoundMode = true
                            midi.destroyVirtualOutputPort()
                            
                            if sceneNameThatWillBeRecieveFromPreviousView != "pad" {
                                arrayOfLocations.append(sceneNode)
                                showCards(card1: myCardView1, card2: myCardView2, card3: myCardView3)
                                inSoundMode = true
                                hideAndShowButton.setBackgroundImage(UIImage(named: "Arrow Down"), for: .normal)
                                hideAndShowButton.isHidden = false
                                
                               
                            }
                            
                            //                        showCards.isHidden = true
                            //                        hideCards.isHidden = false
                            arrayOfLocations.append(sceneNode)
                            instrumentAllowedInScene = false
                            
                            
                        }
                    }
                }
            }
        }
    }
    
    
//    tapping handler function
//    @objc func handleTap(sender: UITapGestureRecognizer) {
//        // Check if tap was performed, then move forward else, return
//        guard let sceneView = sceneView else {return}
//        // Get the location of the touch in the Scene View
//        let touchLocation = sender.location(in: sceneView)
//        // use hit test to get the location of tap
//        let hitTestResult = sceneView.hitTest(touchLocation, options : nil)
//        if !hitTestResult.isEmpty {
//            // if tap is recognized, add the portal in front of camera
//            if let nodeLocation = hitTestResult.first?.node{
//                tappedNode = hitTestResult.first?.node.name ?? "1"
//                if Int(tappedNode) == 1 || Int(tappedNode)! <= 17 {
//                    if sceneNameThatWillBeRecieveFromPreviousView == "piano" {
//                   
//                    sceneView.scene.rootNode.childNode(withName: "\(tappedNode)", recursively: true)?.runAction(SCNAction.moveBy(x: 0, y: 0.009, z: 0, duration: 0.5))
//                     }
//                    
//                    else if sceneNameThatWillBeRecieveFromPreviousView == "pad" {
//                       
//                         sceneView.scene.rootNode.childNode(withName: "\(tappedNode)", recursively: true)?.runAction(SCNAction.moveBy(x: 0, y: 0.009, z: 0, duration: 0.5))
//                    }
//                if sender.state != .began {
//                    
//                    tappedNode = hitTestResult.first?.node.name ?? "1"
//                    if Int(tappedNode) == 1 || Int(tappedNode)! <= 17 {
//                        if sceneNameThatWillBeRecieveFromPreviousView == "piano" {
//                    sceneView.scene.rootNode.childNode(withName: "\(tappedNode)", recursively: true)?.runAction(SCNAction.moveBy(x: 0, y: -0.009, z: 0, duration: 0.2))
//      
//                        }
//                        
//                        else if sceneNameThatWillBeRecieveFromPreviousView == "pad" {
//                          
//                              sceneView.scene.rootNode.childNode(withName: "\(tappedNode)", recursively: true)?.runAction(SCNAction.moveBy(x: 0, y: -0.009, z: 0, duration: 0.2))
//                         
//                        
//                            
//                        }
//                    }
//                }
//            }
//        }
//                
//        else {
//        }
//            
//            }
//        }
//    
    @objc func handleLongPress(sender: UILongPressGestureRecognizer ){
            let touchLocation = sender.location(in: sceneView)
            // use hit test to get the location of tap
            let hitTestResult = sceneView.hitTest(touchLocation, options : nil)
        if sender.state == .began{
            
            if !hitTestResult.isEmpty {
                // if tap is recognized, add the portal in front of camera
                if let nodeLocation = hitTestResult.first?.node{
                    tappedNode = hitTestResult.first?.node.name ?? "1"
                   
                    if Int(tappedNode) == 1 || Int(tappedNode)! <= 17 {
                         lastTappedNode = hitTestResult.first?.node.name ?? "1"
                         if sceneNameThatWillBeRecieveFromPreviousView == "piano" && inSoundMode == true {
                            
                    sceneView.scene.rootNode.childNode(withName: "\(tappedNode)", recursively: true)?.runAction(SCNAction.moveBy(x: 0, y: -0.005, z: 0, duration: 0.8))
                            didHitKey(synthModel, at: Int(tappedNode) ?? 1)
                            
                            
                        }
                            
                    else if sceneNameThatWillBeRecieveFromPreviousView == "piano" && inSoundMode == false {
                            print("121")
                            
                            noteOn(note: MIDINoteNumber(getNoteNum(with: Int(tappedNode) ?? 1)))
                            sceneView.scene.rootNode.childNode(withName: "\(tappedNode)", recursively: true)?.runAction(SCNAction.moveBy(x: 0, y: -0.005, z: 0, duration: 0.8))
                          
                            
                         }
                        else if sceneNameThatWillBeRecieveFromPreviousView == "pad"{
                            if Int(tappedNode) != 12 && inSoundMode == true{
                                 sceneView.scene.rootNode.childNode(withName: "\(tappedNode)", recursively: true)?.runAction(SCNAction.moveBy(x: 0, y: -0.001, z: 0, duration: 0.5))
                                 padSoundPlayer(numOfPad: Int(tappedNode) ?? 1)
                                
                            }
                            else if Int(tappedNode)! == 12 && inSoundMode == true{
                                 padSoundPlayer(numOfPad: Int(tappedNode) ?? 1)
                            }
                            
                            else if Int(tappedNode)! >= 1 && Int(tappedNode)! <= 16 && inSoundMode == false{
                                noteOn(note: MIDINoteNumber(getPadNoteNumber(tappedPadButton: Int(tappedNode) ?? 1)))
                                sceneView.scene.rootNode.childNode(withName: "\(tappedNode)", recursively: true)?.runAction(SCNAction.moveBy(x: 0, y: -0.001, z: 0, duration: 0.5))
                            }
                       
                        }
                    }
                    else {
                        sender.state = .failed
                    }
                            
                        }
                    }
                }

        else if sender.state == .ended {
               tappedNode = hitTestResult.first?.node.name ?? "1"
            
            
            if Int(tappedNode) == 1 || Int(tappedNode)! <= 27 {
                
                if sceneNameThatWillBeRecieveFromPreviousView == "piano" {
                    if Int(tappedNode) == 1 || Int(tappedNode)! <= 27  {
                    sceneView.scene.rootNode.childNode(withName: "\(lastTappedNode)", recursively: true)?.runAction(SCNAction.moveBy(x: 0, y: 0.005, z: 0, duration: 0.2))
                    }
                    didStopKey(synthModel, at: Int(lastTappedNode) ?? 1)
                    noteOff(note: MIDINoteNumber(getNoteNum(with: Int(tappedNode) ?? 1 )))
                }
                else if sceneNameThatWillBeRecieveFromPreviousView == "pad" {
                    if Int(tappedNode) != 12 && inSoundMode == true {
                    sceneView.scene.rootNode.childNode(withName: "\(lastTappedNode)", recursively: true)?.runAction(SCNAction.moveBy(x: 0, y: 0.001, z: 0, duration: 0.2))
                        
                        
                    }
                    else if Int(tappedNode)! >= 1 && Int(tappedNode)! <= 16 && inSoundMode == false {
                        sceneView.scene.rootNode.childNode(withName: "\(lastTappedNode)", recursively: true)?.runAction(SCNAction.moveBy(x: 0, y: 0.001, z: 0, duration: 0.2))
                        noteOff(note: MIDINoteNumber(getPadNoteNumber(tappedPadButton: Int(lastTappedNode) ?? 1)))
               
                    }
                }
            }
        }
        else if sender.state == .cancelled{
            if Int(tappedNode) == 1 || Int(tappedNode)! <= 17 {
            didStopKey(synthModel, at: Int(lastTappedNode) ?? 1 )
            sceneView.scene.rootNode.childNode(withName: "\(lastTappedNode)", recursively: true)?.runAction(SCNAction.moveBy(x: 0, y: 0.001, z: 0, duration: 0.2))
                noteOff(note: MIDINoteNumber(getPadNoteNumber(tappedPadButton: Int(lastTappedNode) ?? 1)))

            }
        }
       
        
//        else if sender.state == .changed && Int(tappedNode) ?? 0  >= Int(lastTappedNode) ?? 1 {
//
//            sceneView.scene.rootNode.childNode(withName: "\(lastTappedNode)", recursively: true)?.runAction(SCNAction.move(by: SCNVector3(0
//                , 0.001, 0), duration: 0.2))
//
//        }
        
    }
    
}



extension TheSetupArea {
    
    func padSoundPlayer(numOfPad : Int ) {
        
        if numOfPad >= 1 && numOfPad < 12 {
            do {
                try AudioKit.start()
            } catch  {
                print("error")
            }
            fileExtenson = "wav"
            let soundFile = try! AKAudioFile(readFileName: "PadSounds/\(numOfPad).\(fileExtenson)")
            let soundPlayer = try! AKAudioPlayer(file: soundFile)
            
            AudioKit.output = soundPlayer
            soundPlayer.play()
            drumMidi.openOutput()
           
          
            
            do {
                try AudioKit.start()
            }
            catch {
                print("there was a problem starting audioKit ")
            }
            
        }
        else if  numOfPad >= 12 && numOfPad <= 16  && inSoundMode == true{
            
            if numOfPad == 12 && inSoundMode == true {
                
                let soundFile = try! AKAudioFile(readFileName: "PadSounds/\(numOfPad).\(fileExtenson)")
               let soundPlayer = try! AKAudioPlayer(file: soundFile)
                if button12IsOn == true{
                    do {
                        try AudioKit.start()
                    } catch  {
                        print("error")
                    }
                    AudioKit.output = soundPlayer
                    soundPlayer.looping = button12IsOn
                   
                    soundPlayer.play()
                    
                    
                     button12IsOn = false
                   sceneView.scene.rootNode.childNode(withName: "\(tappedNode)", recursively: true)?.runAction(SCNAction.moveBy(x: 0, y: -0.001, z: 0, duration: 0.5))
                    print("it's off ")
                }
                else {
//                    AudioKit.output = soundPlayer
//                    soundPlayer.loopEnabled = false
                     sceneView.scene.rootNode.childNode(withName: "\(lastTappedNode)", recursively: true)?.runAction(SCNAction.moveBy(x: 0, y: 0.001, z: 0, duration: 0.2))
                    
                    
                    try! AudioKit.stop()
                    
                    print("iits on ")
                    button12IsOn = true
                  
                }
               
            }
            else if numOfPad > 12 && numOfPad <= 16 {
                
                fileExtenson = "aif"
                let soundFile = try! AKAudioFile(readFileName: "PadSounds/\(numOfPad).\(fileExtenson)")
                let soundPlayer = try! AKAudioPlayer(file: soundFile)
                    print("playback completed.")
            
                AudioKit.output = soundPlayer
                
                try! AudioKit.start()
                soundPlayer.play()
                
            }
        }
        
        
    }
    
}


extension TheSetupArea {
    
    func padMidiSoundPlayer(chosenNote : Int){
        
        if getPadNoteNumber(tappedPadButton: Int(tappedNode) ?? 1) == 40 || getPadNoteNumber(tappedPadButton: Int(tappedNode) ?? 1) == 41 || getPadNoteNumber(tappedPadButton: Int(tappedNode) ?? 1) == 42 || getPadNoteNumber(tappedPadButton: Int(tappedNode) ?? 1) == 43 || getPadNoteNumber(tappedPadButton: Int(tappedNode) ?? 1) == 102 || getPadNoteNumber(tappedPadButton: Int(tappedNode) ?? 1) == 103 || getPadNoteNumber(tappedPadButton: Int(tappedNode) ?? 1) == 104 {
            sendCCNoteNumber = getPadNoteNumber(tappedPadButton: Int(tappedNode) ?? 1)
            let event = AKMIDIEvent(controllerChange: MIDIByte(sendCCNoteNumber), value: MIDIByte(127), channel: MIDIChannel(channelNumber))
            midi.sendEvent(event)
            
        }
        else {
            sendMidiNoteNumber = getNoteNum(with: Int(tappedNode) ?? 1)
            let event = AKMIDIEvent(noteOn: MIDINoteNumber(getPadNoteNumber(tappedPadButton: Int(tappedNode) ?? 1)), velocity: MIDIVelocity(velocity), channel: MIDIChannel(channelNumber))
            midi.sendEvent(event)
            
        }
    }
}
extension TheSetupArea {
func stopPadMidiNoteSender(chosenNote : Int){
    
    if getPadNoteNumber(tappedPadButton: Int(tappedNode) ?? 1) == 40 || getPadNoteNumber(tappedPadButton: Int(tappedNode) ?? 1) == 41 || getPadNoteNumber(tappedPadButton: Int(tappedNode) ?? 1) == 42 || getPadNoteNumber(tappedPadButton: Int(tappedNode) ?? 1) == 43 || getPadNoteNumber(tappedPadButton: Int(tappedNode) ?? 1) == 102 || getPadNoteNumber(tappedPadButton: Int(tappedNode) ?? 1) == 103 || getPadNoteNumber(tappedPadButton: Int(tappedNode) ?? 1) == 104 {
        sendCCNoteNumber = getPadNoteNumber(tappedPadButton: Int(tappedNode) ?? 1)
        let event = AKMIDIEvent(controllerChange: MIDIByte(sendCCNoteNumber), value: MIDIByte(0), channel: MIDIChannel(channelNumber))
        midi.sendEvent(event)
        
    }
    else {
        sendMidiNoteNumber = getNoteNum(with: Int(tappedNode) ?? 1)
        let event = AKMIDIEvent(noteOn: MIDINoteNumber(getPadNoteNumber(tappedPadButton: Int(tappedNode) ?? 1)), velocity: MIDIVelocity(0), channel: MIDIChannel(channelNumber))
        midi.sendEvent(event)
        
    }
}
    
}



extension TheSetupArea {
    //    MARK: CARDS ACTIONS
    
    @IBAction func attackSlider(_ sender: UISlider) {
        attackValue = Double(sender.value)
        synthModel.attackValue = attackValue
    }
    
    @IBAction func decaySlider(_ sender: UISlider) {
        decayValue = Double(sender.value)
        synthModel.decayValue = decayValue
    }
    
    @IBAction func sustainSlider(_ sender: UISlider) {
        sustainValue = Double(sender.value)
        synthModel.sustainValue = sustainValue
    }
    
    @IBAction func releaseSlider(_ sender: UISlider) {
        releaseValue = Double(sender.value)
        synthModel.releaseValue = releaseValue
    }
    
    @IBAction func FilterFreqSLider(_ sender: UISlider) {
        frequency = pow(10, Double(sender.value))
        synthModel.filterFrequency = frequency
        
    }
    @IBAction func ResonanceSlider(_ sender: UISlider) {
        resonance = pow(10, Double(sender.value))
        synthModel.resFreq = resonance
       
    }
    
    
    @IBAction func filterSelector1(_ sender: UISegmentedControl) {
        filterSelection = sender.selectedSegmentIndex
        synthModel.typeSelection = filterSelection
      
    }

    /********************************/
}

extension TheSetupArea {
    
    func hideArCards(){
        sceneCard1.removeFromParentNode()
        sceneCard2.removeFromParentNode()
        sceneCard3.removeFromParentNode()
        
    }
    
    func noteOn(note: MIDINoteNumber) {
        midi.sendEvent(AKMIDIEvent(noteOn: note, velocity: MIDIVelocity(synthModel.amp) , channel: 1))
        
    }
    func noteOff(note: MIDINoteNumber) {
        midi.sendEvent(AKMIDIEvent(noteOff: note, velocity: 0, channel: 1))
        
    }
    
}
