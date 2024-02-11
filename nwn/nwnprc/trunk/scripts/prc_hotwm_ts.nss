//::///////////////////////////////////////////////
//:: True Stealth
//:: prc_hotwm_ts.nss
//::///////////////////////////////////////////////
/*
    Handles the True Stealth ability for Hands of the Winged Masters
*/
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: Nov 23, 2007
//:://////////////////////////////////////////////

#include "prc_alterations"

void RemoveStealth(object oPC)
{
    effect eLoop=GetFirstEffect(oPC);

    while (GetIsEffectValid(eLoop))
       {
           if(GetEffectSubType(eLoop) == SUBTYPE_EXTRAORDINARY)
           {
                 if (GetEffectType(eLoop) == EFFECT_TYPE_CONCEALMENT)
                      RemoveEffect(oPC, eLoop);
                 else if (GetEffectType(eLoop) == EFFECT_TYPE_SKILL_DECREASE)
                      RemoveEffect(oPC, eLoop);
             }
                
           eLoop=GetNextEffect(oPC);
       }
               
       SetLocalInt(oPC, "TrueStealthApplied", FALSE);
}

void main()
{
    object oPC = OBJECT_SELF;
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("prc_hotwm_ts running, event: " + IntToString(nEvent));

    //Activation/Deactivation
    if(nEvent != EVENT_ONHEARTBEAT)
    {
        if(GetLocalInt(oPC, "TrueStealthOn"))
        {
            SetLocalInt(oPC, "TrueStealthOn", FALSE);
            RemoveEventScript(oPC, EVENT_ONHEARTBEAT, "prc_hotwm_ts", TRUE, FALSE);
            FloatingTextStringOnCreature("*True Stealth Deactivated*", oPC, FALSE);
            RemoveStealth(oPC);
        }
        else
        {
            SetLocalInt(oPC, "TrueStealthOn", TRUE);
            FloatingTextStringOnCreature("*True Stealth Activated*", oPC, FALSE);
            AddEventScript(oPC, EVENT_ONHEARTBEAT, "prc_hotwm_ts", TRUE, FALSE);
        }
    }
    else if(nEvent == EVENT_ONHEARTBEAT)
    {
        int nMode = GetStealthMode(oPC);
        if((nMode == STEALTH_MODE_ACTIVATED) && !GetLocalInt(oPC, "TrueStealthApplied"))
        {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectConcealment(50)), oPC, 9999.0f);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectSkillDecrease(SKILL_HIDE, 10)), oPC, 9999.0f);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectSkillDecrease(SKILL_MOVE_SILENTLY, 10)), oPC, 9999.0f);
            SetLocalInt(oPC, "TrueStealthApplied", TRUE);
        }
        else if((nMode == STEALTH_MODE_DISABLED) && GetLocalInt(oPC, "TrueStealthApplied"))
        {
            RemoveStealth(oPC);
        }
    }
}