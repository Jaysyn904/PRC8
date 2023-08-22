/*
    prc_pyro_touch

    Touch attack when using Nimbus

    By: Flaming_Sword
    Created: Dec 7, 2007
    Modified: Dec 7, 2007
*/

#include "prc_inc_sp_tch"

void main()
{
    object oPC = OBJECT_SELF;
    if(!GetHasSpellEffect(SPELL_NIMBUS, oPC))
    {
        FloatingTextStringOnCreature("*Nimbus Is Not Active!*", oPC);
        return;
    }
    object oTarget = PRCGetSpellTargetObject();
    int nDamageType = GetPersistantLocalInt(oPC, "PyroDamageType");
    int nLevel = (GetLevelByClass(CLASS_TYPE_PYROKINETICIST, oPC));
    int nDice = (nLevel >= 8) ? 4 : 2;
    int iAttackRoll = 0;
    int nImpactVFX = GetPersistantLocalInt(oPC, "PyroImpactVFX");

    int nDam = (nDamageType == DAMAGE_TYPE_SONIC) ? d4(nDice) : d6(nDice);    //reduced damage dice
    if((nDamageType == DAMAGE_TYPE_COLD) || (nDamageType == DAMAGE_TYPE_ELECTRICAL) || (nDamageType == DAMAGE_TYPE_ACID))
        nDam = max(nDice, nDam - nDice);   //minimum of 1 per die

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_NIMBUS_TOUCH_ATTACK));

        iAttackRoll = PRCDoMeleeTouchAttack(oTarget);
        if(iAttackRoll > 0)
        {
             // perform melee touch attack and apply sneak attack if any exists
             ApplyTouchAttackDamage(oPC, oTarget, iAttackRoll, nDam, nDamageType);
             PRCBonusDamage(oTarget);

             //Apply the VFX impact and damage effect
             SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(nImpactVFX), oTarget);
        }
    }
}
