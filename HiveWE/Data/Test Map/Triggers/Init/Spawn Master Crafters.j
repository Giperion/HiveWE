function Trig_Spawn_Master_Crafters_Actions takes nothing returns nothing
    local integer player_count = 0
    
    local integer i = 0
	loop
	    exitwhen (i > 9)
        
		if (GetPlayerController(Player(i)) != MAP_CONTROL_COMPUTER) then
            if (GetPlayerSlotState(Player(i)) == PLAYER_SLOT_STATE_PLAYING) then
                set player_count = player_count + 1
                set bj_lastCreatedUnit = CreateUnitAtLoc(Player(i), 'H001', GetRandomLocInRect(gg_rct_revive), bj_UNIT_FACING)
            endif
        endif
        
	    set i = i + 1
	endloop

    call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, 2500, 2)
    call PanCameraToTimed(GetRectCenterX(gg_rct_revive), GetRectCenterY(gg_rct_revive), 2)
	
    call EnableTrigger(gg_trg_load)
    if (player_count == 1) then
		call DisableTrigger(gg_trg_save)
        call DisplayTimedTextToForce(GetPlayersAll(), 500.00, "Saving has been disabled. Play with atleast 2 players to enable saving.")
    endif
endfunction

//===========================================================================
function InitTrig_Spawn_Master_Crafters takes nothing returns nothing
    set gg_trg_Spawn_Master_Crafters = CreateTrigger()
    call TriggerRegisterTimerEvent(gg_trg_Spawn_Master_Crafters, 2.00, false)
    call TriggerAddAction(gg_trg_Spawn_Master_Crafters, function Trig_Spawn_Master_Crafters_Actions)
endfunction