//::///////////////////////////////////////////////
//:: Aura of Menace
//:: NW_S1_AuraMenac.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Upon entering the aura all creatures of type animal
    are struck with fear.
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
    if ( GetHasSpellEffect(SPELLABILITY_AURA_MENACE, OBJECT_SELF) )
    {
        PRCRemoveSpellEffects( SPELLABILITY_AURA_MENACE, OBJECT_SELF, OBJECT_SELF );
        return;
    }

    //Set and apply AOE object
    effect eAOE = EffectAreaOfEffect(AOE_MOB_MENACE);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, OBJECT_SELF, HoursToSeconds(100));
}
