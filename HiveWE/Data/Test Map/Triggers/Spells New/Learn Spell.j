function Trig_Learn_Spell_Actions takes nothing returns nothing
    local integer i = 0
	local integer j = 0
	local boolean isSummoningAbility = false
	if (spellToAbility.has(GetItemTypeId(GetManipulatedItem()))) then
		// Check if spell is already learned
		if (PlayerHasSpell(GetOwningPlayer(GetTriggerUnit()), spellToAbility[GetItemTypeId(GetManipulatedItem())])) then
			call DisplayTimedTextToPlayer(GetTriggerPlayer() ,0, 0, 200.00, "You already have this spell." )
			call CreateItem(GetItemTypeId(GetManipulatedItem()), GetUnitX(GetTriggerUnit()), GetUnitY(GetTriggerUnit()))
			return
		endif
		
		// See if this ability is a summoning ability
		set i = 0
		loop
			exitwhen i > summoningAbilitiesCount - 1
			if (summoningAbilities[i] == spellToAbility[GetItemTypeId(GetManipulatedItem())]) then
				set isSummoningAbility = true
				call DisplayTimedTextToPlayer(GetTriggerPlayer() ,0, 0, 200.00, "Found summoning ability" )
				set i = summoningAbilitiesCount
			endif
			set i = i + 1
		endloop
		
		// Remove other summoning abilities if it is a summoning ability	
		if (isSummoningAbility) then
			set i = 0
			loop
				exitwhen i > 6
				set j = 0
				loop
					exitwhen j > summoningAbilitiesCount - 1
					if (summoningAbilities[j] == playerAbilities[GetPlayerId(GetOwningPlayer(GetTriggerUnit())) * 7 + i]) then
						call UnitRemoveAbility(GetTriggerUnit(), abilities[playerAbilities[GetPlayerId(GetOwningPlayer(GetTriggerUnit())) * 7 + i]])
						set playerAbilities[GetPlayerId(GetOwningPlayer(GetTriggerUnit())) * 7 + i] = -1
						call DisplayTimedTextToPlayer(GetTriggerPlayer() ,0, 0, 200.00, "Removing old summon spell" )
					endif
					set j = j + 1
				endloop
				set i = i + 1
			endloop
		endif
		
		// Look for an empty spot and add the spell
		set i = 0
		loop
			exitwhen i > 6
			if (playerAbilities[GetPlayerId(GetOwningPlayer(GetTriggerUnit())) * 7 + i] == -1) then
				call UnitAddAbility(GetTriggerUnit(), abilities[spellToAbility[GetItemTypeId(GetManipulatedItem())]])
				set playerAbilities[GetPlayerId(GetOwningPlayer(GetTriggerUnit())) * 7 + i] = spellToAbility[GetItemTypeId(GetManipulatedItem())]
				return
			endif
			set i = i + 1
		endloop
		call DisplayTimedTextToPlayer(GetTriggerPlayer() ,0, 0, 200.00, "You can only have 7 spells." )
		call CreateItem(GetItemTypeId(GetManipulatedItem()), GetUnitX(GetTriggerUnit()), GetUnitY(GetTriggerUnit()))
	endif
endfunction

//===========================================================================
function InitTrig_Learn_Spell takes nothing returns nothing
    local trigger gg_trg_Learn_Spell = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Learn_Spell, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddAction( gg_trg_Learn_Spell, function Trig_Learn_Spell_Actions )
endfunction

