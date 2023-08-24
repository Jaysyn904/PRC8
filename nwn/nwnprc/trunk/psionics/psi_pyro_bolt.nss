/*
    prc_pyro_bolt

    Bolt of Fire

    By: Flaming_Sword
    Created: Dec 6, 2007
    Modified: Dec 6, 2007
*/

#include "prc_inc_sp_tch"

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nDamageType = GetPersistantLocalInt(oPC, "PyroDamageType");
    int nLevel = (GetLevelByClass(CLASS_TYPE_PYROKINETICIST, oPC));
    int iAttackRoll = 0;
    int nImpactVFX = GetPersistantLocalInt(oPC, "PyroImpactVFX");
    int nBeam = GetPersistantLocalInt(oPC, "PyroBeam");

    int nDam = (nDamageType == DAMAGE_TYPE_SONIC) ? d4(nLevel) : d6(nLevel);    //reduced damage dice
    if((nDamageType == DAMAGE_TYPE_COLD) || (nDamageType == DAMAGE_TYPE_ELECTRICAL) || (nDamageType == DAMAGE_TYPE_ACID))
        nDam = max(nLevel, nDam - nLevel);   //minimum of 1 per die

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_BOLT_OF_FIRE));

        iAttackRoll = PRCDoRangedTouchAttack(oTarget);
        if(iAttackRoll > 0)
        {
             // perform ranged touch attack and apply sneak attack if any exists
             ApplyTouchAttackDamage(oPC, oTarget, iAttackRoll, nDam, nDamageType);
             PRCBonusDamage(oTarget);

             //Apply the VFX impact and damage effect
             SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(nImpactVFX), oTarget);
        }
        effect eRay = EffectBeam(nBeam, OBJECT_SELF, BODY_NODE_HAND, !iAttackRoll);
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7,FALSE);
    }
}
