//::///////////////////////////////////////////////
//:: Invisibilty Purge: On Enter
//:: NW_S0_InvPurgeA
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
     All invisible creatures in the AOE become
     visible.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////
//::March 31: Made it so it will actually remove
//  the effects of Improved Invisibility

#include "prc_inc_spells"

//------------------------------------------------------------------------------
// Doesn't care who the caster was removes the effects of the spell nSpell_ID.
// will ignore the subtype as well...
// GZ: Removed the check that made it remove only one effect.
//------------------------------------------------------------------------------
void PRCRemoveAnySpellEffects(int nSpell_ID, object oTarget)
{
    //Declare major variables

    effect eAOE;
    if(GetHasSpellEffect(nSpell_ID, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE))
        {
            //If the effect was created by the spell then remove it
            if(GetEffectSpellId(eAOE) == nSpell_ID)
            {
                RemoveEffect(oTarget, eAOE);
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
}

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);

    //Declare major variables
    object oTarget = GetEnteringObject();

    PRCRemoveAnySpellEffects(SPELL_IMPROVED_INVISIBILITY, oTarget);
    PRCRemoveAnySpellEffects(SPELL_INVISIBILITY, oTarget);
    PRCRemoveAnySpellEffects(SPELLABILITY_AS_INVISIBILITY , oTarget); 
    PRCRemoveAnySpellEffects(SPELLABILITY_AS_IMPROVED_INVISIBLITY , oTarget); 

    effect eInvis = GetFirstEffect(oTarget);




    int bIsImprovedInvis = FALSE;
    while(GetIsEffectValid(eInvis))
    {
        if (GetEffectType(eInvis) == EFFECT_TYPE_IMPROVEDINVISIBILITY)
        {
            bIsImprovedInvis = TRUE;
        }
        //check for invisibility
        if(GetEffectType(eInvis) == EFFECT_TYPE_INVISIBILITY || bIsImprovedInvis)
        {
            if(!GetIsReactionTypeFriendly(oTarget, GetAreaOfEffectCreator()))
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), SPELL_INVISIBILITY_PURGE));
            }
            else
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), SPELL_INVISIBILITY_PURGE, FALSE));
            }
            //remove invisibility
            RemoveEffect(oTarget, eInvis);
            if (bIsImprovedInvis)
            {
                PRCRemoveSpellEffects(SPELL_IMPROVED_INVISIBILITY, oTarget, oTarget);
            }
        }
        //Get Next Effect
        eInvis = GetNextEffect(oTarget);
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}
