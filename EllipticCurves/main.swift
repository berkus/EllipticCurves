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

class Point
{
    let x: Double
    let y: Double
    let curve: EllipticCurve

    // Only used by Ideal below to init curve
    init(curve: EllipticCurve)
    {
        self.curve = curve
        self.x = -1.0 // Hmm, make them optionals? blergh!
        self.y = -1.0
    }

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

@prefix func -(right: Point) -> Point
{
    return Point(x: right.x, y: -right.y, curve: right.curve)
}

class Ideal : Point
{

    init(curve: EllipticCurve)
    {
        super.init(curve: curve)
    }

    override var description: String {
        return "[Ideal]"
    }
}

@prefix func -(right: Ideal) -> Ideal
{
    return Ideal(curve: right.curve)
}

@infix func +(left: Ideal, right: Point) -> Point
{
    assert(left.curve == right.curve, "Points on different curves!")
    return right
}

@infix func +(left: Point, right: Ideal) -> Point
{
    assert(left.curve == right.curve, "Points on different curves!")
    return left
}

@infix func +(left: Point, right: Point) -> Point
{
    assert(left.curve == right.curve, "Points on different curves!")
    var m: Double // Doh
    let (x_1, y_1, x_2, y_2) = (left.x, left.y, right.x, right.y)
    if x_1 == x_2 && y_1 == y_2 {
        if y_1 == 0.0 {
            return Ideal(curve: left.curve)
        }
        // Slope of the tangent line
        m = (3 * x_1 * x_1 + left.curve.a) / (2 * y_1)
    }
    else
    {
        if x_1 == x_2 {
            return Ideal(curve: left.curve) // Vertical line
        }
        // Slope of the secant line
        m = (y_2 - y_1) / (x_2 - x_1)
    }

    // Use Vieta's formula for the sum of the roots
    let x_3 = m*m - x_2 - x_1
    let y_3 = m*(x_3 - x_1) + y_1

    return Point(x: x_3, y: -y_3, curve: left.curve)
}

println(EllipticCurve(a: 17, b: 1).description)
//println(EllipticCurve(a: 0, b: 0))
let c = EllipticCurve(a: -2, b: 4)

let p1 = Point(x: 3, y: 5, curve: c)
let p2 = Point(x: -2, y: 0, curve: c)
let i1 = Ideal(curve: c)

println((p1+p2).description)
println((p2+p1).description)
println((p2+p2).description)
println((p1+p1).description)
println((p1+p1+p1).description)

println((p1+i1).description)
println(Point(x: 1, y: 1, curve: c))

