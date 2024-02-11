//:://////////////////////////////////////////////
//:: Name     Invoke the Cerulean Sign
//:: FileName   sp_invCS.nss
//:://////////////////////////////////////////////
/** @file 
Evocation
Level: Druid 2, Ranger 2, Bard 3, Cleric 3, Paladin 3, Sorcerer 3, Wizard 3,
Components: S,
Casting Time: 1 standard action
Range: 30 ft.
Area: Multiple aberrations whose combined total Hit Dice do not exceed twice 
caster level in a spread emanating from the character to the extreme of the range
Duration: Instantaneous
Saving Throw: Fortitude negates
Spell Resistance: No

The cerulean sign is an ancient symbol said to embody
the purity of the natural world, and as such it is 
anathema to aberrations.
While druids and rangers are the classes most often
known to cast this ancient spell, its magic is nearly 
universal and can be mastered by all spellcasting classes.
When you cast this spell, you trace the cerulean sign
in the air with a hand, leaving a glowing blue rune
in the air for a brief moment before it flashes and fills
the area of effect with a pulse of cerulean light.
Any aberration within the area must make a Fortitude 
saving throw or suffer the following ill effects.
Closer aberrations are affected first.
Each effect lasts for 1 round.

None: The aberration suffers no ill effect, even if it fails the
saving throw.
Sickened: The aberration takes a -2 penalty on attack 
rolls, saving throws, skill checks, and ability checks for 1 round.
Nauseated: The aberration cannot attack, cast spells, concentrate
on spells, or do anything but take a single move action for 1 round.
Dazed: The aberration can take no actions, but has no penalty to
its Armor Class, for 1 round.
Stunned: The aberration drops everything held, can't take actions, 
takes a -2 penalty to AC, and loses its Dexterity bonus to AC (if any)
for 1 round.

Once a creature recovers from an effect, it moves up one level on the table.
Thus, a creature that is stunned by this spell is dazed the round after
that, nauseated the round after that, sickened the round after that, and
then recovers fully the next round.
*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 7/13/22
//:://////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_add_spell_dc"
#include "prc_effect_inc"

void DoDrop(object oTarget)
{	
	object oTargetWep = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
	object oOffhand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);
	object oNewWeap = CopyObject(oTargetWep, GetLocation(oTarget));
	object oNewOff = CopyObject(oOffhand, GetLocation(oTarget));
	DestroyObject(oTargetWep);
	DestroyObject(oOffhand);
}

void DoSign(object oTarget)
{
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FROST_L), oTarget);
	
	//2nd round sickened
	DelayCommand(6.0f, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSickened(), oTarget, 6.0f));
	
	//3rd round Nauseated
	DelayCommand(12.0f, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectNausea(oTarget, 6.0f), oTarget, 6.0f));
	
	//4th round Dazed
	DelayCommand(18.0f, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneParalyze(), oTarget, 6.0f));
	
	//5th round Stunned
	DelayCommand(24.0f, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneParalyze(), oTarget, 6.0f));
	DelayCommand(24.0f, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectACDecrease(2), oTarget, 6.0f));
	DelayCommand(24.0f, DoDrop(oTarget));
	
	//6th round Dazed
	DelayCommand(30.0f, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneParalyze(), oTarget, 6.0f));
	
	//7th round Nauseated
	DelayCommand(36.0f, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectNausea(oTarget, 6.0f), oTarget, 6.0f));
	
	//8th round sickened
	DelayCommand(42.0f, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSickened(), oTarget, 6.0f));
}

void main()
{
	if(!X2PreSpellCastCode()) return;
	PRCSetSchool(SPELL_SCHOOL_EVOCATION);
	object oPC = OBJECT_SELF;
        int nCasterLvl = PRCGetCasterLevel(oPC);
        int nDice = nCasterLvl * 2;    
        location lLoc = GetLocation(oPC);
        int nTargetDice;
        
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FROST_L), oPC);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HASTE), oPC);
        
        object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, 9.144f, lLocl, FALSE, OBJECT_TYPE_CREATURE);
        
        while(GetIsObjectValid && nDice > 0)
        {
        	//Aberration
        	if(MyPRCGetRacialType(oTarget) == RACIAL_TYPE_ABERRATION)
        	{
        		//Save
        		if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, PRCGetSaveDC(oTarget, oPC)))
        		{
        			nTargetDice = GetHitDice(oTarget);
        			if(nDice >= nTargetDice)
        			{
        				nDice -= nTargetDice;
        				DoSign(oTarget);
        			}
        		}
        	}
        	oTarget = MyNextObjectInShape(SHAPE_SPHERE, 9.144f, lLocl, FALSE, OBJECT_TYPE_CREATURE);
        }
        PRCSetSchool();
}