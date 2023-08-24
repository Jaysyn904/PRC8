//::///////////////////////////////////////////////
//:: Aura of Unnatural
//:: NW_S1_AuraMencA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Upon entering the aura all animals are struck with
    fear.
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
    if ( GetHasSpellEffect(SPELLABILITY_AURA_UNNATURAL, OBJECT_SELF) )
    {
        PRCRemoveSpellEffects( SPELLABILITY_AURA_UNNATURAL, OBJECT_SELF, OBJECT_SELF );
        return;
    }

    //Set and apply the AOE object
    effect eAOE = EffectAreaOfEffect(AOE_MOB_UNNATURAL);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, OBJECT_SELF, HoursToSeconds(100));
}
