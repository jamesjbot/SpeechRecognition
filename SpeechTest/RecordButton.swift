//
//  RecordButton.swift
//  SpeechTest
//
//  Created by James Jongsurasithiwat on 4/2/17.
//  Copyright © 2017 James Jongs. All rights reserved.
//

import UIKit

@IBDesignable
class RecordButton: UIButton {

    // MARK: VARIABLES

    @IBInspectable internal var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
        }
    }

    @IBInspectable internal var borderColor: UIColor = UIColor.green {
        didSet {
            self.layer.borderColor = self.borderColor.cgColor
        }
    }

    @IBInspectable internal var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = self.borderWidth
        }
    }


    // MARK: FUNCTIONS

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

}
