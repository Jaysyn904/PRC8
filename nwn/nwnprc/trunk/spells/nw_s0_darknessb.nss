//::///////////////////////////////////////////////
//:: Darkness: On Exit
//:: NW_S0_DarknessB.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a globe of darkness around those in the area
    of effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Feb 28, 2002
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);

    object oTarget = GetExitingObject();
    object oCreator = GetAreaOfEffectCreator();
    if(DEBUG) DoDebug(GetName(oTarget) + " is leaving " + GetName(oCreator) + "'s darkness effect");

    int bValid = FALSE;
    effect eAOE;

    //Search through the valid effects on the target.
    eAOE = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eAOE))
    {
        int nType = GetEffectType(eAOE);
        int nID = GetEffectSpellId(eAOE);
        object oEffectCreator = GetEffectCreator(eAOE);

        if((nID == SPELL_DARKNESS                    ||
            nID == SPELLABILITY_AS_DARKNESS          ||
            nID == SPELL_SHADOW_CONJURATION_DARKNESS ||
            nID == 688                               || //bioware SLA darkness
            nID == SHADOWLORD_DARKNESS               ||
            nID == SPELL_RACE_DARKNESS               ||
            nID == SPELL_DEEPER_DARKNESS             ||
            nID == INVOKE_DARKNESS                   ||
            (nID == -1 && (GetObjectType(GetEffectCreator(eAOE)) == OBJECT_TYPE_ITEM) && GetLocalInt(OBJECT_SELF, "PRC_AoE_IPRP_Init")) // Item-based AoE
            )                                       &&
           GetEffectCreator(eAOE) == oCreator       &&
           nType != EFFECT_TYPE_AREA_OF_EFFECT
           )
        {
            if(DEBUG) DoDebug(GetName(oTarget) + " has an effect from " + GetName(oCreator) + "'s darkness effect");
            RemoveEffect(oTarget, eAOE);
        }

        //Get next effect on the target
        eAOE = GetNextEffect(oTarget);
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}
