//Spell script for reserve feat Protective Ward
//prc_reservprtwrd
//by ebonfowl
//Dedicated to Edgar, the real Ebonfowl

#include "prc_sp_func"
#include "prc_inc_sp_tch"
#include "prc_add_spell_dc"

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();

    effect eEffect, eVis;

    int nSpellID = PRCGetSpellId();
    int nBonus, nDuration;

    nBonus = GetLocalInt(oPC, "ProtectiveWardBonus");
    nDuration = 1;
            
    eEffect = EffectACIncrease(nBonus, AC_DODGE_BONUS);
    eEffect = SupernaturalEffect(eEffect);
    eVis = EffectVisualEffect(VFX_IMP_AC_BONUS);

    if (nBonus == 0) 
    {
        FloatingTextStringOnCreature("You do not have a spell available of adequate level or type", oPC, FALSE);
        return;
    }

    if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
    {
        //Remove existing spell effects to prevent stacking
        GZPRCRemoveSpellEffects(nSpellID, oTarget, FALSE);

        //Apply effects
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, RoundsToSeconds(nDuration));
    }
}