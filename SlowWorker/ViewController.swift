//
//  ViewController.swift
//  SlowWorker
//
//  Created by Tim Pryor on 2015-09-29.
//  Copyright (c) 2015 Tim Pryor. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet var startButton: UIButton!
    @IBOutlet var resultsTextView: UITextView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    func fetchSomethingFromServer() -> String {
        NSThread.sleepForTimeInterval(1)
        return "Hi there"
    }
    
    func processData(data: String) -> String {
        NSThread.sleepForTimeInterval(2)
        return data.uppercaseString
    }
    
    func calculateFirstResult(data: String) -> String {
        NSThread.sleepForTimeInterval(3)
        return "Number of chars: \(count(data))"
    }
    
    func calculateSecondResult(data: String) -> String {
        NSThread.sleepForTimeInterval(4)
        return data.stringByReplacingOccurrencesOfString("E", withString: "e")
    }
    
    @IBAction func doWork(sender: AnyObject) {
        
        let startTime = NSDate()
        self.resultsTextView.text = ""
        startButton.enabled = false
        spinner.startAnimating()
        
        // grab a preexisting global queue that's always avail
        // two arg, 1st being a priority, secong unused and should always be 0
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        
        // make this code run entirely in the background by wrapping all the 
        // code in a closure and pass to a GCD function called dispatch_async
        // Two parameters: a GCD queue and a closure to assign it to the queue
        
        // uses Swift's trailing closure syntax to make code more readable
        /* normal syntax:
        dispatch_queue_async(queue, {
            //Code
        })

        */
        
        // GCD takes the closure and puts it on the queue, form where it will be scheduled to
        // run on a background thread and executed one step at a time
        
        dispatch_async(queue) {
            let fetchedData = self.fetchSomethingFromServer()
            let processedData = self.processData(fetchedData)
            //let firstResult = self.calculateFirstResult(processedData)
            //let secondResult = self.calculateSecondResult(processedData)
            
            
            // each of the calculate methods returns a value that we want to grab
            // we need to make sure that the variables firstResult and secondResult can be assigned from
            //  the closures
            
            // String!: implicitly unwrap, but need to make sure both will have value when eventually read
            // vars are read in completion closure for async group, by which time they are certain to have value
            var firstResult: String!
            var secondResult: String!
            let group = dispatch_group_create()
            
            dispatch_group_async(group, queue) {
                firstResult = self.calculateFirstResult(processedData)
            }
            
            dispatch_group_async(group, queue) {
                secondResult = self.calculateSecondResult(processedData)
            }
            
            dispatch_group_notify(group, queue) {
                let resultsSummary = "First: [\(firstResult)\nSecond[\(secondResult)]"
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.resultsTextView.text = resultsSummary
                    self.startButton.enabled = true
                    self.spinner.stopAnimating()
                }
                
                // messaging any GUI object from a background thread is forbidden
                // This passes work back to main thread
                
                let endTime = NSDate()
                // startTime defined before closure created
                // by the time the closure is executed, doWork() has returned
                // Swift automatically allows closure to access
                println("Completed in \(endTime.timeIntervalSinceDate(startTime)) seconds")
            
                
            }
            
        }
    
    }
 
}

