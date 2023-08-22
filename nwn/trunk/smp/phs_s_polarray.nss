/*:://////////////////////////////////////////////
//:: Spell Name Polar Ray
//:: Spell FileName PHS_S_PolarRay
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Evocation [Cold]
    Level: Sor/Wiz 8
    Components: V, S, F
    Casting Time: 1 standard action
    Range: Close (8M)
    Effect: Ray
    Duration: Instantaneous
    Saving Throw: None
    Spell Resistance: Yes

    A blue-white ray of freezing air and ice springs from your hand. You must
    succeed on a ranged touch attack with the ray to deal damage to a target.
    The ray deals 1d6 points of cold damage per caster level (maximum 25d6).

    Focus: A small, white ceramic cone or prism.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Touch attack (ray) for 1d6 caster level, max 25d6.

    It has more rays then the standard cold ray. It will create some placeables
    just next to the target's location :-)
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_POLAR_RAY)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Ray ranged touch attack
    int nTouch = PHS_SpellTouchAttack(PHS_TOUCH_RAY, oTarget, TRUE);

    // Up to 25d6 damage
    int nDice = PHS_LimitInteger(nCasterLevel, 25);

    // Damage is up to 25d6 (Double for critical, its a ray)
    int nDam = PHS_MaximizeOrEmpower(6, nDice, nMetaMagic, FALSE, nTouch);

    // Delcare effects
    effect eVis = EffectVisualEffect(VFX_IMP_FROST_L);

    // Signal event
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_POLAR_RAY);

    // Do ray hit/miss
    PHS_ApplyTouchBeam(oTarget, VFX_BEAM_COLD, nTouch);

    // Touch attack
    if(nTouch)
    {
        // Apply cool Visuals along the ray in inteverals of 0.05 seconds.
        PHS_ApplyBeamAlongVisuals(VFX_IMP_FROST_S, oCaster, oTarget, 1.0);

        // PvP check
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            // Resistance
            if(!PHS_SpellResistanceCheck(oCaster, oTarget))
            {
                // Apply effects
                PHS_ApplyDamageVFXToObject(oTarget, eVis, nDam, DAMAGE_TYPE_COLD);
            }
        }
    }
}
