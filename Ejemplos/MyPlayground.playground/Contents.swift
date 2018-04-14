//: Playground - noun: a place where people can play

import UIKit

let main = DispatchQueue.main
let background = DispatchQueue.global()

func doSyncWork() {
    background.sync {
        for _ in 1...3 {
            print("Light")
        }
    }
    
    for _ in 1...3 {
        print("Heavy")
    }
} //main

doSyncWork()

let asianWorker = DispatchQueue(label: "construction_worker_1")
let bronwWorker = DispatchQueue(label: "construction_worker_2")

func doLightwork() {
    asianWorker.async {
        for _ in 1...10 {
            print("👷🏻‍♂️")
        }
    }
    
    bronwWorker.async {
        for _ in 1...10 {
            print("👷🏽‍♂️")
        }
    }
}

doLightwork()

let whiteWorker = DispatchQueue(label: "construction_worker_3", qos: .background)// less important
let blackWorker = DispatchQueue(label: "construction_worker_4", qos: .userInitiated) // more important

func doLightworks() {
    whiteWorker.async {
        for _ in 1...10 {
            print("👷‍♂️")
        }
    }
    
    blackWorker.async {
        for _ in 1...10 {
            print("👷🏿‍♂️")
        }
    }
}
doLightworks()

/*
 
 userInteactive (highest priority)
 userInitiated
 default
 utility
 background
 unspecified (lowest)
 */


