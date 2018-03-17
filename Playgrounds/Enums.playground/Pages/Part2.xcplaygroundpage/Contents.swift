//: [Previous](@previous)

import UIKit

enum EstadoDocuemnto: Int {
    case Recibido = 0, Validado, EnProceso, Publicado
}

let valorEstado = EstadoDocuemnto.Validado.rawValue
let estado = EstadoDocuemnto(rawValue: 2)

enum ResultadoWebService {
    case Exito(String)
    case Error (Int)
}

func llamadaWS () -> ResultadoWebService {
    if false {
        return ResultadoWebService.Exito("Mi contenido")
    } else {
        return ResultadoWebService.Error(502)
    }
}

let resultado: ResultadoWebService = llamadaWS()
switch resultado {
    case let .Exito(contenido):
        print(contenido)
    case let .Error(contenido):
        print("El código de error es \(contenido)")
}



//: [Next](@next)
