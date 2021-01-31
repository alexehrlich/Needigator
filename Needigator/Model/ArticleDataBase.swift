//
//  ArticleDataBase.swift
//  Needigator
//
//  Created by Alexander Ehrlich on 16.03.20.
//  Copyright © 2020 Alexander Ehrlich. All rights reserved.
//

import Foundation

struct ArticleDataBase {
  
    //Hart-coded Produktdatenbank aus Testzwecke. Das soll durch eine Cloud-DB ersetzt werden.
    var items : [Article] = [
        Article(imageFileName: "Brantweinessig_1000 ml_72_1,19_YES_0,79.png"),
        Article(imageFileName: "Eier Freilandhaltung_6 Stk._38_1,59_NO_1,59.png"),
        Article(imageFileName: "Glühwein_700 ml_75_0,89_YES_0,55.png"),
        Article(imageFileName: "Meerschweinchenfutter_2 kg_33_12,99_NO_12,99.png"),
        Article(imageFileName: "Paulaner Weizenbier_500 ml_81_0,98_NO_0,98.png"),
        Article(imageFileName: "Pringles Chips_120 g_36_1,89_YES_1,24.png"),
        Article(imageFileName: "Rotwein_700 ml_91_5,99_NO_5,99.png"),
        Article(imageFileName: "Schweinehals_1 kg_0_2,49_NO_2,49.png"),
        Article(imageFileName: "Schweineschnitzel_1 kg_0_1,39_NO_1,39.png"),
        Article(imageFileName: "Vollkornbrot_700 g_70_1,19_NO_1,19.png"),
        Article(imageFileName: "Weihenstephan Vollmilch_1 l_10_0,89_NO_0,89.png"),
        Article(imageFileName: "Weißwein_700 ml_75_5,99_NO_5,99.png"),
        Article(imageFileName: "Rosewein_700ml_75_6,99_YES_4,39.png"),
        Article(imageFileName: "Allzweckreiniger_1 L_31_1,79_NO_1,79"),
        Article(imageFileName: "Badeschwamm_2 Stk_33_0,89_NO_0,89"),
        Article(imageFileName: "Destiliertes Wasser_3 L_28_2,89_YES_2,22"),
        Article(imageFileName: "Vollwaschmittel_5 L_30_3,89_NO_3,89"),
        Article(imageFileName: "Walnüsse_500 Gr_74_2,89_2,49_NO_2,49")
    ]
}
