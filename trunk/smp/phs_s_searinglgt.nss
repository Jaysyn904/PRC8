/*:://////////////////////////////////////////////
//:: Spell Name Searing Light
//:: Spell FileName PHS_S_SearingLgt
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    20M, ray, SR applies, no save. Ranged touch attack.
    Normal creature: 1d8/2 levels (to 5d8)
    Undead: 1d6/level (max 10d6)
    Undead who hates light: 1d8/level (max 10d8)
    Construct/inanimate object: 1d6/2 levels (max 5d6)
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As spell description. Similar to bioware one - needs a touch attack, however!

    Spell file similar to Ray of Frost.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_SEARING_LIGHT)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nRace = GetRacialType(oTarget);
    int nObjectType = GetObjectType(oTarget);
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Needs a touch attack
    int nTouch = PHS_SpellTouchAttack(PHS_TOUCH_RAY, oTarget, TRUE);

    // Damage is dependant on target race.
    int nDam, nDice, nSides;
    // Undead - max damage, 1dX/level
    if(nRace == RACIAL_TYPE_UNDEAD)
    {
        // 1dX a level
        nDice = PHS_LimitInteger(nCasterLevel, 10);
        // If special undead who hates sun, we do extra damage
        if(PHS_GetHateSun(oTarget))
        {
            // up to 10d8 (3-80)
            nSides = 8;
        }
        else
        {
            // up to 10d6 - still really powerful (3-60)
            nSides = 6;
        }
    }
    else
    {
        // Max of 1dX/2 levels
        nDice = PHS_LimitInteger(nCasterLevel/2, 5);
        // If construct/any non-creature, 1d6/2 levels, to 5d6.
        if(nRace == RACIAL_TYPE_CONSTRUCT || nObjectType != OBJECT_TYPE_CREATURE)
        {
            // Max 5d6
            nSides = 6;
        }
        // Anything else - Max of 5d8 - 1d8/2 levels
        else
        {
            // Max 5d8
            nSides = 8;
        }
    }
    // Define nDam
    nDam = PHS_MaximizeOrEmpower(nSides, nDice, nMetaMagic, FALSE, nTouch);

    // Declare effects
    effect eVis = EffectVisualEffect(VFX_IMP_SUNSTRIKE);

    // Signal event
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_SEARING_LIGHT);

    // Do ray visual
    PHS_ApplyTouchBeam(oTarget, VFX_BEAM_HOLY, nTouch);

    // Touch attack
    if(nTouch)
    {
        // PvP check and spell immunity check
        if(!GetIsReactionTypeFriendly(oTarget) &&
            PHS_TotalSpellImmunity(oTarget))
        {
            // Resistance
            if(!PHS_SpellResistanceCheck(oCaster, oTarget))
            {
                // Apply damage and VFX
                PHS_ApplyDamageVFXToObject(oTarget, eVis, nDam, DAMAGE_TYPE_DIVINE);
            }
        }
    }
}
