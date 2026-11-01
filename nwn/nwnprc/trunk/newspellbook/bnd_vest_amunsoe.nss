/*
OnEnter script for Amun-her Khepeshef's Scion of War 60-ft Aura (bnd_vest_amunsoe)
*/
#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = GetAreaOfEffectCreator();
    if (!GetIsObjectValid(oBinder) ||
        !GetHasSpellEffect(VESTIGE_AMUN_HER, oBinder) ||
        !GetLocalInt(oBinder, "AmunScionAuraActive"))
    {
        DestroyObject(OBJECT_SELF);
        return;
    }

    object oTarget = GetEnteringObject();
    if (!GetIsObjectValid(oTarget))
        return;

    if (GetIsFriend(oTarget, oBinder) || oTarget == oBinder)
    {
        int nBonus = 2 * GetAbilityModifier(ABILITY_CHARISMA, oBinder);
        if (nBonus > 0)
        {
            SetLocalInt(oTarget, "AmunScionAuraBonus", nBonus);
            SetLocalObject(oTarget, "AmunScionAuraSource", oBinder);
        }
    }
}
