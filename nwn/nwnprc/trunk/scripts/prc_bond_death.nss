//::///////////////////////////////////////////////
//:: Name       Bonded summoner familiar death eventhook
//:: FileName   prc_bond_death
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    When a bonded summoners familiar dies,
    the summoner takes 1d4 damage to each stat
    plus damage equal to the familiars HD
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

#include "prc_alterations"

void main()
{
    object oPC = GetMaster(OBJECT_SELF);
    if(!GetIsObjectValid(oPC))
        return;
    ApplyAbilityDamage(oPC, ABILITY_STRENGTH,     d4(), DURATION_TYPE_PERMANENT);
    ApplyAbilityDamage(oPC, ABILITY_DEXTERITY,    d4(), DURATION_TYPE_PERMANENT);
    ApplyAbilityDamage(oPC, ABILITY_CONSTITUTION, d4(), DURATION_TYPE_PERMANENT);
    ApplyAbilityDamage(oPC, ABILITY_INTELLIGENCE, d4(), DURATION_TYPE_PERMANENT);
    ApplyAbilityDamage(oPC, ABILITY_WISDOM,       d4(), DURATION_TYPE_PERMANENT);
    ApplyAbilityDamage(oPC, ABILITY_CHARISMA,     d4(), DURATION_TYPE_PERMANENT);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(GetHitDice(OBJECT_SELF)), oPC);
}