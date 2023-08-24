//::///////////////////////////////////////////////
//:: Frenzied Berserker - Remove effects of Supreme Power Attack
//:: NW_S1_frebzk
//:: Copyright (c) 2004
//:://////////////////////////////////////////////
/*
    Removes bonuses of Supreme Power Attack
*/
//:://////////////////////////////////////////////
//:: Created By: Oni5115
//:: Created On: Aug 23, 2004
//:://////////////////////////////////////////////

#include "prc_effect_inc"

void main()
{
    object oPC = OBJECT_SELF;

    if(GetHasFeatEffect(FEAT_FRENZY, oPC))
    {
        int willSave = WillSave(oPC, 20, SAVING_THROW_TYPE_NONE, oPC);
        if(willSave == 1)
        {
            PRCRemoveSpellEffects(SPELL_FRENZY, oPC, oPC);
            PRCRemoveSpellEffects(SPELL_SUPREME_POWER_ATTACK, oPC, oPC);
        }
    }
}