/*:://////////////////////////////////////////////
//:: Spell Name Ray of Frost
//:: Spell FileName PHS_S_RayOfFrost
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Evocation [Cold]
    Level: Sor/Wiz 0
    Components: V, S
    Casting Time: 1 standard action
    Range: Close (8M)
    Effect: Ray
    Duration: Instantaneous
    Saving Throw: None
    Spell Resistance: Yes

    A ray of freezing air and ice projects from your pointing finger. You must
    succeed on a ranged touch attack with the ray to deal damage to a target.
    The ray deals 1d3 points of cold damage.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As spell description.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_RAY_OF_FROST)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Ray touch attack
    int nTouch = PHS_SpellTouchAttack(PHS_TOUCH_RAY, oTarget, TRUE);

    // Damage is 1d3 - cold
    int nDam = PHS_MaximizeOrEmpower(3, 1, nMetaMagic, FALSE, nTouch);

    // Declare effects
    effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);

    // Signal event
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_RAY_OF_FROST);

    // Do hit/miss ray
    PHS_ApplyTouchBeam(oTarget, VFX_BEAM_COLD, nTouch);

    // Touch attack
    if(nTouch)
    {
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
