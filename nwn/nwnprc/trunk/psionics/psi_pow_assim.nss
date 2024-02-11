/** @file psi_pow_assim

    Assimilate

    Psychometabolism
    Level: Psion/wilder 9
    Manifesting Time: 1 standard action
    Range: Touch
    Target: One living creature touched
    Duration: Instantaneous and 1 hour; see text
    Saving Throw: Fortitude half
    Power Resistance: Yes
    Power Points: 17
    Metapsionics: Empower, Maximize, Twin

    Your pointing finger turns black as obsidian. A creature touched by you is
    partially assimilated into your form and takes 20d6 points of damage. Any
    creature reduced to 0 or fewer hit points by this power is killed, entirely
    assimilated into your form, leaving behind only a trace of fine dust. An
    assimilated creature’s equipment is unaffected.

    A creature that is partially assimilated into your form (that is, a creature
    that has at least 1 hit point following your use of this power) grants you a
    number of temporary hit points equal to half the damage you dealt for 1
    hour.

    A creature that is completely assimilated grants you a number of temporary
    hit points equal to the damage you dealt and a +4 bonus to each of your
    ability scores for 1 hour. If the assimilated creature knows psionic powers,
    you gain knowledge of one of its powers for 1 hour.


    @todo Gaining a temporary power

    @author Stratovarius
    @date   Created: Feb 26, 2005
    @date   Modified: Jul 3, 2006
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_sp_func"
#include "prc_inc_sp_tch"

int DoPower(object oManifester, object oTarget, struct manifestation manif)
{
    int nPen = GetPsiPenetration(oManifester);
    int nDamage, nTouchAttack;
    int bHit = 0;

    effect eVis  = EffectVisualEffect(VFX_COM_HIT_NEGATIVE);
    effect eLink =                          EffectAbilityIncrease(ABILITY_CHARISMA,     4);
           eLink = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_CONSTITUTION, 4));
           eLink = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_DEXTERITY,    4));
           eLink = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_INTELLIGENCE, 4));
           eLink = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_STRENGTH,     4));
           eLink = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_WISDOM,       4));
           eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MAJOR));

    PRCSignalSpellEvent(oTarget, TRUE, manif.nSpellID, oManifester);

    int nRepeats = manif.bTwin ? 2 : 1;
    for(; nRepeats > 0; nRepeats--)
    {
        nTouchAttack = PRCDoMeleeTouchAttack(oTarget);
        if(nTouchAttack > 0)
        {
            bHit = 1;
            if((PRCMyResistPower(oManifester, oTarget, nPen) == POWER_RESIST_FAIL) && PRCGetIsAliveCreature(oTarget))
            {
                // Determine damage
                int nNumberOfDice = 20;
                int nDieSize      = 6;
                int nDamage       = MetaPsionicsDamage(manif, nDieSize, nNumberOfDice, 0, 0, TRUE, FALSE);
                // Fort save for half
                if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, GetManifesterDC(oManifester), SAVING_THROW_TYPE_NONE))
                {
                    nDamage /= 2;
                if (GetHasMettle(oTarget, SAVING_THROW_FORT))
                // This script does nothing if it has Mettle, bail
                    nDamage = 0;
                }
                nDamage = GetTargetSpecificChangesToDamage(oTarget, manif.oManifester, nDamage);
                // Apply damage and the accompanying VFX
                ApplyTouchAttackDamage(manif.oManifester, oTarget, nTouchAttack, nDamage, DAMAGE_TYPE_MAGICAL);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                // Give the temp HP, and if the target was dead, the stat boosts
                effect eTempHP;
                if(GetIsDead(oTarget))
                {
                    eTempHP = EffectTemporaryHitpoints(nDamage);
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, manif.oManifester, HoursToSeconds(1), TRUE, -1, manif.nManifesterLevel);
                }
                else
                    eTempHP = EffectTemporaryHitpoints(nDamage / 2);

                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTempHP, manif.oManifester, HoursToSeconds(1), TRUE, -1, manif.nManifesterLevel);
            }
        }
    }

    return bHit;    //Held charge is used if at least 1 touch from twinned power hits
}

void main()
{
    if(!PsiPrePowerCastCode()) return;
    object oManifester = OBJECT_SELF;
    object oTarget     = PRCGetSpellTargetObject();
    struct manifestation manif;
    int nEvent = GetLocalInt(oManifester, PRC_SPELL_EVENT); //use bitwise & to extract flags
    if(!nEvent) //normal cast
    {
        manif =
            EvaluateManifestation(oManifester, oTarget,
                                  PowerAugmentationProfile(),
                                  METAPSIONIC_EMPOWER | METAPSIONIC_MAXIMIZE | METAPSIONIC_TWIN
                                  );

        if(manif.bCanManifest)
        {
            if(GetLocalInt(oManifester, PRC_SPELL_HOLD) && oManifester == oTarget)
            {   //holding the charge, manifesting power on self
                SetLocalSpellVariables(oManifester, 1);   //change 1 to number of charges
                SetLocalManifestation(oManifester, PRC_POWER_HOLD_MANIFESTATION, manif);
                return;
            }
            DoPower(oManifester, oTarget, manif);
        }
    }
    else
    {
        if(nEvent & PRC_SPELL_EVENT_ATTACK)
        {
            manif = GetLocalManifestation(oManifester, PRC_POWER_HOLD_MANIFESTATION);
            if(DoPower(oManifester, oTarget, manif))
                DecrementSpellCharges(oManifester);
        }
    }
}