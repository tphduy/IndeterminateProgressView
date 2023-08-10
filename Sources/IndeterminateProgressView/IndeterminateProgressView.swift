//
//  IndeterminateProgressView.swift
//  IndeterminateProgressView
//
//  Created by Duy Tran on 10/08/2023.
//

import SwiftUI

/// A view that shows the indeterminate progress toward the completion of a task.
public struct IndeterminateProgressView: View {
    // MARK: States

    /// A flag indicating whether the animation is running.
    @State private var isAnimating: Bool = false

    // MARK: View

    public var body: some View {
        Capsule()
            .frame(height: 6)
            .foregroundColor(.gray.opacity(0.15))
            .overlay(progress)
    }

    /// A capsule shape aligned inside the frame of the view containing it.
    ///
    /// If it is animating, the capsule will run from left to right and repeat forever.
    private var progress: some View {
        GeometryReader { (geometry: GeometryProxy) in
            Capsule()
                .foregroundColor(Color.accentColor)
                .frame(width: progressWidth(in: geometry))
                .offset(offset(in: geometry))
                .onAppear {
                    withAnimation(animation) {
                        isAnimating = true
                    }
                }
        }
    }

    /// A linear animation that repeats forever.
    private var animation: Animation? {
        .linear(duration: 1).repeatForever(autoreverses: false)
    }

    /// Returns the relative width of the progress in the container view.
    /// - Parameter geometry: A proxy for access to the size and coordinate space (for anchor resolution) of the container view.
    private func progressWidth(in geometry: GeometryProxy) -> CGFloat {
        geometry.size.width / 3
    }

    /// Returns the relative offset of the progress in the container view.
    /// - Parameter geometry: A proxy for access to the size and coordinate space (for anchor resolution) of the container view.
    private func offset(in geometry: GeometryProxy) -> CGSize {
        isAnimating
        ? CGSize(width: geometry.size.width, height: 0)
        : CGSize(width: -progressWidth(in: geometry), height: 0)
    }
}
