function Trig_newsave_is_hero takes nothing returns boolean
    return IsUnitType(GetFilterUnit(), UNIT_TYPE_HERO)
endfunction

function Trig_newsave_Actions takes nothing returns nothing
    local unit hero = null
    
	local string data_code = ""
    local string save_code = ""
	local string item_code = ""
	local integer items = 0
	local string spell_code = ""
	local integer spells = 0
	local string alphabet = "TJly/1x%DB=aPK^A9O}_]7hjX[o)Cq*nZsQk:5I+if2&@`zMr<g.eVuwR(3N?8,-LSd!WF0;Y#tc4UGEbv>${6|~pHm"
    local integer alphabet_length = StringLength(alphabet)
	local integer i
    
    local group hero_group = CreateGroup()
    local boolexpr filter = Filter(function Trig_newsave_is_hero)
	
    /* test

comment


oraoraoraoraoraora*/
    // Obfuscation variables
	local integer search_result = -1
    
    // Get Hero from the units owned by the player
    call GroupEnumUnitsOfPlayer(hero_group, GetTriggerPlayer(), filter)
    call DestroyBoolExpr(filter)
    set hero = FirstOfGroup(hero_group)
    set hero_group = null
    set filter = null
    
    // Add gold to save code. Wood is calculated on load based on stats
    set data_code = I2S(GetPlayerState(GetTriggerPlayer(), PLAYER_STATE_RESOURCE_GOLD)) + "|"
	
	// Add name to save code
	set data_code = data_code + GetPlayerName(GetTriggerPlayer()) + "|"
	
    // Add level to save code
    set data_code = data_code + I2S(GetHeroLevel(hero)) + "|"
    
    // Add stats to save code
    set data_code = data_code + I2S(GetHeroStr(hero, false)) + "|"
    set data_code = data_code + I2S(GetHeroAgi(hero, false)) + "|"
    set data_code = data_code + I2S(GetHeroInt(hero, false)) + "|"
    
    // Add items to save code
    set i = 0
    loop
        exitwhen i > 5
		if (UnitItemInSlot(hero, i) != null) then
			set item_code = item_code + SubString(I2S(GetItemTypeId(UnitItemInSlot(hero, i))), 2, 10) + "|"
			set items = items + 1
		endif
        set i = i + 1
    endloop
	set data_code = data_code + I2S(items) + "|" + item_code
	
	// Add abilities to save code
	set i = 0
    loop
        exitwhen i > 6
		if (playerAbilities[GetPlayerId(GetTriggerPlayer()) * 7 + i] != -1) then
			set spell_code = spell_code + I2S(GetUnitAbilityLevel(hero, abilities[playerAbilities[GetPlayerId(GetTriggerPlayer()) * 7 + i]]))
			set spell_code = spell_code + I2S(playerAbilities[GetPlayerId(GetTriggerPlayer()) * 7 + i]) + "|"
			set spells = spells + 1
		endif
        set i = i + 1
    endloop
	set data_code = data_code + I2S(spells) + "|" + spell_code
	
	
    // Obfuscate save code	
	set i = 0
    loop
        exitwhen i > StringLength(data_code) - 1
		set search_result = search_in_string(alphabet, at(data_code, i)) + 5 + i
		if (search_result >= alphabet_length) then
			set search_result = search_result - alphabet_length
			if (search_result >= alphabet_length) then
				set search_result = search_result - alphabet_length
			endif
		endif
        set save_code = save_code + at(alphabet, search_result)
        set i = i + 1
    endloop
	
	set udg_saveTemp = save_code
	call CreateTextFileForPlayer(GetTriggerPlayer())
	
    call DisplayTimedTextToPlayer(GetTriggerPlayer(), 0, 0, 200.00, "Your save code is saved in a text file.\nSave code: " + save_code )
endfunction

//===========================================================================
function InitTrig_save takes nothing returns nothing
    local trigger gg_trg_save = CreateTrigger()
    call TriggerRegisterPlayerChatEvent( gg_trg_save, Player(0), "-save", true )
    call TriggerRegisterPlayerChatEvent( gg_trg_save, Player(1), "-save", true )
    call TriggerRegisterPlayerChatEvent( gg_trg_save, Player(2), "-save", true )
    call TriggerRegisterPlayerChatEvent( gg_trg_save, Player(3), "-save", true )
    call TriggerRegisterPlayerChatEvent( gg_trg_save, Player(4), "-save", true )
    call TriggerRegisterPlayerChatEvent( gg_trg_save, Player(5), "-save", true )
    call TriggerRegisterPlayerChatEvent( gg_trg_save, Player(6), "-save", true )
    call TriggerRegisterPlayerChatEvent( gg_trg_save, Player(7), "-save", true )
    call TriggerRegisterPlayerChatEvent( gg_trg_save, Player(8), "-save", true )
    call TriggerRegisterPlayerChatEvent( gg_trg_save, Player(9), "-save", true )
    call TriggerAddAction( gg_trg_save, function Trig_newsave_Actions )
endfunction

