//:: Name     Blast of Force
//:: FileName   sp_blastfrc.nss
//:://////////////////////////////////////////////
/** @file
Evocation [Force]
Level: Sorcerer 2, Wizard 2, Force 3,
Components: V, S,\line Casting Time: 1 standard action
Range: Medium (100 ft. + 10 ft./level)
Effect: Ray
Duration: Instantaneous
Saving Throw: Fortitude partial
Spell Resistance: Yes

Drawing upon magic in its purest form, you send invisible energy whistling through the air to batter your foe.
You must succeed on a ranged touch attack with the ray to strike a target. A blast of force deals 1d6 points 
of damage per two caster levels (maximum 5d6). In addition, a successful hit forces the subject to make a 
Fortitude save or be knocked prone (size and stability modifiers apply to the saving throw as if the spell 
were a bull rush).
*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 1/20/21//::
//:://////////////////////////////////////////////

#include "prc_inc_sp_tch"
#include "prc_sp_func"
#include "prc_add_spell_dc"
#include "prc_inc_combmove"
//Implements the spell impact, put code here
//  if called in many places, return TRUE if
//  stored charges should be decreased
//  eg. touch attack hits
//
//  Variables passed may be changed if necessary

int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)
{
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nSaveDC = PRCGetSaveDC(oTarget, oCaster);
    // Applying Bull Rush bonuses to defender
    nSaveDC -= GetCombatMoveCheckBonus(oTarget, COMBAT_MOVE_BULLRUSH, TRUE);
    int nPenetr = nCasterLevel + SPGetPenetr();  
    PRCSignalSpellEvent(oTarget, TRUE, SPELL_BLASTOFFORCE, oCaster);
    
    //Make touch attack
    int iAttackRoll = PRCDoRangedTouchAttack(oTarget);
    //No VFX
    if (iAttackRoll)
    {
        if (!PRCDoResistSpell(oCaster, oTarget, nPenetr))
        {
            int nDice= PRCMin(nCasterLevel/2, 5);
            int nDam = d6(nDice);
            if(nMetaMagic & METAMAGIC_MAXIMIZE) nDam = 6 * nDice;
            if(nMetaMagic & METAMAGIC_EMPOWER)  nDam += (nDam/2);
            nDam += SpellDamagePerDice(oCaster, nDice);
            if (PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nSaveDC, SAVING_THROW_TYPE_SPELL))
            {
				nDam /= 2;
                if(GetHasMettle(oTarget, SAVING_THROW_FORT))
	               nDam = 0;				
            }
            else
            {
                effect eKnock = EffectKnockdown();
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnock, oTarget, 3.0);            
            }
            
            effect eDam = PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_FORCE);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DESTRUCTION), oTarget);            
        }
    }
    return iAttackRoll;    //return TRUE if spell charges should be decremented
}

void main()
{
	object oCaster = OBJECT_SELF;
	int nCasterLevel = PRCGetCasterLevel(oCaster);
	PRCSetSchool(GetSpellSchool(PRCGetSpellId()));
	
	if (!X2PreSpellCastCode()) return;
	object oTarget = PRCGetSpellTargetObject();
	int nEvent = GetLocalInt(oCaster, PRC_SPELL_EVENT); //use bitwise & to extract flags
	if(!nEvent) //normal cast
	{
		if (GetLocalInt(oCaster, PRC_SPELL_HOLD) && GetHasFeat(FEAT_EF_HOLD_RAY, oCaster) && oCaster == oTarget)
		{
			//holding the charge, casting spell on self
            		SetLocalSpellVariables(oCaster, 1);   //change 1 to number of charges
            		return;
        	}
        	
        	if (oCaster != oTarget)//cant target self with this spell, only when holding charge
		{
			DoSpell(oCaster, oTarget, nCasterLevel, nEvent);
		}
    		else
    		{
    			if(nEvent & PRC_SPELL_EVENT_ATTACK)
    			{
    				if(DoSpell(oCaster, oTarget, nCasterLevel, nEvent))
    				DecrementSpellCharges(oCaster);
    			}
    		}
    		PRCSetSchool();
	}
}