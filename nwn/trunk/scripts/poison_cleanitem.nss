//::///////////////////////////////////////////////
//:: Clean Off Poison spellscript
//:: poison_cleanitem
//::///////////////////////////////////////////////
/*
    Removes contact poison, all relevant locals
    and this spell from the item casting this spell.
    This spell is attached to any items that are
    poisoned.
    
    Any character other than the original poisoner
    using this will have to roll Disable Traps
    versus a DC stored on the item. On failure,
    they get poisoned.
    Either way, the removal happens.
    
    Locals removed, integers:
      pois_itm_idx
      pois_itm_uses
      pois_itm_trap_dc
      pois_itm_safecount
    
    Locals removed, objects:
      pois_itm_poisoner
      pois_itm_safe_X  , where X is from 1 to pois_itm_safecount

*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 10.01.2005
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "inc_poison"
#include "prc_inc_spells"


void main()
{
    object oItem   = GetSpellCastItem();
    object oPC     = OBJECT_SELF;
    
    if(!(oPC == GetLocalObject(oItem, "pois_itm_poisoner")))
    {
        int nDC = GetLocalInt(oItem, "pois_itm_trap_dc");
        
        if(!GetIsSkillSuccessful(oPC, SKILL_DISABLE_TRAP, nDC))
        {
            // Apply the poison to the cleaner
            int nPoisonIdx = GetLocalInt(oItem, "pois_itm_idx");
            effect ePoison = EffectPoison(nPoisonIdx);
            SPApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoison, oPC, 0.0f, FALSE);
            
            // Inform the cleaner of the fact
            SendMessageToPC(oPC,
                            GetStringByStrRef(STRREF_CLEAN_ITEM_FAIL_1) + " " +
                            GetName(oItem) + " " +
                            GetStringByStrRef(STRREF_CLEAN_ITEM_FAIL_2)
                           ); // You slip while cleaning xxxx and touch the poison.
        }// end if - Disable Trap check failed
    }// end if - Handle cleaner != poisoner
    
    // Remove the poison and inform player
    DoPoisonRemovalFromItem(oItem);
    SendMessageToPC(oPC,
                    GetStringByStrRef(STRREF_CLEAN_ITEM_SUCCESS) + " " +
                    GetName(oItem) + "."
                   ); // You remove all traces of poison off of xxxx.
}