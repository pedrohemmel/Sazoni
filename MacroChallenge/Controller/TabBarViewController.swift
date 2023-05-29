//
//  TabBarViewController.swift
//  MacroChallenge
//
//  Created by Pedro henrique Dias hemmel de oliveira souza on 29/05/23.
//

import Foundation
import UIKit

class TabBarViewController: UIViewController {
    
    lazy var text: UILabel = {
        let text = UILabel()
        text.text = "Pedrolas"
        text.textColor = .black
        return text
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.text)
    }
}
