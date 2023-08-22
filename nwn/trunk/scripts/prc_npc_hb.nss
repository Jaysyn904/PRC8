//::///////////////////////////////////////////////
//:: OnHeartbeat NPC eventscript
//:: prc_npc_hb
//:://////////////////////////////////////////////
#include "inc_prc_npc"
#include "prc_inc_switch"
#include "inc_epicspellai"

int DoDeadHealingAI()
{
    if(!GetPRCSwitch(PRC_PNP_DEATH_ENABLE))
        return FALSE;
    object oDead;
    //test if you can heal stuff
    talent tHeal = GetCreatureTalentRandom(TALENT_CATEGORY_BENEFICIAL_HEALING_TOUCH);
    if(!GetIsTalentValid(tHeal))
        tHeal = GetCreatureTalentRandom(TALENT_CATEGORY_BENEFICIAL_HEALING_AREAEFFECT);
    if(GetIsTalentValid(tHeal))
    {
        //look for dying ones
        int i = 1;
        oDead = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE,
            OBJECT_SELF, i,
            CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_FRIEND,
            CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN);
        while(GetIsObjectValid(oDead))
        {
            if(GetCurrentHitPoints(oDead) < 10
                && GetLocalInt(oDead, "DeadDying"))
            {
                break;
            }
            i++;
            oDead = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE,
                OBJECT_SELF, i,
                CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_FRIEND,
                CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN);
        }
        if(GetIsObjectValid(oDead))
        {
            ClearAllActions();
            ActionUseTalentOnObject(tHeal, oDead);
            return TRUE;
        }
    }
    //now look for dead things
    oDead = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, FALSE,
        OBJECT_SELF, 1,
        CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_FRIEND,
        CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN);
    if(GetIsObjectValid(oDead))
    {
        if(GetHasSpell(SPELL_RESURRECTION))
        {
            ClearAllActions();
            ActionCastSpellAtObject(SPELL_RESURRECTION, oDead);
            return TRUE;
        }
        else if(GetHasSpell(SPELL_RAISE_DEAD))
        {
            ClearAllActions();
            ActionCastSpellAtObject(SPELL_RAISE_DEAD, oDead);
            return TRUE;
        }
    }
    return FALSE;
}

void main()
{    
    //NPC substiture for OnEquip
    DoEquipTest();

    if(DoEpicSpells())
    {
        ActionDoCommand(SetCommandable(TRUE));
        SetCommandable(FALSE);
    }
    
    if(DoDeadHealingAI())
    {
        ActionDoCommand(SetCommandable(TRUE));
        SetCommandable(FALSE);
    }
    
    if (!GetIsResting(OBJECT_SELF)) 
    {
    	SetLocalInt(OBJECT_SELF, "PnP_Rest_InitialHP", GetCurrentHitPoints(OBJECT_SELF));
    	if(DEBUG) DoDebug("prc_npc_hb: HPs for " + DebugObject2Str(OBJECT_SELF) +" nCurrent: "+IntToString(GetCurrentHitPoints(OBJECT_SELF)));
    }	    

    //run the individual HB event script
    ExecuteScript("prc_onhb_indiv", OBJECT_SELF);
}