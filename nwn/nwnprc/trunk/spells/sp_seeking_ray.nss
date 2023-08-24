//::///////////////////////////////////////////////
//:: Name      Seeking Ray
//:: FileName  sp_seeking_ray.nss
//:://////////////////////////////////////////////
/**@file Seeking Ray
Evocation
Level: Duskblade 2, sorcerer/wizard 2
Components: V,S
Casting Time: 1 standard action
Range: Medium
Effect: Ray
Duration: Instantaneous; see text
Saving Throw: None
Spell Resistance: Yes

You create a ray that deals 4d6 points of electricity
damage if it strikes your target. While this ray 
requires a ranged touch attack to strike an opponent,
it ignores concealment and cover (but not total 
concealment or total cover), and it does not take the
standard penalty for firing into melee.

In addition to the damage it deals, the ray creates a
link of energy between you and the subject. If this
ray struck the target and dealt damage, you gain a +4
bonus on attacks you make with ray spells (including
another casting of this one, if desired) against the
subject for 1 round per caster level.  If you cast
seeking ray a second time on a creature that is still
linked to you from a previous casting, the duration
of the new link overlaps (does not stack with) the 
remaining duration of the previous one.

**/
//////////////////////////////////////////////////////
// Author: Tenjac
// Date:   26.9.06
//////////////////////////////////////////////////////

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
	float fDur = RoundsToSeconds(nCasterLevel);
	
	//INSERT SPELL CODE HERE
	int iAttackRoll = 0;    //placeholder
	
	iAttackRoll = PRCDoRangedTouchAttack(oTarget);
	
	//Beam VFX.  Ornedan is my hero.
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_LIGHTNING, oCaster, BODY_NODE_HAND, !iAttackRoll), oTarget, 1.0f); 
	
	if (iAttackRoll > 0)
	{
		if(!PRCDoResistSpell(OBJECT_SELF, oTarget, nCasterLevel + SPGetPenetr()))
		{
			//Touch attack code goes here
			int nDam = d6(4);
			
			if(nMetaMagic & METAMAGIC_MAXIMIZE)
			{
				nDam = 24;
			}
			
			if(nMetaMagic & METAMAGIC_EMPOWER)
			{
				nDam += (nDam/2);
			}
			nDam += SpellDamagePerDice(oCaster, 4);
			if(nMetaMagic & METAMAGIC_EXTEND)
			{
				fDur += fDur;
			}
			
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_ELECTRICAL), oTarget);
			
			//Apply VFX for duration to enable "seeking" - add code to prc_inc_sp_touch!
			SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE), oTarget, fDur);
		}
	}
	return iAttackRoll;    //return TRUE if spell charges should be decremented	
}
	
void main()
{
    object oCaster = OBJECT_SELF;
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    PRCSetSchool(SPELL_SCHOOL_EVOCATION);
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
			
			