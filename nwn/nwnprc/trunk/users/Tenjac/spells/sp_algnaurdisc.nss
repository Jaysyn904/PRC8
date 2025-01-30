
//:://////////////////////////////////////////////
//:: Name     Aligned Aura Discarge
//:: FileName   sp_algnaurdisc.nss
//:://////////////////////////////////////////////
/** @file

 
*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 1/25/21
//:://////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_add_spell_dc"


void main()
{
	if(!X2PreSpellCastCode()) return;
	PRCSetSchool(SPELL_SCHOOL_ABJURATION);
	object oPC = OBJECT_SELF;
        int nCasterLvl = PRCGetCasterLevel(oPC);
        int nMetaMagic = PRCGetMetaMagicFeat();
        location lLoc = GetLocation(oPC);
        int nDC;
        int nAlign;
        int nAlignTarget;
        
        if (GetHasSpellEffect(SPELL_ALIGNED_AURA_LAW,oPC)) nAlign == ALIGNMENT_LAWFUL;
        else if(GetHasSpellEffect(SPELL_ALIGNED_AURA_CHAOS,oPC)) nAlign = ALIGNMENT_CHAOTIC;
        else if (GetHasSpellEffect(SPELL_ALIGNED_AURA_GOOD,oPC)) nAlign = ALIGNMENT_GOOD;
        else if (GetHasSpellEffect(SPELL_ALIGNED_AURA_EVIL,oPC)) nAlign = ALIGNMENT_EVIL;
        else SendMessageToPC(oPC, "Invalid alignment passed in script sp_algnaurdisc.nss");
                        
        //Get duration left
        int nEffectDuration, nEffectDurationRemaining;
	effect eEffect = GetFirstEffect(OBJECT_SELF);    
	while(GetIsEffectValid(eEffect))
	{
		if(GetEffectSpellId(eEffect) == SPELL_ALIGNED_AURA_LAW) 
	        {
	        	nEffectDuration = GetEffectDuration(eEffect);
	            	nEffectDurationRemaining = GetEffectDurationRemaining(eEffect);
	            	nAlign = ALIGNMENT_LAWFUL;	            	
	        }
	        else if(GetSpellId(eEffect) == SPELL_ALIGNED_AURA_CHAOS)
	        {
	        	nEffectDuration = GetEffectDuration(eEffect);
			nEffectDurationRemaining = GetEffectDurationRemaining(eEffect);
		        nAlign = ALIGNMENT_CHAOTIC;		        
		}
		else if(GetSpellId(eEffect) == SPELL_ALIGNED_AURA_GOOD)
		{
			nEffectDuration = GetEffectDuration(eEffect);
			nEffectDurationRemaining = GetEffectDurationRemaining(eEffect);
		        nAlign = ALIGNMENT_GOOD;		        
		}
		else if(GetSpellId(eEffect) == SPELL_ALIGNED_AURA_EVIL)
		{
			nEffectDuration = GetEffectDuration(eEffect);
			nEffectDurationRemaining = GetEffectDurationRemaining(eEffect);
		        nAlign = ALIGNMENT_EVIL;		        	       
		}	        	
	        eEffect = GetNextEffect(OBJECT_SELF);
	}
        //GetEffectDurationRemaining returns seconds, need rounds
        int nDice = nEffectDurationRemaining / 6;
        int nDam = d4(PRCMin(15, nDice));  
        
        //Do the AoE
        object oTarget = MyFirstObjectInShape(SHAPE_SPHERE,FeetToMeters(60.0), lLoc);
        {
        	while(GetIsObjectValid(oTarget))
        	{
        		if(oTarget != oPC)
			{
				//lawful or chaotic	
				if(nAlign == ALIGNMENT_LAWFUL || nAlign == ALIGNMENT_CHAOTIC) nAlignTarget = GetAlignmentLawChaos(oTarget);        		
				else if (nAlign == ALIGNMENT_GOOD || nAlign == ALIGNMENT_EVIL) nAlignTarget = GetAlignmentGoodEvil(oTarget);
				
				//Same alignment, heal
				if(nAlign == nAlignTarget)
				{
					SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectHeal(nDam, oTarget), oTarget);       	
				}
				//Opposing alignment, damage
				if(nAlign != nAlignTarget)
				{
					nDC = PRCGetSaveDC(oTarget, oPC);
					//SR
					if(!PRCDoResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
					{
						//Fort Save half
						if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_DIVINE)
						{
							nDam = nDam/2;
						}
						effect eDam = PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_MAGICAL);
						effect eVis = EffectVisualEffect(VFX_IMP_DIVINE_STRIKE_HOLY);
						effect eLink = EffectLinkEffects(eDam, eVis);
						SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
					}
				}
			}			
			oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(60.0), lLoc);		
		}
	}
PRCSetSchool();
}




