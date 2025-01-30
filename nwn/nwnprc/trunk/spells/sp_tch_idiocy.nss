//::///////////////////////////////////////////////
//:: Name      Touch of Idiocy
//:: FileName  sp_tch_idiocy.nss
//:://////////////////////////////////////////////
/**@file Touch of Idiocy
Enchantment (Compulsion) [Mind-Affecting]
Level: Sor/Wiz 2, Hexblade 2
Components: V, S
Casting Time: 1 standard action
Range: Touch
Target: Living creature touched
Duration: 10 min./level
Saving Throw: No
Spell Resistance: Yes

With a touch, you reduce the target’s mental faculties. 
Your successful melee touch attack applies a 1d6 penalty 
to the target’s Intelligence, Wisdom, and Charisma 
scores. This penalty can’t reduce any of these scores 
below 1.

This spell’s effect may make it impossible for the target
to cast some or all of its spells, if the requisite 
ability score drops below the minimum required to cast 
spells of that level.

**/

////////////////////////////////////////////////////
// Author: Tenjac
// Date:   15.9.2006
////////////////////////////////////////////////////

/*
    PRC_SPELL_EVENT_ATTACK is set when a
        touch or ranged attack is used
    <END NOTES TO SCRIPTER>
*/

#include "prc_inc_sp_tch"
#include "prc_sp_func"
#include "prc_add_spell_dc"
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
    int nPenetr = nCasterLevel + SPGetPenetr();
    int nDam = d6(1);
    float fDur = (60.0f * nCasterLevel);
    
    PRCSignalSpellEvent(oTarget,TRUE, SPELL_TOUCH_OF_IDIOCY, oCaster);

    //INSERT SPELL CODE HERE
    int iAttackRoll = 0;    //placeholder

    iAttackRoll = PRCDoMeleeTouchAttack(oTarget);
    if (iAttackRoll > 0 && PRCGetIsAliveCreature(oTarget))
    {
	     //Touch attack code goes here
	    if (!PRCDoResistSpell(oCaster, oTarget, nCasterLevel + SPGetPenetr()))
	    {
		    if(nMetaMagic & METAMAGIC_MAXIMIZE)
		    {
			    nDam = 6;
		    }
		    
		    if(nMetaMagic & METAMAGIC_EMPOWER)
		    {
			    nDam += (nDam/2);
		    }
		    
		    if(nMetaMagic & METAMAGIC_EXTEND)
		    {
			    fDur += fDur;
		    }
		    
		    int nDamInt = PRCMin(nDam, (GetAbilityScore(oTarget, ABILITY_INTELLIGENCE) - 1));
		    int nDamWis = PRCMin(nDam, (GetAbilityScore(oTarget, ABILITY_WISDOM) - 1));
		    int nDamCha = PRCMin(nDam, (GetAbilityScore(oTarget, ABILITY_CHARISMA) - 1));
		    
		    ApplyAbilityDamage(oTarget, ABILITY_INTELLIGENCE, nDamInt, DURATION_TYPE_TEMPORARY, TRUE, fDur, TRUE, oCaster);
		    ApplyAbilityDamage(oTarget, ABILITY_WISDOM, nDamWis, DURATION_TYPE_TEMPORARY, TRUE, fDur, TRUE, oCaster);
		    ApplyAbilityDamage(oTarget, ABILITY_CHARISMA, nDamCha, DURATION_TYPE_TEMPORARY, TRUE, fDur, TRUE, oCaster);
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
        if(GetLocalInt(oCaster, PRC_SPELL_HOLD) && oCaster == oTarget)
        {   //holding the charge, casting spell on self
            SetLocalSpellVariables(oCaster, 1);   //change 1 to number of charges
            return;
        }
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