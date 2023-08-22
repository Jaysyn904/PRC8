//////////////////////////////////////////////////
//  Moment of Alacrity
//  tob_dmnd_momal.nss
//  Tenjac  10/3/07
//////////////////////////////////////////////////
/** @file Moment of Alacrity
Diamond Mind(Boost)
Level: Swordsage 6, warblade 6
Prerequisite: Two Diamond Mind maneuvers
Initiation Action: 1 swift action
Range: Personal
Target: You
Duration: Instantaneous

You step into a space between heartbeats and act again while your enemies are still
reacting to your last strike.

You can improve your initiative count for the next round and all subsequent round of the 
current encounter. When you initiate this maneuver, your initiative count improves by 20,
and your place in the initiative order changes accordingly. This modifier applies at the
end of the round. Your place in the initiative order changes to reflect moment of alacrity's
effect starting with the next round.

*/

#include "tob_inc_move"
#include "tob_movehook"
#include "inc_timestop"

void main()
{
    if(!PreManeuverCastCode()) return;

    object oInitiator    = OBJECT_SELF;
    object oTarget       = PRCGetSpellTargetObject();
    struct maneuver move = EvaluateManeuver(oInitiator, oTarget);

    if(move.bCanManeuver)
    {
        //probably a couple second timestop on self
        effect eVis = EffectVisualEffect(VFX_FNF_TIME_STOP);
        effect eTime = EffectTimeStop();
        float fDuration = 1.5;
        location lTarget = GetLocation(oInitiator);
        if(GetPRCSwitch(PRC_TIMESTOP_LOCAL))
        {
            eTime = EffectAreaOfEffect(VFX_PER_NEW_TIMESTOP);
            eTime = EffectLinkEffects(eTime, EffectEthereal());
        	if(GetPRCSwitch(PRC_TIMESTOP_NO_HOSTILE))
        	{
        	    AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyNoDamage(), GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oInitiator),fDuration);
        	    AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyNoDamage(), GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator),fDuration);
        	    AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyNoDamage(), GetItemInSlot(INVENTORY_SLOT_BULLETS, oInitiator),fDuration);
        	    AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyNoDamage(), GetItemInSlot(INVENTORY_SLOT_ARROWS, oInitiator),fDuration);
        	    AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyNoDamage(), GetItemInSlot(INVENTORY_SLOT_BOLTS, oInitiator),fDuration);
        	    AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyNoDamage(), GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oInitiator),fDuration);
        	    AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyNoDamage(), GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oInitiator),fDuration);
        	    AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyNoDamage(), GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oInitiator),fDuration);            
        	    DelayCommand(fDuration, RemoveTimestopEquip());
        	    /*
        	    string sSpellscript = PRCGetUserSpecificSpellScript();
        	    DelayCommand(fDuration, PRCSetUserSpecificSpellScript(sSpellscript));
        	    PRCSetUserSpecificSpellScript("tsspellscript");
        	    */
        	    //integrated into main spellhook
        	}            
        }

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(eTime), oInitiator, fDuration);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget);
    }
}