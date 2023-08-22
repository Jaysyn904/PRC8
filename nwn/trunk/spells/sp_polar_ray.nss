/*
Polar Ray

Caster Level(s): Wizard / Sorcerer 8
Innate Level: 8
School: Evocation
Descriptor(s): Cold
Component(s): Verbal, Somatic
Range: Short
Area of Effect / Target: Single
Duration: Instant
Additional Counter Spells: 
Save: None
Spell Resistance: Yes

A blue-white ray of freezing air and ice springs from your hand. 
You must succeed on a ranged touch attack with the ray to deal 
damage to a target. The ray deals 1d6 points of cold damage per 
caster level (maximum 25d6).
*/

//::Added hold ray functionality - HackyKid


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
    int nDam = nCasterLevel;
    // 25d6 Max
    if (nDam > 25) nDam = 25;
    nDam = d6(nDam);
    effect eDam;
    effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);
    effect eRay = EffectBeam(VFX_BEAM_COLD, OBJECT_SELF, BODY_NODE_HAND);
    
    int iAttackRoll = 0;

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_RAY_OF_FROST));
        eRay = EffectBeam(VFX_BEAM_COLD, OBJECT_SELF, BODY_NODE_HAND);
        
        iAttackRoll = PRCDoRangedTouchAttack(oTarget);;
        if(iAttackRoll > 0)
        {
            //Make SR Check
            if(!PRCDoResistSpell(oCaster, oTarget, nPenetr))
            {
                 //Enter Metamagic conditions
                 if (CheckMetaMagic(nMetaMagic, METAMAGIC_MAXIMIZE))
                 {
                     nDam = 6 * nCasterLevel;//Damage is at max
                     // 25 * 6 = 150, so its the most the spell can do.
                     if (nDam > 150) nDam = 150;
                 }
                 if (CheckMetaMagic(nMetaMagic, METAMAGIC_EMPOWER))
                 {
                     nDam = nDam + nDam/2; //Damage/Healing is +50%
                 }
            	 nDam += SpellDamagePerDice(oCaster, nCasterLevel);
                 // perform ranged touch attack and apply sneak attack if any exists
                 int eDamageType = ChangedElementalDamage(OBJECT_SELF, DAMAGE_TYPE_COLD);
                 ApplyTouchAttackDamage(OBJECT_SELF, oTarget, iAttackRoll, nDam, eDamageType);
                 PRCBonusDamage(oTarget);
    
                 //Apply the VFX impact and damage effect
                 SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
             }
        }
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
