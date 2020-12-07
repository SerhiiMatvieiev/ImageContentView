//
//  UIButton.swift
//  ImageContentView
//
//  Created by Serhii Matvieiev on 04.12.2020.
//

import UIKit

extension UIButton {
    
    private struct AssociatedKeys {
        static var touchAreaInset = "touchAreaInset"
    }
    
    var touchAreaInset: CGFloat {
        get {
            guard let inset = objc_getAssociatedObject(self, &AssociatedKeys.touchAreaInset) as? CGFloat else { return .zero }
            return inset
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.touchAreaInset, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

