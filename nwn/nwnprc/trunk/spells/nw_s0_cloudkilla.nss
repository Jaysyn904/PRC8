//::///////////////////////////////////////////////
//:: Cloudkill: On Enter
//:: NW_S0_CloudKillA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Cloudkill
	Conjuration (Creation)
	Level: 	Sor/Wiz 5
	Components: 	V, S
	Casting Time: 	1 standard action
	Range: 	Medium (100 ft. + 10 ft./level)
	Effect: 	Cloud spreads in 20-ft. radius, 20 ft. high
	Duration: 	1 min./level
	Saving Throw: 	Fortitude partial; see text
	Spell Resistance: 	No

	This spell generates a bank of fog, similar to a fog 
	cloud, except that its vapors are yellowish green and poisonous. 
	These vapors automatically kill any living creature with 3 or 
	fewer HD (no save). A living creature with 4 to 6 HD is slain 
	unless it succeeds on a Fortitude save (in which case it takes 
	1d4 points of Constitution damage on your turn each round while 
	in the cloud).

	A living creature with 6 or more HD takes 1d4 points of Constitution 
	damage on your turn each round while in the cloud (a successful 
	Fortitude save halves this damage). Holding one’s breath doesn’t 
	help, but creatures immune to poison are unaffected by the spell.

	Unlike a fog cloud, the cloudkill moves away from you at 10 feet per 
	round, rolling along the surface of the ground.

	Figure out the cloud’s new spread each round based on its new point 
	of origin, which is 10 feet farther away from the point of origin 
	where you cast the spell.

	Because the vapors are heavier than air, they sink to the lowest 
	level of the land, even pouring down den or sinkhole openings. It 
	cannot penetrate liquids, nor can it be cast underwater. 
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////


//:: modified by mr_bumpkin Dec 4, 2003
//:: modified by Ornedan Dec 22, 2004 to PnP rules
//:: Fixed poison immunity bypass 2026-04-28  

#include "prc_inc_spells"  
#include "prcsp_archmaginc"   
#include "prc_add_spell_dc"    
  
void main()  
{  
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");  
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);  
  
  
    //Declare major variables  
    object oTarget  = GetEnteringObject();  
    int nHD         = GetHitDice(oTarget);  
    effect eDeath   = EffectDeath();  
    effect eVis     = EffectVisualEffect(VFX_IMP_DEATH);  
    effect eNeg     = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);  
    effect eConceal = EffectConcealment(20);  
    effect eVis2    = EffectVisualEffect(VFX_DUR_GHOST_TRANSPARENT);  
    effect eLink    = EffectLinkEffects(eConceal, eVis2);  
  
    //effect eDam;  
    int nDam = d4();  
    int nMetaMagic = PRCGetMetaMagicFeat();  
  
    object aoeCreator = GetAreaOfEffectCreator();  
    int CasterLvl = GetLocalInt(OBJECT_SELF, "X2_AoE_Caster_Level");  
  
    //int nPenetr = SPGetPenetrAOE(aoeCreator,CasterLvl);  
  
    //Enter Metamagic conditions  
    if(nMetaMagic & METAMAGIC_MAXIMIZE)  
    {  
        nDam = 4;//Damage is at max  
    }  
    if(nMetaMagic & METAMAGIC_EMPOWER)  
    {  
        nDam =  nDam + (nDam/2); //Damage/Healing is +50%  
    }  
  
      if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, aoeCreator))  
    {  
		// Check for Mastery of Shaping protection  
		if(CheckMasteryOfShapes(aoeCreator, oTarget))  
		{  
			return; // Target is protected, exit  
		}  
		//Fire cast spell at event for the specified target  
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CLOUDKILL));  
  
        //Concealement by fog happens no matter what  
        SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eConceal, oTarget, 0.0f, FALSE);  
  
        // Creatures immune to poison are unaffected by the spell's vapors  
        if(GetIsImmune(oTarget, IMMUNITY_TYPE_POISON))  
            return;  
  
        //Determine spell effect based on the targets HD  
        if (nHD <= 3)  
        {  
            if(!GetIsImmune(oTarget, IMMUNITY_TYPE_DEATH))  
            {  
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);  
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget);  
            }  
        }  
        else if (nHD >= 4 && nHD <= 6)  
        {  
            //Make a save or die  
            if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, PRCGetSaveDC(oTarget, aoeCreator), SAVING_THROW_TYPE_DEATH, OBJECT_SELF))  
            {  
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget);  
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);  
            }  
            else  
            {  
                if (GetHasMettle(oTarget, SAVING_THROW_FORT))  
                    return; // Mettle: no effect on successful save  
                AssignCommand(aoeCreator, ApplyAbilityDamage(oTarget, ABILITY_CONSTITUTION, nDam, DURATION_TYPE_TEMPORARY, TRUE, -1.0f));  
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eNeg, oTarget);  
            }  
        }  
        else  
        {  
            if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, PRCGetSaveDC(oTarget, aoeCreator), SAVING_THROW_TYPE_SPELL, OBJECT_SELF))  
            {  
                AssignCommand(aoeCreator, ApplyAbilityDamage(oTarget, ABILITY_CONSTITUTION, nDam, DURATION_TYPE_TEMPORARY, TRUE, -1.0f));  
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eNeg, oTarget);  
            }  
            else  
            {  
                if (GetHasMettle(oTarget, SAVING_THROW_FORT))  
                    return;  
                // Halve the damage on successful save  
                AssignCommand(aoeCreator, ApplyAbilityDamage(oTarget, ABILITY_CONSTITUTION, nDam / 2, DURATION_TYPE_TEMPORARY, TRUE, -1.0f));  
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eNeg, oTarget);  
            }  
        }  
    }
	
