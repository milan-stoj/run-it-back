//
//  PlayerLibrarySelectionView.swift
//  Run It Back
//
//  Created on December 9, 2025.
//

import SwiftUI
import SwiftData

struct PlayerLibrarySelectionView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query(filter: #Predicate<Player> { $0.isSaved == true }, sort: \Player.name) private var savedPlayers: [Player]
    
    @Binding var players: [Player]
    @State private var selectedPlayerIDs: Set<UUID> = []
    @State private var searchText = ""
    
    var filteredPlayers: [Player] {
        if searchText.isEmpty {
            return savedPlayers
        } else {
            return savedPlayers.filter { $0.name.localizedStandardContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(uiColor: .systemBackground).ignoresSafeArea()
                
                if savedPlayers.isEmpty {
                    emptyStateView
                } else {
                    playerSelectionView
                }
            }
            .navigationTitle("Select Players")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(.primary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add (\(selectedPlayerIDs.count))") {
                        addSelectedPlayers()
                    }
                    .tint(.accentColor)
                    .disabled(selectedPlayerIDs.isEmpty)
                }
            }
            .searchable(text: $searchText, prompt: "Search players")
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.2.slash")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)
            
            Text("No Saved Players")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
            
            Text("Add players to your library first to import them")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
    
    private var playerSelectionView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(filteredPlayers) { player in
                    SelectablePlayerCard(
                        player: player,
                        isSelected: selectedPlayerIDs.contains(player.id)
                    )
                    .onTapGesture {
                        toggleSelection(for: player)
                    }
                }
            }
            .padding()
        }
    }
    
    private func toggleSelection(for player: Player) {
        if selectedPlayerIDs.contains(player.id) {
            selectedPlayerIDs.remove(player.id)
        } else {
            selectedPlayerIDs.insert(player.id)
        }
    }
    
    private func addSelectedPlayers() {
        for savedPlayer in savedPlayers where selectedPlayerIDs.contains(savedPlayer.id) {
            // Create a game copy (not saved to library)
            let gameCopy = PlayerStore.createGameCopy(of: savedPlayer)
            players.append(gameCopy)
        }
        dismiss()
    }
}

struct SelectablePlayerCard: View {
    let player: Player
    let isSelected: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            // Selection indicator
            ZStack {
                Circle()
                    .strokeBorder(isSelected ? Color.accentColor : Color.secondary.opacity(0.3), lineWidth: 2)
                    .frame(width: 28, height: 28)
                
                if isSelected {
                    Circle()
                        .fill(Color.accentColor)
                        .frame(width: 16, height: 16)
                }
            }
            
            // Player info
            VStack(alignment: .leading, spacing: 4) {
                Text(player.name)
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                HStack(spacing: 12) {
                    Text(player.heightFormatted)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Text("•")
                        .foregroundStyle(.secondary)
                    
                    Text("Grade: \(player.gradeRating)")
                        .font(.subheadline)
                        .foregroundStyle(.tint)
                }
            }
            
            Spacer()
            
            // Grade badge
            Text(player.gradeRating)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
                .frame(width: 50, height: 50)
                .background(Color.accentColor.opacity(0.15))
                .cornerRadius(8)
        }
        .padding()
        .background(isSelected ? Color.accentColor.opacity(0.1) : Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.accentColor : Color.secondary.opacity(0.2), lineWidth: isSelected ? 2 : 1)
        )
    }
}

#Preview {
    PlayerLibrarySelectionView(players: .constant([]))
        .modelContainer(for: Player.self, inMemory: true)
}

