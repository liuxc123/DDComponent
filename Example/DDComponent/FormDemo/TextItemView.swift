//
//  TextItemView.swift
//  FastepBus
//
//  Created by liuxc on 2021/12/20.
//  Copyright © 2021 Youba. All rights reserved.
//

import UIKit

public class TextItemView: UIView {
    
    public lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        return imageView
    }()
    
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    public lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    public lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .top
        return stackView
    }()
    
    private let insets: UIEdgeInsets
    private let titleWidth: CGFloat?

    public init(frame: CGRect, insets: UIEdgeInsets = .zero, titleWidth: CGFloat? = nil) {
        self.insets = insets
        self.titleWidth = titleWidth
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }
    
    public required init?(coder: NSCoder) {
        self.insets = .zero
        self.titleWidth = nil
        super.init(coder: coder)
        setupUI()
        setupLayout()
    }
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: self.frame.width, height: self.frame.height)
    }

    private func setupUI() {
        addSubview(stackView)
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(detailLabel)
    }
    
    private func setupLayout() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        if let titleWidth = titleWidth {
            titleLabel.widthAnchor.constraint(equalToConstant: titleWidth).isActive = true
        }
        
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        detailLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }

}

