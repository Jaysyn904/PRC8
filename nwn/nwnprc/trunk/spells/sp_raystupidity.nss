//::///////////////////////////////////////////////
//:: Ray of Stupidity
//:: [sp_raystupidity.nss]
//;:
//:://////////////////////////////////////////////
/* Ray of Stupidity
(Spell Compendium, p. 167)

Enchantment (Compulsion) [Mind-Affecting]
Level: Sorcerer 2, Wizard 2,
Components: V, S, M,
Casting Time: 1 standard action
Range: Close (25 ft. + 5 ft./2 levels)
Effect: Ray
Duration: Instantaneous
Saving Throw: None
Spell Resistance: Yes

A bright yellow beam bursts from your extended 
fingertips. The beam emits an "uh" sound, like 
someone trying to think of a word.

This ray clouds the mind of your enemy, damaging 
its intellect. You must succeed on a ranged touch 
attack with the ray to strike a target. A subject 
struck by the ray takes 1d4+1 points of 
Intelligence damage. If the target is a wizard, 
she might temporarily lose the ability to cast 
some or all of her spells if her Intelligence 
drops too low.

Material Component: A miniature cone-shaped hat.
*/
//:://////////////////////////////////////////////
//:: Created By: Jaysyn
//:: Created On: 2026-07-27 23:16:24
//:://////////////////////////////////////////////
#include "prc_inc_sp_tch"
#include "prc_add_spell_dc"
#include "prc_sp_func"

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

    int nLoss = d4() + 1;
    effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
    effect eRay;

    int iAttackRoll = 0;

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 99999/* SPELL_RAY_OF_STUPIDITY */));
        eRay = EffectBeam(VFX_BEAM_ODD, OBJECT_SELF, BODY_NODE_HAND);

        // attack roll
        iAttackRoll = PRCDoRangedTouchAttack(oTarget);;
        if(iAttackRoll > 0)
        {
             //Make SR check
             if (!PRCDoResistSpell(OBJECT_SELF, oTarget,nPenetr))
             {
				//Enter Metamagic conditions
				if ((nMetaMagic & METAMAGIC_MAXIMIZE))
				{
					nLoss = 5;
				}
				if ((nMetaMagic & METAMAGIC_EMPOWER))
				{
					 nLoss = nLoss + (nLoss/2);
				}
				//Apply the ability damage effect and VFX impact
				ApplyAbilityDamage(oTarget, ABILITY_INTELLIGENCE, nLoss, DURATION_TYPE_INSTANT, TRUE, 0.0, TRUE);
				SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 0.0f, FALSE);                
			}
		}
    }
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.0);

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
        {   //holding the charge, casting spell on self
            SetLocalSpellVariables(oCaster, 1);   //change 1 to number of charges
            return;
        }
	if (oCaster != oTarget)	//cant target self with this spell, only when holding charge
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
