//
//  AudioViewController+Buttons.swift
//  Subtitles
//
//  Created by Akram Hussein on 02/12/2017.
//  Copyright © 2017 Akram Hussein. All rights reserved.
//

import Foundation
import Material
import UIKit

extension AudioViewController {

    var intermediateTextIcon: UIImage? {
        return UIImage(named: "intermediate_text_icon")?.withRenderingMode(.alwaysTemplate)
    }

    func prepareAddCommonPhrasesFABMenuItem() {
        self.addCommonPhrasesFABMenuItem = FABMenuItem()
        self.addCommonPhrasesFABMenuItem.title = "Audio.AddCommonPhrases".localized
        self.addCommonPhrasesFABMenuItem.fabButton.image = Icon.work
        self.addCommonPhrasesFABMenuItem.fabButton.tintColor = Color.orange.base
        self.addCommonPhrasesFABMenuItem.fabButton.pulseColor = .white
        self.addCommonPhrasesFABMenuItem.fabButton.backgroundColor = .white
        self.addCommonPhrasesFABMenuItem.fabButton.addTarget(self, action: #selector(self.handleAddCommonPhrasesFABMenuItem(button:)), for: .touchUpInside)
    }

    func prepareChangeMicrophoneFABMenuItem() {
        self.changeMicrophoneFABMenuItem = FABMenuItem()
        self.changeMicrophoneFABMenuItem.title = "Audio.SwitchMicrophone.Bluetooth".localized
        self.changeMicrophoneFABMenuItem.fabButton.image = Icon.cm.microphone
        self.changeMicrophoneFABMenuItem.fabButton.tintColor = Color.blue.base
        self.changeMicrophoneFABMenuItem.fabButton.pulseColor = .white
        self.changeMicrophoneFABMenuItem.fabButton.backgroundColor = .white
        self.changeMicrophoneFABMenuItem.fabButton.addTarget(self, action: #selector(self.handleChangeMicrophoneFABMenuItem(button:)), for: .touchUpInside)
    }

    func prepareClearFABMenuItem() {
        self.clearFABMenuItem = FABMenuItem()
        self.clearFABMenuItem.title = "Audio.ClearText".localized
        self.clearFABMenuItem.fabButton.image = Icon.cm.clear
        self.clearFABMenuItem.fabButton.tintColor = Color.red.base
        self.clearFABMenuItem.fabButton.pulseColor = .white
        self.clearFABMenuItem.fabButton.backgroundColor = .white
        self.clearFABMenuItem.fabButton.addTarget(self, action: #selector(self.handleClearFABMenuItem(button:)), for: .touchUpInside)
    }

    func preparePlayPauseFABMenuItem() {
        self.playPauseFABMenuItem = FABMenuItem()
        self.playPauseFABMenuItem.title = "Audio.Pause".localized
        self.playPauseFABMenuItem.fabButton.image = Icon.cm.pause
        self.playPauseFABMenuItem.fabButton.tintColor = Color.red.base
        self.playPauseFABMenuItem.fabButton.pulseColor = .white
        self.playPauseFABMenuItem.fabButton.backgroundColor = .white
        self.playPauseFABMenuItem.fabButton.addTarget(self, action: #selector(self.handlePlayPauseFABMenuItem(button:)), for: .touchUpInside)
    }

    func prepareHypothesisTextFABMenuItem() {
        self.showHypothesisTextFABMenuItem = FABMenuItem()
        self.showHypothesisTextFABMenuItem.title = "Audio.IntermediateText.Hide".localized
        self.showHypothesisTextFABMenuItem.fabButton.image = self.intermediateTextIcon
        self.showHypothesisTextFABMenuItem.fabButton.tintColor = Color.red.base
        self.showHypothesisTextFABMenuItem.fabButton.backgroundColor = .white
        self.showHypothesisTextFABMenuItem.fabButton.pulseColor = .white
        self.showHypothesisTextFABMenuItem.fabButton.addTarget(self, action: #selector(self.handleHypothesisTextFabMenuItem(button:)), for: .touchUpInside)
    }

    func prepareKeywordColoursFABMenuItem() {
        self.keywordColoursFABMenuItem = FABMenuItem()
        self.keywordColoursFABMenuItem.title = "Audio.AddKeywordColours".localized
        self.keywordColoursFABMenuItem.fabButton.image = Icon.pen
        self.keywordColoursFABMenuItem.fabButton.tintColor = Color.green.base
        self.keywordColoursFABMenuItem.fabButton.backgroundColor = .white
        self.keywordColoursFABMenuItem.fabButton.pulseColor = .white
        self.keywordColoursFABMenuItem.fabButton.addTarget(self, action: #selector(self.handleKeywordColoursFABMenuItem(button:)), for: .touchUpInside)
    }

    func prepareOptionsFABMenuItem() {
        self.optionsFABMenuItem = FABMenuItem()
        self.optionsFABMenuItem.title = "Audio.Options".localized
        self.optionsFABMenuItem.fabButton.image = Icon.menu
        self.optionsFABMenuItem.fabButton.tintColor = Color.purple.base
        self.optionsFABMenuItem.fabButton.backgroundColor = .white
        self.optionsFABMenuItem.fabButton.pulseColor = .white
        self.optionsFABMenuItem.fabButton.addTarget(self, action: #selector(self.handleOptionsFABMenuItem(button:)), for: .touchUpInside)
    }

    func prepareFABButton() {
        self.fabButton = FABButton(image: Icon.cm.menu, tintColor: .white)
        self.fabButton.pulseColor = .white
        self.fabButton.backgroundColor = self.currentHighlightColor
    }

    func prepareFABMenu() {

        self.fabMenu.removeFromSuperview()
        self.fabMenu.fabButton = self.fabButton
        self.fabMenu.fabMenuDirection = .up
        self.fabMenu.interimSpace = 1.5

        self.fabMenu.fabMenuItems = [
            clearFABMenuItem,
            playPauseFABMenuItem,
            changeMicrophoneFABMenuItem,
            showHypothesisTextFABMenuItem,
            addCommonPhrasesFABMenuItem,
            keywordColoursFABMenuItem,
            optionsFABMenuItem
        ]

        // Center the button in middle of plot
        self.view.layout(self.fabMenu)
            .size(self.fabMenuSize)
            .bottom(self.bottomInset)
            .right(self.rightInset)
    }

    var bottomInset: CGFloat {
        let fabButtonHeight = self.fabMenuSize.height
        let plotHeight = (self.view.frame.height * 0.20)
        var bottomInset = (plotHeight / 2) - (fabButtonHeight / 2)

        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            bottomInset += window?.safeAreaInsets.bottom ?? 0.0
        }

        return bottomInset
    }

    func prepareButtons() {
        self.prepareFABButton()
        self.prepareClearFABMenuItem()
        self.preparePlayPauseFABMenuItem()
        self.prepareHypothesisTextFABMenuItem()
        self.prepareAddCommonPhrasesFABMenuItem()
        self.prepareChangeMicrophoneFABMenuItem()
        self.prepareKeywordColoursFABMenuItem()
        self.prepareOptionsFABMenuItem()
    }

    // MARK: Button Handlers

    @objc
    func handleClearFABMenuItem(button: UIButton) {
        self.textView.text.removeAll()
        self.finalTextEndRangeMarker = 0
        self.fabMenu.close()
        self.fabMenu.fabButton?.animate(.rotate(0))
    }

    @objc
    func handlePlayPauseFABMenuItem(button: Any) {
        self.play = !self.play
        self.fabMenu.close()
        self.fabMenu.fabButton?.animate(.rotate(0))
    }

    @objc
    func handleHypothesisTextFabMenuItem(button: UIButton) {
        self.shouldShowHypothesis = !self.shouldShowHypothesis
        self.showHypothesisTextFABMenuItem.fabButton.tintColor = self.shouldShowHypothesis ? Color.red.base : Color.green.base
        self.showHypothesisTextFABMenuItem.title = self.shouldShowHypothesis ? "Audio.IntermediateText.Hide".localized : "Audio.IntermediateText.Show".localized
        self.fabMenu.close()
        self.fabMenu.fabButton?.animate(.rotate(0))
    }

    @objc
    func handleAddCommonPhrasesFABMenuItem(button: UIButton) {
        self.fabMenu.close()
        self.fabMenu.fabButton?.animate(.rotate(0))

        let nav = UINavigationController(rootViewController: CommonPhrasesViewController())
        nav.navigationBar.barTintColor = .black
        nav.navigationBar.backgroundColor = .white

        self.present(nav, animated: true, completion: nil)
    }

    @objc
    func handleKeywordColoursFABMenuItem(button: UIButton) {
        self.fabMenu.close()
        self.fabMenu.fabButton?.animate(.rotate(0))

        let nav = UINavigationController(rootViewController: KeywordListViewController())
        nav.navigationBar.barTintColor = .black
        nav.navigationBar.backgroundColor = .white

        self.present(nav, animated: true, completion: nil)
    }

    @objc
    func handleChangeMicrophoneFABMenuItem(button: UIButton) {
        switch self.mode {
        case .mic:
            self.mode = .bluetooth
            self.startBluetooth()
        case .bluetooth:
            self.mode = .mic
            self.startMic()
        }

        self.fabMenu.close()
        self.fabMenu.fabButton?.animate(.rotate(0))
    }

    @objc
    func handleOptionsFABMenuItem(button: Any) {
        let nav = UINavigationController(rootViewController: OptionsViewController())
        nav.navigationBar.barTintColor = .black
        nav.navigationBar.backgroundColor = .white
        self.present(nav, animated: true, completion: nil)
        self.fabMenu.close()
        self.fabMenu.fabButton?.animate(.rotate(0))
    }
}
