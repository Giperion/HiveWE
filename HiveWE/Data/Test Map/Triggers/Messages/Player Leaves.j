function Trig_Player_Leaves_Remove takes nothing returns nothing
    call RemoveUnit( GetEnumUnit() )
endfunction

function Trig_Player_Leaves_Actions takes nothing returns nothing
    local group g = CreateGroup()
    
    call DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 25.00, GetPlayerName(GetTriggerPlayer()) + " has left the game.")
    call GroupEnumUnitsOfPlayer(g, GetTriggerPlayer(), null)
    call ForGroup(g, function Trig_Player_Leaves_Remove)
    
    call DestroyGroup(g)
    set g = null
endfunction

//===========================================================================
function InitTrig_Player_Leaves takes nothing returns nothing
    local trigger gg_trg_Player_Leaves = CreateTrigger()
    local integer i = 0
	loop
	    exitwhen (i > 9)
        call TriggerRegisterPlayerEvent(gg_trg_Player_Leaves, Player(i), EVENT_PLAYER_LEAVE) 
	    set i = i + 1
	endloop
	call TriggerAddAction( gg_trg_Player_Leaves, function Trig_Player_Leaves_Actions )
    set gg_trg_Player_Leaves = null
endfunction

