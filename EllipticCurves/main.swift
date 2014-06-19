//
//  main.swift
//  EllipticCurves - http://jeremykun.com/2014/02/24/elliptic-curves-as-python-objects/
//
//  Created by Berkus on 19/06/14.
//  Copyright (c) 2014 Berkus. All rights reserved.
//

import Foundation
import Cocoa

class EllipticCurve
{
    let a: Double
    let b: Double
    let discriminant: Double
    
    // Assume already in Weierstrass form
    init(a: Double, b: Double)
    {
        self.a = a
        self.b = b
        self.discriminant = -16 * (4 * a*a*a + 27 * b*b)
        assert(isSmooth(), "Elliptic curve is not smooth!")
    }
    
    func isSmooth() -> Bool {
        return !discriminant.isZero;
    }
    
    func testPoint(x: Double, _ y: Double) -> Bool {
        return y*y == x*x*x + a * x + b
    }
    
    var description: String {
        return "y^2 = x^3 + \(a)x + \(b)"
    }
}

func == (left: EllipticCurve, right: EllipticCurve) -> Bool
{
    return left.a == right.a && left.b == right.b
}

struct Point
{
    var x: Double
    var y: Double
    let curve: EllipticCurve

    init(x: Double, y: Double, curve: EllipticCurve)
    {
        self.x = x
        self.y = y
        self.curve = curve
        assert(curve.testPoint(x, y), "Point is not on elliptic curve!")
    }

    var description: String {
        return "[\(x) : \(y)]"
    }
}


println(EllipticCurve(a: 17, b: 1).description)
//println(EllipticCurve(a: 0, b: 0))
let c = EllipticCurve(a: 1, b: 2)

println(Point(x: 1, y: 2, curve: c).description)
println(Point(x: 1, y: 1, curve: c))

