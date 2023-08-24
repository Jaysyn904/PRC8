//::///////////////////////////////////////////////
//:: Name      Calm Emotions: On Enter
//:: FileName  sp_calm_emotionA.nss
//:://////////////////////////////////////////////2
/** @file Calm Emotions
Enchantment (Compulsion) [Mind-Affecting]
Level: 	Brd 2, Clr 2, Law 2
Components: 	V, S, DF
Casting Time: 	1 standard action
Range: 	Medium (100 ft. + 10 ft./level)
Area: 	Creatures in a 20-ft.-radius spread
Duration: 	1 round/level
Saving Throw: 	Will negates
Spell Resistance: 	Yes

This spell calms agitated creatures. You have no 
control over the affected creatures, but calm emotions
can stop raging creatures from fighting or joyous ones
from reveling. Creatures so affected cannot take 
violent actions (although they can defend themselves) 
or do anything destructive. 


**/
//////////////////////////////////////////////////////
// Author: Tenjac
// Date:   8.10.06
//////////////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_add_spell_dc"

int GetIsSupernaturalCurse(effect eEff)
{
    object oCreator = GetEffectCreator(eEff);
    if(GetTag(oCreator) == "q6e_ShaorisFellTemple")
        return TRUE;
    return FALSE;
}

void main()
{
	object oPC = GetAreaOfEffectCreator();
	object oTarget = GetEnteringObject();
	int nDC = PRCGetSaveDC(oTarget, oPC);	
	
	//SR
	if(!PRCDoResistSpell(oPC, oTarget, PRCGetCasterLevel(oPC) + SPGetPenetr()))
	{
		//Saving Throw and no targeting self
		if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_SPELL) && oTarget != oPC)
		{
			effect eVis = EffectVisualEffect(VFX_IMP_DAZED_S);
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
			PRCRemoveEffectsFromSpell(oTarget, 307); // Barbarian Rage
			PRCRemoveEffectsFromSpell(oTarget, SPELL_BARD_SONG); // Bard Song
			
    			effect eEffect = GetFirstEffect(oTarget);
			while(GetIsEffectValid(eEffect))
			{       //Effect removal - see prc_sp_func for list of effects removed
			        if(CheckRemoveEffects(SPELL_CALM_EMOTIONS, GetEffectType(eEffect)) && !GetIsSupernaturalCurse(eEffect) && (GetEffectSubType(eEffect) != SUBTYPE_EXTRAORDINARY))
			            RemoveEffect(oTarget, eEffect);
			        eEffect = GetNextEffect(oTarget);
			}
		}
	}
}