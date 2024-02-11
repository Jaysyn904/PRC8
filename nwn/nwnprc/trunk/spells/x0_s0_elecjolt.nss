//::///////////////////////////////////////////////
//:: Electric Jolt
//:: [x0_s0_ElecJolt.nss]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
Evocation [Electricity]
Level:            Sorcerer/wizard 0
Components:       V, S
Casting Time:     1 standard action
Range:            Close (25 ft. + 5 ft./2 levels)
Effect:           Ray
Duration:         Instantaneous
Saving Throw:     None
Spell Resistance: Yes

You release a small stroke of electrical energy.
You must succeed on a ranged touch attack with the
ray to strike a target. The spell deals 1d3 points
of electricity damage.

*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 17 2002
//:://////////////////////////////////////////////
//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff

#include "prc_sp_func"
#include "prc_inc_sp_tch"

int DoSpell(object oCaster, object oTarget, int nCasterLevel)
{
    //Declare major variables
    int nPenetr = nCasterLevel + SPGetPenetr();
    int nMetaMagic = PRCGetMetaMagicFeat();
    int EleDmg = ChangedElementalDamage(oCaster, DAMAGE_TYPE_ELECTRICAL);
    int iAttackRoll = 0;
    effect eVis = EffectVisualEffect(VFX_IMP_LIGHTNING_S);

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_ELECTRIC_JOLT));

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

                // perform attack roll for ray and deal proper damage
                ApplyTouchAttackDamage(oCaster, oTarget, iAttackRoll, nDamage, EleDmg);
                PRCBonusDamage(oTarget);
            }
        }
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
        if(oCaster != oTarget) //cant target self with this spell, only when holding charge
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
