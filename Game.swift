//
//  Game.swift
//  Midterm
//
//  Created by Justin Chee on 2015-02-17.
//  Copyright (c) 2015 Justin Chee. All rights reserved.
//

import Foundation

class Game
{

    let title: String
    let genre: [String]
    let year: Int
    
    init(title: String, genre: [String], year: Int)
    {
        self.title = title
        self.genre = genre
        self.year = year
    }
    
}