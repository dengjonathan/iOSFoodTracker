import UIKit

class Meal {
    var name: String
    var photo: UIImage?
    var rating: Int
    
    // MARK: initialization
    init?(name: String, photo: UIImage?, rating: Int) {
        if name.isEmpty || rating < 0  || rating > 5 {
            return nil
        }
        self.name = name
        self.photo = photo
        self.rating = rating
    }
    
    
}
