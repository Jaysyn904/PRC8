//::///////////////////////////////////////////////
//:: Magic Circle Against Evil
//:: NW_S0_CircEvil.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
//:: [Description of File]
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: March 18, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 11, 2001

#include "prc_inc_spells"

void main()
{
    object oPC = OBJECT_SELF;
    int nSpellID = GetSpellId();

    if(!GetHasSpellEffect(nSpellID))
    {
        effect eBonus = ExtraordinaryEffect(EffectAreaOfEffect(AOE_MOB_CIRCEVIL, "fist_circevila", "", "fist_circevilb"));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBonus, oPC);
        //FloatingTextStringOnCreature("*Magic Circle Against Evil Activated*", OBJECT_SELF, FALSE);
    }
    else
    {
        PRCRemoveEffectsFromSpell(oPC, nSpellID);
        //FloatingTextStringOnCreature("*Magic Circle Against Evil Deactivated*", OBJECT_SELF, FALSE);
    }
}

