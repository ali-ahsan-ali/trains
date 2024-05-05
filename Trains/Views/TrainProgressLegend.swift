//
//  TrainProgressLegend.swift
//  Trains
//
//  Created by Ali Ali on 27/2/2024.
//

import SwiftUI

struct TrainProgressLegend: View {
    @State private var legendSize: CGSize = .zero
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            HStack {
                Rectangle()
                    .frame(width: legendSize.height, height: legendSize.height)
                    .foregroundStyle(.green)
                Text("10+ minutes")
                    .font(.caption)
                    .background( 
                        GeometryReader { geo in
                            Color.clear
                                .onAppear {
                                    legendSize = geo.size
                                }
                        }
                    )
            }
            HStack {
                Rectangle()
                    .frame(width: legendSize.height, height: legendSize.height)
                    .foregroundStyle(Color(hex: "#67B7D1"))
                Text("10 minutes")
                    .font(.caption)
                    .background(
                        GeometryReader { geo in
                            Color.clear
                                .onAppear {
                                    legendSize = geo.size
                                }
                        }
                    )
            }
            HStack {
                Rectangle()
                    .frame(width: legendSize.height, height: legendSize.height)
                    .foregroundStyle(.orange)
                Text("1 minute")
                    .font(.caption)
                    .background(
                        GeometryReader { geo in
                            Color.clear
                                .onAppear {
                                    legendSize = geo.size
                                }
                        }
                    )
            }
            HStack {
                Rectangle()
                    .frame(width: legendSize.height, height: legendSize.height)
                    .foregroundStyle(.red)
                Text("Departed")
                    .font(.caption)
                    .background(
                        GeometryReader { geo in
                            Color.clear
                                .onAppear {
                                    legendSize = geo.size
                                }
                        }
                    )
            }
        }
    }
}

#Preview {
    TrainProgressLegend()
}
