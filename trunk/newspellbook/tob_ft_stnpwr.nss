//::///////////////////////////////////////////////
//:: Name      Stone Power
//:: FileName  tob_ft_stnpwr.nss
//:://////////////////////////////////////////////
/** You can take a penalty of as much as -5 on your 
attack rolls. This number cannot exceed your base 
attack bonus. You gain temporary hit points equal 
to twice the number that you subtract from your 
attack rolls (to a maximum of +10). These 
temporary hitpoints last until the beginning of 
your next turn.

Pressing the feat repeatedly will cycle through 
the options available.

Author:    Stratovarius
Created:   11.11.2018
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_effect_inc"

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("tob_ft_stnpwr running, event: " + IntToString(nEvent));
    object oInitiator = OBJECT_SELF;
    
    // We aren't being called from any event, instead from the feat
    if(nEvent == FALSE)
    {    
        int nSwitch = GetLocalInt(oInitiator, "StonePowerSwitch") + 1;
        int nBAB = GetBaseAttackBonus(oInitiator);
    
        if (nSwitch > 5 || nSwitch > nBAB) 
        {
            DeleteLocalInt(oInitiator, "StonePowerSwitch");
            nSwitch = 0;
            FloatingTextStringOnCreature("Stone Power disabled", oInitiator, FALSE);
            RemoveEventScript(oInitiator, EVENT_ONHEARTBEAT, "tob_ft_stnpwr", TRUE, FALSE);
        }
        else
        {
            SetLocalInt(oInitiator, "StonePowerSwitch", nSwitch);
            FloatingTextStringOnCreature("Stone Power set to "+IntToString(nSwitch), oInitiator, FALSE);
            AddEventScript(oInitiator, EVENT_ONHEARTBEAT, "tob_ft_stnpwr", TRUE, FALSE);
        }
    }   
    else if(nEvent == EVENT_ONHEARTBEAT)
    {    
        // No Stacking
        PRCRemoveSpellEffects(GetSpellId(), oInitiator, oInitiator);
        // Skip applying effects if nothing to apply
        int nSwitch = GetLocalInt(oInitiator, "StonePowerSwitch");
        if (nSwitch == 0) return;
    
        effect eLink = EffectLinkEffects(EffectAttackDecrease(nSwitch), EffectTemporaryHitpoints(nSwitch * 2));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(eLink), oInitiator, 6.0);
    }    
}

