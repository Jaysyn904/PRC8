/*:://////////////////////////////////////////////
//:: Spell Name Sunbeam
//:: Spell FileName PHS_S_Sunbeam
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    20M range, level 7, SR applies, 1 round level or up to 3 beams (1 per
    3 caster levels, max 6). Beam is in a line.

    Each in beam are blinded and take 4d6 damage, double if they don't like
    sunlight. Reflex save halfs damage and stops blindness.

    Undead (and oozes) take 1d6/level, to 20d6. Halfed if reflex save, and if any
    are harmed by light it destroys them if it fails save.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    If called from an item, and the item is specifically the ability item, then
    it will call a new beam out of the allotment.

    Beam is 1.5M in left/right sorta size.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_SUNBEAM)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lTarget = GetSpellTargetLocation();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nCasterLevel = PHS_GetCasterLevel();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nDam, bUndead, nRace;
    int nDice = PHS_LimitInteger(nCasterLevel, 20);
    float fDelay;

    // Charges - 1 per 3 levels, max 6.
    int nCharges = PHS_LimitInteger(nCasterLevel/3, 6);

    // Duration is 1 round/level for both the item and the blindness.
    float fDuration = PHS_GetDuration(PHS_ROUNDS, nCasterLevel, nMetaMagic);

    // Check caster item
    if(!PHS_CheckChargesForSpell(PHS_SPELL_SUNBEAM, nCharges, fDuration)) return;

    // Declare effects
    effect eVis = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
    effect eDeath = EffectDeath();
    effect eBlind = EffectBlindness();
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    // Link blindness duration effects
    effect eLink = EffectLinkEffects(eBlind, eCessate);

    // We get the first in the beam
    // - Cylinder
    oTarget = GetFirstObjectInShape(SHAPE_SPELLCYLINDER, 20.0, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTarget))
    {
        // Reaction type check
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            fDelay = GetDistanceToObject(oTarget)/20;

            // Signal event
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_SUNBEAM);

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
        oTarget = GetNextObjectInShape(SHAPE_SPELLCYLINDER, 20.0, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
}
