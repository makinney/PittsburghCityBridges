//
//  ContentView.swift
//  PittsburghCityBridges
//  Created by MAKinney on 9/27/21.
//

import SwiftUI
import CoreData

struct CloudKitContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)], animation: .default) private var items: FetchedResults<Item>

    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \OpenDataServer.url, ascending: true)], animation: .default) private var openDataServers: FetchedResults<OpenDataServer>
    var body: some View {
        
        // Text("URL is \(openDataServers.first?.url ?? "not defined")")
            
        List {
            ForEach(openDataServers) { server in
                Text("URL is \(server.url ?? "nd")")
            }
        }
//        .onAppear {
//            addURL()
//        }
//        NavigationView {
//            List {
//                ForEach(openDataServers) { dataServer in
//                    NavigationLink {
//               //         Text("URL is \(dataServer.)")
//                    } label: {
//                        Text("Hello")
//                    }
//                }
//      //          .onDelete(perform: deleteItems)
//            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
//                ToolbarItem {
//                    Button(action: addURL) {
//                        Label("Add URL", systemImage: "plus")
//                    }
//                }
//            }
//            Text("Select an item")
//        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func addURL() {
        withAnimation {
            let newURL = OpenDataServer(context: viewContext)
            newURL.url = "another new url"

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }


    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct CloudKitContentView_Previews: PreviewProvider {
    static var previews: some View {
        CloudKitContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
