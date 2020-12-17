//
//  RowView.swift
//  BillSplit
//
//  Created by Matheus Oliveira Costa on 17/12/20.
//

import SwiftUI

struct RowView: View {
    @Environment(\.editMode) var editMode

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Hello, World!")
                    .font(.headline)
                Text("Matheus")
                    .font(.caption)
            }
            Spacer()
            Text("R$ 12,00")
            if editMode?.wrappedValue == .active {
                Button(action: {}, label: {
                    Image(systemName: "xmark.circle.fill")
                        .imageScale(.large)
                        .foregroundColor(Color(.systemRed))
                })
                .padding(.leading)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
    }
}

struct RowView_Previews: PreviewProvider {
    static var previews: some View {
        RowView()
            .previewLayout(.sizeThatFits)
        RowView()
            .previewLayout(.sizeThatFits)
            .environment(\.editMode, .constant(.active))
    }
}
