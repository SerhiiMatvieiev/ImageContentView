//
//  ImageContentView.swift
//  Nebula
//
//  Created by Sergey Matveev on 24.01.2020.
//  Copyright © 2020 Genesis. All rights reserved.
//

import UIKit

public class ImageContentView: UIView {
    
    // MARK: Dependencies
    private(set) var image: UIImage?
    
    private var contentActions: [ContentAction] = []

    // MARK: Public
    public func configure(withImage image: UIImage?) {
        self.imageView.image = image
        self.imageEdgeInsets = { self.imageEdgeInsets }()
        self.contentInset = { self.contentInset }()
        addActionButtons()
    }
    
    public var imageEdgeInsets: UIEdgeInsets = .zero {
        didSet {
            imageView.image = imageView.image?.withAlignmentRectInsets(imageEdgeInsets)
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    public var contentInset: UIEdgeInsets = .zero {
        didSet {
            scrollView.contentInset = contentInset
        }
    }

    public func addActions(_ actions: [ContentAction]) {
        actions.forEach { addAction($0) }
    }
    
    public func addAction(_ action: ContentAction) {
        guard action.frame != .zero else { return }
        contentActions.append(action)
    }
    
    // MARK: Subviews
    public var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsHorizontalScrollIndicator = false
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    
    private var contentView = UIView()
    
    private lazy var imageView: DynamicImageView = {
        let iv = DynamicImageView()
        iv.image = image
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    // MARK: - Init
    
    public init(image: UIImage? = nil) {
        self.image = image
        super.init(frame: .zero)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeImageViewObserver()
    }
    
    private func initialize() {
        setupUI()
        addImageViewObserver()
    }
    
    // MARK: - Observers
    
    private var imageViewObserver: NSKeyValueObservation?

    private func addImageViewObserver() {
        imageViewObserver = imageView.observe(\.bounds) { [weak self] _, _ in
            guard let strongSelf = self else { return }
            strongSelf.didLayoutImageView()
        }
    }
    
    private func removeImageViewObserver() {
        imageViewObserver?.invalidate()
    }
    
    private func didLayoutImageView() {
        addActionButtons()
    }

    // MARK: Actions
    @objc private func contentAction(_ sender: ImageActionButton) {
        sender.action?.actionHandler?()
        #if DEBUG
        if let name = sender.action?.name {
            actionAlert(message: name)
        }
        #endif
    }
    
    // MARK: Private
    private func setupUI() {
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.leftAnchor.constraint(equalTo: leftAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.rightAnchor.constraint(equalTo: rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        let heightConstraint = scrollView.heightAnchor.constraint(equalTo: heightAnchor)
        heightConstraint.priority = UILayoutPriority(rawValue: 250)
        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: widthAnchor),
            heightConstraint
        ])
        
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func actionAlert(message: String? = nil) {
        let alert = UIAlertController(title: "Action", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    private func addActionButtons() {
        guard let image = imageView.image else { return }
        imageView.subviews.forEach { $0.removeFromSuperview() }
        
        let imageViewContentSize = imageView.intrinsicContentSize
        let imageSize = image.size
        
        for action in contentActions {
            let x = CGFloat(action.frame.origin.x / imageSize.width) * imageViewContentSize.width
            let y = CGFloat(action.frame.origin.y / imageSize.height) * imageViewContentSize.height
            let width = CGFloat(action.frame.width / imageSize.width) * imageViewContentSize.width
            let height = CGFloat(action.frame.height / imageSize.height) * imageViewContentSize.height
            
            let actionButton = ImageActionButton(action: action, frame: CGRect(x: x, y: y, width: width, height: height))
            actionButton.addTarget(self, action: #selector(contentAction), for: action.controlEvent)
            imageView.addSubview(actionButton)
        }
    }
}
