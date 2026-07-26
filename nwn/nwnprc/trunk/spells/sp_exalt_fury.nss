//::///////////////////////////////////////////////
//:: Name      Exalted Fury
//:: FileName  sp_exalt_fury.nss
//:://////////////////////////////////////////////
/**@file Exalted Fury 
Evocation [Good] 
Level: Sanctified 9 
Components: V, Sacrifice 
Casting Time: 1 standard action 
Range: 40 ft.
Area: 40-ft. radius burst, centered on you 
Duration: Instantaneous
Saving Throw: None 
Spell Resistance: Yes

Uttering a single, awesomely powerful syllable of 
the Words of Creation, your body erupts in the same 
holy power that shaped the universe at its birth. 
All evil creatures within the area take damage equal
to your current hit points +50.

Sacrifice: You die. You can be raised or resurrected
normally.

Author:    Tenjac
Created:   
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
	if(!X2PreSpellCastCode()) return;
	
	PRCSetSchool(SPELL_SCHOOL_EVOCATION);
	
	object oPC = OBJECT_SELF;
	int nMetaMagic = PRCGetMetaMagicFeat();
	location lLoc = PRCGetSpellTargetLocation();	
	object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, 12.19f, lLoc, TRUE, OBJECT_TYPE_CREATURE);
	effect eVisLink = EffectLinkEffects(EffectVisualEffect(VFX_FNF_STRIKE_HOLY), EffectVisualEffect(VFX_FNF_SCREEN_BUMP));
	       eVisLink = EffectLinkEffects(eVisLink, EffectVisualEffect(VFX_FNF_SUNBEAM));
	int nCasterLvl = PRCGetCasterLevel(oPC);
	
	//Damage = Hitpoints + 50
	int nDam = (GetCurrentHitPoints(oPC) + 50);
	
	if(nMetaMagic & METAMAGIC_EMPOWER)
	{
		nDam += (nDam/2);
	}
	
	//You die, make it spectacular
	//SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVisLink, oPC);
	//SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(TRUE), oPC);
	
	//You die, make it spectacular  
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVisLink, oPC);  
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oPC, nDam, DAMAGE_TYPE_DIVINE), oPC);

	
	//Loop
	while(GetIsObjectValid(oTarget))
	{
		//only looking for evil
		if(GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL)
		{
			//SR
			if(!PRCDoResistSpell(OBJECT_SELF, oTarget, nCasterLvl + SPGetPenetr()))
			{
				//Hit 'em
				SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_MAGICAL), oTarget);
			}
		}
		
		//cycle
		oTarget = MyNextObjectInShape(SHAPE_SPHERE, 12.19f, lLoc, TRUE, OBJECT_TYPE_CREATURE);
	}
	
	//Sanctified spells get mandatory 10 pt good adjustment, regardless of switch
	AdjustAlignment(oPC, ALIGNMENT_GOOD, 10, FALSE);
	
	//SPGoodShift(oPC);
	
	PRCSetSchool();
}