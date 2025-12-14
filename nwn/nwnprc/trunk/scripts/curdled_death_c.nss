//::///////////////////////////////////////////////  
//:: Aroma of Curdled Death: Heartbeat  
//:: FileName: curdled_death_c.nss  
//::///////////////////////////////////////////////  
/*  
    Applies recurring effects each round to creatures  
    remaining in the cloud.  
*/  
//::///////////////////////////////////////////////  
#include "prc_inc_spells"  
  
void main()  
{  
    DoDebug("Entering curdled_death_c / onHeartbeat.");
	
	// Check if creator is still valid  
    if(!GetIsObjectValid(GetAreaOfEffectCreator()))  
    {  
        DestroyObject(OBJECT_SELF);  
        return;  
    }  
      
    object oTarget;  
    object oCreator = GetAreaOfEffectCreator();  
      
    // Cycle through all creatures in the AoE  
    oTarget = GetFirstInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);  
    while(GetIsObjectValid(oTarget))  
    {  
        // Skip the creator (immune)  
        if(oTarget != oCreator &&  
           spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCreator))  
        {  
            int nHD = GetHitDice(oTarget);  
              
            // Signal spell cast at target  
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CLOUDKILL));  
              
            // Apply effects based on HD  
            if(nHD <= 3)  
            {  
                // Already dead from OnEnter, but check anyway  
                if(!GetIsImmune(oTarget, IMMUNITY_TYPE_DEATH))  
                {  
                    effect eDeath = EffectDeath();  
                    effect eVis = EffectVisualEffect(VFX_IMP_DEATH);  
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);  
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget);  
                }  
            }  
            else if(nHD >= 4 && nHD <= 6)  
            {  
                // Fort save or die each round  
                if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, 17, SAVING_THROW_TYPE_DEATH, OBJECT_SELF))  
                {  
                    effect eDeath = EffectDeath();  
                    effect eVis = EffectVisualEffect(VFX_IMP_DEATH);  
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget);  
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);  
                }  
            }  
            else  
            {  
                // 7+ HD: Constitution damage each round  
                int nDam = d4();  
                if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, 17, SAVING_THROW_TYPE_SPELL, OBJECT_SELF))  
                {  
                    // Full damage  
                    AssignCommand(oCreator, ApplyAbilityDamage(oTarget, ABILITY_CONSTITUTION, nDam, DURATION_TYPE_TEMPORARY, TRUE, -1.0f));  
                }  
                else  
                {  
                    // Half damage on successful save  
                    AssignCommand(oCreator, ApplyAbilityDamage(oTarget, ABILITY_CONSTITUTION, nDam / 2, DURATION_TYPE_TEMPORARY, TRUE, -1.0f));  
                }  
                effect eNeg = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);  
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eNeg, oTarget);  
            }  
        }  
        oTarget = GetNextInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);  
    }  
}