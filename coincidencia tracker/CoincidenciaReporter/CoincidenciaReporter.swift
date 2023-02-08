//
//  CoincidenciaReporter.swift
//  coincidencia tracker
//
//  Created by Filipe Cruz on 08/02/23.
//

import SwiftUI

struct CoincidenciaReporter: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var backButton : some View { Button(action: {
        self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
            Image(systemName: "chevron.left") // BackButton Image
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.white)
            }
        }
    }
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text(
                    getStatistics()
                )
                .multilineTextAlignment(.center)
                .frame(alignment: .center)
                .foregroundColor(.white)
                List {
                    ForEach(items) { item in
                        Text("Coincidencia do tipo \(typeCoincidencia(item.type)) em \(item.timestamp!, formatter: itemFormatter)")
                    }                .onDelete(perform: deleteItems)
                    
                }
            }
            
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
    }
    
    private func getStatistics() -> String {
        let horas = items.filter { item in
            item.type == 1
        }.count
        
        let bikes = items.filter { item in
            item.type == 0
        }.count
        
        return "Ocorreram \(horas) coincidencia de horas e \(bikes) coincidencia de bikes desde o último reporte"
    }
    
    private func typeCoincidencia(_ typeC: Double) -> String {
        return typeC == 0 ? "bike": "hora"
    }
    
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "pt-br")
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter
    }()
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct CoincidenciaReporter_Previews: PreviewProvider {
    static var previews: some View {
        CoincidenciaReporter().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
