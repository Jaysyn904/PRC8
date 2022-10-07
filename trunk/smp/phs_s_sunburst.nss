/*:://////////////////////////////////////////////
//:: Spell Name Sunburst
//:: Spell FileName PHS_S_Sunburst
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Light spell. Long range. 26.6M burst! Reflex partial: else blinded and take
    full 6d6 damage. If light is harmful to the creature, double damage. SR
    applies.

    Undead take 1d6/caster level to 25d6. Half if reflex sucessful. If light
    is harmful to them, it kills any that fail the save.

    Oozes and slimes act like undead with this spell.

    Sunburst dispels any darkness spells of lower than 9th level within its area.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Darkness destroying not yet in (as darkness SPELL not yet in!)
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_SUNBURST)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lTarget = GetSpellTargetLocation();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nCasterLevel = PHS_GetCasterLevel();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nDam, bUndead, nRace;
    int nDice = PHS_LimitInteger(nCasterLevel, 25);
    float fDelay;

    // Duration is 1 round/level
    float fDuration = PHS_GetDuration(PHS_ROUNDS, nCasterLevel, nMetaMagic);

    // Declare effects
    effect eVis = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
    effect eDeath = EffectDeath();
    effect eBlind = EffectBlindness();
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    // Link blindness duration effects
    effect eLink = EffectLinkEffects(eBlind, eCessate);

    // We get the first in the beam
    // - Cylinder
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 26.67, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTarget))
    {
        // Reaction type check
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            // We don't mind applying the damage effects after a delay.
            fDelay = GetDistanceBetweenLocations(GetLocation(oTarget), lTarget)/20;

            // Signal event
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_SUNBURST);

            // Check spell resistance
            if(!PHS_SpellResistanceCheck(oCaster, oTarget, fDelay))
            {
                // Are they undead?
                nRace = GetRacialType(oTarget);
                if(nRace == RACIAL_TYPE_UNDEAD ||
                   nRace == RACIAL_TYPE_OOZE)
                {
                    bUndead = TRUE;
                }
                else
                {
                    bUndead = FALSE;
                }

                // Get damage to be done
                if(bUndead)
                {
                    // Up to 20d6
                    nDam = PHS_MaximizeOrEmpower(6, nDice, nMetaMagic);
                }
                else
                {
                    // 4d6 damage to non-undead
                    nDam = PHS_MaximizeOrEmpower(6, 4, nMetaMagic);

                    // Do they hate light?
                    if(PHS_GetHateSun(oTarget))
                    {
                        nDam *= 2;
                    }
                }
                // Check reflex save - special though. Immunities == Pass (can't be immune...really?)
                if(PHS_SavingThrow(SAVING_THROW_REFLEX, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_DIVINE, oCaster, fDelay))
                {
                    // Saved - half damage (or none with evasion)
                    if(GetHasFeat(FEAT_EVASION, oTarget) || GetHasFeat(FEAT_IMPROVED_EVASION, oTarget))
                    {
                        // None with evasions of any kind
                        nDam = 0;
                    }
                    else
                    {
                        // Else half damage anyway
                        nDam /= 2;
                    }
                }
                else // FAIL
                {
                    // Failed + Undead + Hate sun = Destroyed
                    if(bUndead == TRUE && PHS_GetHateSun(oTarget))
                    {
                        DelayCommand(fDelay, PHS_ApplyInstantAndVFX(oTarget, eVis, eDeath));
                        nDam = 0;
                    }
                    else
                    {
                        // Improved evasion always gives half damage
                        if(GetHasFeat(FEAT_IMPROVED_EVASION, oTarget))
                        {
                            nDam /= 2;
                        }
                        // + Blindness!
                        PHS_ApplyDuration(oTarget, eLink, fDuration);
                    }
                }
                // We apply damage
                DelayCommand(fDelay, PHS_ApplyDamageVFXToObject(oTarget, eVis, nDam, DAMAGE_TYPE_DIVINE));
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, 26.67, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
}
