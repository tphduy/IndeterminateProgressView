// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

/// A view that shows the indeterminate progress toward the completion of a task.
public struct IndeterminateProgressView<Label>: View where Label: View {
    // MARK: States
    
    /// The completed amount of the animation, in a range of 0.0 to 1.
    @State private var progress: CGFloat = 0
    
    /// A view builder that creates a view that describes the task in progress.
    private var label: () -> Label
    
    /// The fixed height of of the indicator.
    private var indicatorHeight: CGFloat {
#if os(iOS)
        4
#elseif os(macOS)
        6
#elseif os(tvOS)
        10
#elseif os(visionOS)
        4
#else
        12
#endif
    }
    
    // MARK: Init
    
    /// Creates a progress view for showing indeterminate progress, without a label.
    public init() where Label == EmptyView {
        self.label = { EmptyView() }
    }
    
    /// Creates a progress view for showing indeterminate progress that displays a custom label.
    /// - Parameter label: A view builder that creates a view that describes the task in progress.
    public init(@ViewBuilder label: @escaping () -> Label) {
        self.label = label
    }
    
    /// Creates a progress view for showing indeterminate progress that generates its label from a localized string.
    /// - Parameter titleKey: The key for the progress view’s localized title that describes the task in progress.
    public init(_ titleKey: LocalizedStringKey) where Label == Text {
        self.label = { Text(titleKey) }
    }
    
    /// Creates a progress view for showing indeterminate progress that generates its label from a string.
    /// - Parameter title: A string that describes the task in progress.
    public init<S>(_ title: S) where Label == Text, S: StringProtocol {
        self.label = { Text(title) }
    }

    // MARK: View

    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            label()
            Capsule()
                .frame(height: indicatorHeight)
#if os(watchOS)
                .foregroundStyle(.tint.tertiary)
#elseif os(tvOS) || os(visionOS)
                .foregroundStyle(.tertiary)
#else
                .foregroundStyle(.quaternary)
#endif
                .overlay(indicator)
                .clipped()
        }
        .onAppear {
            withAnimation(
                .interpolatingSpring(duration: 1)
                .repeatForever()
            ) {
                progress = 1
            }
        }
    }

    /// A capsule shape aligned inside the frame of the view containing it.
    ///
    /// If it is animating, the capsule will run from left to right and repeat forever.
    private var indicator: some View {
        GeometryReader { (geometry: GeometryProxy) in
            Capsule()
                .foregroundStyle(.tint)
                .frame(width: indicatorWidth(in: geometry))
                .offset(offset(in: geometry))
        }
    }

    /// Returns the relative width of the indicator in the container view.
    /// - Parameter geometry: A proxy for access to the size and coordinate space (for anchor resolution) of the container view.
    private func indicatorWidth(in geometry: GeometryProxy) -> CGFloat {
        geometry.size.width / 3
    }

    /// Returns the relative offset of the indicator in the container view.
    /// - Parameter geometry: A proxy for access to the size and coordinate space (for anchor resolution) of the container view.
    private func offset(in geometry: GeometryProxy) -> CGSize {
        let indicatorWidth = indicatorWidth(in: geometry)
        let parentWidth = geometry.size.width * progress
        let lowerBound = -indicatorWidth * 0.9
        let upperBound = parentWidth * 0.95
        let width = lowerBound + progress * (upperBound - lowerBound)
        return CGSize(width: width, height: 0)
    }
}

@available(iOS 17.0, macCatalyst 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, watchOS 10.0, *)
#Preview {
    @Previewable @State var rotationDegrees: Double = 0
    
    VStack {
        IndeterminateProgressView()
        IndeterminateProgressView("Loading")
        IndeterminateProgressView {
            HStack {
                Text("Loading")
                Image(systemName: "gear")
                    .rotationEffect(.degrees(rotationDegrees))
                    .onAppear {
                        withAnimation(
                            .linear
                            .speed(0.1)
                            .repeatForever(autoreverses: false)
                        ) {
                            rotationDegrees = 360.0
                        }
                    }
            }
        }
    }
    .tint(.blue)
    .foregroundStyle(
        .linearGradient(
            colors: [.blue, .mint],
            startPoint: .leading,
            endPoint: .trailing
        )
    )
}
