//::///////////////////////////////////////////////
//:: Troglodyte Stench
//:: race_stench.nss
//:://////////////////////////////////////////////
/*
    Objects entering the aura must make a fortitude saving
    throw or or be sickened for 10 rounds
*/
//:://////////////////////////////////////////////
//:: Created By: xwarren
//:: Created On: 2011-05-05
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
    object oCaster = OBJECT_SELF;

    if(GetHasSpellEffect(SPELL_TROGLODYTE_STENCH))
    {
        PRCRemoveEffectsFromSpell(oCaster, SPELL_TROGLODYTE_STENCH);
        return;
    }

    effect eStench = EffectAreaOfEffect(AOE_MOB_TROGLODYTE_STENCH, "prc_TrogStenchA", "", "");
    eStench = ExtraordinaryEffect(eStench);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eStench, oCaster);
}