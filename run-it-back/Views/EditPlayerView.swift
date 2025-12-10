//
//  EditPlayerView.swift
//  Run It Back
//
//  Created on December 9, 2025.
//

import SwiftUI
import SwiftData

enum EditPlayerMode {
    case add
    case edit
}

struct EditPlayerView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    let player: Player?
    let mode: EditPlayerMode
    
    @State private var name: String = ""
    @State private var offense: Int = 3
    @State private var defense: Int = 3
    @State private var playmaking: Int = 3
    @State private var athleticism: Int = 3
    @State private var intangibles: Int = 3
    @State private var heightFeet: Int = 6
    @State private var heightInches: Int = 0
    
    @State private var showingError = false
    @State private var errorMessage = ""
    
    var totalHeight: Int {
        heightFeet * 12 + heightInches
    }
    
    var heightBonus: Int {
        max(0, (totalHeight - 72) / 3)
    }
    
    var totalRating: Int {
        offense + defense + playmaking + athleticism + intangibles + heightBonus
    }
    
    init(player: Player?, mode: EditPlayerMode) {
        self.player = player
        self.mode = mode
        
        if let player = player {
            _name = State(initialValue: player.name)
            _offense = State(initialValue: player.offense)
            _defense = State(initialValue: player.defense)
            _playmaking = State(initialValue: player.playmaking)
            _athleticism = State(initialValue: player.athleticism)
            _intangibles = State(initialValue: player.intangibles)
            _heightFeet = State(initialValue: player.height / 12)
            _heightInches = State(initialValue: player.height % 12)
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        PlayerCustomizationView(
                            name: $name,
                            offense: $offense,
                            defense: $defense,
                            playmaking: $playmaking,
                            athleticism: $athleticism,
                            intangibles: $intangibles,
                            heightFeet: $heightFeet,
                            heightInches: $heightInches,
                            showNameField: true,
                            showTotalRating: true
                        )
                        
                        // Save Button
                        Button {
                            savePlayer()
                        } label: {
                            Text(mode == .add ? "Add to Library" : "Save Changes")
                                .font(.headline)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(name.trimmingCharacters(in: .whitespaces).isEmpty ? Color.gray : Color.cyan)
                                .cornerRadius(12)
                        }
                        .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                        .padding(.top)
                    }
                    .padding()
                }
            }
            .navigationTitle(mode == .add ? "Add Player" : "Edit Player")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
            .alert("Error", isPresented: $showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func savePlayer() {
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        
        guard !trimmedName.isEmpty else {
            errorMessage = "Please enter a player name"
            showingError = true
            return
        }
        
        if mode == .add {
            let newPlayer = Player(
                name: trimmedName,
                offense: offense,
                defense: defense,
                playmaking: playmaking,
                athleticism: athleticism,
                intangibles: intangibles,
                height: totalHeight,
                isSaved: true
            )
            PlayerStore.savePlayer(newPlayer, context: modelContext)
        } else if let player = player {
            player.name = trimmedName
            player.offense = offense
            player.defense = defense
            player.playmaking = playmaking
            player.athleticism = athleticism
            player.intangibles = intangibles
            player.height = totalHeight
            PlayerStore.updatePlayer(player, context: modelContext)
        }
        
        dismiss()
    }
}

#Preview {
    EditPlayerView(player: nil, mode: .add)
        .modelContainer(for: Player.self, inMemory: true)
}
