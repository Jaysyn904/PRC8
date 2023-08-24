//::///////////////////////////////////////////////
//:: Name      Amber Sarcophagus
//:: FileName  sp_amber_sarc.nss
//:://////////////////////////////////////////////
/**@file Amber Sarcophagus
Evocation
Level: Sorcerer/wizard 7
Components: V,S,M
Casting Time: 1 standard action
Range: Close
Target: One creature
Duration: 1 day/level
Saving Throw: None
Spell Resistance: Yes

You infuse an amber sphere with magical power and
hurl it toward the target.  If you succeed on a
ranged touch attack, the amber strikes the target
and envelops it in coruscating energy that hardens
immediately, trapping the target within a
translucent, immobile amber shell.  The target is
perfectly preserved and held in stasis, unharmed
yet unable to take any actions.  Within the amber
sarcophagus, the target is protected against all
attacks, including purely mental ones.

The amber sarcophagus has hardness 5 and 10hp per
caster level(maximum 200hp). If it is reduced to
0 hp, it shatters and crumbles to worhless amber
dust, at which point the target is released from
stasis (although it is flat footed until next
turn).  Left alone, the amber sarcophagus traps
the target for the duration of the spell, then
disappears before releasing the target from
captive stasis.

Material Component: An amber sphere worth at
least 500 gp.

Author:    Tenjac
Created:   6/19/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

void SarcMonitor(object oTarget, object oPC, int nNormHP);
void RemoveSarc(object oTarget, object oPC);
void MakeImmune(object oTarget, float fDur);

#include "prc_inc_sp_tch"
#include "prc_add_spell_dc"

void main()
{
        if(!X2PreSpellCastCode()) return;

        PRCSetSchool(SPELL_SCHOOL_EVOCATION);

        object oPC = OBJECT_SELF;
        object oTarget = PRCGetSpellTargetObject();
        int nCasterLvl = PRCGetCasterLevel(oPC);
        int nMetaMagic = PRCGetMetaMagicFeat();
        float fDur = HoursToSeconds(24 * nCasterLvl);

        if(nMetaMagic & METAMAGIC_EXTEND)
        {
                fDur += fDur;
        }

        PRCSignalSpellEvent(oTarget,TRUE, SPELL_AMBER_SARCOPHAGUS, oPC);

        //Make touch attack
        int nTouch = PRCDoRangedTouchAttack(oTarget);

        if(nTouch)
        {
                //Sphere projectile VFX

                if(!PRCDoResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
                {
                        //Get starting HP
                        int nNormHP = GetCurrentHitPoints(oTarget);

                        //Apply effects
                        effect eSarc = EffectLinkEffects(EffectTemporaryHitpoints(10 * min(20, nCasterLvl)), EffectCutsceneParalyze());
                               eSarc = EffectLinkEffects(eSarc, EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MAJOR));

                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSarc, oTarget, fDur, TRUE, PRCGetSpellId(), nCasterLvl);

                        //Make immune to pretty much everything
                        MakeImmune(oTarget, fDur);

                        SarcMonitor(oPC, oTarget, nNormHP);
                }
        }
        PRCSetSchool();
}

void SarcMonitor(object oPC, object oTarget, int nNormHP)
{
        int nHP = GetCurrentHitPoints(oTarget);

        if(nHP <= nNormHP)
        {
                RemoveSarc(oTarget, oPC);
        }

        else
        {
                DelayCommand(3.0f, SarcMonitor(oPC, oTarget, nNormHP));

        }
}

void RemoveSarc(object oTarget, object oPC)
{
        effect eTest = GetFirstEffect(oTarget);

        while(GetIsEffectValid(eTest))
        {
                if(GetEffectSpellId(eTest) == SPELL_AMBER_SARCOPHAGUS)
                {
                        if(GetEffectCreator(eTest) == oPC)
                        {
                                RemoveEffect(oTarget, eTest);
                        }
                }
                eTest = GetNextEffect(oTarget);
        }
}

void MakeImmune(object oTarget, float fDur)
{
        effect eLink;
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_BLINDNESS));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_DEAFNESS));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_DEATH));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_DISEASE));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_ENTANGLE));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_SLOW));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_KNOCKDOWN));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_NEGATIVE_LEVEL));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_PARALYSIS));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_SILENCE));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_SNEAK_ATTACK));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_TRAP));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS));

               SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur);
}