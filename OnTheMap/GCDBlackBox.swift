//
//  GCDBlackBox.swift
//  OnTheMap
//
//  Created by Youngsun Paik on 6/9/16.
//  Copyright © 2016 Youngsun Paik. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(updates: () -> Void) {
    dispatch_async(dispatch_get_main_queue()) {
        updates()
    }
}