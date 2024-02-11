//::///////////////////////////////////////////////
//:: Aura of Protection
//:: NW_S1_AuraProt.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Acts as a double strength Magic Circle against
    evil and a Minor Globe for those friends in
    the area.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: March 18, 2001
//:://////////////////////////////////////////////

// Modified 2004/01/30 (Brian Greinke)
// Added disable/reenable support
#include "prc_inc_spells"

void main()
{
    //first, look to see if effect is already activated
    if ( GetHasSpellEffect(SPELLABILITY_AURA_PROTECTION, OBJECT_SELF) )
    {
        PRCRemoveSpellEffects( SPELLABILITY_AURA_PROTECTION, OBJECT_SELF, OBJECT_SELF );
        return;
    }

    //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(AOE_MOB_PROTECTION);

    object oTarget = PRCGetSpellTargetObject();
    int nDuration = GetCasterLevel(OBJECT_SELF) / 2;
    int nMetaMagic = PRCGetMetaMagicFeat();
    //Make sure duration does no equal 0
    if (nDuration < 1)
    {
        nDuration = 1;
    }
    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oTarget, TurnsToSeconds(nDuration));
}
