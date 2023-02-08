//
//  ContentView.swift
//  coincidencia tracker
//
//  Created by Filipe Cruz on 08/02/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        NavigationView {

            VStack{
                NavigationLink(destination: CoincidenciaReporter()                .environment(\.managedObjectContext, viewContext)
){
                        Text("Será?? Vejamos!")
                            .foregroundColor(.white)
                    
                }

                Text(" ")
                    .frame(width: 12, height: 50)
                Button(action: {
                    addItem(type: .hour)
                }) {
                    Text("Hora Igual")
                        .frame(width: 200, height: 200)
                        .foregroundColor(Color.black)
                        .background(Color.brown.opacity(0.5))
                        .clipShape(Circle())
                }
                Text(" ")
                    .frame(width: 12, height: 100)
                Button(action: {
                    addItem(type: .bike)
                }) {
                    Text("Cruzamento na ciclovia")
                        .frame(width: 200, height: 200)
                        .foregroundColor(Color.black)
                        .background(Color.cyan.opacity(0.5))
                        .clipShape(Circle())
                }
            }
        }.navigationTitle("")
    }

    private func addItem(type: PersistenceController.CoincidenciaType) {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            switch type {
            case .bike:
                newItem.type = 0
            case .hour:
                newItem.type = 1
            }
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
