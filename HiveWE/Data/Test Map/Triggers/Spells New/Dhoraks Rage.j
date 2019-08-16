function Trig_Dharoks_Rage_Conditions takes nothing returns boolean
	return GetUnitAbilityLevel(GetAttacker(), 'A0ES') > 0
endfunction

function Trig_Dharoks_Rage_Actions takes nothing returns nothing
    call SetUnitAbilityLevel(GetAttacker(), 'A0ES',  (100 - R2I(GetUnitLifePercent(GetAttacker()))) / 10 + 1 )
endfunction

//===========================================================================
function InitTrig_Dhoraks_Rage takes nothing returns nothing
    set gg_trg_Dhoraks_Rage = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Dhoraks_Rage, EVENT_PLAYER_UNIT_ATTACKED )
    call TriggerAddCondition( gg_trg_Dhoraks_Rage, Condition( function Trig_Dharoks_Rage_Conditions ) )
    call TriggerAddAction( gg_trg_Dhoraks_Rage, function Trig_Dharoks_Rage_Actions )
endfunction

