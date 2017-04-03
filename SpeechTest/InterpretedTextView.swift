//
//  InterpretedTextView.swift
//  SpeechTest
//
//  Created by James Jongsurasithiwat on 4/2/17.
//  Copyright © 2017 James Jongs. All rights reserved.
//

import UIKit
import QuartzCore

@IBDesignable
class InterpretedTextView: UITextView {

    // MARK: - IBOutlets


    // MARK: - IBActions


    // MARK: - Constants


    // MARK: - Variables

    @IBInspectable internal var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
        }
    }

    @IBInspectable internal var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = self.borderColor.cgColor
        }
    }

    @IBInspectable internal var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = self.borderWidth
        }
    }

    // MARK: - Function

    internal required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    internal override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }


}
