//::///////////////////////////////////////////////
//:: Poison Weapon OnHit spellscript
//:: poison_onhit
//::///////////////////////////////////////////////
/*
    The weapon used to trigger this should contain two
    local ints:
    pois_wpn_idx  - The number of poison to use. Matched
                    against poison.2da
    pois_wpn_uses - The number of uses remaining.

    The script first makes sure that both ints contain
    valid values. If uses is 0 or less, they are both
    removed along with the itemproperty.
    The removal also happens when uses run out.

    The actual effect is an EffectPoison being applied
    to the target. The poison used is determined by
    pois_wpn_idx.

*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 12.12.2004
//:: Updated On: 20.12.2004
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "inc_poison"


void main()
{
    object oWeapon = GetSpellCastItem();
    object oTarget = PRCGetSpellTargetObject();
    object oPC     = GetLastAttacker(oTarget);
    int nPoisonIdx = GetLocalInt(oWeapon, "pois_wpn_idx");
    int nUses      = GetLocalInt(oWeapon, "pois_wpn_uses");

    if(DEBUG) DoDebug("poison_wpn_onhit running\n"
                    + "oWeapon = " + DebugObject2Str(oWeapon) + "\n"
                    + "oTarget = " + DebugObject2Str(oTarget) + "\n"
                    + "oPC = " + DebugObject2Str(oPC) + "\n"
                    + "nPoisonIdx = " + IntToString(nPoisonIdx) + "\n"
                    + "nUses = " + IntToString(nUses) + "\n"
                      );

    /* Make sure the weapon is poisoned. This is pretty much paranoia, but
     * there could be cases of something wiping the local variables, but leaving
     * the temporary itemproperty around.
     */
    if(nUses <= 0)
    {
        DoPoisonRemovalFromWeapon(oWeapon);
        return;
    }

    // Apply the poison to target
    effect ePoison = EffectPoison(nPoisonIdx);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoison, oTarget);

    // Remove one from the use counter and see if the poison wore off
    nUses -= 1;

    if(nUses <= 0)
    {
        DoPoisonRemovalFromWeapon(oWeapon);

        // If a player was wielding the weapon, inform them
        object oPC = GetLastAttacker(oTarget);
        if(GetIsPC(oPC))
            SendMessageToPCByStrRef(oPC, STRREF_POISON_WORN_OFF);
    }
    else
        SetLocalInt(oWeapon, "pois_wpn_uses", nUses);
}
