//::///////////////////////////////////////////////
//:: Death Knell
//:: sp_deathknell.nss
//:://////////////////////////////////////////////
/*
Death Knell
Necromancy [Death, Evil]
Level:            Clr 2, Death 2
Components:       V, S
Casting Time:     1 standard action
Range:            Touch
Target:           Living creature touched
Duration:         Instantaneous/10 minutes per HD
                  of subject; see text
Saving Throw:     Will negates
Spell Resistance: Yes


You draw forth the ebbing life force of a creature
and use it to fuel your own power. Upon casting
this spell, you touch a living creature that has
-1 or fewer hit points. If the subject fails its
saving throw, it dies, and you gain 1d8 temporary
hit points and a +2 bonus to Strength.
Additionally, your effective caster level goes up
by +1, improving spell effects dependent on caster
level. (This increase in effective caster level
does not grant you access to more spells.) These
effects last for 10 minutes per HD of the subject
creature.
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: Sept 13, 2004
//:://////////////////////////////////////////////

#include "prc_inc_sp_tch"
#include "prc_sp_func"
#include "prc_add_spell_dc"

int DoSpell(object oCaster, object oTarget, int nCasterLevel)
{
    int iAttackRoll = PRCDoMeleeTouchAttack(oTarget);

    if(iAttackRoll)
    {
        int nMetaMagic = PRCGetMetaMagicFeat();
        int nPenetr = nCasterLevel + SPGetPenetr();

        float fDuration = TurnsToSeconds(GetHitDice(oTarget));
        if(nMetaMagic & METAMAGIC_EXTEND)
            fDuration *= 2;

        int nBonus = d8(1);
        if(nMetaMagic & METAMAGIC_MAXIMIZE)
            nBonus = 8;
        if(nMetaMagic & METAMAGIC_EMPOWER)
            nBonus += (nBonus / 2);

        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
        effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, 2);
        effect eHP = EffectTemporaryHitpoints(nBonus);

        effect eVis2 = EffectVisualEffect(VFX_IMP_DEATH_L);
        effect eVis = EffectVisualEffect(VFX_IMP_HOLY_AID);

        effect eLink = EffectLinkEffects(eStr, eDur);

        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_DEATH_KNELL));

        if(GetCurrentHitPoints(oTarget) < 10 && PRCGetIsAliveCreature(oTarget))
        {
            if(!PRCDoResistSpell(oCaster, oTarget, nPenetr))
            {
                if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, PRCGetSaveDC(oTarget, oCaster), SAVING_THROW_TYPE_DEATH))
                {
                    //Apply the VFX impact and effects
                    DeathlessFrenzyCheck(oTarget);
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget);
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);

                    if(GetIsDead(oTarget))
                    {
                        //Remove previous bonuses
                        PRCRemoveEffectsFromSpell(oCaster, SPELL_DEATH_KNELL);
                        //Apply the bonuses to the PC
                        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oCaster);
                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, fDuration, TRUE, SPELL_DEATH_KNELL, nCasterLevel);
                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHP, oCaster, fDuration, TRUE, SPELL_DEATH_KNELL, nCasterLevel);
                    }
                }
            }
        }
        else
        {
            FloatingTextStringOnCreature("*Death Knell failure: The target isn't weak enough*", oCaster, FALSE);
        }
    }

    return iAttackRoll;    //return TRUE if spell charges should be decremented
}

void main()
{
    if (!X2PreSpellCastCode()) return;
    PRCSetSchool(SPELL_SCHOOL_NECROMANCY);
    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    int nEvent = GetLocalInt(oCaster, PRC_SPELL_EVENT); //use bitwise & to extract flags
    if(!nEvent) //normal cast
    {
        if(GetLocalInt(oCaster, PRC_SPELL_HOLD) && oCaster == oTarget)
        {   //holding the charge, casting spell on self
            SetLocalSpellVariables(oCaster, 1);   //change 1 to number of charges
            return;
        }
        DoSpell(oCaster, oTarget, nCasterLevel);
    }
    else
    {
        if(nEvent & PRC_SPELL_EVENT_ATTACK)
        {
            if(DoSpell(oCaster, oTarget, nCasterLevel))
                DecrementSpellCharges(oCaster);
        }
    }
    PRCSetSchool();
}