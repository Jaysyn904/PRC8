//::///////////////////////////////////////////////
//:: Aura of Fear
//:: NW_S1_AuraFear.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Upon entering the aura of the creature the player
    must make a will save or be struck with fear because
    of the creatures presence.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 25, 2001
//:://////////////////////////////////////////////
#include "prc_inc_spells"

void main()
{
    object oPC = OBJECT_SELF;

    if(GetHasSpellEffect(SPELL_HOUND_AURAMENACE))
    {
        PRCRemoveEffectsFromSpell(oPC, SPELL_HOUND_AURAMENACE);
        return;
    }

    //Set and apply AOE object
    effect eAOE = ExtraordinaryEffect(EffectAreaOfEffect(AOE_MOB_FEAR,"hound_aurafeara"));
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAOE, oPC);
}