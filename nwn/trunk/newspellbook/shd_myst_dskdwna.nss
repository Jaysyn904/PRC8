/*
12/02/19 by Stratovarius

Dusk and Dawn, OnEnter

Apprentice, Shutters and Clouds 
Level/School: 1st/Evocation 
Range: Close (25 ft. + 5 ft./2 levels) 
Area: 20-ft.-radius emanation centered on a point in space 
Duration: 10 minutes/level (D) 
Saving Throw: None 
Spell Resistance: No

By drawing shade from the Plane of Shadow, or banishing the shadows back to it, you control the level of illumination in the area.

You make a dark area lighter or a light area darker, blanketing the affected area in shadowy illumination. Creatures with darkvision can see through this area normally.
*/

#include "shd_inc_shdfunc"

void DeadlyShade(object oTarget, struct mystery myst);

void main()
{
    object oShadow = GetAreaOfEffectCreator();
    object oTarget  = GetEnteringObject();
    object oAoE     = OBJECT_SELF;
    effect eDark = EffectDarkness();
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink = EffectLinkEffects(eDark, eDur);
    
    struct mystery myst = GetLocalMystery(oShadow, MYST_HOLD_MYST+"6");  

    if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oShadow))
    {
        //Fire cast spell at event for the target
        SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), SPELL_DARKNESS));

        //Apply reduced movement effect and VFX_Impact
        SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget, 0.0f, FALSE);
    }// end if - Difficulty check
    if (myst.nMystId == MYST_DEADLY_SHADE_DR && GetIsFriend(oShadow, oTarget))
    {
        eLink = EffectLinkEffects(EffectDamageResistance(DAMAGE_TYPE_PIERCING, 4), EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING, 4));
        eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_SLASHING, 4));
        eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_FIRE, 4));
        eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_COLD, 4));
        eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_ACID, 4));
        eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, 4));
        eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_SONIC, 4));
        eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_BLUESHIELDPROTECT));
        SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget, 0.0f, FALSE);
    }
    if (myst.nMystId == MYST_DEADLY_SHADE_NEG)
    {
        SetLocalInt(oTarget, "DeadlyShade", TRUE);
        SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget, 0.0f, FALSE);
        DeadlyShade(oTarget, myst);
    } 
    if (myst.nMystId == MYST_FEARFUL_GLOOM)
    {
    	if (GetHitDice(oTarget) > 4)
    	{
            if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, myst.nSaveDC, SAVING_THROW_TYPE_FEAR))
            {
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectFrightened(), oTarget, RoundsToSeconds(d6(2)), TRUE, myst.nMystId, myst.nShadowcasterLevel);
            }
            else 
            	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectShaken(), oTarget, RoundsToSeconds(1), TRUE, myst.nMystId, myst.nShadowcasterLevel);
        } 
        else 
        	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectFrightened(), oTarget, RoundsToSeconds(d6(2)), TRUE, myst.nMystId, myst.nShadowcasterLevel);
    }  
    if (myst.nMystId == MYST_SICKENING_SHADOW)
    {
        if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, myst.nSaveDC, SAVING_THROW_TYPE_SPELL))
        {
        	float fDur = RoundsToSeconds(d4(1));
        	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectNausea(oTarget, fDur), oTarget, fDur, TRUE, myst.nMystId, myst.nShadowcasterLevel);
        	DelayCommand(fDur, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSickened(), oTarget, RoundsToSeconds(d6(2)), TRUE, myst.nMystId, myst.nShadowcasterLevel));
        }
        else 
        	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSickened(), oTarget, RoundsToSeconds(d6(2)), TRUE, myst.nMystId, myst.nShadowcasterLevel);
    }     
}

void DeadlyShade(object oTarget, struct mystery myst)
{
    if (GetLocalInt(oTarget, "DeadlyShade"))
    {
        int nLast = GetLocalInt(oTarget, "DeadlyShadeHP");
        int nCur = GetCurrentHitPoints(oTarget);
        SetLocalInt(oTarget, "DeadlyShadeHP", nCur);
        
        if (nLast > nCur)
        {
            if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, myst.nSaveDC, SAVING_THROW_TYPE_SPELL))
            {
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectNegativeLevel(1), oTarget, HoursToSeconds(myst.nShadowcasterLevel), TRUE, myst.nMystId, myst.nShadowcasterLevel);               
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_NEGBLAST_ENERGY), oTarget);
            }
        }
        
        DelayCommand(1.0, DeadlyShade(oTarget, myst));
    }
}