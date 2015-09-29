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
        let fetchedData = self.fetchSomethingFromServer()
        let processedData = self.processData(fetchedData)
        let firstResult = self.calculateFirstResult(processedData)
        let secondResult = self.calculateSecondResult(processedData)
        let resultsSummary = "First: [\(firstResult)]\nSecond: [\(secondResult)]"
        self.resultsTextView.text = resultsSummary
        let endTime = NSDate()
        println("Completed in \(endTime.timeIntervalSinceDate(startTime)) second")
        
    }


}

