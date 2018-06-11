//
//  InstagramSharedVC+Handler.swift
//  Capchur
//
//  Created by Hitesh Surani on 01/06/18.
//  Copyright © 2018 Hitesh Surani. All rights reserved.
//

import Foundation

extension InstagramSharedVC{
    
    @objc func dismissLoginViewController() {
        self.dismiss(animated: true)
    }
    
    @objc func refreshPage() {
        self.reloadPage()
    }
}
