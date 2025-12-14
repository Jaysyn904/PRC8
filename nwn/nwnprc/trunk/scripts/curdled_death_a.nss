//::///////////////////////////////////////////////  
//:: Aroma of Curdled Death: On Enter  
//:: FileName: curdled_death_a.nss  
//::///////////////////////////////////////////////  
/*  
    Creates an invisible cloud that moves with the user.  
    Effects based on Hit Dice:  
    - 3 HD or less: dies immediately (no save)  
    - 4-6 HD: Fort save DC 17 or dies  
    - 7+ HD: 1d4 Con damage (Fort DC 17 half)  
*/  
//::///////////////////////////////////////////////  
#include "prc_inc_spells"  
  
void main()  
{  
    DoDebug("Entering curdled_death_a / onEnter."); 
	
	// Declare major variables  
    object oTarget = GetEnteringObject();  
    object oCreator = GetAreaOfEffectCreator();  
    int nHD = GetHitDice(oTarget);  
      
    // Skip if target is the creator (immune)  
    if(oTarget == oCreator) return;  
      
    // Check if target is hostile  
    if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCreator))  
    {  
        // Signal spell cast at target  
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CLOUDKILL));  
          
        // Apply effects based on HD  
        if(nHD <= 3)  
        {  
            // Instant death for 3 HD or less  
            if(!GetIsImmune(oTarget, IMMUNITY_TYPE_DEATH))  
            {  
                DoDebug("curdled_death_a: found a target."); 
				effect eDeath = EffectDeath();  
                effect eVis = EffectVisualEffect(VFX_IMP_DEATH);  
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);  
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget);  
            }  
        }  
        else if(nHD >= 4 && nHD <= 6)  
        {  
            // Fort save or die for 4-6 HD  
            if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, 17, SAVING_THROW_TYPE_DEATH, OBJECT_SELF))  
            {  
                DoDebug("curdled_death_a: found a target.");
				effect eDeath = EffectDeath();  
                effect eVis = EffectVisualEffect(VFX_IMP_DEATH);  
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget);  
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);  
            }  
        }  
        else  
        {  
            // 7+ HD: Constitution damage with save for half  
            int nDam = d4();  
            if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, 17, SAVING_THROW_TYPE_SPELL, OBJECT_SELF))  
            {  
                // Full damage  
                DoDebug("curdled_death_a: found a target.");
				AssignCommand(oCreator, ApplyAbilityDamage(oTarget, ABILITY_CONSTITUTION, nDam, DURATION_TYPE_TEMPORARY, TRUE, -1.0f));  
            }  
            else  
            {  
                // Half damage on successful save  
                DoDebug("curdled_death_a: found a target.");
				AssignCommand(oCreator, ApplyAbilityDamage(oTarget, ABILITY_CONSTITUTION, nDam / 2, DURATION_TYPE_TEMPORARY, TRUE, -1.0f));  
            }  
            effect eNeg = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);  
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eNeg, oTarget);  
        }  
    }  
}