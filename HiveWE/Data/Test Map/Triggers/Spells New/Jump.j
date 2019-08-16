scope JumpSpellvJASS

    globals
        private string EFF = "Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl"
        private constant integer AID = 'A0ER'
        private constant integer DID = 'e000'
        private constant integer OID = 852121
        private unit HARVESTER
        private group ENU = CreateGroup()
        private constant real GRAVITY       = 100
        private constant real SPEED         = 500
        private constant real MAX_HEIGHT    = 250
        private constant real AOE   = 200
        private rect REC = Rect(0, 0, 0, 0)
        private Table TAB
    endglobals

    struct JumpingStomp extends array
    
        private static method DestructableFilter takes nothing returns boolean
            if GetDestructableLife(GetFilterDestructable()) > 0 then
                call IssueTargetOrder(HARVESTER, "harvest", GetFilterDestructable())
                if GetUnitCurrentOrder(HARVESTER) == OrderId("harvest") then
                    call KillDestructable(GetFilterDestructable())
                endif
                call IssueImmediateOrder(HARVESTER, "stop")
            endif
        return false
    endmethod
    
        private static method onFinish takes nothing returns boolean
            local real x
            local real y
            if not IsUnitType(EVENT_JUMP_UNIT, UNIT_TYPE_DEAD) then
                set x = GetUnitX(EVENT_JUMP_UNIT)
                set y = GetUnitY(EVENT_JUMP_UNIT)
                call DestroyEffect(AddSpecialEffect(EFF, x, y))
                call SetRect(REC, x-AOE, y-AOE, x+AOE, y+AOE)
                call EnumDestructablesInRect(REC, function thistype.DestructableFilter, null)
            endif
            return false
        endmethod
        
        private static method onCast takes nothing returns boolean
            local unit u = GetTriggerUnit()
            local real x0 = GetUnitX(u)
            local real y0 = GetUnitY(u)
            local real x1 = GetSpellTargetX()
            local real y1 = GetSpellTargetY()
            // Here I make each jump take at least 0.5 seconds. The distance add to the jump time with 0.5 factor.
            local real time = 0.5 + 0.5 * SquareRoot( (x1-x0)*(x1-x0) + (y1-y0)*(y1-y0) ) / SPEED
            call Jump.start(GetTriggerUnit(), GetSpellTargetX(), GetSpellTargetY(), MAX_HEIGHT, time, GRAVITY)
            
            /* --------- Moving Shadow Trail ---------- /
            set ST = ShadowTrail.add(GetTriggerUnit(), TRAIL_TYPE_MOTION, 8)
            call ST.setupMovingTrail(5, 20, 0.85)
            call ST.setColor(200, 200, 200, 200)
            call ST.setAnimationIndex(2)
            call ST.setFadeRate(10, true)
            / ---------------------------------------- */
            
            
            /* --------- Static Shadow Trail ---------- / 
            
            set ST = ShadowTrail.add(GetTriggerUnit(), TRAIL_TYPE_STATIC, 0)
            call ST.setInterval(0.06250)
            call ST.setColor(150, 150, 150, 150)
            call ST.setAnimationIndex(6)
            call ST.setFadeRate(8, true)
            call ST.setPlayerColor(GetPlayerColor(Player(15)))
            
            / ---------------------------------------- */
            
            // set TAB[GetHandleId(GetTriggerUnit())] = ST
            
            set u = null
            return false
        endmethod
        
        private static method onOrder takes nothing returns boolean
            if GetIssuedOrderId() == OID and not IsPointJumpable(GetOrderPointX(), GetOrderPointY()) then
                call PauseUnit(GetTriggerUnit(), true)
                call IssueImmediateOrder(GetTriggerUnit(), "stop")
                call PauseUnit(GetTriggerUnit(), false)
            endif
            return false
        endmethod
    
        private static method onInit takes nothing returns nothing
            local trigger t = CreateTrigger()
            call TriggerRegisterVariableEvent(t, "EVENT_JUMP_FINISH", EQUAL, 1)
            call TriggerAddCondition(t, function thistype.onFinish)
            
            set t = CreateTrigger()
            call TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER)
            call TriggerAddCondition(t, function thistype.onOrder)
            
            call RegisterSpellEffectEvent(AID, function thistype.onCast)
            
            set HARVESTER = CreateUnit(Player(15), 'hpea', 0, 0, 0)
            call UnitAddAbility(HARVESTER, 'Aloc')
            call ShowUnit(HARVESTER, false)
            
            set TAB = Table.create()
        endmethod
    endstruct
endscope

