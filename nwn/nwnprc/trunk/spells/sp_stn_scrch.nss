//::///////////////////////////////////////////////
//:: Name      Stunning Screech
//:: FileName  sp_stn_scrch
//:://////////////////////////////////////////////
/**@file Stunning Screech 
Evocation [Evil, Sonic] 
Level: Brd 3, Demonologist 2 
Components: V, S, M, Drug 
Casting Time: 1 action 
Range: 30 ft.
Targets: All creatures within range 
Duration: 1 round
Saving Throw: Fortitude negates 
Spell Resistance: Yes 

The caster emits a piercing screech like that of a 
vrock demon. Every creature within the area is 
stunned for 1 round.

Material Component: Feather of a large bird or 
a vrock.

Drug Component: Mushroom powder.

Author:    Tenjac
Created:   
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_add_spell_dc"
void main()
{
	object oPC = OBJECT_SELF;
	location lLoc = PRCGetSpellTargetLocation();
	effect eStun = EffectStunned();
	int nCasterLvl = PRCGetCasterLevel(oPC);
	int nDC;
	effect eVis1 = EffectVisualEffect(VFX_FNF_SOUND_BURST);
	effect eVis2 = EffectVisualEffect(VFX_IMP_STUN);
	
	//spellhook
	if(!X2PreSpellCastCode()) return;
	
	PRCSetSchool(SPELL_SCHOOL_EVOCATION);
	
	//check for drug
	if(GetHasSpellEffect(SPELL_MUSHROOM_POWDER, oPC))
	{
		//Play VFX and sound
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis1, oPC);
		PlaySound("sff_combansh");
		
		//loop
		object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lLoc);
		
		while (GetIsObjectValid(oTarget))
		{
			if(oTarget != oPC)
			{
				nDC = PRCGetSaveDC(oTarget, oPC);
				//SR
				if(!PRCDoResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
				{
					//Save
					if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_EVIL))
		
					{
						SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
						SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun, oTarget, 6.0f);
					}
				}
			}
			
                oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lLoc);
		}
	}
	
	//SPEvilShift(oPC);
	PRCSetSchool();
}
			