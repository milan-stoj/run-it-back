//
//  PlayerCustomizationView.swift
//  Run It Back
//
//  Created on December 9, 2025.
//

import SwiftUI

struct PlayerCustomizationView: View {
    @Binding var name: String
    @Binding var offense: Int
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
        offense + defense + playmaking + athleticism + intangibles + heightBonus
    }
    
    var gradeRating: String {
        switch totalRating {
        case 28...Int.max:
            return "A+"
        case 26...27:
            return "A"
        case 24...25:
            return "A-"
        case 22...23:
            return "B+"
        case 20...21:
            return "B"
        case 18...19:
            return "B-"
        case 16...17:
            return "C+"
        case 14...15:
            return "C"
        case 12...13:
            return "C-"
        case 10...11:
            return "D+"
        case 8...9:
            return "D"
        case 6...7:
            return "D-"
        default:
            return "F"
        }
    }
    
    var body: some View {
        VStack(spacing: 24) {
            // Name Input
            if showNameField {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Player Name")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    TextField("Enter name", text: $name)
                        .textFieldStyle(.plain)
                        .padding()
                        .background(Color(uiColor: .secondarySystemBackground))
                        .cornerRadius(8)
                        .foregroundStyle(.primary)
                        .autocapitalization(.words)
                }
            }
            
            // Total Rating Display
            if showTotalRating {
                VStack(spacing: 8) {
                    Text("Overall Grade")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Text(gradeRating)
                        .font(.system(size: 48, weight: .bold))
                        .foregroundStyle(.tint)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(12)
            }
            
            // Stats Section
            VStack(alignment: .leading, spacing: 16) {
                Text("Player Stats")
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                StatSlider(label: "Offense", value: $offense)
                StatSlider(label: "Defense", value: $defense)
                StatSlider(label: "Playmaking", value: $playmaking)
                StatSlider(label: "Athleticism", value: $athleticism)
                StatSlider(label: "Intangibles", value: $intangibles)
            }
            
            // Height Section
            VStack(alignment: .leading, spacing: 12) {
                Text("Height")
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                HStack(spacing: 20) {
                    VStack {
                        Text("Feet")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
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
                            .foregroundStyle(.secondary)
                        
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
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(12)
                
                if heightBonus > 0 {
                    HStack {
                        Image(systemName: "arrow.up.circle.fill")
                            .foregroundStyle(.green)
                        Text("Height Bonus: +\(heightBonus)")
                            .font(.subheadline)
                            .foregroundStyle(.green)
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
                    .foregroundStyle(.primary)
                
                Spacer()
                
                Text("\(value)")
                    .font(.headline)
                    .foregroundStyle(.tint)
                    .frame(width: 30)
            }
            
            Slider(value: Binding(
                get: { Double(value) },
                set: { value = Int($0) }
            ), in: 1...5, step: 1)
            .tint(.cyan)
        }
        .padding()
        .background(Color(uiColor: .tertiarySystemBackground))
        .cornerRadius(8)
    }
}

#Preview {
    ZStack {
        Color(uiColor: .systemBackground).ignoresSafeArea()
        
        ScrollView {
            PlayerCustomizationView(
                name: .constant("Test Player"),
                offense: .constant(3),
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

