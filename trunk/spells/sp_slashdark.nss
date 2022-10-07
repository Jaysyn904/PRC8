/////////////////////////////////////////////////////////////////////
//
// Slashing Darkness - Project a damaging ray of negative energy.
//
/////////////////////////////////////////////////////////////////////
//::Added hold ray functionality - HackyKid


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

    int nDice = (nCasterLevel + 1) / 2;
    if (nDice > 5) nDice = 5;

    // Adjust the damage type if necessary.
    int nDamageType = PRCGetElementalDamageType(DAMAGE_TYPE_NEGATIVE, OBJECT_SELF);

    int iAttackRoll = 0;

    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    {
        //Fire cast spell at event for the specified target
        PRCSignalSpellEvent(oTarget);

        iAttackRoll = PRCDoRangedTouchAttack(oTarget);;

        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY,
          EffectBeam(VFX_BEAM_BLACK, OBJECT_SELF, BODY_NODE_HAND, 0 == iAttackRoll), oTarget, 1.0,FALSE);

        if (iAttackRoll > 0)
        {
            if (!PRCDoResistSpell(OBJECT_SELF, oTarget, nPenetr))
            {
                int nDamage = PRCGetMetaMagicDamage(nDamageType, 1 == iAttackRoll ? nDice : (nDice * 2), 8);
				nDamage += SpellDamagePerDice(oCaster, nDice);
                // Apply the damage and the vfx to the target.
                
                effect eEffect = PRCEffectDamage(oTarget, nDamage, nDamageType);
                if (RACIAL_TYPE_UNDEAD == MyPRCGetRacialType(oTarget) || (GetHasFeat(FEAT_TOMB_TAINTED_SOUL, oTarget) && GetAlignmentGoodEvil(oTarget) != ALIGNMENT_GOOD) || GetLocalInt(oTarget, "AcererakHealing"))
                	eEffect = PRCEffectHeal(nDamage, oTarget);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eEffect, oTarget);
                PRCBonusDamage(oTarget);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY), oTarget);
            }
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
