/*
Heartbeat script for Amun-her Khepeshef's Scion of War 60-ft Aura (bnd_vest_amunsoh)
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

    int nBonus = 2 * GetAbilityModifier(ABILITY_CHARISMA, oBinder);
    if (nBonus < 0) nBonus = 0;

    location lLoc = GetLocation(oBinder);
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(60.0), lLoc, FALSE, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oTarget))
    {
        if (GetIsFriend(oTarget, oBinder) || oTarget == oBinder)
        {
            SetLocalInt(oTarget, "AmunScionAuraBonus", nBonus);
            SetLocalObject(oTarget, "AmunScionAuraSource", oBinder);
        }
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(60.0), lLoc, FALSE, OBJECT_TYPE_CREATURE);
    }
}
