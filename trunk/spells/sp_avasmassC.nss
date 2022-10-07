//::///////////////////////////////////////////////
//:: Avascular Mass C
//:: sw_avasmassC.nss
//:://////////////////////////////////////////////
/*
    Upon entering the AOE the target must make
    a reflex save or be entangled by animated blood
    vessels.
*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 11/15/05
//:://////////////////////////////////////////////


#include "prc_inc_spells"
#include "prc_alterations"
#include "prc_add_spell_dc"

void main()
{
	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
	SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_NECROMANCY);
	
	//Declare major variables
	effect eHold = EffectEntangle();
	effect eSlow = EffectSlow();
	
	//effect eEntangle = EffectVisualEffect(VFX_DUR_AMENTANGLE);
	effect eEntangle = EffectVisualEffect(VFX_DUR_ENTANGLE);    
	
	//Link Entangle and Hold effects
	effect eLink = EffectLinkEffects(eHold, eEntangle);
	int bValid;
	object aoeCreator = GetAreaOfEffectCreator();
	int CasterLvl = PRCGetCasterLevel(aoeCreator);
	int nPenetr = SPGetPenetrAOE(aoeCreator,CasterLvl);
	object oTarget = GetFirstInPersistentObject();
	
	while(GetIsObjectValid(oTarget))
	{  
		// Woodland Stride does not negate as 
		if(GetCreatureFlag(OBJECT_SELF, CREATURE_VAR_IS_INCORPOREAL) != TRUE) 
		{
			if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, aoeCreator))
			{
				//Fire cast spell at event for the specified target
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_AVASCULAR_MASS));
				//Make SR check
				if(!GetHasSpellEffect(SPELL_AVASCULAR_MASS, oTarget))
				{
					if(!PRCDoResistSpell(aoeCreator, oTarget,nPenetr))
					{
						//Make reflex save
						if(!PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, (PRCGetSaveDC(oTarget,aoeCreator))))
						
						{
							//Apply linked effects
							SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(2),FALSE);
						}
					}
				}
				
				//If Reflex save successful, slow the target
				else
				{
					SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSlow, oTarget, RoundsToSeconds(2), FALSE);
				}
				
			}
		}
		
		//Get next target in the AOE
		oTarget = GetNextInPersistentObject();
	}
	
	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
	// Getting rid of the local integer storing the spellschool name
}
    