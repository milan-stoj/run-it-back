//
//  CreateGameView.swift
//  Run It Back
//
//  Created on December 9, 2025.
//

import SwiftUI

struct LabeledField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.primary)
            TextField("", text: $text, prompt: Text(placeholder).foregroundStyle(.secondary))
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                .foregroundStyle(.primary)
                .overlay(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                )
        }
    }
}

struct LabeledDatePicker: View {
    let title: String
    @Binding var date: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.primary)
            DatePicker(
                selection: $date,
                displayedComponents: [.date, .hourAndMinute]
            ) {
                EmptyView()
            }
            .datePickerStyle(.compact)
            .tint(.accentColor)
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
            )
        }
    }
}

struct GameTypePicker: View {
    @Binding var selected: GameType

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Game Type")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.primary)

            HStack(spacing: 12) {
                ForEach(GameType.allCases, id: \.self) { type in
                    GameTypeButton(type: type, isSelected: selected == type) {
                        selected = type
                    }
                }
            }
        }
    }
}

struct GameTypeButton: View {
    let type: GameType
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(type.rawValue)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(isSelected ? .white : .primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(isSelected ? Color.accentColor : Color(UIColor.secondarySystemBackground))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                )
        }
    }
}

struct CreateGameView: View {
    @Environment(\.dismiss) var dismiss
    @State private var gameState = GameState()
    @State private var navigationDestination: NavigationDestination?
    @State private var showAlert = false
    
    enum NavigationDestination: String, Identifiable, Hashable {
        case addPlayers
        var id: String { rawValue }
    }
    
    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Court Name
                    LabeledField(title: "Court / Gym Name", placeholder: "e.g., Central Park Court", text: $gameState.courtName)
                    
                    // Location
                    LabeledField(title: "Location", placeholder: "e.g., Manhattan, NY", text: $gameState.location)
                    
                    // Date Picker
                    LabeledDatePicker(title: "Date & Time", date: $gameState.date)
                    
                    // Game Type
                    GameTypePicker(selected: $gameState.gameType)
                    
                    // Continue Button
                    Button(action: {
                        if gameState.isValid {
                            navigationDestination = .addPlayers
                        } else {
                            showAlert = true
                        }
                    }) {
                        Text("Continue to Add Players")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.accentColor)
                            .shadow(color: Color.accentColor.opacity(0.25), radius: 8, x: 0, y: 4)
                            .cornerRadius(8)
                    }
                    .padding(.top, 8)
                }
                .padding(24)
                .tint(.accentColor)
            }
        }
        .navigationTitle("Create Game")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color(.systemBackground), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationDestination(item: $navigationDestination) { destination in
            switch destination {
            case .addPlayers:
                AddPlayersView(gameState: gameState)
            }
        }
        .alert("Missing Information", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Please fill in all fields")
        }
    }
}

#Preview {
    NavigationStack {
        CreateGameView()
    }
}
