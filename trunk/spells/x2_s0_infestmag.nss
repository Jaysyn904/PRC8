/*
    x2_s0_infestmag

    You infest  a target with maggotlike creatures.
    They deal 1d4 points of temporary Constitution
    damage each round. Each round the subject makes
    a new Fortitude save. The spell ends if the
    target succeeds at its saving throw.

    If the targets constitution would drop to 0
    through this spell, and the player is playing
    on hardcore difficulty, the target is
    is killed instantly.

    By: Andrew Nobbs
    Created: Nov 19, 2002
    Modified: Jun 30, 2006
*/
#include "prc_sp_func"
#include "prc_add_spell_dc"

void RunInfestImpact(object oTarget, object oCaster, int nSaveDC, int nMetaMagic)
{
    if (PRCGetDelayedSpellEffectsExpired(SPELL_INFESTATION_OF_MAGGOTS,oTarget,oCaster)) return;

    if (GetIsDead(oTarget) == FALSE)
    {
         int nDC = GetLocalInt(oTarget,"XP2_L_SPELL_SAVE_DC_" + IntToString (SPELL_INFESTATION_OF_MAGGOTS));
         if (!PRCMySavingThrow(SAVING_THROW_FORT,oTarget,nSaveDC,SAVING_THROW_TYPE_DISEASE,OBJECT_SELF))
         {
            effect eVis    = EffectVisualEffect   ( VFX_IMP_DISEASE_S );
            int    nDamage = d4(1);
            if ( nMetaMagic & METAMAGIC_MAXIMIZE ) nDamage = 4;
            if ( nMetaMagic & METAMAGIC_EMPOWER ) nDamage += nDamage / 2;
            effect eDam = ExtraordinaryEffect  ( EffectAbilityDecrease( ABILITY_CONSTITUTION, nDamage));
            SPApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget);
            if (GetAbilityScore(oTarget,ABILITY_CONSTITUTION)<=3 && GetGameDifficulty() >= GAME_DIFFICULTY_CORE_RULES)
            {
                  if (!GetImmortal(oTarget))
                 {
                     FloatingTextStrRefOnCreature(100932,oTarget);
                     effect eKill = PRCEffectDamage(oTarget, GetCurrentHitPoints(oTarget)+1);
                     SPApplyEffectToObject(DURATION_TYPE_INSTANT,eKill,oTarget);
                     effect eVfx = EffectVisualEffect(VFX_IMP_DEATH_L);
                     SPApplyEffectToObject(DURATION_TYPE_INSTANT,eVfx,oTarget);
                 }
            }
            else
            {
                 SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eDam, oTarget);
                 DelayCommand(6.0, RunInfestImpact(oTarget,oCaster,nSaveDC, nMetaMagic));
            }
         }
         else
         {
            DeleteLocalInt(oTarget,"XP2_L_SPELL_SAVE_DC_" + IntToString (SPELL_INFESTATION_OF_MAGGOTS));
            GZPRCRemoveSpellEffects(SPELL_INFESTATION_OF_MAGGOTS, oTarget);
         }
    }
}

//Implements the spell impact, put code here
//  if called in many places, return TRUE if
//  stored charges should be decreased
//  eg. touch attack hits
//
//  Variables passed may be changed if necessary
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)
{
    if(GetHasSpellEffect(SPELL_INFESTATION_OF_MAGGOTS, oTarget))
    {
        FloatingTextStrRefOnCreature(100775, oCaster, FALSE);
        return TRUE;
    }
    int nMetaMagic = PRCGetMetaMagicFeat();
    int CasterLvl = nCasterLevel;
    int nDuration  = 10 + CasterLvl;

    if ((nMetaMagic & METAMAGIC_EXTEND)) nDuration *= 2;

    float  fDist   = GetDistanceToObject(oTarget);
    float  fDelay  = fDist/25.0;
    int    nDC     = PRCGetSaveDC(oTarget, oCaster);
    effect eDur = EffectVisualEffect(VFX_DUR_FLIES);

    CasterLvl +=SPGetPenetr();
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_INFESTATION_OF_MAGGOTS));
        if(!PRCDoResistSpell(oCaster, oTarget,CasterLvl, fDelay))
        {
            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, RoundsToSeconds(nDuration)));
            SetLocalInt(oTarget,"XP2_L_SPELL_SAVE_DC_" + IntToString(SPELL_INFESTATION_OF_MAGGOTS), nDC);
            DelayCommand(fDelay+0.1f, RunInfestImpact(oTarget, oCaster, nDC, nMetaMagic));
        }
    }

    return TRUE;    //return TRUE if spell charges should be decremented
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
        DoSpell(oCaster, oTarget, nCasterLevel, nEvent);
    }
    else
    {
        if(nEvent & PRC_SPELL_EVENT_ATTACK)
        {
            if(DoSpell(oCaster, oTarget, nCasterLevel, nEvent))
                DecrementSpellCharges(oCaster);
        }
    }
    PRCSetSchool();
}