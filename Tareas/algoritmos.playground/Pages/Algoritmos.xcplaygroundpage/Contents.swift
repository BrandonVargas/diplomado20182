//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"


func isPrime(n: Int) -> Bool{
    return n > 1 && !(2..<n).contains { n % $0 == 0 }
}

isPrime(n: 23)
isPrime(n: 4)

func fibonacci(n: Int) -> Int {
    if (n == 0 || n == 1) {
        return n
    } else {
        return (fibonacci(n: n - 1) + fibonacci(n: n - 2))
    }
}

func fibonacciPrime(n: Int) {
    var temp = 0
    for index in 0...n {
        temp = fibonacci(n: index)
        if (isPrime(n: temp)) {
            print(temp)
        }
    }
}

fibonacciPrime(n: 10)

func isPalindrome(str: String) -> Bool {
    let str2 = str.replacingOccurrences(of: "\\W", with: "", options: .regularExpression, range: nil)
    return str2.elementsEqual(str2.reversed())
}

var palindromo = "anita lava la tina"
isPalindrome(str: palindromo)

func sameChars(_ stringA: String,con stringB: String) -> Bool {
    for letterA in stringA {
        if !stringB.contains(letterA){
            return false
        }
    }
    for letterB in stringB {
        if !stringA.contains(letterB){
            return false
        }
    }
    return true
}

sameChars("loho", con: "hola")


