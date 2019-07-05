// MIT License
//
// Copyright (c) 2019 Andrey Ufimtsev
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

/// A variable with atomic access.
class Atomic<T> {
    private let queue = DispatchQueue(label: "io.github.aethe.kit.atomic", qos: .userInteractive, attributes: .concurrent)
    private var value: T
    
    /// Creates a new atomic variable with the specified value.
    ///
    /// - Parameter value: The initial value.
    init(_ value: T) {
        self.value = value
    }
    
    /// Returns the current value.
    ///
    /// - Returns: The current value.
    func get() -> T {
        var result: T!
        
        queue.sync {
            result = value
        }
        
        return result
    }
    
    /// Sets a new value.
    ///
    /// - Parameter newValue: The new value.
    func set(_ newValue: T) {
        queue.sync(flags: .barrier) {
            value = newValue
        }
    }
    
    /// Mutates the current value preventing any thread from accessing it until the mutation is complete.
    ///
    /// - Parameter handler: A closure that receives the current value as an input and returns a new value as an output.
    func mutate(_ handler: (T) -> T) {
        queue.sync(flags: .barrier) {
            value = handler(value)
        }
    }
}
