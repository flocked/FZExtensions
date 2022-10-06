import SwiftUI

public struct EmptyShape: InsettableShape {
  public init() {}

    public func path(in rect: CGRect) -> SwiftUI.Path {
        SwiftUI.Path()
  }

  public func inset(by amount: CGFloat) -> some InsettableShape {
    self
  }
}
