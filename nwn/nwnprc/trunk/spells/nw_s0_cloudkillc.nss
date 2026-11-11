//::///////////////////////////////////////////////
//:: Cloudkill: Heartbeat
//:: NW_S0_CloudKillC.nss
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
#include "prc_add_spell_dc"  
#include "prcsp_archmaginc"

void main()  
{  
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");  
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);  
  
  
    //Declare major variables  
    int nMetaMagic = PRCGetMetaMagicFeat();  
    int nDamage = d4();  
    //effect eDam;  
    effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);  
    object oTarget;  
    int nHD;  
    float fDelay;  
  
    //Enter Metamagic conditions  
    if(nMetaMagic & METAMAGIC_MAXIMIZE)  
    {  
        nDamage = 4;//Damage is at max  
    }  
    if(nMetaMagic & METAMAGIC_EMPOWER)  
    {  
        nDamage =  nDamage + (nDamage/2); //Damage/Healing is +50%  
    }  
  
   //--------------------------------------------------------------------------  
    // GZ 2003-Oct-15  
    // When the caster is no longer there, all functions calling  
    // GetAreaOfEffectCreator will fail. Its better to remove the barrier then  
    //--------------------------------------------------------------------------  
    if (!GetIsObjectValid(GetAreaOfEffectCreator()))  
    {  
        DestroyObject(OBJECT_SELF);  
        return;  
    }  
  
    object aoeCreator = GetAreaOfEffectCreator();  
    int CasterLvl = GetLocalInt(OBJECT_SELF, "X2_AoE_Caster_Level");  
    int nPenetr = SPGetPenetrAOE(aoeCreator,CasterLvl);  
  
  
    //Set damage effect  
    //Get the first object in the persistant AOE  
    oTarget = GetFirstInPersistentObject();  
    while(GetIsObjectValid(oTarget))  
    {  
        fDelay = PRCGetRandomDelay();  
        if(spellsIsTarget(oTarget,SPELL_TARGET_STANDARDHOSTILE , aoeCreator) )  
        {  
			if(CheckMasteryOfShapes(aoeCreator, oTarget))  
			{  
				// Target is protected by Mastery of Shaping, skip damage  
				oTarget = GetNextInPersistentObject();  
				continue;  
			}  
  
			//Fire cast spell at event for the specified target  
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CLOUDKILL));  
  
            nHD = GetHitDice(oTarget);  
  
            // Creatures immune to poison are unaffected by the spell's vapors  
            if(GetIsImmune(oTarget, IMMUNITY_TYPE_POISON))  
            {  
                oTarget = GetNextInPersistentObject();  
                continue;  
            }  
  
            //Apply VFX impact and damage  
            //Creatures with less than 6 HD take full damage automatically  
            //Any with 6 or more get to save (Fortitude) for half  
            if (nHD < 6)  
            {  
                AssignCommand(aoeCreator, ApplyAbilityDamage(oTarget, ABILITY_CONSTITUTION, nDamage, DURATION_TYPE_TEMPORARY, TRUE, -1.0f));  
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);  
            }  
            else  
            {  
                if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, (PRCGetSaveDC(oTarget,aoeCreator)), SAVING_THROW_TYPE_SPELL, OBJECT_SELF))  
                {  
                    AssignCommand(aoeCreator, ApplyAbilityDamage(oTarget, ABILITY_CONSTITUTION, nDamage, DURATION_TYPE_TEMPORARY, TRUE, -1.0f));  
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);  
                }  
                else  
                {  
                    // Mettle: no effect on successful save, skip to next target  
                    if (GetHasMettle(oTarget, SAVING_THROW_FORT))  
                    {  
                        oTarget = GetNextInPersistentObject();  
                        continue;  
                    }  
                    // Halve the damage on successful save  
                    AssignCommand(aoeCreator, ApplyAbilityDamage(oTarget, ABILITY_CONSTITUTION, nDamage / 2, DURATION_TYPE_TEMPORARY, TRUE, -1.0f));  
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);  
                }  
            }  
        }  
        //Get the next target in the AOE  
        oTarget = GetNextInPersistentObject();  
    }  
  
  
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");  
// Getting rid of the local integer storing the spellschool name  
}    
  
