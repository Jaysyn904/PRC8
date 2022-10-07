/*:://////////////////////////////////////////////
//:: Spell Name Ray of Force
//:: Spell FileName XXX_S_RayOfForce
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Evocation
    Level: Sor/Wiz 2
    Components: V, S
    Casting Time: 1 standard action
    Range: Medium (20M)
    Effect: Ray
    Duration: Instant
    Saving Throw: None
    Spell Resistance: Yes
    Source: Various (Josh_Kablack)

    You snap your fingers and point at a target, causing a tangible ray of
    gunmetal blue force to project forth from your finger. You must succeed at a
    ranged touch attack to hit a target. The ray deals 2d6 points of force
    damage to your target plus an additional +1 point per caster level (maximum +10).
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Force damage is magical damage. Left in for now, like magic missile.

    Easily done. Cap was +20, but now +10, inline with other level 2 spells.

    Visual is a projectile.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!SMP_SpellHookCheck(SMP_SPELL_RAY_OF_FORCE)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = SMP_GetMetaMagicFeat();
    int nCasterLevel = SMP_GetCasterLevel();
    // Ray touch attack
    int nTouch = SMP_SpellTouchAttack(SMP_TOUCH_RAY, oTarget, TRUE);

    // Bonus to damage
    int nBonus = SMP_LimitInteger(nCasterLevel, 10);

    // Damage is 2d6 + 1/caster level - magical
    int nDam = SMP_MaximizeOrEmpower(6, 2, nMetaMagic, nBonus, nTouch);

    // Declare effects
    effect eVis = EffectVisualEffect(VFX_IMP_MAGBLUE);

    // Signal event
    SMP_SignalSpellCastAt(oTarget, SMP_SPELL_RAY_OF_FORCE);

    // Touch attack
    if(nTouch)
    {
        // PvP check
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            // Resistance
            if(!SMP_SpellResistanceCheck(oCaster, oTarget))
            {
                // Apply effects
                SMP_ApplyDamageVFXToObject(oTarget, eVis, nDam);
            }
        }
    }
}
