/*:://////////////////////////////////////////////
//:: Spell Name Wall of Thorns: On Enter
//:: Spell FileName PHS_S_WallofThoA
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Damage on enter. This applies to both round and wall.

    Ok, so the round will damage anyone when cast, so what? Maybe have a
    "Growth" from the point. After that, it'll only damage things who enter...
    I'd use it to protect myself personally.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Check AOE creator.
    if(!PHS_CheckAOECreator()) return;

    // Declare Major Variables
    object oCreator = GetAreaOfEffectCreator();
    object oTarget = GetEnteringObject();
    int nCasterLevel = PHS_GetAOECasterLevel();

    // Damage starts at 25
    int nDamage = 25;
    int nReduce;

    // Declare major effects
    effect eSlow = EffectMovementSpeedDecrease(70);
    effect eDur = EffectVisualEffect(VFX_DUR_ENTANGLE);
    effect eLink = EffectLinkEffects(eDur, eSlow);

    // PvP Check, Do damage
    if(!GetIsReactionTypeFriendly(oTarget, oCreator) &&
    // Make sure they are not immune to spells
       !PHS_TotalSpellImmunity(oTarget))
    {
        // Fire cast spell at event for the target
        PHS_SignalSpellCastAt(oTarget, PHS_SPELL_WALL_OF_THORNS);

        // Spell Resistance check
        if(!PHS_SpellResistanceCheck(oCreator, oTarget))
        {
            // Get proper damage
            // - Reduce it by shield and armor amount
            nReduce += GetItemACValue(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget));
            nReduce += GetItemACValue(GetItemInSlot(INVENTORY_SLOT_CHEST, oTarget));
            // (Not perfect compared to "ignore dexterity and dodge bonuses" but
            // a damn sight easier!)

            // Get new damage
            nDamage -= nReduce;

            // Check if can do damage
            if(nDamage > 0)
            {
                PHS_ApplyDamageToObject(oTarget, nDamage, DAMAGE_TYPE_SLASHING);
            }
        }
    }

    // Always apply some slow for a short duration
    PHS_ApplyDuration(oTarget, eLink, PHS_GetRandomDelay(2.0, 6.0));
}
