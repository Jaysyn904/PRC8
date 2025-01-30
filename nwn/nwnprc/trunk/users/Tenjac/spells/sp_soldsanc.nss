//:://////////////////////////////////////////////
//:: Name     Soldiers of Sanctity
//:: FileName   sp_soldsanc.nss
//:://////////////////////////////////////////////
/** @file Evocation [Good]
Level: Cleric 3, Paladin 3,
Components: V, S, DF,
Casting Time: 1 full round
Range: Close (25 ft. + 5 ft./2 levels)
Target: You, plus one willing creature/2 levels; see text
Duration: 1 min./level
Saving Throw: None
Spell Resistance: No

For the duration of soldiers of sanctity, you gain a
bonus on turning checks and turning damage rolls made
when you have allies within 30 feet of you. This is a
sacred bonus, equal to the number of allies within 30
feet, to a maximum of +6.

In addition, each target gains a +2 bonus to AC against
all attacks made by undead creatures. This bonus 
applies for the duration of the spell as long as an 
ally is within 30 feet of you.

*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 8/4/22
//:://////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_add_spell_dc"

void AllyCheck(object oPC, float fDur)
{
	int nCount;
	object oTest = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(30), GetLocation(oPC), OBJECT_TYPE_CREATURE);
	
	while(GetIsObjectValid(oTest))
	{
		if(GetIsReactionTypeFriendly(oTest))
		{
			nCount++;
		}
		oTest = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(30), GetLocation(oPC), OBJECT_TYPE_CREATURE);
	}
	SetLocalInt(oPC, "SOLDIERS_OF_SANCTITY_ALLIES", nCount);
	
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, VersusRacialTypeEffect(EffectACIncrease(2), RACIAL_TYPE_UNDEAD), oPC, 6.0f);
	DelayCommand(6.0f, AllyCheck(oPC, fDur- 6.0));
}
	
void main()
{
	if(!X2PreSpellCastCode()) return;
	PRCSetSchool(SPELL_SCHOOL_EVOCATION);
	object oPC = OBJECT_SELF;
        int nCasterLvl = PRCGetCasterLevel(oPC);
        float fDur =  60.0f * (nCasterLvl);
        int nMetaMagic = PRCGetMetaMagicFeat();
        if(nMetaMagic & METAMAGIC_EXTEND) fDur += fDur;
        int nTargets = PRCMin(6, nCasterLvl/2);
                
        AllyCheck(oPC, fDur);
        
        object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(30), GetLocation(oPC), OBJECT_TYPE_CREATURE);
        
        while(nTargets > 0)
        {
        	AllyCheck(oTarget, fDur);
        	oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(30), GetLocation(oPC), OBJECT_TYPE_CREATURE);
        	nTargets--;
        }        
        PRCSetSchool();
}