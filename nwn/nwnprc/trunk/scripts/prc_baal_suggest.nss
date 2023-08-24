//::///////////////////////////////////////////////
//:: [Charm Person]
//:: [NW_S0_CharmPer.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Will save or the target is charmed for 1 round
//:: per caster level.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 29, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 5, 2001
//:: Last Updated By: Preston Watamaniuk, On: April 10, 2001
//:: VFX Pass By: Preston W, On: June 20, 2001


//:: modified by mr_bumpkin Dec 4, 2003

#include "inc_newspellbook" 
#include "prc_inc_core"

void main()
{
    int nLevel = GetLevelByClass(CLASS_TYPE_DISC_BAALZEBUL);
    int nDC    = 10 + nLevel + GetAbilityModifier(ABILITY_CHARISMA);
    DoRacialSLA(SPELL_CHARM_PERSON, nLevel, nDC);
}
