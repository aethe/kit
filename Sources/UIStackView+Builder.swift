// MIT License
//
// Copyright (c) 2021 Andrey Ufimcev
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

extension UIStackView {
    static var horizontal: Builder {
        Builder(axis: .horizontal)
    }

    static var vertical: Builder {
        Builder(axis: .vertical)
    }

    class Builder {
        private let stackView = UIStackView()

        init(axis: NSLayoutConstraint.Axis) {
            stackView.axis = axis
        }

        func align(by alignment: UIStackView.Alignment) -> Self {
            stackView.alignment = alignment
            return self
        }

        func distribute(by distribution: UIStackView.Distribution) -> Self {
            stackView.distribution = distribution
            return self
        }

        func space(by spacing: CGFloat) -> Self {
            stackView.spacing = spacing
            return self
        }

        func inset(by insets: UIEdgeInsets) -> Self {
            stackView.layoutMargins = insets
            return self.arrangeRelativeToLayoutMargins()
        }

        func inset(left: CGFloat, right: CGFloat, top: CGFloat, bottom: CGFloat) -> Self {
            inset(by: UIEdgeInsets(top: top, left: left, bottom: bottom, right: right))
        }

        func inset(all: CGFloat) -> Self {
            inset(by: UIEdgeInsets(top: all, left: all, bottom: all, right: all))
        }

        func inset(horizontal: CGFloat, vertical: CGFloat) -> Self {
            inset(by: UIEdgeInsets(top: vertical, left: horizontal, bottom: vertical, right: horizontal))
        }

        func inset(horizontal: CGFloat) -> Self {
            inset(by: UIEdgeInsets(top: 0, left: horizontal, bottom: 0, right: horizontal))
        }

        func inset(vertical: CGFloat) -> Self {
            inset(by: UIEdgeInsets(top: vertical, left: 0, bottom: vertical, right: 0))
        }

        func inset(left: CGFloat) -> Self {
            inset(by: UIEdgeInsets(top: 0, left: left, bottom: 0, right: 0))
        }

        func inset(right: CGFloat) -> Self {
            inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: right))
        }

        func inset(top: CGFloat) -> Self {
            inset(by: UIEdgeInsets(top: top, left: 0, bottom: 0, right: 0))
        }

        func inset(bottom: CGFloat) -> Self {
            inset(by: UIEdgeInsets(top: 0, left: 0, bottom: bottom, right: 0))
        }

        func arrangeRelativeToLayoutMargins() -> Self {
            stackView.insetsLayoutMarginsFromSafeArea = false
            stackView.isLayoutMarginsRelativeArrangement = true
            return self
        }

        func arrangeRelativeToBaseline() -> Self {
            stackView.isBaselineRelativeArrangement = true
            return self
        }

        func build(_ views: UIView...) -> UIStackView {
            for view in views {
                stackView.addArrangedSubview(view)
            }

            return stackView
        }

        func build(_ views: [UIView]) -> UIStackView {
            for view in views {
                stackView.addArrangedSubview(view)
            }

            return stackView
        }
    }
}
