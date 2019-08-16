function Trig_Upgrade_Spell_Actions takes nothing returns nothing
	local integer spellID = GetItemTypeId(GetManipulatedItem())

	if (spellUpgradeToAbility.has(GetItemTypeId(GetManipulatedItem()))) then
		// Check if unit has spell or too low a level
		if (GetUnitAbilityLevel(GetTriggerUnit(), spellUpgradeToAbility[spellID]) < (spellToAbilityLevel[spellID]) - 1) then
			call DisplayTimedTextToPlayer(GetTriggerPlayer() ,0, 0, 200.00, "You have not learned the base spell or the previous spell level." )
			call CreateItem(spellID, GetUnitX(GetTriggerUnit()), GetUnitY(GetTriggerUnit()))
			return
		endif
		
		// Check if unit has this level already or higher
		if (GetUnitAbilityLevel(GetTriggerUnit(), spellUpgradeToAbility[spellID]) >= spellToAbilityLevel[spellID]) then
			call DisplayTimedTextToPlayer(GetTriggerPlayer() ,0, 0, 200.00, "You have already mastered this level." )
			call CreateItem(spellID, GetUnitX(GetTriggerUnit()), GetUnitY(GetTriggerUnit()))
			return
		endif
		
		call SetUnitAbilityLevel(GetTriggerUnit(), spellUpgradeToAbility[spellID], spellToAbilityLevel[spellID])
	endif
endfunction

//===========================================================================
function InitTrig_Upgrade_Spell takes nothing returns nothing
    local trigger gg_trg_Upgrade_Spell = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Upgrade_Spell, EVENT_PLAYER_UNIT_USE_ITEM )
    call TriggerAddAction( gg_trg_Upgrade_Spell, function Trig_Upgrade_Spell_Actions )
endfunction

