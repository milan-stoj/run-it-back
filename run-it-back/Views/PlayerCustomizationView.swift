//
//  PlayerCustomizationView.swift
//  Run It Back
//
//  Created on December 9, 2025.
//

import SwiftUI

struct PlayerCustomizationView: View {
    @Binding var name: String
    @Binding var scoring: Int
    @Binding var defense: Int
    @Binding var playmaking: Int
    @Binding var athleticism: Int
    @Binding var intangibles: Int
    @Binding var heightFeet: Int
    @Binding var heightInches: Int
    
    var showNameField: Bool = true
    var showTotalRating: Bool = true
    
    var totalHeight: Int {
        heightFeet * 12 + heightInches
    }
    
    var heightBonus: Int {
        max(0, (totalHeight - 72) / 3)
    }
    
    var totalRating: Int {
        scoring + defense + playmaking + athleticism + intangibles + heightBonus
    }
    
    var body: some View {
        VStack(spacing: 24) {
            // Name Input
            if showNameField {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Player Name")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    TextField("Enter name", text: $name)
                        .textFieldStyle(.plain)
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(8)
                        .foregroundColor(.white)
                        .autocapitalization(.words)
                }
            }
            
            // Total Rating Display
            if showTotalRating {
                VStack(spacing: 8) {
                    Text("Total Rating")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text("\(totalRating)")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.cyan)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white.opacity(0.05))
                .cornerRadius(12)
            }
            
            // Stats Section
            VStack(alignment: .leading, spacing: 16) {
                Text("Player Stats")
                    .font(.headline)
                    .foregroundColor(.white)
                
                StatSlider(label: "Scoring", value: $scoring)
                StatSlider(label: "Defense", value: $defense)
                StatSlider(label: "Playmaking", value: $playmaking)
                StatSlider(label: "Athleticism", value: $athleticism)
                StatSlider(label: "Intangibles", value: $intangibles)
            }
            
            // Height Section
            VStack(alignment: .leading, spacing: 12) {
                Text("Height")
                    .font(.headline)
                    .foregroundColor(.white)
                
                HStack(spacing: 20) {
                    VStack {
                        Text("Feet")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Picker("Feet", selection: $heightFeet) {
                            ForEach(4...7, id: \.self) { feet in
                                Text("\(feet)'").tag(feet)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(height: 120)
                    }
                    
                    VStack {
                        Text("Inches")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Picker("Inches", selection: $heightInches) {
                            ForEach(0...11, id: \.self) { inches in
                                Text("\(inches)\"").tag(inches)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(height: 120)
                    }
                }
                .padding()
                .background(Color.white.opacity(0.05))
                .cornerRadius(12)
                
                if heightBonus > 0 {
                    HStack {
                        Image(systemName: "arrow.up.circle.fill")
                            .foregroundColor(.green)
                        Text("Height Bonus: +\(heightBonus)")
                            .font(.subheadline)
                            .foregroundColor(.green)
                    }
                }
            }
        }
    }
}

struct StatSlider: View {
    let label: String
    @Binding var value: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(label)
                    .font(.subheadline)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("\(value)")
                    .font(.headline)
                    .foregroundColor(.cyan)
                    .frame(width: 30)
            }
            
            Slider(value: Binding(
                get: { Double(value) },
                set: { value = Int($0) }
            ), in: 1...5, step: 1)
            .tint(.cyan)
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(8)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        
        ScrollView {
            PlayerCustomizationView(
                name: .constant("Test Player"),
                scoring: .constant(3),
                defense: .constant(3),
                playmaking: .constant(3),
                athleticism: .constant(3),
                intangibles: .constant(3),
                heightFeet: .constant(6),
                heightInches: .constant(0)
            )
            .padding()
        }
    }
}
