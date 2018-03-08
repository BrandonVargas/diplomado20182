//: [Previous](@previous)

import Foundation

func magicEightBall() {
    let number: UInt32 = arc4random_uniform(UInt32(8))
    switch number {
    case 0:
        print("Vas a tener suerte en el amor")
    case 1:
        print("Te va a ir mal en el amor")
    case 2:
        print("Ganarás la loteria")
    case 3:
        print("Aaaaveda")
    case 4:
        print("Ño")
    case 5:
        print("Chi")
    case 6:
        print("Sevaser o no sevaser")
    case 7:
        print("Se tiene queaser")
    case 8:
        print("Encontrarás al amor de tu vida")
    default:
        print("Error")
    }
}

magicEightBall()

//: [Next](@next)
