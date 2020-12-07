//
//  ContentAction.swift
//  Nebula
//
//  Created by Sergey Matveev on 27.01.2020.
//  Copyright © 2020 Genesis. All rights reserved.
//

import UIKit

public struct ContentAction {
    
    let frame: CGRect
    let name: String
    let touchAreaInset: CGFloat
    let controlEvent: UIControl.Event

    public typealias ContentActionHandler = () -> Void
    public let actionHandler: ContentActionHandler?
    
    public init(
        frame: CGRect, name: String = "",
        for controlEvent: UIControl.Event = .touchUpInside,
        touchAreaInset: CGFloat = .zero,
        handler: ContentActionHandler? = nil
    ) {
        self.frame = frame
        self.name = name
        self.controlEvent = controlEvent
        self.touchAreaInset = touchAreaInset
        self.actionHandler = handler
    }
}
