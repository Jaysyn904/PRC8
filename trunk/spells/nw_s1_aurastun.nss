//::///////////////////////////////////////////////
//:: Aura of Stunning
//:: NW_S1_AuraStun.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Upon entering the aura of the creature the player
    must make a will save or be stunned.
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
    if ( GetHasSpellEffect(SPELLABILITY_AURA_STUN, OBJECT_SELF) )
    {
        PRCRemoveSpellEffects( SPELLABILITY_AURA_STUN, OBJECT_SELF, OBJECT_SELF );
        return;
    }

    //Set and apply the AOE object
    effect eAOE = EffectAreaOfEffect(AOE_MOB_STUN);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, OBJECT_SELF, HoursToSeconds(100));
}
