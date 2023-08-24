/*:://////////////////////////////////////////////
//:: Spell Name Dismissal
//:: Spell FileName PHS_S_Dismissal
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Abjuration
    Level: Clr 4, Sor/Wiz 5
    Components: V, S, DF
    Casting Time: 1 standard action
    Range: Close (8M)
    Target: One extraplanar creature
    Duration: Instantaneous
    Saving Throw: Will negates; see text
    Spell Resistance: Yes

    This spell forces an extraplanar creature (outsider) back to its proper
    plane if it fails a special Will save
    (DC = spell’s save DC - creature’s HD + your caster level). If the spell
    is successful, the creature is instantly whisked away, but there is a 20%
    chance of actually sending the subject to a plane other than its own.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    We can't do this completely unless we know this outsider isn't already
    on thier plane!

    But the rest is easy enough.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_DISMISSAL)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nCasterLevel = PHS_GetCasterLevel();

    // The save DC:
    // DC = spell’s save DC - creature’s HD + your caster level
    int nSpellSaveDC = PHS_GetSpellSaveDC() - GetHitDice(oTarget) + nCasterLevel;

    // Declare effects
    effect eVis = EffectVisualEffect(VFX_IMP_UNSUMMON);

    // Needs to be a non-PvP person, and an outsider race
    if(GetRacialType(oTarget) == RACIAL_TYPE_OUTSIDER &&
      !GetIsReactionTypeFriendly(oTarget))
    {
        // Signal spell cast at
        PHS_SignalSpellCastAt(oTarget, PHS_SPELL_DISMISSAL);

        // Check spell resistance
        if(!PHS_SpellResistanceCheck(oCaster, oTarget))
        {
            // Will save against the effects
            if(!PHS_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC))
            {
                // Failed - send them back
                if(GetIsPC(oTarget))
                {
                    // Kill PC's (as they'll be shapechanged, most likely)
                    PHS_ApplyDeathByDamageAndVFX(oTarget, eVis);
                }
                else
                {
                    // Destroy them for no XP
                    if(PHS_CanCreatureBeDestroyed(oTarget))
                    {
                        // Apply AOE visual
                        PHS_ApplyLocationVFX(GetLocation(oTarget), eVis);
                        DestroyObject(oTarget);
                    }
                }
            }
        }
    }
}
