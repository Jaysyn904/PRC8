//::///////////////////////////////////////////////
//:: Soulknife: Mindblade Enhancement - Lucky
//:: psi_sk_lucky
//::///////////////////////////////////////////////
/** @file
    Gives a +1 bonus to attack, damage and saves
    for 1 round / sk level.
    
    @author Ornedan
    @date   Created - 2006.03.09
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "psi_inc_soulkn"
#include "inc_utility"

void main()
{
    object oPC;
    if(GetRunningEvent() != EVENT_ONPLAYERREST_FINISHED)
    {
        oPC = OBJECT_SELF;
        if(GetLocalInt(oPC, "PRC_SK_LuckyUsed"))
        {
            FloatingTextStrRefOnCreature(0x01000000 + 47478, oPC, FALSE);
            return;
        }
        
        // Generate effect
        effect eLink    =                          EffectAttackIncrease(1);
               eLink    = EffectLinkEffects(eLink, EffectDamageIncrease(DAMAGE_BONUS_1, DAMAGE_TYPE_SLASHING));
               eLink    = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_ALL, 1));
               eLink    = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
        float fDuration = 6.0f * GetLevelByClass(CLASS_TYPE_SOULKNIFE, oPC);
        
        // Apply it
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDuration, TRUE, SPELL_MINDBLADE_LUCKY, 1);
        
        // Mark the ability used for the day
        SetLocalInt(oPC, "PRC_SK_LuckyUsed", TRUE);
        
        // Add eventhook to OnRestFinished to reset the used marker
        AddEventScript(oPC, EVENT_ONPLAYERREST_FINISHED, "psi_sk_lucky", FALSE, FALSE);
    }
    // Running OnRestFinished
    else
    {
        oPC = GetLastBeingRested();
        DeleteLocalInt(oPC, "PRC_SK_LuckyUsed");
    }
}