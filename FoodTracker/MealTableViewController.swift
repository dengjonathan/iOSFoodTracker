//  MealTableViewController.swift
//  FoodTracker
//
//  Created by Jonathan Deng on 5/25/17.
//  Copyright © 2017 Jonathan Deng. All rights reserved.
//

import UIKit

class MealTableViewController: UITableViewController {
    // MARK: properties
    
    // why does this view controller store all the views= should we store in a model and use that as a data source?
    var meals = [Meal]()

    override func viewDidLoad() {
        super.viewDidLoad()

        loadSampleMeals()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    // these methods satisfy the UITableViewDataSourceProtocol

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MealTableViewCell", for: indexPath) as? MealTableViewCell else {
         fatalError("The dequeued cell is not an instance of the class MealTableViewCell")
        }
        
        let meal = meals[indexPath.row]

        // Configure the cell...
        cell.mealLabel.text = meal.name
        cell.photoImageView.image = meal.photo
        cell.ratingControl.rating = meal.rating

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    // MARK: private functions
    private func loadSampleMeals() {
        let photo1 = UIImage(named: "image1")
        let photo2 = UIImage(named: "image2")
        let photos: [UIImage?] = [photo1, photo2]
        for photo in photos {
            guard let meal = Meal(name: "Meal of \(photo?.description ?? "some meal")", photo: photo, rating: Int(arc4random_uniform(5))) else {
                fatalError("Meal object failed to init")
            }
            meals.append(meal)
        }
    }
    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        // if the sourceViewController is an instance of MealViewController (or could be cast as one) AND sourceViewController.meal is NOT nil
        // assigns 2 local contants 1. sourceViewController, 2. meal
        if let sourceViewController = sender.source as? MealViewController, let meal = sourceViewController.meal {
            // put new meal at end of first section
            let indexPath = IndexPath(row: meals.count, section: 0)
            // the at argument is an array of indexes to get to the node that we're looking for
            // in this case we're only going one level down
            tableView.insertRows(at: [indexPath], with: .automatic)
            
            // update model
            meals.append(meal)
        }
    }
}