/*     if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, aoeCreator))  
    {  
		// Check for Mastery of Shaping protection    
		if(CheckMasteryOfShapes(aoeCreator, oTarget))    
		{    
			return; // Target is protected, exit    
		}            
		//Fire cast spell at event for the specified target  
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CLOUDKILL));  
  
        //Concealement by fog happens no matter what  
        SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eConceal, oTarget, 0.0f, FALSE);  
  
        //Determine spell effect based on the targets HD  
        if (nHD <= 3)  
        {  
            if(!GetIsImmune(oTarget, IMMUNITY_TYPE_DEATH))  
            {  
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);  
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget);  
            }  
        }  
        else if (nHD >= 4 && nHD <= 6)  
        {  
            //Make a save or die  
            if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, PRCGetSaveDC(oTarget, aoeCreator), SAVING_THROW_TYPE_DEATH, OBJECT_SELF))  
            {  
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget);  
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);  
            }  
            else  
            {  
			if (GetHasMettle(oTarget, SAVING_THROW_FORT))  
			// This script does nothing if it has Mettle, bail  
				return;              
                // Check for poison immunity before applying damage  
                if(!GetIsImmune(oTarget, IMMUNITY_TYPE_POISON))  
                {  
                    AssignCommand(aoeCreator, ApplyAbilityDamage(oTarget, ABILITY_CONSTITUTION, nDam, DURATION_TYPE_TEMPORARY, TRUE, -1.0f));  
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eNeg, oTarget);  
                }  
            }  
        }  
        else  
        {  
            if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, PRCGetSaveDC(oTarget, aoeCreator), SAVING_THROW_TYPE_SPELL, OBJECT_SELF))  
            {  
                // Check for poison immunity before applying damage  
                if(!GetIsImmune(oTarget, IMMUNITY_TYPE_POISON))  
                {  
                    AssignCommand(aoeCreator, ApplyAbilityDamage(oTarget, ABILITY_CONSTITUTION, nDam, DURATION_TYPE_TEMPORARY, TRUE, -1.0f));  
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eNeg, oTarget);  
                }  
            }  
            else  
            {  
			if (GetHasMettle(oTarget, SAVING_THROW_FORT))  
			// This script does nothing if it has Mettle, bail  
				return;              
                // Check for poison immunity before applying damage  
                if(!GetIsImmune(oTarget, IMMUNITY_TYPE_POISON))  
                {  
                    // Halve the damage on succesfull save.  
                    AssignCommand(aoeCreator, ApplyAbilityDamage(oTarget, ABILITY_CONSTITUTION, nDam / 2, DURATION_TYPE_TEMPORARY, TRUE, -1.0f));  
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eNeg, oTarget);  
                }  
            }  
        }  
    }   */
  
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");  
// Getting rid of the local integer storing the spellschool name  
}