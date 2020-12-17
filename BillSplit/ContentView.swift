//
//  ContentView.swift
//  BillSplit
//
//  Created by Matheus Oliveira Costa on 17/12/20.
//

import SwiftUI

private struct CloseBillButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: self.action) {
            HStack {
                Spacer()
                Text("Fechar conta")
                    .font(.headline)
                Spacer()
            }
        }
        .buttonStyle(RoundedButtonStyle())
    }
}

private struct AddItemButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: self.action) {
            HStack {
                Image(systemName: "plus")
                    .imageScale(.large)
                    .font(.headline)
                Text("Adicionar")
                    .font(.headline)
            }
        }
        .buttonStyle(RoundedButtonStyle(cornerRadius: 25))
    }
}

struct ContentView: View {
    @State var addFormIsPresented = false

    var body: some View {
        NavigationView {
            GeometryReader { (geometry) in
                ZStack(alignment: .bottomTrailing) {
                    ScrollView {
                        LazyVStack {
                            RowView()
                            RowView()

                            Spacer(minLength: 16)
                            CloseBillButton(action: {})
                        }
                        .padding()
                    }

                    AddItemButton(action: { self.addFormIsPresented = true })
                        .padding(.trailing)
                        .padding(.bottom, geometry.safeAreaInsets.bottom + 16)
                        .sheet(isPresented: $addFormIsPresented, content: {
                            CreateItemView(isPresented: $addFormIsPresented)
                        })
                }
                .background(Color(.systemGray6).opacity(0.8))
                .edgesIgnoringSafeArea(.bottom)
                .navigationTitle("Conta")
                .navigationBarItems(trailing: EditButton())
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
