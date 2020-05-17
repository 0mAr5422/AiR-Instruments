//
//  PickNewInstruments.swift
//  AiR Instruments
//
//  Created by omar on 9/21/18.
//  Copyright © 2018 omar. All rights reserved.
//

import UIKit
import PageControls
import AudioKit

protocol CanRecieve {
    func passData(instrumentName : String , didPickInstrument : Bool )
}

class PickNewInstrument: UIViewController {

    //    MARK: VARIABLES AND CONSTANTS
    var availableInstruments = ["piano", "pad"]
    var delegate : CanRecieve?
    var pickedInstrument = ""
    
  
    //  MARK:IBOUTLETS
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var uiPageControllerDots: FilledPageControl!
    @IBOutlet weak var instrumentName: UILabel!
    @IBOutlet weak var instrumentThumbnail: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    //    MARK: CARDS OUTLETS
    

    
    /********************************/
    
    
    //    MARK: IBACTIONS

    @IBAction func userTappedTheImageOfInstrument(_ sender: UIButton) {
        
       pickedInstrument = instrumentName.text!
        delegate?.passData(instrumentName: pickedInstrument, didPickInstrument: true)
       dismiss(animated: true, completion: nil)
        
    }
    
  
    override func viewWillAppear(_ animated: Bool) {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.frame.origin.y -= 80
            
        }, completion: nil)
        UIView.animate(withDuration: 1, animations: {
            self.view.frame.origin.y += 80
        }, completion: nil)
    }
  
    override func viewDidDisappear(_ animated: Bool) {
       
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        instrumentThumbnail.image = UIImage(named: "\(availableInstruments.first ?? "piano")")
        instrumentName.text = availableInstruments.first
    
        containerView.layer.cornerRadius = 0.5
        instrumentThumbnail.layer.cornerRadius = 0.5
        scrollView.layer.cornerRadius = 0.5
        self.view.layer.cornerRadius = 0.5
        
 
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Update scroll view content size.
        let contentSize = CGSize(width: scrollView.bounds.width * 2 ,
                                 height: scrollView.bounds.height)
        scrollView.contentSize = contentSize
    }
    

   
}
extension PickNewInstrument {
    
    func updateInstrumentsWhenYouChangePage(pageNumber : Int) {
        
        instrumentThumbnail.image = UIImage(named: "\(availableInstruments[pageNumber])")
        instrumentName.text = availableInstruments[pageNumber]
        pickedInstrument = availableInstruments[pageNumber]
        
        
    }

}
extension PickNewInstrument : UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.bounds.width
        let progressInPage = scrollView.contentOffset.x - (page * scrollView.bounds.width)
        let progress = CGFloat(page) + progressInPage
        uiPageControllerDots.progress = progress
       updateInstrumentsWhenYouChangePage(pageNumber: uiPageControllerDots.currentPage
        )
        uiPageControllerDots.tintColor = .black
        
        
     
        
    }
}


