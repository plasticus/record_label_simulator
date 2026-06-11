#!/usr/bin/env kotlin
import kotlin.random.Random

class SongNameGenerator {

    // Pulling direct samples from the 'Future Country Song Generator Word Bank' spreadsheet columns
    private val techModifiers = arrayOf("Bio", "Neon", "Synth", "Nano", "Cyber", "Quantum", "Laser", "Holo", "Plasma", "Glitch", "Neural", "Vector", "Sonic", "Atomic", "Kinetic", "Static")
    private val emotionalActions = arrayOf("Crying", "Longing", "Drinking", "Leaving", "Ridin'", "Prayin'", "Cheatin'", "Dyin'", "Lovin'", "Missin'", "Workin'", "Bleedin'", "Searchin'", "Dreamin'")
    private val classicTropes = arrayOf("Truck", "Train", "Mama", "Heartbreak", "Dog", "Rain", "Boot", "Beer", "Whiskey", "Dirt", "Tailgate", "Guitar", "Porch", "Road", "River", "Hound")
    private val cyberSlang = arrayOf("Glitch", "Chrome", "Grid", "Proxy", "Static", "Neural", "Buffer", "Vector", "Sprawl", "Ping", "Synth", "Node", "Bit", "Net", "Port", "Code")
    private val ruralNouns = arrayOf("Dirt", "Whiskey", "Tailgate", "Guitar", "Porch", "Road", "River", "Hound", "Field", "Crops", "Harvest", "Tractor", "Barn", "Cattle", "Pasture")
    private val futuristicPlaces = arrayOf("Dome", "Megacity", "Outpost", "Sector", "Canyon", "Colony", "Station", "Crater", "Hab", "Bunker", "Spire", "Ring", "Waste", "Vault")

    /**
     * Generates a completely randomized future-country song title
     * by structurally combining the database matrices.
     */
    fun generateSongTitle(): String {
        val random = Random.Default

        val tech = techModifiers[random.nextInt(techModifiers.size)]
        val action = emotionalActions[random.nextInt(emotionalActions.size)]
        val trope = classicTropes[random.nextInt(classicTropes.size)]
        val slang = cyberSlang[random.nextInt(cyberSlang.size)]
        val noun = ruralNouns[random.nextInt(ruralNouns.size)]
        val place = futuristicPlaces[random.nextInt(futuristicPlaces.size)]

        // Synthesizing various structural formula archetypes for maximum aesthetic variance
        return when (random.nextInt(4)) {
            0 -> "$tech-$trope $slang"            // e.g., "Bio-Truck Grid"
            1 -> "$action in the $tech $place"    // e.g., "Crying in the Quantum Sector"
            2 -> "$slang $noun Blues"             // e.g., "Chrome Tractor Blues"
            3 -> "My $tech $trope Got a $slang"   // e.g., "My Neon Dog Got a Glitch"
            else -> "$tech $noun of $action"
        }
    }
}
// Line below: // End of SongNameGenerator class
