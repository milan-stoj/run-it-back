//
//  PlayerLibraryView.swift
//  Run It Back
//
//  Created on December 9, 2025.
//

import SwiftUI
import SwiftData

struct PlayerLibraryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query(filter: #Predicate<Player> { $0.isSaved == true }, sort: \Player.name) private var savedPlayers: [Player]
    
    @State private var searchText = ""
    @State private var showingAddPlayer = false
    @State private var selectedPlayer: Player?
    @State private var showingEditPlayer = false
    
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
                    playerListView
                }
            }
            .navigationTitle("Player Library")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundStyle(.primary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddPlayer = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(.tint)
                            .font(.title2)
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search players")
            .sheet(isPresented: $showingAddPlayer) {
                EditPlayerView(player: nil, mode: .add)
            }
            .sheet(item: $selectedPlayer) { player in
                EditPlayerView(player: player, mode: .edit)
            }
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
            
            Text("Add players to your library to quickly add them to games")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button {
                showingAddPlayer = true
            } label: {
                Label("Add Player", systemImage: "plus")
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .padding()
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(12)
            }
            .padding(.top, 10)
        }
    }
    
    private var playerListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(filteredPlayers) { player in
                    PlayerLibraryCard(player: player)
                        .onTapGesture {
                            selectedPlayer = player
                            showingEditPlayer = true
                        }
                        .contextMenu {
                            Button {
                                selectedPlayer = player
                                showingEditPlayer = true
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            
                            Button(role: .destructive) {
                                deletePlayer(player)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
            .padding()
        }
    }
    
    private func deletePlayer(_ player: Player) {
        withAnimation {
            PlayerStore.deletePlayer(player, context: modelContext)
        }
    }
}

struct PlayerLibraryCard: View {
    let player: Player
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(player.name)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                    
                    Text(player.heightFormatted)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Grade")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text(player.gradeRating)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.tint)
                }
            }
            
            Divider()
                .background(Color.secondary.opacity(0.2))
            
            // Stats Grid
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                StatBadge(label: "Offense", value: player.offense)
                StatBadge(label: "Defense", value: player.defense)
                StatBadge(label: "Playmaking", value: player.playmaking)
                StatBadge(label: "Athleticism", value: player.athleticism)
                StatBadge(label: "Intangibles", value: player.intangibles)
                
                if player.heightBonus > 0 {
                    StatBadge(label: "Height Bonus", value: player.heightBonus, isBonus: true)
                }
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
        )
    }
}

struct StatBadge: View {
    let label: String
    let value: Int
    var isBonus: Bool = false
    
    var body: some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            Text("\(value)")
                .font(.headline)
                .foregroundStyle(isBonus ? .green : .primary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color(uiColor: .tertiarySystemBackground))
        .cornerRadius(8)
    }
}

#Preview {
    PlayerLibraryView()
        .modelContainer(for: Player.self, inMemory: true)
}
