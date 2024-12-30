# Notes App (MVVM-C)

A modern iOS notes application built with SwiftUI following the MVVM-C (Model-View-ViewModel-Coordinator) architecture pattern. This app demonstrates best practices in iOS development, including reactive programming, clean architecture, and modern SwiftUI features.

## Features

- 📝 Create, read, update, and delete notes
- 📌 Pin important notes to the top
- 🏷️ Categorize notes with predefined categories
- 🔖 Add custom tags to notes
- 🎨 Visual category indicators with icons and colors
- 📱 Modern iOS design following Apple's Human Interface Guidelines
- 💾 Persistent storage using UserDefaults

## Architecture

The app follows the MVVM-C (Model-View-ViewModel-Coordinator) architecture:

### Models
- `Note`: Core data model representing a note with properties like title, content, category, tags, and pin status

### Views
- `NotesListView`: Main view displaying all notes with pinned section
- `NoteDetailView`: View for creating and editing notes
- `NoteRowView`: Reusable component for note preview in the list
- `TagsView`: Component for managing note tags

### ViewModels
- `NotesListViewModel`: Manages the list of notes and filtering
- `NoteDetailViewModel`: Handles note creation and editing logic

### Coordinator
- `MainCoordinator`: Manages navigation flow between views

### Services
- `NotesStorage`: Handles data persistence using UserDefaults

## Project Structure
