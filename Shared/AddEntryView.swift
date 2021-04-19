//
//  AddEntryView.swift
//  PocketWallet
//
//  Created by Ashli Rankin on 4/18/21.
//

import SwiftUI
import CoreData

struct AddEntryView: View {
    
    @State private var alertIsPresented: Bool = false
    
    @State private var entryData: [Entry] = []
    
    @ObservedObject private var viewModel = ViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(entryData) { _ in
                    AddEntrySectionView(viewModel: viewModel)
                    Button(action: {
                        print("Tapped")
                    }, label: {
                        Text("Add")
                            .foregroundColor(.white)
                    })
                    .frame(width: 120, height: 44, alignment: .center)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 12.0))
                }
            }
            .listStyle(GroupedListStyle())
            .navigationTitle(Text("Month Budgget"))
            .navigationBarItems(trailing: Button(action: {
                alertIsPresented = true
            }, label: {
                Image(systemName: "plus")
            })
            .actionSheet(isPresented: $alertIsPresented) {
                ActionSheet(title: Text("Add Budget Section"), message: Text("What section would you like to add?"), buttons: [
                    .default(Text("Expense")) {
                        entryData.append(viewModel.addRow(type: "Expense"))
                    },
                    .default(Text("Income")) {
                        entryData.append(viewModel.addRow(type: "Income"))
                    },
                    .cancel()
                ])
            })
        }
    }
}

struct AddEntrySectionView: View {
    
    @StateObject var viewModel: ViewModel
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Category")
                Picker("", selection: $viewModel.selectedCategory) {
                    ForEach(viewModel.categories, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(DefaultPickerStyle())
            }
            
            HStack {
                Text("Date")
                Spacer()
                DatePicker(selection: $viewModel.selectedDate, in: ...Date(), displayedComponents: .date) {
                    Text("")
                }
            }
            
            HStack(alignment: .center, spacing: 24) {
                Text("Title")
                Spacer()
                TextField("Enter Description", text: $viewModel.entryDescription)
                    .multilineTextAlignment(.trailing)
            }
            
            HStack {
                Text("Amount")
                Spacer()
                TextField("Enter cost", text: $viewModel.cost)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
        }
    }
}

struct AddEntryView_Previews: PreviewProvider {
    static var previews: some View {
        AddEntryView()
    }
}

class ViewModel: ObservableObject {
    
    @Published var entryDescription: String = ""
    
    @Published var cost: String = ""
    
    @Published var selectedCategory = "Personal"
    
    @Published var selectedDate = Date()
    
    let categories = ["Health/Medical", "Car Insurance", "Subscriptions", "Personal", "Utilities", "Food", "Gifts", "Home", "Gas", "Pets", "Travel", "Debt", "Other"]
    
    private var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    func addRow(type: String) -> Entry {
        let entry = Entry(context: managedObjectContext)
        entry.amount = .zero
        entry.type = type
        entry.entryDescription = nil
        entry.date = Date()
        entry.category = nil
        entry.identifier = UUID()
        entry.monthDescription = nil
        return entry
    }
}
