//::///////////////////////////////////////////////
//:: Pestilence
//:: sp_pest_aura_hb.nss
//:://////////////////////////////////////////////
/*
 Contagiousness aura hearbeat script for Pestilence.
 This should never be called before the first OnEnter, but
 the initialization code is present anyway.
 
 The aura will delete itself should it be present when the carrier is
 no longer infected.
 
 All creatures within the aura, other than the carrier, will be subject
 to SR and fort checks to resist being infected.
 
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: December 26, 2004
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void SetupPestilenceAura(object oTarget, object oCaster, int nCasterLevel, int nDC)
{
    effect eAoE = EffectAreaOfEffect(AOE_MOB_PESTILENCE);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAoE, oTarget, HoursToSeconds(24) /*+10*/, FALSE, SPELL_PESTILENCE, nCasterLevel, oCaster);

    object oAoE = GetAreaOfEffectObject(GetLocation(oTarget), "VFX_MOB_PESTILENCE");
    SetAllAoEInts(SPELL_PESTILENCE, oAoE, nDC, 1, nCasterLevel);
}

void main()
{
	//SpawnScriptDebugger();
	
PRCSetSchool(SPELL_SCHOOL_NECROMANCY);

	object oCarrier, oCaster;
	int nDC, nCasterLvl, nPenetr;
	
	
	// See if we've already got a handle on the creature carrying this AoE around
	if(!GetLocalInt(OBJECT_SELF, "INIT_DONE"))
	{
		//Not initialized yet. Look through creatures in AoE to find a new carrier
		// (which should almost always be the one carrying this AoE)
		int bFound = FALSE;
		oCarrier = GetFirstInPersistentObject();
		while(oCarrier != OBJECT_INVALID && !bFound)
		{
			if(GetLocalInt(oCarrier, "SPELL_PESTILENCE_DO_ONCE"))
			{
				bFound = TRUE;
				break;
			}// end if - is this a new carrier?
			
			oCarrier = GetNextInPersistentObject();
		}// end while - search for the carrier
		
		// Get caster data from the carrier
		nDC        = GetLocalInt(oCarrier, "SPELL_PESTILENCE_DC");
		nCasterLvl = GetLocalInt(oCarrier, "SPELL_PESTILENCE_CASTERLVL");
		nPenetr    = GetLocalInt(oCarrier, "SPELL_PESTILENCE_SPELLPENETRATION");
		oCaster = GetLocalObject(oCarrier, "SPELL_PESTILENCE_CASTER");
		
		// Store the data on self for easier access
		SetLocalInt(OBJECT_SELF, "SPELL_PESTILENCE_DC", nDC);
		SetLocalInt(OBJECT_SELF, "SPELL_PESTILENCE_CASTERLVL", nCasterLvl);
		SetLocalInt(OBJECT_SELF, "SPELL_PESTILENCE_SPELLPENETRATION", nPenetr);
		SetLocalObject(OBJECT_SELF, "SPELL_PESTILENCE_CARRIER", oCarrier);
		SetLocalObject(OBJECT_SELF, "SPELL_PESTILENCE_CASTER", oCaster);
		
		// These are no longer needed on the carrier, so delete them.
		//DeleteLocalInt(oCarrier, "SPELL_PESTILENCE_DC");
		//DeleteLocalInt(oCarrier, "SPELL_PESTILENCE_CASTERLVL");
		DeleteLocalInt(oCarrier, "SPELL_PESTILENCE_SPELLPENETRATION");
		//DeleteLocalObject(oCarrier, "SPELL_PESTILENCE_CASTER");
		
		// Mark the initialization being done
		DeleteLocalInt(oCarrier, "SPELL_PESTILENCE_DO_ONCE");
		SetLocalInt(OBJECT_SELF, "INIT_DONE", TRUE);
	}// end if - initialization wasn't done yet
	else
	{
		oCaster  = GetLocalObject(OBJECT_SELF, "SPELL_PESTILENCE_CASTER");
		oCarrier = GetLocalObject(OBJECT_SELF, "SPELL_PESTILENCE_CARRIER");
		nDC        = GetLocalInt(OBJECT_SELF, "SPELL_PESTILENCE_DC");
		nCasterLvl = GetLocalInt(OBJECT_SELF, "SPELL_PESTILENCE_CASTERLVL");
		nPenetr    = GetLocalInt(OBJECT_SELF, "SPELL_PESTILENCE_SPELLPENETRATION");
	}// end else - initilization already done, just load data from self
	
	/* Make sure the carrier is still infected. It is possible for
	 * this effect to be present on the carrier even if it has been
	 * cured.
	 */
	if(!PRCGetHasEffect(EFFECT_TYPE_DISEASE, oCarrier))
	{
		// It isn't, so do a paranoia cleanup of the carrier and delete self
		DeleteLocalInt(oCarrier, "SPELL_PESTILENCE_SAVED");
		DeleteLocalInt(oCarrier, "SPELL_PESTILENCE_DC");
		DeleteLocalInt(oCarrier, "SPELL_PESTILENCE_CASTERLVL");
		DeleteLocalInt(oCarrier, "SPELL_PESTILENCE_SPELLPENETRATION");
		DeleteLocalInt(oCarrier, "SPELL_PESTILENCE_DO_ONCE");
		DeleteLocalObject(oCarrier, "SPELL_PESTILENCE_CASTER");
		
		DestroyObject(OBJECT_SELF);
		return;
	}
	
	/* All is OK, so we can proceed with the heartbeat */
	object oTarget = GetFirstInPersistentObject();
	effect eDisease = EffectDisease(DISEASE_PESTILENCE);
	effect eAoE = EffectAreaOfEffect(AOE_MOB_PESTILENCE);
	
	while(oTarget != OBJECT_INVALID)
	{
		// Do not try to re-infect the carrier or a target that is already.
		// diseased. That'd just cause extra spam.
		if(!(oTarget == oCarrier || PRCGetHasEffect(EFFECT_TYPE_DISEASE, oTarget)))
		{
			//Make sure the target is a living one
			if(PRCGetIsAliveCreature(oTarget))
			{
				//Make SR Check
				if (!PRCDoResistSpell(oCaster, oTarget, nPenetr))
				{
					if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_DISEASE))
					{
						SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eDisease, oTarget, 0.0f, FALSE, SPELL_PESTILENCE, nCasterLvl, oCaster);
						SetLocalInt(oTarget, "SPELL_PESTILENCE_DC", nDC);
						SetLocalInt(oTarget, "SPELL_PESTILENCE_CASTERLVL", nCasterLvl);
						SetLocalInt(oTarget, "SPELL_PESTILENCE_SPELLPENETRATION", nPenetr);
						SetLocalObject(oTarget, "SPELL_PESTILENCE_CASTER", oCaster);
						SetLocalInt(oTarget, "SPELL_PESTILENCE_DO_ONCE", TRUE);
		//				DelayCommand(4.0f, DeleteLocalInt(oTarget, "SPELL_PESTILENCE_DO_ONCE"));
						
						// Delayed a bit. Seems like the presence of the disease effect may
						// not register immediately, resulting in the AoE killing itself
						// right away due to that check failing.
						DelayCommand(0.4f, SetupPestilenceAura(oTarget, oCaster, nCasterLvl, nDC));
		     	}// end if - fort save
				}// end if - spell resistance
			}// end if - only living targets
		}// end if - skip the carrier
		
		oTarget = GetNextInPersistentObject();
	}// end while - cycle through all creatures in this AoE

// Clean up the spell local
PRCSetSchool();
}
