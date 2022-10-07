/*:://////////////////////////////////////////////
//:: Spell Name Blindness/Deafness
//:: Spell FileName SMP_S_BlindDeaf
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Necromancy
    Level: Brd 2, Clr 3, Sor/Wiz 2
    Components: V
    Casting Time: 1 standard action
    Range: Medium (20M)
    Target: One living creature
    Duration: Permanent (D)
    Saving Throw: Fortitude negates
    Spell Resistance: Yes

    You call upon the powers of unlife to render the subject blinded or deafened,
    as you choose.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Set to be a permament effect, but I bet resting takes it off.

    It cannot be set to non-magical incase they want to dispel it. Might make
    it Supernatural or Extraordinary if there is need for it, because really
    I bet it can't be dispelled.

    Sub-dial spell. 2 subdials are either Blindness or Deafness. Both useful,
    although Blindness is generally more hampering, deafness causes arcane
    spell failure.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!SMP_SpellHookCheck()) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nSpellSaveDC = SMP_GetSpellSaveDC();
    int nSpellId = GetSpellId();

    // Declare effects
    effect eVis = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eBad;
    effect eLink;

    // Check spell ID
    if(nSpellId == SMP_SPELL_BLINDNESS_DEAFNESS_DEAF)
    {
        eBad = EffectDeaf();
    }
    // Default to blind
    else //if(nSpellId == SMP_SPELL_BLINDNESS_DEAFNESS_BLIND)
    {
        eBad = EffectBlindness();
    }

    // Link final effects
    eLink = EffectLinkEffects(eBad, eCessate);

    // PvP Check
    if(!GetIsReactionTypeFriendly(oTarget) &&
    // Make sure they are not immune to spells
       !SMP_TotalSpellImmunity(oTarget))
    {
        // Signal Spell Cast At event
        SMP_SignalSpellCastAt(oTarget, SMP_SPELL_BLINDNESS_DEAFNESS);

        // Spell Resistance and Immunity check
        if(!SMP_SpellResistanceCheck(oCaster, oTarget))
        {
            // Fortitude save check
            if(!SMP_SavingThrow(SAVING_THROW_FORT, oTarget, nSpellSaveDC))
            {
                // Apply effects (Permamently!)
                SMP_ApplyPermanentAndVFX(oTarget, eVis, eLink);
            }
        }
    }
}