/* void main()  
{  
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");  
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);  
  
  
    //Declare major variables  
    int nMetaMagic = PRCGetMetaMagicFeat();  
    int nDamage = d4();  
    //effect eDam;  
    effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);  
    object oTarget;  
    int nHD;  
    float fDelay;  
  
    //Enter Metamagic conditions  
    if(nMetaMagic & METAMAGIC_MAXIMIZE)  
    {  
        nDamage = 4;//Damage is at max  
    }  
    if(nMetaMagic & METAMAGIC_EMPOWER)  
    {  
        nDamage =  nDamage + (nDamage/2); //Damage/Healing is +50%  
    }  
  
   //--------------------------------------------------------------------------  
    // GZ 2003-Oct-15  
    // When the caster is no longer there, all functions calling  
    // GetAreaOfEffectCreator will fail. Its better to remove the barrier then  
    //--------------------------------------------------------------------------  
    if (!GetIsObjectValid(GetAreaOfEffectCreator()))  
    {  
        DestroyObject(OBJECT_SELF);  
        return;  
    }  
  
    object aoeCreator = GetAreaOfEffectCreator();  
    int CasterLvl = GetLocalInt(OBJECT_SELF, "X2_AoE_Caster_Level");  
    int nPenetr = SPGetPenetrAOE(aoeCreator,CasterLvl);  
  
  
    //Set damage effect  
    //Get the first object in the persistant AOE  
    oTarget = GetFirstInPersistentObject();  
    while(GetIsObjectValid(oTarget))  
    {  
        fDelay = PRCGetRandomDelay();  
        if(spellsIsTarget(oTarget,SPELL_TARGET_STANDARDHOSTILE , aoeCreator) )  
        {  
			if(CheckMasteryOfShapes(aoeCreator, oTarget))    
			{    
				// Target is protected by Mastery of Shaping, skip damage    
				oTarget = GetNextInPersistentObject();    
				continue;    
			}   
			  
			//Fire cast spell at event for the specified target  
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CLOUDKILL));  
  
            nHD = GetHitDice(oTarget);  
  
            //Apply VFX impact and damage  
            //Creatures with less than 6 HD take full damage automatically  
            //Any with more than 6 get to save (Fortitued) for half  
            if (nHD < 6)  
            {  
                // Check for poison immunity before applying damage  
                if(!GetIsImmune(oTarget, IMMUNITY_TYPE_POISON))  
                {  
                    AssignCommand(aoeCreator, ApplyAbilityDamage(oTarget, ABILITY_CONSTITUTION, nDamage, DURATION_TYPE_TEMPORARY, TRUE, -1.0f));  
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);  
                }  
            }  
            else  
            {  
                if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, (PRCGetSaveDC(oTarget,aoeCreator)), SAVING_THROW_TYPE_SPELL, OBJECT_SELF))  
                {  
                    // Check for poison immunity before applying damage  
                    if(!GetIsImmune(oTarget, IMMUNITY_TYPE_POISON))  
                    {  
                        AssignCommand(aoeCreator, ApplyAbilityDamage(oTarget, ABILITY_CONSTITUTION, nDamage, DURATION_TYPE_TEMPORARY, TRUE, -1.0f));  
                        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);  
                    }  
                }  
                else  
                {  
                	if (GetHasMettle(oTarget, SAVING_THROW_FORT))  
			// This script does nothing if it has Mettle, bail  
				nDamage = 0;  
                    // Check for poison immunity before applying damage  
                    if(!GetIsImmune(oTarget, IMMUNITY_TYPE_POISON))  
                    {  
                        // Halve the damage on succesfull save.  
                        AssignCommand(aoeCreator, ApplyAbilityDamage(oTarget, ABILITY_CONSTITUTION, nDamage / 2, DURATION_TYPE_TEMPORARY, TRUE, -1.0f));  
                        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);  
                    }  
                }  
            }  
        }  
        //Get the next target in the AOE  
        oTarget = GetNextInPersistentObject();  
    }  
  
  
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");  
// Getting rid of the local integer storing the spellschool name  
} */