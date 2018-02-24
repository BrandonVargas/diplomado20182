//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"


func isPrime(n: Int) -> Bool{
    if (n <= 1) {
        return false
    }else if (n <= 3) {
        return true
    }else if (n % 2 == 0 || n % 3 == 0) {
        return false
    }
    var i = 5
    while (i * i <= n) {
        if (n % i == 0 || n % (i + 2) == 0) {
            return false
        }
    }
    i = i + 6
    return true
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

for index in 1...10 {
    let x = fibonacci(n: index)
    if (isPrime(n: x)) {
        print(x)
    }
}

func isPalindrome(str: String) -> Bool {
    let str2 = str.replacingOccurrences(of: "\\W", with: "", options: .regularExpression, range: nil)
    if (str2.elementsEqual(str2.reversed())) {
        return true
    } else {
        return false
    }
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

sameChars("acac", con: "caca")


