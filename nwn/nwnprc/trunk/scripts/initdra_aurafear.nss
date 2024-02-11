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
#include "prc_alterations"
void main()
{
    int iLvl = GetAbilityModifier(ABILITY_CHARISMA,OBJECT_SELF);

    int AOESize = AOE_MOB_FEAR;

   if (iLvl>2)
        AOESize = AOE_MOB_DRAGON_FEAR;

 SendMessageToPC(OBJECT_SELF," Size" +IntToString(AOESize));
    //Set and apply AOE object
    effect eAOE = ExtraordinaryEffect(EffectAreaOfEffect(AOESize,"initdr_aurafeara"));
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAOE, OBJECT_SELF);
}
