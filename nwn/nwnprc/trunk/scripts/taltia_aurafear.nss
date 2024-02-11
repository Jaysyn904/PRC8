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

    if(GetHasSpellEffect(SPELL_TOT_FRIGHTFUL_PRESENCE))
    {
        PRCRemoveEffectsFromSpell(oPC, SPELL_TOT_FRIGHTFUL_PRESENCE);
        return;
    }

    int AOESize = GetAbilityModifier(ABILITY_CHARISMA, oPC) > 2 ? AOE_MOB_DRAGON_FEAR : AOE_MOB_FEAR;

    SendMessageToPC(oPC," Size" +IntToString(AOESize));
    //Set and apply AOE object
    effect eAOE = ExtraordinaryEffect(EffectAreaOfEffect(AOESize, "taltia_aurafeara"));
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAOE, oPC);
}