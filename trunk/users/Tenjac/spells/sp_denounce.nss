//:://////////////////////////////////////////////
//:: Name     Denounce
//:: FileName   sp_denounce.nss
//:://////////////////////////////////////////////
/** @file
Enchantment [Mind-Affecting]
Level: Cleric 2, Paladin 2
Components: V, S,
Casting Time: 1 standard action
Range: Close (25 ft. + 5 ft./2 levels)
Target: One outsider
Duration: 1 min./level (D); see text
Saving Throw: Will negates; see text
Spell Resistance: Yes

You point your finger and pronounce judgment.
You instill feelings of shame and guilt in a target outsider, imposing a -4 insight penalty
on its attack rolls, saves, and checks. Each round on its turn, the subject can attempt a new
saving throw to end the effect.

(This is a full-round action that does not provoke attacks of opportunity).
Outsiders with the good subtype are immune to denounce.
*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 5/25/2022
//:://////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_add_spell_dc"

void SaveCheck(object oTarget, object oPC, int nRounds)
{
	if(GetHasSpellEffect(SPELL_DENOUNCE, oTarget))
	{
		//Save
		if(PRCMySavingThrow(SAVING_THROW_WILL, oTarget, PRCGetSaveDC(oTarget, OBJECT_SELF)))
		{
			RemoveSpellEffects(SPELL_DENOUNCE);
		}
		
		//Loop for another round
		else 
		{
			nRounds--;
			DelayCommand(6.0f, SaveCheck(oTarget, oPC, nRounds));
		}
	}
}

void main()
{
	if(!X2PreSpellCastCode()) return;
	PRCSetSchool(SPELL_SCHOOL_ENCHANTMENT);
	object oPC = OBJECT_SELF;
        int nCasterLvl = PRCGetCasterLevel(oPC);
        float fDur =  60.0f *(nCasterLvl);
        int nMetaMagic = PRCGetMetaMagicFeat();
        if(nMetaMagic & METAMAGIC_EXTEND) fDur += fDur;
        object oTarget = SPGetSpellTargetObject();
        int nPenetr = nCaster + SPGetPenetr();
        
        if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
        {
        	if(MyPRCGetRacialType(oTarget) == RACIAL_TYPE_OUTSIDER)
        	{
        		//No good subtypes, interpret as good alignment
        		if(GetAlignmentGoodEvil(oTarget) == ALIGNMENT_GOOD)
        		{	
        			SendMessageToPC(oPC, "Outsiders of good alignment are immune to Denounce."
        		}
        		//Non-good outsider; resolve spell
        		else
        		{
        			//SR
        			if(!PRCDoResistSpell(oCreator, oTarget, nPenetr))
        			{
        				//Save
        				if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, PRCGetSaveDC(oTarget, OBJECT_SELF)))
        				{
        					effect eLink = EffectLinkEffects(EffectAttackDecrease(4), EffectSavingThrowDecrease(SAVING_THROW_ALL, 4));
        					eLink = EffectLinkEffects(eLink, EffectSkillDecrease(SKILL_ALL_SKILLS, 4));
        					eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_AURA_PULSE_ORANGE_WHITE));
        					
        					SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur);
        					DelayCommand(6.0f, SaveCheck(oTarget, oPC, FloatToInt(fDur / 6)));
        					}
        				}
        			}
        			 
        		}	        
        PRCSetSchool();
}
