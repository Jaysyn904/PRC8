//::///////////////////////////////////////////////
//:: DNecro - Fear Aura
//:: prc_dnc_fearaura.nss
//:://////////////////////////////////////////////
//:: Fear Aura
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: May 16, 2009
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
    object oPC = OBJECT_SELF;

    if(GetHasSpellEffect(SPELL_DREADNECRO_FEARAURA))
    {
        PRCRemoveEffectsFromSpell(oPC, SPELL_DREADNECRO_FEARAURA);
        return;
    }

    effect eAOE = EffectAreaOfEffect(AOE_MOB_DN_FEAR_AURA);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAOE, oPC);
}