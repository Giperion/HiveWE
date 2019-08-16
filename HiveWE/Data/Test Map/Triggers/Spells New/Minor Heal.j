function Trig_Minor_Heal_Conditions takes nothing returns boolean
    if (GetSpellAbilityId() != 'A09C' ) then
        return false
    endif
    return true
endfunction

function Trig_Minor_Heal_Actions takes nothing returns nothing
	call SetUnitState(GetSpellTargetUnit(), UNIT_STATE_LIFE, GetUnitState(GetSpellTargetUnit(), UNIT_STATE_LIFE) + 70 + GetHeroInt(GetTriggerUnit(), true) * 0.5)
endfunction

//===========================================================================
function InitTrig_Minor_Heal takes nothing returns nothing
    set gg_trg_Minor_Heal = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Minor_Heal, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Minor_Heal, Condition( function Trig_Minor_Heal_Conditions ) )
    call TriggerAddAction( gg_trg_Minor_Heal, function Trig_Minor_Heal_Actions )
endfunction

