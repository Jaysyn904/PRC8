//Spell script for reserve feat ranged touch attacks
//prc_reservrng
//by ebonfowl
//Dedicated to Edgar, the real Ebonfowl

#include "prc_inc_sp_tch"
#include "prc_add_spell_dc"
#include "prc_inc_spells"

void DoRanged(effect eVis, int nSaveType, int nDamage, int nDamageType, int nSpellID = -1)
{
    object oTarget = PRCGetSpellTargetObject();
    int nAtk = PRCDoRangedTouchAttack(oTarget, TRUE, OBJECT_SELF);
     
    if(nAtk)
    {
        effect eMissile = EffectVisualEffect(VFX_IMP_MIRV);
         
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            //Fire cast spell at event for the specified target
            PRCSignalSpellEvent(oTarget, TRUE, nSpellID);
             
            // Apply the damage and the damage visible effect to the target.
            ApplyTouchAttackDamage(OBJECT_SELF, oTarget, nAtk, nDamage, nDamageType);
            PRCBonusDamage(oTarget);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
             
            /*if(PRCGetIsAliveCreature(oTarget))
            {
                // If the target failed it's save then apply the failed save effect as well for 1 round.
                if (!PRCMySavingThrow(nSaveType, oTarget, PRCGetSaveDC(oTarget, OBJECT_SELF)))
                {
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFailSave, oTarget, RoundsToSeconds(1),TRUE,-1,nCasterLvl);
                }
            }*/
        }           
    }
    PRCSetSchool();
}

void main()
{
	int nSpellID = PRCGetSpellId();
    int nDice, nDamage;
    
    effect eVis, eVisFail;

    if (!GetLocalInt(OBJECT_SELF, "AcidicSplatterBonus"))
    {
        FloatingTextStringOnCreature("You do not have a spell available of adequate level or type", OBJECT_SELF, FALSE);
        return;
    }

    switch (nSpellID)
    {
        case SPELL_ACIDIC_SPLATTER:
        {
	        nDamage = d6(GetLocalInt(OBJECT_SELF, "AcidicSplatterBonus"));
            
            eVis = EffectVisualEffect(VFX_IMP_ACID_S);
	        eVisFail = EffectVisualEffect(VFX_IMP_STUN);

	        DoRanged(eVis, SAVING_THROW_TYPE_ACID, nDamage, DAMAGE_TYPE_ACID);
        }
    }
}
