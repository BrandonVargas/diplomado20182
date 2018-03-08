//: [Previous](@previous)

import Foundation

//: Closures
var closureSuma: (Int, Int) -> Int
var closureMultiplicacion: (Int, Int) -> Int

closureSuma = { (a: Int, b: Int) -> Int in
    return a + b
}

closureMultiplicacion = { (a: Int, b: Int) -> Int in
    return a * b
}

let resultado = closureSuma(3, 2)

func ejecutaOperacion(_ closure: (Int, Int) -> Int, a: Int, b: Int) {
    let resultado = closure(a,b)
    print(resultado)
}

ejecutaOperacion(closureSuma, a:3, b:4)
ejecutaOperacion(closureMultiplicacion, a:3, b:4)

var miClosure = {(a: Int, b: Int) -> Int in
    return a + b
}

miClosure = {
    $0 + $1
}

var closureSinRetorno = {() -> Void in
    print("No regresò nada")
}

closureSinRetorno()

func incrementaClosure() -> () -> Int {
    var contador = 0
    let incrmenta: () -> Int = {
        contador += 1
        return contador
    }
    return incrmenta
}

let contador1 = incrementaClosure()
let contador2 = incrementaClosure()

contador1()
contador1()
contador2()
contador1()

let letras = ["Z", "CCCC", "MHHHHHH", "OOO", "Hiiiiiiiiiii"]
letras.sorted()

print(letras.sorted {
    $0.count > $1.count
})


letras.forEach { (arg) in
    print("\(arg)")
}

let numeros = [2.3, 3.1, 4.7, 5.2, 7.8, 9.1, 10]

numeros.forEach {
    print("\($0)")
}

let filtrados = numeros.filter {
    return $0 > 5
}

print("Numero filtrados: \(filtrados)")

let total = numeros.reduce(0){
    return $0 + $1
}

print(total)

//: [Next](@next)
