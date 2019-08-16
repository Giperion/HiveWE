function Trig_load_is_hero takes nothing returns boolean
    return IsUnitType(GetFilterUnit(), UNIT_TYPE_HERO)
endfunction

function Trig_load_Actions takes nothing returns nothing
	local unit hero = null
    
	local string data_code = SubString(GetEventPlayerChatString(), 3, StringLength(GetEventPlayerChatString()))
    local string load_code = ""
	local string alphabet = "TJly/1x%DB=aPK^A9O}_]7hjX[o)Cq*nZsQk:5I+if2&@`zMr<g.eVuwR(3N?8,-LSd!WF0;Y#tc4UGEbv>${6|~pHm"
    local integer alphabet_length = StringLength(alphabet)
	local string sub_string = ""
	local integer i = 0
	
	local integer gold = 0
	local string name = ""
	local integer wood = 0
	local integer lvl = 0
	local integer str = 0
	local integer agi = 0
	local integer int = 0
	local integer items = 0
	local integer spells = 0
	
    local group hero_group = CreateGroup()
    local boolexpr filter = Filter(function Trig_newsave_is_hero)
	
    // Obfuscation variables
	local integer search_result = -1
		
	if (SubString(GetEventPlayerChatString(), 0, 3) != "-l ") then
		return
	endif
	
	if (udg_playerLoaded[GetPlayerId(GetTriggerPlayer())] == true) then
		call DisplayTimedTextToPlayer(GetTriggerPlayer(), 0, 0, 200.00, "You have already loaded" )
		return
	endif
	
	// Get the hero, remove it and make a new one
	call GroupEnumUnitsOfPlayer(hero_group, GetTriggerPlayer(), filter)
    call DestroyBoolExpr(filter)
    set hero = FirstOfGroup(hero_group)
    set hero_group = null
    set filter = null
	call RemoveUnit(hero)
	set hero = CreateUnitAtLoc(GetTriggerPlayer(), 'H001', GetRandomLocInRect(gg_rct_revive), bj_UNIT_FACING)
	
    // Unobfuscate save code
	set i = 0
    loop
        exitwhen i > StringLength(data_code) - 1
		set search_result = search_in_string(alphabet, at(data_code, i)) - 5 - i
		if (search_result < 0) then
			set search_result = alphabet_length + search_result
			if (search_result < 0) then
				set search_result = alphabet_length + search_result
			endif
		endif
        set load_code = load_code + at(alphabet, search_result)
        set i = i + 1
    endloop
	
    //call DisplayTimedTextToPlayer(GetTriggerPlayer(), 0, 0, 200.00, "Load code: " + load_code )
	
	call split(load_code, "|")
	
//	set bj_forLoopAIndex = 0
//    loop
//        exitwhen bj_forLoopAIndex > udg_stringPartsCount - 1
//		call DisplayTimedTextToPlayer(GetTriggerPlayer(), 0, 0, 200.00, udg_stringParts[bj_forLoopAIndex] )
//        set bj_forLoopAIndex = bj_forLoopAIndex + 1
//    endloop
	
	if (udg_stringPartsCount < 7) then
		call DisplayTimedTextToPlayer(GetTriggerPlayer(), 0, 0, 200.00, "Invalid Load Code" )
		return
	endif

	set gold = S2I(udg_stringParts[0])
	set name = udg_stringParts[1]
	set lvl = S2I(udg_stringParts[2])
	set str = S2I(udg_stringParts[3])
	set agi = S2I(udg_stringParts[4])
	set int = S2I(udg_stringParts[5])
	set items = S2I(udg_stringParts[6])
	
	// Check if name is correct
	if (name != GetPlayerName(GetTriggerPlayer())) then
		call DisplayTimedTextToPlayer(GetTriggerPlayer(), 0, 0, 200.00, "Invalid Name. Another name is attached to this code" )
		return
	endif
	
	call SetPlayerState(GetTriggerPlayer(), PLAYER_STATE_RESOURCE_GOLD, gold)
	call SetHeroLevel(hero, lvl, false)
	
	// Check if attributes are incorrect
	if (lvl + 2 < str + agi + int) then
		call DisplayTimedTextToPlayer(GetTriggerPlayer(), 0, 0, 200.00, "Invalid Stat points have been reset" )
		call SetPlayerState(GetTriggerPlayer(), PLAYER_STATE_RESOURCE_LUMBER, GetHeroLevel(hero) - 1)
	else
		call SetHeroStr(hero, str, true)
		call SetHeroAgi(hero, agi, true)
		call SetHeroInt(hero, int, true)
		call SetPlayerState(GetTriggerPlayer(), PLAYER_STATE_RESOURCE_LUMBER, lvl + 2 - str - agi - int)
	endif
	
	//call DisplayTimedTextToPlayer(GetTriggerPlayer(), 0, 0, 200.00, "Items: " + I2S(items) )
	// Add items
	set i = 0
    loop
        exitwhen i > items
		//call DisplayTimedTextToPlayer(GetTriggerPlayer(), 0, 0, 200.00, "Item: " + udg_stringParts[7 + i])
		call UnitAddItemById(hero, S2I("12" + udg_stringParts[7 + i]))
        set i = i + 1
    endloop
	
	if (udg_stringPartsCount < 7 + items) then
		call DisplayTimedTextToPlayer(GetTriggerPlayer(), 0, 0, 200.00, "Invalid Spells, resetting" )
		return
	endif
	
	set spells = S2I(udg_stringParts[7 + items])
	
	// Add spells
	set i = 0
    loop
        exitwhen i > spells - 1
		set sub_string = udg_stringParts[8 + items + i]
		set lvl = S2I(SubString(sub_string, 0, 1))
		set sub_string = SubString(sub_string, 1, StringLength(sub_string))
		
		set playerAbilities[GetPlayerId(GetTriggerPlayer()) * 7 + i] = S2I(sub_string)
		call UnitAddAbility(hero, abilities[S2I(sub_string)])
		call SetUnitAbilityLevel(hero, abilities[S2I(sub_string)], lvl)
        set i = i + 1
    endloop
	
	set udg_playerLoaded[GetPlayerId(GetTriggerPlayer())] = true
endfunction

//===========================================================================
function InitTrig_load takes nothing returns nothing
	local trigger gg_trg_load = CreateTrigger()
    call TriggerRegisterPlayerChatEvent( gg_trg_load, Player(0), "-l", false )
    call TriggerRegisterPlayerChatEvent( gg_trg_load, Player(1), "-l", false )
    call TriggerRegisterPlayerChatEvent( gg_trg_load, Player(2), "-l", false )
    call TriggerRegisterPlayerChatEvent( gg_trg_load, Player(3), "-l", false )
    call TriggerRegisterPlayerChatEvent( gg_trg_load, Player(4), "-l", false )
    call TriggerRegisterPlayerChatEvent( gg_trg_load, Player(5), "-l", false )
    call TriggerRegisterPlayerChatEvent( gg_trg_load, Player(6), "-l", false )
    call TriggerRegisterPlayerChatEvent( gg_trg_load, Player(7), "-l", false )
    call TriggerRegisterPlayerChatEvent( gg_trg_load, Player(8), "-l", false )
    call TriggerRegisterPlayerChatEvent( gg_trg_load, Player(9), "-l", false )
    call TriggerAddAction( gg_trg_load, function Trig_load_Actions )
endfunction