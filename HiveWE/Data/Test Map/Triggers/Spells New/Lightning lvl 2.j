function Trig_Lightning_Conditions_lvl_2 takes nothing returns boolean
    return GetSpellAbilityId() == 'A0EN' and GetUnitAbilityLevel(GetTriggerUnit(), GetSpellAbilityId()) == 2
endfunction

function Trig_Lightning_Actions_lvl_2 takes nothing returns nothing
    set udg_QJC_Caster = GetTriggerUnit()
    set udg_QJC_TargetUnit = GetSpellTargetUnit()
    set udg_QJC_NoTarget = false
    set udg_QJC_Priority = true
    set udg_QJC_OnePerUnit = true
    set udg_QJC_Damage = true
    set udg_QJC_Heal = false
    set udg_QJC_Heatlh = false
    set udg_QJC_Mana = false
    set udg_QJC_Gold = false
    set udg_QJC_Leech = false
    set udg_QJC_Ally = false
    set udg_QJC_Enemy = true
    set udg_QJC_Amount = 250 + GetHeroInt(GetTriggerUnit(), true) * 0.25
    set udg_QJC_ChainSFX = "CLPB"
    set udg_QJC_TargetSFX = "Abilities\\Spells\\Demon\\DemonBoltImpact\\DemonBoltImpact.mdl"
    set udg_QJC_AttackType = ATTACK_TYPE_CHAOS
    set udg_QJC_DamageType = DAMAGE_TYPE_UNIVERSAL
    set udg_QJC_AmountReduce = 0.15
    set udg_QJC_JumpCount = 4
    set udg_QJC_JumpDelayTime = 0.10
    set udg_QJC_JumpRadius = 550.00
    set udg_QJC_Slow = true
    set udg_QJC_Stun = false
    set udg_QJC_AoE = false
    call ConditionalTriggerExecute( gg_trg_Chain_Create )
endfunction

//===========================================================================
function InitTrig_Lightning_lvl_2 takes nothing returns nothing
    set gg_trg_Lightning_lvl_2 = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Lightning_lvl_2, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Lightning_lvl_2, Condition( function Trig_Lightning_Conditions_lvl_2 ) )
    call TriggerAddAction( gg_trg_Lightning_lvl_2, function Trig_Lightning_Actions_lvl_2 )
endfunction

