//::///////////////////////////////////////////////
//:: Name      Scintillating Pattern
//:: FileName  sp_scint_pattrn.nss
//:://////////////////////////////////////////////
/**@file Scintillating Pattern
Illusion (Pattern) [Mind-Affecting]
Level: Sor/Wiz 8 
Components: V, S, M 
Casting Time: 1 standard action 
Range: Close (25 ft. + 5 ft./2 levels) 
Effect: Colorful lights in a 20-ft.-radius spread 
Duration: Concentration + 2 rounds 
Saving Throw: None 
Spell Resistance: Yes

A twisting pattern of discordant, coruscating colors
weaves through the air, affecting creatures within it.
The spell affects a total number of Hit Dice of 
creatures equal to your caster level (maximum 20).
Creatures with the fewest HD are affected first; 
and, among creatures with equal HD, those who are 
closest to the spell’s point of origin are affected
first. Hit Dice that are not sufficient to affect a
creature are wasted. The spell affects each subject
according to its Hit Dice.

6 or less: Unconscious for 1d4 rounds, then stunned 
for 1d4 rounds, and then confused for 1d4 rounds. 
(Treat an unconscious result as stunned for nonliving
creatures.)

7 to 12: Stunned for 1d4 rounds, then confused for 
1d4 rounds.

13 or more: Confused for 1d4 rounds.

Sightless creatures are not affected by 
scintillating pattern.

Material Component: A small crystal prism.

Author:    Tenjac
Created:   7/6/07
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
        if(!X2PreSpellCastCode()) return;
        
        PRCSetSchool(SPELL_SCHOOL_ILLUSION);
        
        object oPC = OBJECT_SELF;
        object oTarget;
        location lTarget = PRCGetSpellTargetLocation();
        int nSpellSaveDC;
        int nMetaMagic = PRCGetMetaMagicFeat();
        int nCasterLvl = PRCGetCasterLevel();        
        // Other locals
        string sSpellLocal = "SPELL_SCINTILLATING_PATTERN" + ObjectToString(oPC);
        
        // Durations are different for each effect.
        float fDuration, fDuration2, fDuration3;
        
        // Knockdown
        effect eKnockdown = EffectKnockdown();
        
        // Confusion
        effect eConfusionLink = EffectLinkEffects(PRCEffectConfused(), EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED));
        effect eConfusionVis = EffectVisualEffect(VFX_IMP_CONFUSION_S);        
        
        // Stun
        effect eStunLink = EffectLinkEffects(EffectStunned(), EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE));
        effect eStunVis = EffectVisualEffect(VFX_IMP_STUN);     
        
        // Apply AOE visual
        effect eImpact = EffectVisualEffect(VFX_FNF_SCINTILLATING_PATTERN);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget, 0.0f);
        
        int nHD = PRCMin(nCasterLvl, 20);
        float fDistance;
        int bContinueLoop, nCurrentHD, nLow;
        object oLowest;        
        
        // Get the first target in the spell area
        oTarget = GetFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(20.0), lTarget, TRUE);
        // If no valid targets exists ignore the loop
        if(GetIsObjectValid(oTarget))
        {
                bContinueLoop = TRUE;
        }
        // The above checks to see if there is at least one valid target.
        while((nHD > 0) && (bContinueLoop))
        {
                nLow = 99;
                bContinueLoop = FALSE;
                //Get the first creature in the spell area
                oTarget = GetFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(20.0), lTarget, TRUE);
                while(GetIsObjectValid(oTarget))
                {
                        // Already affected check
                        if(!GetLocalInt(oTarget, sSpellLocal))
                        {
                                // Make faction check to ignore allies
                                if(!GetIsReactionTypeFriendly(oTarget) &&
                                // Make sure they are not immune to spells
                                !PRCGetHasEffect(EFFECT_TYPE_SPELL_IMMUNITY, oTarget) &&
                                // Must be alive
                                PRCGetIsAliveCreature(oTarget))
                                {
                                        //Get the current HD of the target creature
                                        nCurrentHD = GetHitDice(oTarget);
                                        
                                        // Check to see if the HD are lower than the current Lowest HD stored and that the
                                        // HD of the monster are lower than the number of HD left to use up.
                                        if(nCurrentHD <= nHD && ((nCurrentHD < nLow) ||
                                        (nCurrentHD <= nLow &&
                                        GetDistanceBetweenLocations(lTarget, GetLocation(oTarget)) <= fDistance)))
                                        {
                                                nLow = nCurrentHD;
                                                fDistance = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget));
                                                oLowest = oTarget;
                                                bContinueLoop = TRUE;
                                        }
                                }
                                else
                                {
                                        // Immune to it in some way, ignore on next pass
                                        SetLocalInt(oTarget, sSpellLocal, TRUE);
                                        DelayCommand(0.1, DeleteLocalInt(oTarget, sSpellLocal));
                                }
                        }
                        //Get the next target in the shape
                        oTarget = GetNextObjectInShape(SHAPE_SPHERE, FeetToMeters(20.0), lTarget, TRUE);
                }
                // Check to see if oLowest returned a valid object
                if(GetIsObjectValid(oLowest))
                {
                        // Fire cast spell at event for the specified target
                        PRCSignalSpellEvent(oLowest, TRUE, SPELL_SCINTILLATING_PATTERN, oPC);
                        
                        // Set a local int to make sure the creature is not used twice in the
                        // pass.  Destroy that variable in 0.1 seconds to remove it from
                        // the creature
                        SetLocalInt(oLowest, sSpellLocal, TRUE);
                        DelayCommand(0.1, DeleteLocalInt(oLowest, sSpellLocal));
                                        
                        // Make SR check, immunity check
                        if(!PRCDoResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()) && !GetIsImmune(oLowest, IMMUNITY_TYPE_MIND_SPELLS))
                        {
                                // No save! But effects based on HD
                                if(nLow <= 6)
                                {
                                        // 1-6, Knockdown, Stun then Confusion.
                                        fDuration = RoundsToSeconds(d4(1));
                                        if(nMetaMagic & METAMAGIC_EXTEND) fDuration += fDuration;
                                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oLowest, fDuration, TRUE, SPELL_SCINTILLATING_PATTERN, nCasterLvl);
                                        // Delay the next one
                                        fDuration2 = RoundsToSeconds(d4(1));
                                        if(nMetaMagic & METAMAGIC_EXTEND) fDuration2 += fDuration2;
                                        DelayCommand(fDuration, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStunVis, oLowest, fDuration2, TRUE, SPELL_SCINTILLATING_PATTERN, nCasterLvl));
                                        DelayCommand(fDuration, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStunLink, oLowest, fDuration2, TRUE, SPELL_SCINTILLATING_PATTERN, nCasterLvl));                                        
                                        
                                        // Delay the next one
                                        fDuration3 = RoundsToSeconds(d4(1));
                                        if(nMetaMagic & METAMAGIC_EXTEND) fDuration3 += fDuration3;
                                        DelayCommand(fDuration2, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eConfusionVis, oLowest, fDuration3, TRUE, SPELL_SCINTILLATING_PATTERN, nCasterLvl));
                                        DelayCommand(fDuration2, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eConfusionLink, oLowest, fDuration3, TRUE, SPELL_SCINTILLATING_PATTERN, nCasterLvl));          
                                }
                                
                                else if(nLow <= 12)
                                {
                                        // 7-12 Stunned for 1d4 rounds, then confused for 1d4 rounds
                                        fDuration = RoundsToSeconds(d4(1));
                                        if(nMetaMagic & METAMAGIC_EXTEND) fDuration += fDuration;
                                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStunLink, oLowest, fDuration, TRUE, SPELL_SCINTILLATING_PATTERN, nCasterLvl);
                                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStunVis, oLowest, fDuration, TRUE, SPELL_SCINTILLATING_PATTERN, nCasterLvl);
                                        // Delay the next one
                                        fDuration2 = RoundsToSeconds(d4(1));
                                        if(nMetaMagic & METAMAGIC_EXTEND) fDuration2 += fDuration2;
                                        DelayCommand(fDuration, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eConfusionVis, oLowest, fDuration2, TRUE, SPELL_SCINTILLATING_PATTERN, nCasterLvl));
                                        DelayCommand(fDuration, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eConfusionLink, oLowest, fDuration2, TRUE, SPELL_SCINTILLATING_PATTERN, nCasterLvl));          
                                }
                                else //if(nLow >= 13)
                                {
                                        // 13+ Confused 1d4 rounds
                                        fDuration = RoundsToSeconds(d4(1));
                                        if(nMetaMagic & METAMAGIC_EXTEND) fDuration += fDuration;
                                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eConfusionVis, oLowest, fDuration);
                                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eConfusionLink, oLowest, fDuration, TRUE, SPELL_SCINTILLATING_PATTERN, nCasterLvl);          
                                }
                        }
                }
                // Remove the HD of the creature from the total
                nHD = nHD - GetHitDice(oLowest);
                oLowest = OBJECT_INVALID;
        }
}