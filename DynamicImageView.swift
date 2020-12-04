//
//  DynamicImageView.swift
//  Nebula
//
//  Created by Sergey Matveev on 10.09.2019.
//  Copyright © 2019 Genesis. All rights reserved.
//

import UIKit

final public class DynamicImageView: UIImageView {
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if bounds.size != intrinsicContentSize {
            invalidateIntrinsicContentSize()
        }
    }
    
    public override var intrinsicContentSize: CGSize {
        guard let image = image else {
            return .zero
        }
        return CGSize(width: frame.size.width, height: ceil(image.size.height * (frame.size.width / image.size.width)))
    }
    
}
