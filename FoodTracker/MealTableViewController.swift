//  MealTableViewController.swift
//  FoodTracker
//
//  Created by Jonathan Deng on 5/25/17.
//  Copyright © 2017 Jonathan Deng. All rights reserved.
//

import UIKit
import os.log

class MealTableViewController: UITableViewController {
    // MARK: properties
    
    // why does this view controller store all the views= should we store in a model and use that as a data source?
    var meals = [Meal]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // use edit button provided by VC
        navigationItem.leftBarButtonItem = editButtonItem
        if let savedMeals = loadMeals() {
            meals += savedMeals
        } else {
            loadSampleMeals()
        }
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

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
//         Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            meals.remove(at: indexPath.row)
            saveMeals()
            // question: why do I have to imperatively delete the row after I've removed the meal from the data source?
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }


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


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    // the segue object has all the informationa about destination and root
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//         Get the new view controller using segue.destinationViewController.
//         Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
            case "AddItem":
                // if we're a adding a new item we don't need to inject any data into the scene
                os_log("adding a new meal", log: OSLog.default, type:.debug)
            case "ShowDetail":
                guard let mealDetailViewController = segue.destination as? MealViewController else {
                    fatalError("unexpected destination \(segue.destination)")
                }
            
                guard let selectedMealCell = sender as? MealTableViewCell else {
                    fatalError("unexpected sender \(sender.debugDescription)")
                }
            
                guard let indexPath = tableView.indexPath(for: selectedMealCell) else {
                    fatalError("no cell is selected/ or the selected cell is not displayed on table")
                }
                mealDetailViewController.meal = meals[indexPath.row]
            default:
                fatalError("unexpected segue identifier")
            }
    }

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
            
            // if row is selected that means we're updating the row
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
               meals[selectedIndexPath.row] = meal
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                // put new meal at end of first section
                let indexPath = IndexPath(row: meals.count, section: 0)
                // the at argument is an array of indexes to get to the node that we're looking for
                
                // update model
                meals.append(meal)
                
                // in this case we're only going one level down
                // when inserting rows, table will automatically use the data source
                // which is member var meals
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
            saveMeals()
        }
    }
    
    private func saveMeals() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveUrl.path)
        if isSuccessfulSave {
            os_log("successful save")
        } else {
            os_log("failed to save meals")
        }
    }
    
    private func loadMeals() -> [Meal]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Meal.ArchiveUrl.path) as? [Meal]
    }
}

