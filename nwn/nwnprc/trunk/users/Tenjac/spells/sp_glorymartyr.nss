//:://////////////////////////////////////////////
//:: Name     Glory of the Martyr
//:: FileName   sp_glorymartyr.nss
//:://////////////////////////////////////////////
/** @file Abjuration [Good]
Level: Champion of Gwynharwyf 4, Paladin 4,
Components: V, S, AF, DF,
Casting Time: 1 standard action
Range: Close (25 ft. + 5 ft./2 levels)
Target: One creature/level
Duration: 1 hour/level (D)
Saving Throw: Will negates (harmless)
Spell Resistance: Yes (harmless)

Like shield other, this spell wards the subjects, 
creating a mystic connection between them and you 
so that some of their wounds are transferred to you.
The subjects each gain a +1 deflection bonus to AC
and a +1 resistance bonus on saves.

All the subjects take only half damage from all
wounds and attacks that deal them hit point damage.
The amount of damage not taken by all the warded
creatures is taken by you.

Forms of harm that do not involve hit points, such
as charm effects, temporary ability damage, level 
draining, and disintegration, are not affected.
If a subject suffers a reduction of hit points 
from a lowered Constitution score, the reduction 
is not split with you because it is not hit point damage.
When the spell ends, subsequent damage is no 
longer divided between you and the subjects, but 
damage already split is not reassigned to the 
subjects.

If you die while this spell is in effect, the spell 
ends in a burst of positive energy that restores 1d8
hit points to each subject.

If a subject moves out of range of the spell, that
subject's connection to you is severed but the spell 
continues as long as there is at least one subject
remaining and you remain alive.

Focus: A platinum ring (worth at least 50 gp) worn 
by you and each subject of the spell.
*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 1/28/21
//:://////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_add_spell_dc"

void DispelMonitor(object oManifester, object oTarget, int nSpellID, int nManifesterLevel, int nBeatsRemaining);

void main()
{
	if(!X2PreSpellCastCode()) return;
	PRCSetSchool(SPELL_SCHOOL_ABJURATION);
	object oPC = OBJECT_SELF;
        int nCasterLvl = PRCGetCasterLevel(oPC);
        float fDur =  HoursToSeconds(nCasterLvl);
        int nMetaMagic = PRCGetMetaMagicFeat();
        if(nMetaMagic & METAMAGIC_EXTEND) fDur += fDur;
        int nBeatsRemaining = FloatToInt(fDur)/6;
        int nMaxTargets = nCasterLvl;
        float fRadius = FeetToMeters(25.0f + (5.0f * (nCasterLvl / 2))))
        location lLoc = GetLocation(oPC);
        int nSpell = GetSpellId();
        effect eDurPos  = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_POSITIVE);
       	effect eDurNeg  = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
        
        object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, fRadius, lLoc, FALSE, OBJECT_TYPE_CREATURE);
        
        while(GetIsObjectValid(oTarget) && nMaxTargets >0)
        {
        	if(oTarget != oPC)
        	{
        		if(GetIsReactionTypeFriendly(oTarget))
        		{        			
        			// Get the OnHitCast: Unique on the caster's armor / hide
        			ExecuteScript("prc_keep_onhit_a", oPC);
        			
        			// Hook eventscript
        			AddEventScript(oPC, EVENT_ONHIT, "psi_pow_shrpnaux", TRUE, FALSE);
        			
        			// Store the target for use in the damage script
        			SetLocalObject(oPC, "PRC_Power_SharePain_Target", oTarget);
        			
        			//Apply bonuses to target
        			effect eLink = EffectLinkEffects(EffectACIncrease(1, AC_DEFLECTION_BONUS), EffectSavingThrowIncrease(SAVING_THROW_ALL, 1, SAVING_THROW_TYPE_ALL));
        			SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur);
        			
        			// Do VFX for the monitor to look for
        			SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDurNeg, oTarget, fDur, TRUE, nSpell, nCasterLvl);
        			SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDurPos, oPC, fDur, TRUE, nSpell, nCasterLvl);
				
				// Start effect end monitor
				DelayCommand(6.0f, DispelMonitor(oPC, oTarget, nSpell, nCasterLvl, nBeatsRemaining);
				nMaxTargets--;
			}
		}		
		oTarget = MyNextObjectInShape(SHAPE_SPHERE, fRadius, lLoc, FALSE, OBJECT_TYPE_CREATURE);
	}        
        PRCSetSchool();
}

void DispelMonitor(object oPC, object oTarget, int nSpellID, int CasterLvl, int nBeatsRemaining)
{
	// Has the power ended since the last beat, or does the duration run out now
	if((--nBeatsRemaining == 0) || 
	GetIsDead(oTarget) ||
	PRCGetDelayedSpellEffectsExpired(nSpellID, oTarget, oPC)     ||
	PRCGetDelayedSpellEffectsExpired(nSpellID, oPC, oPC) ||
	GetDistanceBetween(oPC, oTarget) > FeetToMeters(25.0f + (5.0f * (nCasterLvl / 2))))
	{
		if(DEBUG) DoDebug("Glory of the Martyr: Effect expired, clearing");
		// Clear the target local
		DeleteLocalObject(PC, "PRC_Power_SharePain_Target");
		// Remove the eventscript
		RemoveEventScript(oPC, EVENT_ONHIT, "psi_pow_shrpnaux", TRUE, FALSE);
		
		// Remove remaining effects
		PRCRemoveSpellEffects(nSpellID, oPC, oTarget);
		PRCRemoveSpellEffects(nSpellID, oPC, oPC);
	}
    	else 
    	{
    		nBeatsRemaining --;
    		DelayCommand(6.0f, DispelMonitor(oPC, oTarget, nSpellID, nCasterLvl, nBeatsRemaining));
    	
}