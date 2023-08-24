//::///////////////////////////////////////////////
//:: Negative Energy Ray
//:: NW_S0_NegRay
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Fires a bolt of negative energy at the target
    doing 1d6 damage.  Does an additional 1d6
    damage for 2 levels after level 1 (3,5,7,9) to
    a maximum of 5d6 at level 9.

    By:
    Created:	Preston Watamaniuk	Sept 13, 2001
    Modified:	modified by mr_bumpkin Dec 4, 2003 for PRC stuff
			Added code to maximize for Faith Healing and Blast Infidel
				Aaon Graywolf - Jan 7, 2004
			Added hold ray functionality - HackyKid


*/

#include "prc_sp_func"
#include "prc_inc_function"
#include "prc_inc_sp_tch"
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

    int iAttackRoll = 0;    //placeholder

    if(nCasterLevel > 9)
    {
        nCasterLevel = 9;
    }
    nCasterLevel = (nCasterLevel + 1) / 2;

    int nDamage = d6(nCasterLevel);

    //Enter Metamagic conditions
    int iBlastFaith = BlastInfidelOrFaithHeal(OBJECT_SELF, oTarget, DAMAGE_TYPE_NEGATIVE, TRUE);
    if ((nMetaMagic == METAMAGIC_MAXIMIZE) || iBlastFaith)
    {
        nDamage = 6 * nCasterLevel;//Damage is at max
    }
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EMPOWER))
    {
        nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
    }
    effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    //effect eDam = PRCEffectDamage(oTarget, nDamage, DAMAGE_TYPE_NEGATIVE);
    effect eHeal = PRCEffectHeal(nDamage, oTarget);
    effect eVisHeal = EffectVisualEffect(VFX_IMP_HEALING_M);
    effect eRay;

   
    if(MyPRCGetRacialType(oTarget) != RACIAL_TYPE_UNDEAD
    && !(GetHasFeat(FEAT_TOMB_TAINTED_SOUL, oTarget) && GetAlignmentGoodEvil(oTarget) != ALIGNMENT_GOOD) && !GetLocalInt(oTarget, "AcererakHealing"))
    {
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            iAttackRoll = PRCDoRangedTouchAttack(oTarget);
            if(iAttackRoll > 0)
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_NEGATIVE_ENERGY_RAY));
                eRay = EffectBeam(VFX_BEAM_EVIL, OBJECT_SELF, BODY_NODE_HAND);
                if (!PRCDoResistSpell(OBJECT_SELF, oTarget, nPenetr))
                {
                	nDamage += SpellDamagePerDice(OBJECT_SELF, nCasterLevel);
                    //Make a saving throw check
                    if(/*Will Save*/ PRCMySavingThrow(SAVING_THROW_WILL, oTarget, (PRCGetSaveDC(oTarget,OBJECT_SELF)), SAVING_THROW_TYPE_NEGATIVE))
                    {
                        nDamage /= 2;
                        
                    	if (GetHasMettle(oTarget, SAVING_THROW_WILL)) // Ignores partial effects
                    	{
                		nDamage = 0;
                    	}                          
                    }
                    //Apply the VFX impact and effects
                    //DelayCommand(0.5, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    DelayCommand(0.5, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    //SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                    ApplyTouchAttackDamage(OBJECT_SELF, oTarget, iAttackRoll, nDamage, DAMAGE_TYPE_NEGATIVE);
                }
            }
        }
    }
    else
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_NEGATIVE_ENERGY_RAY, FALSE));
        eRay = EffectBeam(VFX_BEAM_EVIL, OBJECT_SELF, BODY_NODE_HAND);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVisHeal, oTarget);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
        iAttackRoll = 1; // spell did hit
    }
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7,FALSE);
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
