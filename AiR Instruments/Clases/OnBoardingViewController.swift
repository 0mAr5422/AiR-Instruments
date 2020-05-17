//
//  OnBoardingViewController.swift
//  AiR Instruments
//
//  Created by omar on 9/21/18.
//  Copyright © 2018 omar. All rights reserved.
//

import UIKit
import PageControls
class OnBoardingViewController: UIViewController {

//    variables and constants
    let instructionsForEachPage = ["AiR Instruments" , "Carry your instruments everywhere!" , "'Sound Mode' lets you play instruments on App, tweak sound with cards" , "'MIDI Mode ' lets you connect AiR Instrument using MIDI to DAW * " , "" ]
    
    let smallNotesForEachPage = ["CARRY INSTRUMENTS EVERYWHERE!" ," "," ", "* SUPPORTS GARAGE BAND", ""]
    
    /***************************************************************/
    
    //  MARK:  IBOUTLETS
    
 
    @IBOutlet weak var layoutConstraintForImage: NSLayoutConstraint!
    
    @IBOutlet weak var bottomLayoutConstraintForImage: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var onBoardingInstructions: UITextView!
    @IBOutlet weak var onBoardingText: UITextView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var letsGoButton: UIButton!
    @IBOutlet weak var uiPageControllerDots: FilledPageControl!
    /***************************************************************/
    
    
    //    MARK: IBACTIONS
    
    
    @IBAction func letsGoButton(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: "name")
        goToMainView(illegabaleToMainView: true)
    }
    
    
    
    /***************************************************************/
    
    override func viewWillAppear(_ animated: Bool) {
       
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        bottomLayoutConstraintForImage.constant = -70
        UIView.animate(withDuration: 1, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        onBoardingInstructions.isEditable = false
        onBoardingText.isEditable = false
        letsGoButton.isHidden = true
        
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        
       
        uiPageControllerDots.pageCount = instructionsForEachPage.count
        if uiPageControllerDots.currentPage == 0 {
            updateTextViewWithMoreInstructions(pageNumber: uiPageControllerDots.currentPage, instructionOfCurrentPage: onBoardingInstructions, textOfEachPage: onBoardingText)


        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Update scroll view content size.
        let contentSize = CGSize(width: scrollView.bounds.width * 5 ,
                                 height: scrollView.bounds.height)
        scrollView.contentSize = contentSize
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FinishedOnBoarding"{
            _ = segue.destination 
        }
    }
    
    
    
    
    

   

}

extension OnBoardingViewController {
    
    func updateTextViewWithMoreInstructions(pageNumber : Int , instructionOfCurrentPage : UITextView , textOfEachPage : UITextView){
        
        switch pageNumber {
        case 0:
            instructionOfCurrentPage.text = instructionsForEachPage[pageNumber]
            textOfEachPage.text = smallNotesForEachPage[pageNumber]
            letsGoButton.isHidden = true
            onBoardingText.isHidden = false
            onBoardingInstructions.isHidden = false
        case 1 :
            instructionOfCurrentPage.text = instructionsForEachPage[pageNumber]
            textOfEachPage.text = smallNotesForEachPage[pageNumber]
            letsGoButton.isHidden = true
            onBoardingText.isHidden = false
            onBoardingInstructions.isHidden = false
        case 2 :
            instructionOfCurrentPage.text = instructionsForEachPage[pageNumber]
            textOfEachPage.text = smallNotesForEachPage[pageNumber]
            letsGoButton.isHidden = true
            onBoardingText.isHidden = false
            onBoardingInstructions.isHidden = false
        case 3 :
            instructionOfCurrentPage.text = instructionsForEachPage[pageNumber]
            textOfEachPage.text = smallNotesForEachPage[pageNumber]
            letsGoButton.isHidden = true
            onBoardingText.isHidden = false
            onBoardingInstructions.isHidden = false
        case 4 :
            instructionOfCurrentPage.text = instructionsForEachPage[pageNumber]
            textOfEachPage.text = smallNotesForEachPage[pageNumber]
        default: break
        }
    }
    
    func goToMainView (illegabaleToMainView : Bool){
        if illegabaleToMainView == true{
            performSegue(withIdentifier: "FinishedOnBoarding", sender: self)
            
        }
        
    }
    
}

extension OnBoardingViewController : UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.bounds.width
        let progressInPage = scrollView.contentOffset.x - (page * scrollView.bounds.width)
        let progress = CGFloat(page) + progressInPage
        uiPageControllerDots.progress = progress

        updateTextViewWithMoreInstructions(pageNumber: uiPageControllerDots.currentPage, instructionOfCurrentPage: onBoardingInstructions, textOfEachPage: onBoardingText )
        uiPageControllerDots.tintColor = .black


        if uiPageControllerDots.currentPage == instructionsForEachPage.count - 1 {

            letsGoButton.isHidden = false
            onBoardingText.isHidden = true
            onBoardingInstructions.isHidden = true



        }

    }
}

