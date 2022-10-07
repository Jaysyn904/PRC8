//::///////////////////////////////////////////////
//:: Ray of Frost
//:: [NW_S0_RayFrost.nss]
//:: Copyright (c) 2000 Bioware Corp.
//::///////////////////////////////////////////////
/*
Evocation [Cold]
Level:            Sor/Wiz 0
Components:       V, S
Casting Time:     1 standard action
Range:            Close (25 ft. + 5 ft./2 levels)
Effect:           Ray
Duration:         Instantaneous
Saving Throw:     None
Spell Resistance: Yes

A ray of freezing air and ice projects from your
pointing finger. You must succeed on a ranged
touch attack with the ray to deal damage to a
target. The ray deals 1d3 points of cold damage.

*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: feb 4, 2001
//:://////////////////////////////////////////////
//:: Bug Fix: Andrew Nobbs, April 17, 2003
//:: Notes: Took out ranged attack roll.
//:://////////////////////////////////////////////
//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
//:: added hold ray functionality - HackyKid

#include "prc_inc_sp_tch"
#include "prc_sp_func"

int DoSpell(object oCaster, object oTarget, int nCasterLevel)
{
    //Declare major variables
    int nPenetr = nCasterLevel + SPGetPenetr();
    int nMetaMagic = PRCGetMetaMagicFeat();
    int EleDmg = ChangedElementalDamage(oCaster, DAMAGE_TYPE_COLD);
    int iAttackRoll = 0;//placeholder
    effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_RAY_OF_FROST));

        iAttackRoll = PRCDoRangedTouchAttack(oTarget);
        if(iAttackRoll > 0)
        {
            //Make SR Check
            if(!PRCDoResistSpell(oCaster, oTarget, nPenetr))
            {
                 int nDamage = PRCMaximizeOrEmpower(3, 1, nMetaMagic);
				 nDamage += SpellDamagePerDice(oCaster, 1);
                 //Apply the VFX impact and damage effect
                 SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

                 // perform ranged touch attack and apply sneak attack if any exists
                 ApplyTouchAttackDamage(oCaster, oTarget, iAttackRoll, nDamage, EleDmg);
             }
        }
        effect eRay = EffectBeam(VFX_BEAM_COLD, oCaster, BODY_NODE_HAND, !iAttackRoll);
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7, FALSE);
    }
    return iAttackRoll;    //return TRUE if spell charges should be decremented
}

void main()
{
    if (!X2PreSpellCastCode()) return;
    PRCSetSchool(SPELL_SCHOOL_EVOCATION);
    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    int nEvent = GetLocalInt(oCaster, PRC_SPELL_EVENT); //use bitwise & to extract flags
    if(!nEvent) //normal cast
    {
        if (GetLocalInt(oCaster, PRC_SPELL_HOLD) && GetHasFeat(FEAT_EF_HOLD_RAY, oCaster) && oCaster == oTarget)
        {   //holding the charge, casting spell on self
            SetLocalSpellVariables(oCaster, 1);   //change 1 to number of charges
            return;
        }
        if (oCaster != oTarget) //cant target self with this spell, only when holding charge
            DoSpell(oCaster, oTarget, nCasterLevel);
    }
    else
    {
        if(nEvent & PRC_SPELL_EVENT_ATTACK)
        {
            if(DoSpell(oCaster, oTarget, nCasterLevel))
                DecrementSpellCharges(oCaster);
        }
    }
    PRCSetSchool();
}
