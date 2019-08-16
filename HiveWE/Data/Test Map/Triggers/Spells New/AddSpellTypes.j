scope AddSpellTypes initializer Init
    private function ApplySpellTypes takes nothing returns nothing
        call DestroyTimer(GetExpiredTimer())
		
		// Initialise playerAbilities
		set bj_forLoopAIndex = 0
		loop
			exitwhen bj_forLoopAIndex > 69
			set playerAbilities[bj_forLoopAIndex] = -1
			set bj_forLoopAIndex = bj_forLoopAIndex + 1
		endloop
		
		// Add all abilities
		set abilities[0] = 'A01J'	// Ultima
		set abilities[1] = 'A01M'	// Twilight
		set abilities[2] = 'A01O'	// Soul Drain
		set abilities[3] = 'A01N'	// Circle of Death
		set abilities[4] = 'A01Q'	// Wake of Fire
		set abilities[5] = 'A01T'	// Metallic Erruption
		set abilities[6] = 'A01V'	// Concentrated Energy
		set abilities[7] = 'A01X'	// THC Cloud
		set abilities[8] = 'A01Y'	// Deathblow
		set abilities[9] = 'A01Z'	// Siesmic Assualt
		set abilities[10] = 'A022'	// Rip Tide
		set abilities[11] = 'A023'	// Mega Flare
		set abilities[12] = 'A024'	// Mega Magic
		set abilities[13] = 'A025'	// Super Hex
		set abilities[14] = 'A027'	// Psychic Sightnings
		set abilities[15] = 'A029'	// Lit Fury
		set abilities[16] = 'A02B'	// Auto Heal
		set abilities[17] = 'A02I'	// Hyper Heal
		set abilities[18] = 'A02L'	// Ice Quake
		set abilities[19] = 'A02Q'	// Sun Storm
		set abilities[20] = 'A02P'	// Summon - Basic Elemental 	
		set abilities[21] = 'A06X'	// Summon - Lightning Lizard 	
		set abilities[22] = 'A06Y'	// Summon - Steam Being 		
		set abilities[23] = 'A070'	// Summon - Evil Tree 			
		set abilities[24] = 'A074'	// Summon - Gold Lizard 		
		set abilities[25] = 'A071'	// Summon - Ground Charger 		
		set abilities[26] = 'A06Z'	// Summon - Hippy 				
		set abilities[27] = 'A075'	// Summon - Lava Runner 		
		set abilities[28] = 'A079'	// Summon - Lesser Alien 		
		set abilities[29] = 'A076'	// Summon - Molten Machine 		
		set abilities[30] = 'A073'	// Summon - Mud Monster 		
		set abilities[31] = 'A07B'	// Summon - Overgrown Hedge 	
		set abilities[32] = 'A07F'	// Summon - Savage Shrub 		
		set abilities[33] = 'A07C'	// Summon - Seige Engine 		
		set abilities[34] = 'A07E'	// Summon - Critical Charger 	
		set abilities[35] = 'A07D'	// Summon - Toxic Spider
		set abilities[36] = 'A078'	// Summon - Tri Elemental 		
		set abilities[37] = 'A07G'	// Summon - Vampire				
		set abilities[38] = 'A072'	// Summon - Wet Current			
		set abilities[39] = 'A077'	// Summon - Wild Murlock		
		set abilities[40] = 'A07A'	// Summon - Wraith				
		set abilities[41] = 'A087'	// Hyper Burn
		set abilities[42] = 'A088'	// Mental Bitch Slap
		set abilities[43] = 'A08F'	// Eternal life
		set abilities[44] = 'A01W'	// EXP Booster
		set abilities[45] = 'A08K'	// Echo Blast
		set abilities[46] = 'A08O'	// Bloody Tornado
		set abilities[47] = 'A08U'	// Adamant Armor
		set abilities[48] = 'A09B'	// Fire
		set abilities[49] = 'A0EN'	// Lightning
		set abilities[50] = 'A09C'	// Minor Heal
		set abilities[51] = 'A08V'	// Rock Skin
		set abilities[52] = 'A08W'	// Divine Essence
		set abilities[53] = 'A08X'	// Flight
		set abilities[54] = 'A092'	// Master Summoning				
		set abilities[55] = 'A0A1'	// Advanced Summoning			
		set abilities[56] = 'A0A2'	// Electric Skin
		set abilities[57] = 'A06T'	// Fire Skin
		set abilities[58] = 'A09I'	// Combust
		set abilities[59] = 'A0AK'	// Turbo Heal
		set abilities[60] = 'A0AT'	// Critical
		set abilities[61] = 'A0AQ'	// Stone Gaze
		set abilities[62] = 'A0B5'	// Presure Release
		set abilities[63] = 'A09N'	// Devil Booster
		set abilities[64] = 'A0BC'	// ChronoSphere
		set abilities[65] = 'A0CD'	// Full Heal
		set abilities[66] = 'A0ED'	// Mega Shard
		set abilities[67] = 'A0EP'  	// Critical Strike
		set abilities[68] = 'A0EQ'	// Evasion
		set abilities[69] = 'A0ES'	// Dhorak's Rage
		set abilities[70] = 'A0EO'	// Godly summoning

		// Map spell items to matching ability
		set spellToAbility = Table.create()
		set spellToAbility['I01J'] = 0 // Ultima
		set spellToAbility['I01N'] = 1 // Twilight
		set spellToAbility['I01O'] = 2 // Soul Drain
		set spellToAbility['I01P'] = 3 // Circle of Death
		set spellToAbility['I01Q'] = 4 // Wake of Fire
		set spellToAbility['I01R'] = 5 // Metallic Erruption
		set spellToAbility['I01S'] = 6 // Concentrated Energy
		set spellToAbility['I01U'] = 7 // THC Cloud
		set spellToAbility['I01V'] = 8 // Deathblow
		set spellToAbility['I01W'] = 9 // Siesmic Assualt
		set spellToAbility['I01X'] = 10 // Rip Tide
		set spellToAbility['I01Y'] = 11 // Mega Flare
		set spellToAbility['I01Z'] = 12 // Mega Magic
		set spellToAbility['I020'] = 13 // Super Hex
		set spellToAbility['I021'] = 14 // Psychic Sightnings
		set spellToAbility['I022'] = 15 // Lit Fury
		set spellToAbility['I023'] = 16 // Auto Heal
		set spellToAbility['I029'] = 17 // Hyper Heal
		set spellToAbility['I02C'] = 18 // Ice Quake
		set spellToAbility['I02G'] = 19 // Sun Storm
		set spellToAbility['I02F'] = 20	// Summon - Basic Elemental 
		set spellToAbility['I02P'] = 21	// Summon - Lightning Lizard
		set spellToAbility['I02T'] = 22	// Summon - Steam Being 	
		set spellToAbility['I02S'] = 23	// Summon - Evil Tree 		
		set spellToAbility['I02X'] = 24	// Summon - Gold Lizard 	
		set spellToAbility['I02U'] = 25	// Summon - Ground Charger 	
		set spellToAbility['I02R'] = 26	// Summon - Hippy 			
		set spellToAbility['I02Y'] = 27	// Summon - Lava Runner 	
		set spellToAbility['I032'] = 28	// Summon - Lesser Alien 	
		set spellToAbility['I02Z'] = 29	// Summon - Molten Machine 	
		set spellToAbility['I02W'] = 30	// Summon - Mud Monster 	
		set spellToAbility['I034'] = 31	// Summon - Overgrown Hedge 
		set spellToAbility['I038'] = 32	// Summon - Savage Shrub 	
		set spellToAbility['I035'] = 33	// Summon - Seige Engine 	
		set spellToAbility['I037'] = 34	// Summon - Critical Charger
		set spellToAbility['I036'] = 35	// Summon - Toxic Spider 	
		set spellToAbility['I031'] = 36	// Summon - Tri Elemental 	
		set spellToAbility['I039'] = 37	// Summon - Vampire			
		set spellToAbility['I02V'] = 38	// Summon - Wet Current		
		set spellToAbility['I030'] = 39	// Summon - Wild Murlock	
		set spellToAbility['I033'] = 40	// Summon - Wraith			
		set spellToAbility['I03H'] = 41 // Hyper Burn
		set spellToAbility['I03I'] = 42 // Mental Bitch Slap
		set spellToAbility['I03O'] = 43 // Eternal Life
		set spellToAbility['I01T'] = 44 // EXP Booster
		set spellToAbility['I03P'] = 45 // Echo Blast
		set spellToAbility['I03T'] = 46 // Bloody Tornado
		set spellToAbility['I048'] = 47 // Adamant Armor
		set spellToAbility['I04U'] = 48 // Fire
		set spellToAbility['I04V'] = 49 // Lightning
		set spellToAbility['I04W'] = 50 // Minor Heal
		set spellToAbility['I04B'] = 51 // Rock Skin
		set spellToAbility['I04C'] = 52 // Divine Essence
		set spellToAbility['I04D'] = 53 // Flight
		set spellToAbility['I04M'] = 54 // Master Summoning
		set spellToAbility['I05L'] = 55 // Advanced Summoning
		set spellToAbility['I05M'] = 56 // Electric Skin
		set spellToAbility['I05N'] = 57 // Fire Skin
		set spellToAbility['I05O'] = 58 // Combust
		set spellToAbility['I06L'] = 59 // Turbo Heal
		set spellToAbility['I07Y'] = 60 // Critical
		set spellToAbility['I080'] = 61 // Stone Gaze
		set spellToAbility['I088'] = 62 // Presure Release
		set spellToAbility['I055'] = 63 // Devil Booster
		set spellToAbility['I08D'] = 64 // ChronoSphere
		set spellToAbility['I08H'] = 65 // Full Heal
		set spellToAbility['I0AA'] = 66 // Mega Shard
		set spellToAbility['I0AH'] = 67 // Critical Strike
		set spellToAbility['I0AG'] = 68 // Evasion
		set spellToAbility['I0AJ'] = 69 // Dhorak's Rage
		set spellToAbility['I0AE'] = 70 // Godly summoning
		
		set spellToAbilityLevel = Table.create()
		set spellToAbilityLevel['I0AF'] = 2 // Lightning 2
		
		set spellUpgradeToAbility = Table.create()
		set spellUpgradeToAbility['I0AF'] = 'A0EN' // Lightning 2
		
		set summoningAbilities[0] = 20	// Summon - Basic Elemental 
		set summoningAbilities[1] = 21	// Summon - Lightning Lizard
		set summoningAbilities[2] = 22	// Summon - Steam Being 	
		set summoningAbilities[3] = 23	// Summon - Evil Tree 		
		set summoningAbilities[4] = 24	// Summon - Gold Lizard 	
		set summoningAbilities[5] = 25	// Summon - Ground Charger 	
		set summoningAbilities[6] = 26	// Summon - Hippy 			
		set summoningAbilities[7] = 27	// Summon - Lava Runner 	
		set summoningAbilities[8] = 28	// Summon - Lesser Alien 	
		set summoningAbilities[9] = 29	// Summon - Molten Machine 	
		set summoningAbilities[10] = 30	// Summon - Mud Monster 	
		set summoningAbilities[11] = 31	// Summon - Overgrown Hedge 
		set summoningAbilities[12] = 32	// Summon - Savage Shrub 	
		set summoningAbilities[13] = 33	// Summon - Seige Engine 	
		set summoningAbilities[14] = 34	// Summon - Critical Charger
		set summoningAbilities[15] = 35	// Summon - Toxic Spider 	
		set summoningAbilities[16] = 36	// Summon - Tri Elemental 	
		set summoningAbilities[17] = 37	// Summon - Vampire			
		set summoningAbilities[18] = 38	// Summon - Wet Current		
		set summoningAbilities[19] = 39	// Summon - Wild Murlock	
		set summoningAbilities[20] = 40	// Summon - Wraith			
		set summoningAbilities[21] = 54	// Master Summoning	
		set summoningAbilities[22] = 55	// Advanced Summoning
		set summoningAbilities[23] = 70	// Godly Summoning
    endfunction

    private function Init takes nothing returns nothing
        call TimerStart(CreateTimer(), 0.01, false, function ApplySpellTypes)
    endfunction
endscope