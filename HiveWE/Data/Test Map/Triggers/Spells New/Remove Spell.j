function Trig_Remove_Spell_is_hero takes nothing returns boolean
    return ( IsUnitType(GetFilterUnit(), UNIT_TYPE_HERO) == true )
endfunction

function Trig_Remove_Spell_Actions takes nothing returns nothing
	local integer i = 0
	local string command = SubString(GetEventPlayerChatString(), 8, StringLength(GetEventPlayerChatString()))
	local unit hero = null
	local group hero_group = CreateGroup()
    local boolexpr filter = Filter(function Trig_Remove_Spell_is_hero)
    
	
    // Get Hero from the units owned by the player
    call GroupEnumUnitsOfPlayer(hero_group, GetTriggerPlayer(), filter)
    call DestroyBoolExpr(filter)
    set hero = FirstOfGroup(hero_group)
    set hero_group = null
    set filter = null
	
	if (SubString(GetEventPlayerChatString(), 0, 8) != "-remove ") then
		return
	endif
	
	set i = 0
	loop
		exitwhen i > 6
		if (GetObjectName(abilities[playerAbilities[GetPlayerId(GetTriggerPlayer()) * 7 + i]]) == command) then
			call UnitRemoveAbility(hero, abilities[playerAbilities[GetPlayerId(GetTriggerPlayer()) * 7 + i]])
			set playerAbilities[GetPlayerId(GetTriggerPlayer()) * 7 + i] = -1
		endif
		set i = i + 1
	endloop
endfunction

//===========================================================================
function InitTrig_Remove_Spell takes nothing returns nothing
    set gg_trg_Remove_Spell = CreateTrigger(  )
    call TriggerRegisterPlayerChatEvent( gg_trg_Remove_Spell, Player(0), "-remove", false )
    call TriggerRegisterPlayerChatEvent( gg_trg_Remove_Spell, Player(1), "-remove", false )
    call TriggerRegisterPlayerChatEvent( gg_trg_Remove_Spell, Player(2), "-remove", false )
    call TriggerRegisterPlayerChatEvent( gg_trg_Remove_Spell, Player(3), "-remove", false )
    call TriggerRegisterPlayerChatEvent( gg_trg_Remove_Spell, Player(4), "-remove", false )
    call TriggerRegisterPlayerChatEvent( gg_trg_Remove_Spell, Player(5), "-remove", false )
    call TriggerRegisterPlayerChatEvent( gg_trg_Remove_Spell, Player(6), "-remove", false )
    call TriggerRegisterPlayerChatEvent( gg_trg_Remove_Spell, Player(7), "-remove", false )
    call TriggerRegisterPlayerChatEvent( gg_trg_Remove_Spell, Player(8), "-remove", false )
    call TriggerRegisterPlayerChatEvent( gg_trg_Remove_Spell, Player(9), "-remove", false )
    call TriggerAddAction( gg_trg_Remove_Spell, function Trig_Remove_Spell_Actions )
endfunction

