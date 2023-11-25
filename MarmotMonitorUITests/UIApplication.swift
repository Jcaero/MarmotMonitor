//
//  UIApplication.swift
//  MarmotMonitorUITests
//
//  Created by pierrick viret on 25/11/2023.
//
import Foundation
import XCTest
@testable import MarmotMonitor

class UIApplication: XCUIApplication {
    var commencerButton: XCUIElement {self.buttons["Commencer"]}
    var nextButton: XCUIElement {self.buttons["Suivant"]}
//    var clearButton: XCUIElement {self.buttons["Clear"]}
    var input: XCUIElement {self.textFields["babyName"]}
//    var tabBarSearch: XCUIElement {tabBars.buttons.element(boundBy: 0)}
//    var tabBarFavorite: XCUIElement {tabBars.buttons.element(boundBy: 1)}
//    var saveButtonStar: XCUIElement {self.buttons["SaveButtonStar"]}
}
