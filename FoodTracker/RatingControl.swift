import UIKit

@IBDesignable class RatingControl: UIStackView {
    // MARK: members
    // don't want to let anything from outside this class access so declare private
    private var buttons = [UIButton]()
    // need to be able to change from outside (i.e. on info from server) so make public
    var rating = 0 {
        didSet {
            updateButtons()
        }
    }
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            setupButtons()
        }
    }
    @IBInspectable var starNumber: Int = 5 {
        didSet {
            setupButtons()
        }
    }
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    // need to use "required" keyword because super class also uses "required" for this method
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    // MARK: Private methods
    // MARK: button action
    func ratingButtonTapped(button: UIButton) {
        guard let ind = buttons.index(of: button) else {
            fatalError("button \(button) not in the ratings button array")
        }
        
        let selectedRating = ind + 1
        if selectedRating == rating {
            rating = 0
        } else {
            rating = selectedRating
        }
    }

    private func removePreviousButtons() {
        for button in buttons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
    }
    
    private func setupButtons() {
        removePreviousButtons()
        
        // load images for buttons
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "fullStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named: "highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        
        for index in 0..<starNumber {
            let button = UIButton()
            
            // set image for button
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar , for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
            
            // define contraints for button
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
            button.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
            
            // add action handler to button
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            
            // add button to the stack view
            addArrangedSubview(button)
            
            // add button to buttons property of class
            buttons.append(button)
            
            // set accessibility label
            button.accessibilityLabel = "Set \(index + 1) rating"
        }
    }
    
    private func updateButtons() {
        for (index, button) in buttons.enumerated() {
            button.isSelected = index < rating
            
            // set accessibility hint and value
            if index + 1 == rating {
                button.accessibilityHint = "Tap to reset rating to 0"
            } else {
                button.accessibilityHint = nil
            }
            
            let accessibilityValue: String
            switch (rating) {
                case 0:
                    accessibilityValue = "No rating set"
                case 1:
                    accessibilityValue = "1 star set"
                default:
                    accessibilityValue = "\(rating) stars set"
            }
            button.accessibilityValue = accessibilityValue
        }
    }
}
