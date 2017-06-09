import UIKit
import os.log

// class Meal extends NSObject
class Meal: NSObject, NSCoding {
    var name: String
    var photo: UIImage?
    var rating: Int
    
    // MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    // directory in file system that we will store our archive data at
    static let ArchiveUrl = DocumentsDirectory.appendingPathComponent("meals")
    // MARK: Types
    
    // NSCoding approach- store VC's properties in a key-value store to persist when app is closes
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
    }
    
    // MARK: initialization
    init?(name: String, photo: UIImage?, rating: Int) {
        if name.isEmpty || rating < 0  || rating > 5 {
            return nil
        }
        self.name = name
        self.photo = photo
        self.rating = rating
    }
    
    // MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(rating, forKey: PropertyKey.rating)
    }
    
    // convenience initializers must call another initializer method in teh same class
    required convenience init?(coder aDecoder: NSCoder) {
        // should not persist data if there's not name
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("unable to decode the name for a MealObject", log: OSLog.default, type: .debug)
            return nil
        }
        
        // photo is an optional property of meal
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        
        // call regular initializer with decoded values
        self.init(name: name, photo: photo, rating: rating)
    }
}
