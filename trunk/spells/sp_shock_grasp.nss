//::///////////////////////////////////////////////
//:: Name      Shocking Grasp
//:: FileName  sp_shock_grasp.nss
//:://////////////////////////////////////////////
/**@file Shocking Grasp
Evocation [Electricity]
Level:              Sor/Wiz 1, Duskblade 1
Components:         V, S
Casting Time:       1 standard action
Range:              Touch
Target:             Creature or object touched
Duration:           Instantaneous
Saving Throw:       None
Spell Resistance:   Yes

Your successful melee touch attack deals 1d6 points
of electricity damage per caster level (maximum 5d6).
When delivering the jolt, you gain a +3 bonus on
attack rolls if the opponent is wearing metal armor
(or made out of metal, carrying a lot of metal,
or the like).

**/
//::////////////////////////////////////////////////
//:: Author: Tenjac
//:: Date  : 29.9.06
//::////////////////////////////////////////////////


/*3055
<BEGIN NOTES TO SCRIPTER - MAY BE DELETED LATER>
Modify as necessary
Most code should be put in DoSpell()

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
    int nPenetr = nCasterLevel + SPGetPenetr();
    int nDie = min(nCasterLevel, 5);
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oTarget);
    effect eVis = EffectVisualEffect(VFX_DUR_BIGBYS_BIGBLUE_HAND2);

    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SHOCKING_GRASP));

    int nAttackBonus = GetBaseAC(oArmor) >= 4 ? 3 : 0;
    int iAttackRoll = PRCDoMeleeTouchAttack(oTarget, TRUE, oCaster, nAttackBonus);

    if(iAttackRoll > 0)
    {
        // Only creatures, and PvP check.
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            // Check Spell Resistance
            if(!PRCDoResistSpell(oCaster, oTarget, nPenetr))
            {
                int nDam = d6(nDie);
                if(nMetaMagic & METAMAGIC_MAXIMIZE)
                    nDam = 6 * nDie;
                if(nMetaMagic & METAMAGIC_EMPOWER)
                    nDam += (nDam/2);
				nDam += SpellDamagePerDice(oCaster, nDie);
                int eDamageType = ChangedElementalDamage(oCaster, DAMAGE_TYPE_ELECTRICAL);
                ApplyTouchAttackDamage(oCaster, oTarget, iAttackRoll, nDam, eDamageType);
                PRCBonusDamage(oTarget);

                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
        }
    }

    return iAttackRoll;// return TRUE if spell charges should be decremented
}

void main()
{
    PRCSetSchool(SPELL_SCHOOL_EVOCATION);
    if (!X2PreSpellCastCode()) return;
    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    int nEvent = GetLocalInt(oCaster, PRC_SPELL_EVENT); //use bitwise & to extract flags
    if(!nEvent) //normal cast
    {
        if(GetLocalInt(oCaster, PRC_SPELL_HOLD) && oCaster == oTarget)
        {
            //holding the charge, casting spell on self
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