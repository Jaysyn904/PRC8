//::///////////////////////////////////////////////
//:: OnRested NPC eventscript
//:: prc_npc_rested
//:://////////////////////////////////////////////
#include "prc_inc_spells"
#include "inc_npc"

void ShadowElem()
{
    if (GetResRef(OBJECT_SELF) == "shd_shdelem_huge" || GetResRef(OBJECT_SELF) == "shd_shdelem_eldr" || GetResRef(OBJECT_SELF) == "shd_shdelem_med" ||
        GetResRef(OBJECT_SELF) == "shd_shdelem_med2" || GetResRef(OBJECT_SELF) == "shd_shdelem_med3" || GetResRef(OBJECT_SELF) == "shd_shdelem_med4")
    {
        effect eLink = EffectLinkEffects(EffectTrueSeeing(), EffectVisualEffect(PSI_DUR_SHADOW_BODY)); 
               /*eLink = EffectLinkEffects(eLink, EffectDamageIncrease(DAMAGE_BONUS_1, DAMAGE_TYPE_COLD));
               eLink = EffectLinkEffects(eLink, EffectAttackIncrease(1));*/
        SetIncorporeal(OBJECT_SELF, 1.0, 2, TRUE);
        if(DEBUG) DoDebug("prc_npc_rested: ShadowElem");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(eLink), OBJECT_SELF);
    }    
}

void ShadowformFamiliar()
{
    object oPC = GetMaster();
    if(GetIsObjectValid(oPC) && GetHasFeat(FEAT_SHADOWFORM_FAMILIAR, oPC))
    {    
        int i;
        for(i = 1; i <= 5; i++)
        {
            object oAsso = GetAssociateNPC(ASSOCIATE_TYPE_FAMILIAR, oPC, i);
            if(GetIsObjectValid(oAsso))
                SetIncorporeal(oAsso, -1.0, 2, TRUE);
        }
    }    
}

void ChecksOnMaster()
{
    if (DEBUG) DoDebug("ChecksOnMaster: Entered");
    if(MyPRCGetRacialType(OBJECT_SELF)==RACIAL_TYPE_UNDEAD)
    {
        if (DEBUG) DoDebug("ChecksOnMaster: Undead");
        object oMaster = GetMaster();
        if(GetIsObjectValid(oMaster) /*&& GetAssociateType(OBJECT_SELF) != ASSOCIATE_TYPE_SUMMONED*/)
        {
            if (GetLevelByClass(CLASS_TYPE_DREAD_NECROMANCER, oMaster) >= 8)
            {
                if (DEBUG) DoDebug("Corpsecrafter: Dread Necro on Rest");
                int nHD = GetHitDice(OBJECT_SELF);
                effect eHP = EffectTemporaryHitpoints(nHD * 2);
                eHP = SupernaturalEffect(eHP);
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eHP, OBJECT_SELF);
            }
            if (GetHasFeat(FEAT_CORPSECRAFTER, oMaster))
            {
                if (DEBUG) DoDebug("Corpsecrafter: Corpsecrafter on Rest");
                int nHD = GetHitDice(OBJECT_SELF);
                effect eHP = EffectTemporaryHitpoints(nHD * 2);
                eHP = SupernaturalEffect(eHP);
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eHP, OBJECT_SELF);
            }
    		// Necrocarnum Circlet clean up
    		if (GetLevelByClass(CLASS_TYPE_INCARNATE, oMaster) || GetLevelByClass(CLASS_TYPE_SOULBORN, oMaster))
    		{
    			if (GetResRef(OBJECT_SELF) == "prc_sum_dbl" ||
    			    GetResRef(OBJECT_SELF) == "prc_sum_dk" ||
    			    GetResRef(OBJECT_SELF) == "prc_sum_vamp2" ||
    			    GetResRef(OBJECT_SELF) == "prc_sum_bonet" ||
    			    GetResRef(OBJECT_SELF) == "prc_sum_wight" ||
    			    GetResRef(OBJECT_SELF) == "prc_sum_vamp1" ||
    			    GetResRef(OBJECT_SELF) == "prc_sum_grav" ||
    			    GetResRef(OBJECT_SELF) == "prc_sum_sklch" ||
    			    GetResRef(OBJECT_SELF) == "prc_sum_zlord" ||
    			    GetResRef(OBJECT_SELF) == "prc_sum_mohrg" ||
    			    GetResRef(OBJECT_SELF) == "prc_tn_fthug")
    			{
    				DestroyObject(OBJECT_SELF);
    			}
    		}             
        }
    }
}

void main()
{
    // Execute the stuff in prc_rest for REST_EVENTTYPE_REST_STARTED and REST_EVENTTYPE_REST_FINISHED
    //SetLocalInt(OBJECT_SELF, "PnP_Rest_InitialHP", GetCurrentHitPoints(OBJECT_SELF));
    if(DEBUG) DoDebug("prc_npc_rested: HPs for " + DebugObject2Str(OBJECT_SELF) +" nCurrent: "+IntToString(GetCurrentHitPoints(OBJECT_SELF)));
    SetLocalInt(OBJECT_SELF, "prc_rest_eventtype", REST_EVENTTYPE_REST_STARTED);
    ExecuteScript("prc_rest", OBJECT_SELF);
    SetLocalInt(OBJECT_SELF, "prc_rest_eventtype", REST_EVENTTYPE_REST_FINISHED);
    ExecuteScript("prc_rest", OBJECT_SELF);
    DeleteLocalInt(OBJECT_SELF, "prc_rest_eventtype");
    DelayCommand(0.1, ShadowElem());
    DelayCommand(0.1, ShadowformFamiliar());
    DelayCommand(0.1, ChecksOnMaster());    
    
    // Execute scripts hooked to this event for the NPC triggering it
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_NPC_ONRESTED);
}