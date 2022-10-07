/*
18/02/19 by Stratovarius

Tomb of Night

Master, Ebon Walls 
Level/School: 8th/Conjuration (Creation) 
Range: Close (25 ft. + 5 ft./2 levels) 
Target: One Huge or smaller creature 
Duration: 1 round/level
Saving Throw: Fortitude negates; see text 
Spell Resistance: Yes

You solidify extraplanar shadow, creating a solid prison of darkness.

This mystery immobilizes the subject in a prison of shadowstuff. This prison blocks both line of effect and line of sight to the creature inside it, and is impenetrable from the 
outside. The creature inside the prison takes 3d6 points of cold damage at the beginning of each round that it remains inside the prison. Once each round as a standard action, a 
creature caught in the prison can attempt a Fortitude saving throw against the spell’s original DC to break out of the prison. Success means that the creature can move out of the 
prison, and it fades to nothingness. Failure means that the creature gains a negative level and remains trapped.
*/

#include "shd_inc_shdfunc"
#include "shd_mysthook"
#include "inc_timestop"

void PrisonNight(struct mystery myst, object oTarget, int nCount)
{
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, MetashadowsDamage(myst, 6, 3), DAMAGE_TYPE_COLD), oTarget);
    
    if((--nCount == -1)                                         || // Is the power expiring now
       PRCGetDelayedSpellEffectsExpired(MYST_TOMB_NIGHT, oTarget, myst.oShadow)  || // Or has it expired already
       (PRCMySavingThrow(SAVING_THROW_FORT, oTarget, myst.nSaveDC, SAVING_THROW_TYPE_SPELL))       // Or does the creature succeed at its Save
       )
    {
        if(DEBUG) DoDebug("psi_pow_timehop: Power expired or Wis check succeeded, clearing");

        // Remove the effects
        PRCRemoveSpellEffects(MYST_TOMB_NIGHT, myst.oShadow, oTarget);
    }
    else
    {
        SPApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectNegativeLevel(1), oTarget);
        DelayCommand(6.0f, PrisonNight(myst, oTarget, nCount));    
    }    
}

void main()
{
    if(!ShadPreMystCastCode()) return;

    object oShadow      = OBJECT_SELF;
    object oTarget      = PRCGetSpellTargetObject();
    struct mystery myst = EvaluateMystery(oShadow, oTarget, (METASHADOW_EXTEND | METASHADOW_EMPOWER | METASHADOW_MAXIMIZE));

    if(myst.bCanMyst)
    {
        myst.fDur = RoundsToSeconds(myst.nShadowcasterLevel);
        if(myst.bExtend) myst.fDur *= 2;   
        myst.nPen = ShadowSRPen(oShadow, myst.nShadowcasterLevel);
        SignalEvent(oTarget, EventSpellCastAt(oShadow, myst.nMystId));
        myst.oShadow = oShadow;
        myst.nSaveDC = GetShadowcasterDC(oShadow);
        
        if (PRCGetCreatureSize(oTarget) > CREATURE_SIZE_HUGE)
        {
            FloatingTextStringOnCreature("The target creature is too large for Prison of Night", oShadow, FALSE);
            return;
        }
        
        myst.eLink      =                               EffectCutsceneParalyze();
        myst.eLink      = EffectLinkEffects(myst.eLink, EffectCutsceneGhost());
        myst.eLink      = EffectLinkEffects(myst.eLink, EffectEthereal());
        myst.eLink      = EffectLinkEffects(myst.eLink, EffectSpellImmunity(SPELL_ALL_SPELLS));
        myst.eLink      = EffectLinkEffects(myst.eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_ACID,        100));
        myst.eLink      = EffectLinkEffects(myst.eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING, 100));
        myst.eLink      = EffectLinkEffects(myst.eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_DIVINE,      100));
        myst.eLink      = EffectLinkEffects(myst.eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL,  100));
        myst.eLink      = EffectLinkEffects(myst.eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE,        100));
        myst.eLink      = EffectLinkEffects(myst.eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_MAGICAL,     100));
        myst.eLink      = EffectLinkEffects(myst.eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_NEGATIVE,    100));
        myst.eLink      = EffectLinkEffects(myst.eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_PIERCING,    100));
        myst.eLink      = EffectLinkEffects(myst.eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_POSITIVE,    100));
        myst.eLink      = EffectLinkEffects(myst.eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING,    100));
        myst.eLink      = EffectLinkEffects(myst.eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_SONIC,       100)); 
        
        // Only creatures, and PvP check.
        if(spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oShadow))
        {
            // Check Spell Resistance
            if(!PRCDoResistSpell(oShadow, oTarget, myst.nPen))
            {                
                // Apply effect. Not dispellable
               SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, myst.eLink, oTarget, myst.fDur, FALSE);
               // Start Heartbeat
               DelayCommand(6.0f, PrisonNight(myst, oTarget, (FloatToInt(myst.fDur) / 6) - 1));
            }    
        }        
    }
}