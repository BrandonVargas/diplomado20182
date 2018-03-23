//: Playground - noun: a place where people can play

import UIKit

class Person {
    var name: String
    var lastName: String
    var age: Int
    var id: Int
    var partner: Person?
    static var count: Int = 0

    
    init(name: String, lastName: String) {
        self.name = name
        self.lastName = lastName
        self.age = 0
        Person.count = Person.count + 1
        self.id = Person.count
    }
    
    init?(age: Int){
        if(age > 18) {
            self.name = ""
            self.lastName = ""
            self.age = age
            Person.count = Person.count + 1
            self.id = Person.count
        } else {
            return nil
        }
    }
    
    deinit { print("\(name) is being deinitialized") }
}

if let person1 = Person(age: 19) {
    print(person1.age)
}

