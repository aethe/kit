// MIT License
//
// Copyright (c) 2022 Andrey Ufimcev
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation

struct CubicBezier {
    let p1x: Double
    let p1y: Double
    let p2x: Double
    let p2y: Double

    private let a: Double
    private let b: Double
    private let c: Double

    private let abc9SubBCb2: Double
    private let aSq27: Double
    private let aCb54: Double
    private let bDiv3a: Double
    private let pCb: Double
    private let p1y3: Double
    private let p1yNeg6AddP2y3: Double
    private let p1y3SubP2y3Add1: Double

    init(
        p1x: Double,
        p1y: Double,
        p2x: Double,
        p2y: Double
    ) {
        // The control points can't go out of the horizontal bounds.
        self.p1x = min(max(p1x, 0), 1)
        self.p1y = p1y
        self.p2x = min(max(p2x, 0), 1)
        self.p2y = p2y

        // Original equation for a cubic bezier curve:
        // p = (1 - t) ** 3 * p0 + t * p1 * (3 * (1 - t) ** 2) + p2 * (3 * (1 - t) * t ** 2) + p3 * t ** 3,
        // where:
        // - p: the point along the curve,
        // - p0: the start of the curve,
        // - p1: the first control point,
        // - p2: the second control point,
        // - p3: the end of the curve,
        // - t: the interpolation factor.

        // Because animation curves begin at P0 = [0, 0] and end at P1 = [1, 1], this can be reduced to:
        // p = t * p1 * (3 * (1 - t) ** 2) + p2 * (3 * (1 - t) * t ** 2) + t ** 3,
        // and written in a form of a cubic equation:
        // (3 * p1 - 3 * p2 + 1) * t ** 3 + (-6 * p1 + 3 * p2) * t ** 2 + 3 * p1 * t - p = 0.

        // Precalculate some parameters for the cubic equation.
        let p1x3 = 3 * p1x
        let p2x3 = 3 * p2x
        a = p1x3 - p2x3 + 1
        b = -2 * p1x3 + p2x3
        c = p1x3

        // Precalculate some values that are never going to change.
        let aSq = a * a
        let bSq = b * b
        let a3 = 3 * a
        let ac3 = a3 * c
        abc9SubBCb2 = 3 * b * ac3 - 2 * bSq * b
        aSq27 = 27 * aSq
        aCb54 = 54 * aSq * a
        bDiv3a = b / a3

        // Precalculate the p parameter for the Cardano's Formula during sampling.
        // Only the cube of the value is needed.
        let p = (ac3 - bSq) / (9 * aSq)
        pCb = p * p * p

        // Precalculate some values for finding py.
        let p2y3 = 3 * p2y
        p1y3 = 3 * p1y
        p1yNeg6AddP2y3 = -2 * p1y3 + p2y3
        p1y3SubP2y3Add1 = p1y3 - p2y3 + 1
    }

    func sample(at px: Double) -> Double {
        // We only know the x coordinate of the point on the curve - that's the time in the range between 0 and 1.
        // Given px (the time), we need to find py - the y coordinate of the point - the value at that time.
        // We solve a cubic equation along the x axis to find t, then we use t to find the value along the y axis.

        // The last missing parameter from the cubic equation.
        let d = -px

        // Use the Cardano's Formula to find the real root of the equation.
        // According to the formula, a cubic equation has solutions:
        // t1 = r + s - b / (3 * a),
        // t2 = -(r + s) / 2 - b / (3 * a) + i * sqrt(3) / 2 * (r - s),
        // t3 = -(r + s) / 2 - b / (3 * a) - i * sqrt(3) / 2 * (r - s),
        // where:
        // r = cbrt(q + sqrt(p ** 3 + q ** 2)),
        // s = cbrt(q - sqrt(p ** 3 + q ** 2)),
        // p = (3 * a * c - b ** 2) / (9 * a ** 2),
        // q = (9 * a * b * c - 27 * a ** 2 * d - 2 * b ** 3) / (54 / a ** 3).
        // We assume there is only one real solution - t1 (or just t), because 0 <= p1x and p2x <= 1.
        let q = (abc9SubBCb2 - aSq27 * d) / aCb54
        let qSq = q * q
        let pCbAddQSqSqrt = sqrt(pCb + qSq)
        let r = cbrt(q + pCbAddQSqSqrt)
        let s = cbrt(q - pCbAddQSqSqrt)
        let t = r + s - bDiv3a

        // Knowing t, find the y component of the point.
        // That's the value of an animated parameter at the given time px.
        let tSq = t * t
        let tCb = t * t * t
        let py = p1y3SubP2y3Add1 * tCb + p1yNeg6AddP2y3 * tSq + p1y3 * t
        return py
    }
}
