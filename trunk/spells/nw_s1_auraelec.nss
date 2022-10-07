//::///////////////////////////////////////////////
//:: Aura of Electricity
//:: NW_S1_AuraElec.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Prolonged exposure to the aura of the creature
    causes electrical damage to all within the aura.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 25, 2001
//:://////////////////////////////////////////////

// Modified 2004/01/30 (Brian Greinke)
// Added disable/reenable support
#include "prc_alterations"

void main()
{
    //first, look to see if effect is already activated
    if ( GetHasSpellEffect(SPELLABILITY_AURA_ELECTRICITY, OBJECT_SELF) )
    {
        PRCRemoveSpellEffects( SPELLABILITY_AURA_ELECTRICITY, OBJECT_SELF, OBJECT_SELF );
        return;
    }

    //Set and apply AOE object
    effect eAOE = EffectAreaOfEffect(AOE_MOB_ELECTRICAL);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, OBJECT_SELF, HoursToSeconds(100));
}
