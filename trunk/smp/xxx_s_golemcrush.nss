/*:://////////////////////////////////////////////
//:: Spell Name Golem Crusher
//:: Spell FileName XXX_S_GolemCrush
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Evocation [Force]
    Level: Sor/Wiz 6
    Components: V, S
    Casting Time: 1 standard action
    Range: Close (8M)
    Target: One Golem
    Duration: Instantaneous
    Saving Throw: Reflex half
    Spell Resistance: No
    Source: Various (law)

    This spell was made to kill golems when other spells could not. A small
    wave of force comes from the casters hand he must make a ranged touch
    attack to hit his target. This spell deals 1d8 points of force damage per
    caster level (max 20d8 points of force damage). The damage can only effect
    golems.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As the spell says.

    Yes, maybe this is a little powerful, but it needs a touych attack AND a
    reflex save for half damage.

    Sure, it passes right through golem SR though!
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!SMP_SpellHookCheck(SMP_SPELL_GOLEM_CRUSHER)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = SMP_GetMetaMagicFeat();
    int nSpellSaveDC = SMP_GetSpellSaveDC();
    int nCasterLevel = SMP_GetCasterLevel();

    // Ranged touch attack
    int nTouch = SMP_SpellTouchAttack(SMP_TOUCH_RANGED, oTarget, TRUE);

    // Dice is 1 per level.
    int nDice = SMP_LimitInteger(nCasterLevel, 20);

    // Get damage
    int nDam = SMP_MaximizeOrEmpower(8, nDice, nMetaMagic, FALSE, nTouch);

    // Declare effects
    effect eVis = EffectVisualEffect(VFX_IMP_MAGBLUE);

    // Signal event
    SMP_SignalSpellCastAt(oTarget, SMP_SPELL_GOLEM_CRUSHER);

    // Touch attack
    if(nTouch)
    {
        // PvP check and check if construct
        if(!GetIsReactionTypeFriendly(oTarget) &&
            GetRacialType(oTarget) == RACIAL_TYPE_CONSTRUCT)
        {
            // Reflex save
            nDam = SMP_GetAdjustedDamage(SAVING_THROW_REFLEX, nDam, oTarget, nSpellSaveDC);

            if(nDam > 0)
            {
                // Apply damage effects
                SMP_ApplyDamageVFXToObject(oTarget, eVis, nDam);
            }
        }
    }
}
