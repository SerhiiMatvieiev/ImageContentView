//
//  ImageActionButton.swift
//  Nebula
//
//  Created by Sergey Matveev on 27.01.2020.
//  Copyright © 2020 Genesis. All rights reserved.
//

import UIKit

class ImageActionButton: UIButton {
    
    var action: ContentAction?
    
    convenience init(action: ContentAction, frame: CGRect) {
        self.init(frame: frame)
        self.action = action
        self.touchAreaInset = action.touchAreaInset
        #if DEBUG
        addTouchAreaBorder()
        #endif
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        #if DEBUG
        addBorder()
        #endif
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private
    private func addBorder() {
        layer.borderWidth = 1
        layer.borderColor = UIColor(red: 0 / 255, green: 230 / 255, blue: 118 / 255, alpha: 1).cgColor
    }
    
    private func addTouchAreaBorder() {
        guard let touchAreaInset = action?.touchAreaInset else { return }
        layer.addBorder(frame: CGRect(x: -touchAreaInset,
                                      y: -touchAreaInset,
                                      width: frame.width + 2 * touchAreaInset,
                                      height: frame.height + 2 * touchAreaInset),
                        color: UIColor(red: 0 / 255, green: 176 / 255, blue: 255 / 255, alpha: 1),
                        thickness: 1)
    }
}

extension CALayer {
    
    func addBorder(frame: CGRect, color: UIColor?, thickness: CGFloat) {
        let border = CALayer()
        border.frame = frame
        border.borderColor = color?.cgColor
        border.borderWidth = thickness
        addSublayer(border)
    }
}
