//
//  Result.swift
//  Flicko
//
//  Created by Gohar on 10/11/2018.
//  Copyright © 2018 AG. All rights reserved.
//

import UIKit

enum Result <T>{
    case Success(T)
    case Error(String)
}
