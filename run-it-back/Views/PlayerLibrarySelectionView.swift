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
                Color.black.ignoresSafeArea()
                
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
                    .foregroundColor(.white)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add (\(selectedPlayerIDs.count))") {
                        addSelectedPlayers()
                    }
                    .foregroundColor(selectedPlayerIDs.isEmpty ? .gray : .cyan)
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
                .foregroundColor(.gray)
            
            Text("No Saved Players")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("Add players to your library first to import them")
                .font(.body)
                .foregroundColor(.gray)
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
                    .strokeBorder(isSelected ? Color.cyan : Color.white.opacity(0.3), lineWidth: 2)
                    .frame(width: 28, height: 28)
                
                if isSelected {
                    Circle()
                        .fill(Color.cyan)
                        .frame(width: 16, height: 16)
                }
            }
            
            // Player info
            VStack(alignment: .leading, spacing: 4) {
                Text(player.name)
                    .font(.headline)
                    .foregroundColor(.white)
                
                HStack(spacing: 12) {
                    Text(player.heightFormatted)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text("•")
                        .foregroundColor(.gray)
                    
                    Text("Rating: \(player.totalRating)")
                        .font(.subheadline)
                        .foregroundColor(.cyan)
                }
            }
            
            Spacer()
            
            // Total rating badge
            Text("\(player.totalRating)")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(Color.cyan.opacity(0.2))
                .cornerRadius(8)
        }
        .padding()
        .background(isSelected ? Color.cyan.opacity(0.1) : Color.white.opacity(0.05))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.cyan : Color.white.opacity(0.2), lineWidth: isSelected ? 2 : 1)
        )
    }
}

#Preview {
    PlayerLibrarySelectionView(players: .constant([]))
        .modelContainer(for: Player.self, inMemory: true)
}
