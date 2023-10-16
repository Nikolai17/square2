//
//  ContentView.swift
//  Square
//
//  Created by Nikolay Volnikov on 12.10.2023.
//
//
//  ContentView.swift
//  SlenderRow
//
//  Created by Сергей Прокопьев on 16.10.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var isTapped = false
    @State var countRectangle: Int = 7

    var layout: any Layout {
        isTapped ? DiagonalLayout() : HorisontalLayout()
    }

    var body: some View {
        NavigationStack {
            AnyLayout(layout) {
                ForEach(0..<countRectangle, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.blue)
                        .onTapGesture {
                            withAnimation {
                                isTapped.toggle()
                            }
                        }
                }
                .onChange(of: countRectangle) { newValue in
                    print("\(countRectangle)")
                }
            }
            .navigationTitle("sui make my cry")
            .toolbar {
                Stepper("rectangles = \(countRectangle)", value: $countRectangle)
            }

        }


    }
}

// MARK: - Layouts

struct HorisontalLayout: Layout {
    struct Cache {
        var sizes: [CGSize] = []
    }

    func makeCache(subviews: Subviews) -> Cache {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        return Cache(sizes: sizes)
    }

    func updateCache(_ cache: inout Cache, subviews: Subviews) {
        cache.sizes = subviews.map { $0.sizeThatFits(.unspecified) }
    }

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews, cache: inout Cache
    ) -> CGSize {
        return proposal.replacingUnspecifiedDimensions()
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Cache
    ) {
        let width = proposal.replacingUnspecifiedDimensions().width
        let viewsCount = CGFloat(subviews.count)
        let spacingSum = 8.0 * (viewsCount - 1)
        let viewWidth = (width - spacingSum) / viewsCount
        let viewSize = CGSize(width: viewWidth, height: viewWidth)
        var currentX = bounds.minX + viewWidth / 2

        subviews.forEach({ subview in
            let position = CGPoint(x: currentX, y: bounds.midY)
            subview.place(
                at: position,
                anchor: .center,
                proposal: ProposedViewSize(viewSize)
            )
            currentX += viewWidth + spacingSum / (viewsCount - 1)
        })
    }
}

struct DiagonalLayout: Layout {

    struct Cache {
        var sizes: [CGSize] = []
    }

    func makeCache(subviews: Subviews) -> Cache {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        return Cache(sizes: sizes)
    }

    func updateCache(_ cache: inout Cache, subviews: Subviews) {
        cache.sizes = subviews.map { $0.sizeThatFits(.unspecified) }
    }

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews, cache: inout Cache
    ) -> CGSize {
        return proposal.replacingUnspecifiedDimensions()
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Cache
    ) {
        let width = proposal.replacingUnspecifiedDimensions().width
        let height = proposal.replacingUnspecifiedDimensions().height
        let viewsCount = CGFloat(subviews.count)
        let viewHeight = height / viewsCount
        let viewSize = CGSize(width: viewHeight, height: viewHeight)
        var currentY = bounds.maxY
        var currentX = bounds.minX

        subviews.forEach({ subview in
            let position = CGPoint(x: currentX, y: currentY)
            subview.place(
                at: position,
                anchor: .bottomLeading,
                proposal: ProposedViewSize(viewSize)
            )
            currentY -= viewHeight
            currentX += (width - viewHeight) / (viewsCount - 1)
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
