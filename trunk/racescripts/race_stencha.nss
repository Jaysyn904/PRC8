//::///////////////////////////////////////////////
//:: Troglodyte Stench On Enter
//:: race_stencha.nss
//:://////////////////////////////////////////////
/*
    Objects entering the aura must make a fortitude saving
    throw or or be sickened for 10 rounds
*/
//:://////////////////////////////////////////////
//:: Created By: xwarren
//:: Created On: 2011-05-05
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
    // Declare major variables
    object oTarget = GetEnteringObject();
    object oSource = GetAreaOfEffectCreator();

    // Troglodytes are immune
    if(GetRacialType(oTarget) == RACIAL_TYPE_TROGLODYTE
    || GetIsImmune(oTarget, IMMUNITY_TYPE_POISON))
        return;

    effect eSick;

    if(!GetHasSpellEffect(SPELL_TROGLODYTE_STENCH, oTarget))
    {
        // Is the target a valid creature
        if(PRCGetIsAliveCreature(oTarget)
        && !GetIsReactionTypeFriendly(oTarget, oSource))
        {
            // Notify the target that they are being attacked
            SignalEvent(oTarget, EventSpellCastAt(oSource, SPELL_TROGLODYTE_STENCH));

            // Prepare the visual effect for the casting and saving throw
            effect eVis1 = EffectVisualEffect(VFX_IMP_POISON_S);
            effect eVis2 = EffectVisualEffect(VFX_IMP_FORTITUDE_SAVING_THROW_USE);
            effect eImmune = EffectVisualEffect(VFX_DUR_CESSATE_NEUTRAL);
                   eImmune = ExtraordinaryEffect(eImmune);

            // Create the sickened effect
            // and make it supernatural so it can be dispelled
            eSick = SupernaturalEffect(EffectSickened());

            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);

            // DC is constitution based
            int nDC = 10 + (GetHitDice(oSource) / 2) + GetAbilityModifier(ABILITY_CONSTITUTION, oSource);

            // Make a Fortitude saving throw and apply the effect if it fails
            if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_POISON, oSource))
            {
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis1, oTarget);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSick, oTarget, RoundsToSeconds(10));
            }
            else
                // if save was sucessful - immune to stench for 24h.
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eImmune, oTarget, HoursToSeconds(24));
        }
    }
}
