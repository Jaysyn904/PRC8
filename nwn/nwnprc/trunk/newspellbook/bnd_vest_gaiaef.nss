/*
Elemental Fortitude for Gaia (4 sub-radials: Acid, Cold, Electricity, Fire)
Grants 100% immunity to the chosen element. 5-round cooldown on switching.
*/
#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = OBJECT_SELF;
    int nSpellId = PRCGetSpellId();
    if (!BindAbilCooldown(oBinder, VESTIGE_GAIA_ELEM_MASTER_SPELL, VESTIGE_GAIA)) return;

    int nDamType = DAMAGE_TYPE_ACID;
    int nVfx = VFX_IMP_ACID_L;
    string sElem = "Acid";
    if (nSpellId == VESTIGE_GAIA_ELEM_COLD_SPELL)
    {
        nDamType = DAMAGE_TYPE_COLD;
        nVfx = VFX_IMP_FROST_L;
        sElem = "Cold";
    }
    else if (nSpellId == VESTIGE_GAIA_ELEM_ELEC_SPELL)
    {
        nDamType = DAMAGE_TYPE_ELECTRICAL;
        nVfx = VFX_IMP_LIGHTNING_S;
        sElem = "Electricity";
    }
    else if (nSpellId == VESTIGE_GAIA_ELEM_FIRE_SPELL)
    {
        nDamType = DAMAGE_TYPE_FIRE;
        nVfx = VFX_IMP_FLAME_M;
        sElem = "Fire";
    }

    effect eCheck = GetFirstEffect(oBinder);
    while (GetIsEffectValid(eCheck))
    {
        if (GetEffectTag(eCheck) == "GaiaElemFort")
            RemoveEffect(oBinder, eCheck);
        eCheck = GetNextEffect(oBinder);
    }

    effect eImm = TagEffect(SupernaturalEffect(EffectDamageImmunityIncrease(nDamType, 100)), "GaiaElemFort");
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eImm, oBinder, HoursToSeconds(24));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(nVfx), oBinder);
    SetLocalInt(oBinder, "GaiaElemFortType", nDamType);
    FloatingTextStringOnCreature("Gaia Elemental Fortitude switched to 100% " + sElem + " Immunity.", oBinder, FALSE);
}
