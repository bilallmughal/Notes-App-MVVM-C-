//
//  ContentView.swift
//  Notes MVVM-C
//
//  Created by Muhammad Bilal on 30/12/2024.
//

import SwiftUI

class MainCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    
    enum Route: Hashable {
        case notesList
        case noteDetail(Note?)
    }
    
    @ViewBuilder
    func start() -> some View {
        NavigationStack(path: Binding(
            get: { self.path },
            set: { self.path = $0 }
        )) {
            NotesListView(viewModel: NotesListViewModel())
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .notesList:
                        NotesListView(viewModel: NotesListViewModel())
                    case .noteDetail(let note):
                        NoteDetailView(viewModel: NoteDetailViewModel(note: note))
                    }
                }
        }
    }
    
    func navigateToDetail(note: Note?) {
        path.append(Route.noteDetail(note))
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func navigateBack() {
        path.removeLast()
    }
} 
