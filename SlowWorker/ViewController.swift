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
            let firstResult = self.calculateFirstResult(processedData)
            let secondResult = self.calculateSecondResult(processedData)
            let resultsSummary = "First: [\(firstResult)]\nSecond: [\(secondResult)]"
           
            // messaging any GUI object from a background thread is forbidden
            // This passes work back to main thread
            dispatch_async(dispatch_get_main_queue()) {
                self.resultsTextView.text = resultsSummary
            }
            let endTime = NSDate()
            // startTime defined before closure created
            // by the time the closure is executed, doWork() has returned
            // Swift automatically allows closure to access
            println("Completed in \(endTime.timeIntervalSinceDate(startTime)) second")
        }
    }


}

