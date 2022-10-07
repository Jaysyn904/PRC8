//////////////////////////////////////////////////////
// Brittlebone
// sp_brittlebn.nss
//////////////////////////////////////////////////////
/* Brittlebone: This unguent must be spread over a set of
bones before animation as a skeleton. The ointment reduces
the skeleton’s natural armor by 2 points (to a minimum of 0),
but when the skeleton is destroyed, its bones splinter and fl y
apart, sending shards in all directions. Any creature within
the skeleton’s reach takes 1 point of piercing damage per HD
of the skeleton (Reflex DC 15 half; minimum 1 point). */

#include "prc_inc_spells"

void main()
{
        object oPC = OBJECT_SELF;
        object oTarget = PRCGetSpellTargetObject();
        string sResRef = GetResRef(oTarget);
        
        //Conditional statement checking for resrefs of skeletons. If you have custom skeletons, add their resrefs here.
        if(sResRef == "nw_s_skeleton" ||
           sResRef == "x2_s_bguard_18" ||
           sResRef == "nw_s_skelchief" ||
           sResRef == "nw_s_skelwarr" ||
           sResRef == "nw_skeleton"   ||
           sResRef == "nw_skelchief"  ||
           sResRef == "nw_skelmage"   ||
           sResRef == "nw_skelpriest" ||
           sResRef == "nw_skelwarr01" ||
           sResRef == "nw_skelwarr02")
        {
                object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oTarget);
                itemproperty ipOnHit = ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1);
                IPSafeAddItemProperty(oSkin, ipOnHit, 0.0f);
                AddEventScript(oTarget, EVENT_NPC_ONDEATH, "prc_evnt_brtbn.nss", FALSE, FALSE);
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectACDecrease(2, AC_NATURAL_BONUS), oTarget);
                SendMessageToPC(oPC, "You have coated the skeleton with Brittlebone.");
        }
        
        else SendMessageToPC(oPC, "Invalid target. The target must be a skeleton.");
}        