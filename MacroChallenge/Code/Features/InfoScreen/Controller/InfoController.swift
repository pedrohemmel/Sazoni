//
//  InfoController.swift
//  MacroChallenge
//
//  Created by Bruno Lafayette on 03/09/23.
//

import UIKit

class InfoController: UIViewController {
    
    private lazy var infoView = InfoView(frame: self.view.frame)
 
    override func loadView() {
        super.loadView()
        self.view = self.infoView
    }
    
}
