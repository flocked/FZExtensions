//
//  File.swift
//  
//
//  Created by Florian Zand on 14.10.22.
//

import SwiftUI
import Combine

extension SwiftUI.View {
    public func onTimer(isActive: Bool = true, interval: CGFloat, _ action: @escaping (Date) -> Void) -> some View {
        let publisher = isActive ? DisplayLinkTimer.TimerPublisher(interval: interval).eraseToAnyPublisher() : Empty<Date, Never>().eraseToAnyPublisher()
        return SubscriptionView(content: self, publisher: publisher, action: action)
    }
}
