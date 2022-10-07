//:://////////////////////////////////////////////
//:: Name     Aura of Cold
//:: FileName   sp_auracold.nss
//:://////////////////////////////////////////////
/** @file Transmutation [Cold]
Level: Cleric 3, Druid 3, Disciple of Thrym 3, Paladin 4, Ranger 4,
Components: V, S, DF,
Casting Time: 1 standard action
Range: 5 ft.
Area: 5-ft.-radius spherical emanation, centered on you
Duration: 1 round/level (D)
Saving Throw: None
Spell Resistance: Yes

You are covered in a thin layer of white frost and frigid cold emanates from your
body, dealing 1d6 points of cold damage at the start of your round to each creature
within 5 feet.
*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 6/8/2022
//:://////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_add_spell_dc"

void DoCold(object oPC, int nRounds)
{
	if(nRounds > 0)
	{
		location lLoc=GetLocation(oPC);
		//Do the AoE
		object oTarget = MyFirstObjectInShape(SHAPE_SPHERE,FeetToMeters(5.0), lLoc);
		{
			while(GetIsObjectValid(oTarget))
			{
				if(oTarget != oPC)			
				{
					SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d6(1), DAMAGE_TYPE_COLD), oTarget);
					SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FROST_S), oTarget);
				}
				oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(5.0), lLoc);
			}
		}
		nRounds--;
		DelayCommand(6.0f, DoCold(oPC, nRounds));
	}
}
				
void main()
{
	if(!X2PreSpellCastCode()) return;
	PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);
	object oPC = OBJECT_SELF;
        int nCasterLvl = PRCGetCasterLevel(oPC);
        float fDur =  RoundsToSeconds(nCasterLvl);
        int nMetaMagic = PRCGetMetaMagicFeat();
        if(nMetaMagic & METAMAGIC_EXTEND) fDur += fDur;
        int nRounds = nCasterLvl;
        if(nMetaMagic & METAMAGIC_EXTEND) nRounds += nRounds;        
        
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_AURA_PULSE_BLUE_WHITE), oPC, fDur);
        
        DoCold(oPC, nRounds);
        
        PRCSetSchool();
}