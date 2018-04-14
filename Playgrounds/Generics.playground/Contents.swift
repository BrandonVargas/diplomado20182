//: Playground - noun: a place where people can play

import UIKit

func swapGeneric<T>(a: inout T, b: inout T) {
    let temp = a
    a = b
    b = temp
}

var a1 = 5
var b1 = 10
swapGeneric(a: &a1, b: &b1)
print("\(a1) - \(b1)")


func genericEqual<T : Comparable>(a: T, b: T) -> Bool {
    return a == b
}

struct List<T> {
    var items = [T]()
    mutating func add(item: T) {
        items.append(item)
    }
    
    func getItemAtIndex(index: Int) -> T? {
        if items.count > index {
            return items[index]
        } else {
            return nil
        }
    }
    
    func getSize() -> Int {
        return items.count
    }
    
    subscript(index: Int) -> T? {
        return getItemAtIndex(index: index)
    }
    
    subscript(r: CountableClosedRange<Int>) -> [T]? {
        get {
            return Array(items[r.lowerBound...r.upperBound])
        }
    }
}
class generica<T, E> {}

enum enumGenerico<T> {}

var stringList = List<String>()
stringList.add(item: "1")
stringList.add(item: "2")
stringList.add(item: "3")

print(stringList.getItemAtIndex(index: 0)!)

//Associated types

protocol MyProtocol {
    associatedtype T
    var items: [T] { get set }
    mutating func addItem(item: T)
}

struct MystringType: MyProtocol {
    var items: [Int] = []
    mutating func addItem(item: Int) {
        items.append(item)
    }
}

struct MyGenericStruct<T>: MyProtocol {
    var items:[T] = []
    mutating func addItem(item: T) {
        items.append(item)
    }
}

var myIntList = List<Int>()
myIntList.add(item: 1)
myIntList.add(item: 2)
myIntList.add(item: 3)
myIntList.add(item: 4)

var valores = myIntList[1...3]
print(valores!)
