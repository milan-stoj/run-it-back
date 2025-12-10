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
                Color.black.ignoresSafeArea()
                
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
                    .foregroundColor(.white)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddPlayer = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.cyan)
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
                .foregroundColor(.gray)
            
            Text("No Saved Players")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("Add players to your library to quickly add them to games")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button {
                showingAddPlayer = true
            } label: {
                Label("Add Player", systemImage: "plus")
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding()
                    .background(Color.cyan)
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
                        .foregroundColor(.white)
                    
                    Text(player.heightFormatted)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Total Rating")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text("\(player.totalRating)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.cyan)
                }
            }
            
            Divider()
                .background(Color.white.opacity(0.2))
            
            // Stats Grid
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                StatBadge(label: "Scoring", value: player.scoring)
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
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
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
                .foregroundColor(.gray)
            
            Text("\(value)")
                .font(.headline)
                .foregroundColor(isBonus ? .green : .white)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color.white.opacity(0.05))
        .cornerRadius(8)
    }
}

#Preview {
    PlayerLibraryView()
        .modelContainer(for: Player.self, inMemory: true)
}
