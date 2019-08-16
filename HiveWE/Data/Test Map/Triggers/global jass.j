/*Enter map-specific custom script code below. This text will be included in the map script after variables are declared and before any trigger code.*/

globals
	
	integer array playerAbilities[71]
	integer array abilities
	integer array summoningAbilities
	integer summoningAbilitiesCount = 24
	
	
	integer array typeToFortified
	integer array typeToDivine
	integer array typeToFlying
endglobals

function filter_unit_is_hero takes nothing returns boolean
    return IsUnitType(GetFilterUnit(), UNIT_TYPE_HERO) == true
endfunction

function CreateTextFileForPlayer takes player pl returns nothing
	local unit hero = null
	local group hero_group = CreateGroup()
    local boolexpr filter = Filter(function filter_unit_is_hero)
	local string fileData = ""
	local string fileName = ""

    // Get Hero from the units owned by the player
    call GroupEnumUnitsOfPlayer(hero_group, pl, filter)
    call DestroyBoolExpr(filter)
    set hero = FirstOfGroup(hero_group)
    set hero_group = null
    set filter = null

	// Right now, this is:
	//      Hero: (hero name)
	//      Level: (hero level)
	//      Code: -load XXXX
	set fileData = "\r\n\t\t\t\tHero: " + GetUnitName(hero) + "\r\n\t\t\t\t" + "Level: " + I2S(GetHeroLevel(hero)) + "\t\t\r\n\t\t\t\t" + "Code: -l " + udg_saveTemp + "\r\n\n\t\t    "

	// Right now, this is:
	//      "Warcraft III\FolderName\(hero name) - (hero level)"
	set fileName = "MCFC\\" + GetUnitName(hero) + " - " + I2S(GetHeroLevel(hero)) + ".txt"

	if GetLocalPlayer() == pl then
	   call PreloadGenClear()
	   call PreloadGenStart()

	   call Preload(fileData)
	   call PreloadGenEnd(fileName)
	endif
endfunction

function at takes string text, integer position returns string
	return SubString(text, position, position+1)
endfunction

function search_in_string takes string text, string character returns integer
	local integer i = 0
    loop
        exitwhen i > StringLength(text) - 1
        if (character == at(text, i)) then
			return i
		endif
        set i = i + 1
    endloop
	return -1
endfunction

function split takes string text, string seperator returns nothing
	local integer j = 0
	set udg_stringParts[0] = ""
	set udg_stringPartsCount = 0
    loop
        exitwhen j > StringLength(text) - 1
        if (seperator == at(text, j)) then
			set udg_stringPartsCount = udg_stringPartsCount + 1
			set udg_stringParts[udg_stringPartsCount] = ""
		else
			set udg_stringParts[udg_stringPartsCount] = udg_stringParts[udg_stringPartsCount] + at(text, j)
		endif
        set j = j + 1
    endloop
endfunction

function UnitHasItemOfType takes unit unit_to_check, itemtype type_of_item returns integer
	local integer index
	local item indexItem
	local integer count = 0
	
	set index = 0
	loop
		exitwhen index >= bj_MAX_INVENTORY
		set indexItem = UnitItemInSlot(unit_to_check, index)
		if (indexItem != null) and (GetItemType(indexItem) == type_of_item) then
			set count = count + 1
		endif
		set index = index + 1
	endloop
	return count
endfunction

function PlayerHasSpell takes player whichPlayer, integer spell returns boolean
	local integer i = 0
	loop
		exitwhen i > 6
		if (playerAbilities[GetPlayerId(whichPlayer) * 7 + i] == spell) then
			return true
		endif
		set i = i + 1
	endloop
	return false
endfunction