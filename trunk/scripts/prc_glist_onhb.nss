//:://////////////////////////////////////////////
//:: Generic Listener object OnHearbeat script
//:: prc_glist_onhb
//:://////////////////////////////////////////////
/** @file
    The generic listener object's heartbeat script.
    If the listener is listening to a single object,
    makes sure the target is still a valid object.
    If it isn't, the listener deletes itself.
    
    If the listener is listening at a location,
    returns the listener to that location if it had moved.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 19.06.2005
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_inc_listener"

void ApplyEffects(object oListener)
{
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY), oListener, 9999.0f);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectCutsceneGhost(), oListener);
}

void main()
{
    object oListener = OBJECT_SELF;
    // Check if we are listening to a single creature or an area
    if(GetLocalInt(oListener, "PRC_GenericListener_ListenToSingle"))
    {
        object oListeningTo = GetLocalObject(oListener, "PRC_GenericListener_ListeningTo");
        if(GetIsObjectValid(oListeningTo))
        {
            ClearAllActions(TRUE);
            AssignCommand(oListener, ActionJumpToLocation(GetLocation(oListeningTo)));
            AssignCommand(oListener, ActionForceFollowObject(oListeningTo));
            if (DEBUG) DoDebug("Listener distance to listened: " + FloatToString(GetDistanceBetween(oListener, oListeningTo))
                + ". In the same area: " + (GetArea(oListener) == GetArea(oListeningTo) ? "TRUE":"FALSE"));
        }
        else
            DestroyListener(oListener);
    }
    // An area. Just make sure the listener stays there
    else
    {
        if(GetLocation(oListener) != GetLocalLocation(oListener, "PRC_GenericListener_ListeningLocation"))
            AssignCommand(oListener, JumpToLocation(GetLocalLocation(oListener, "PRC_GenericListener_ListeningLocation")));
    }

    // Handle timers
    int nVFXTimer = 0;
    if(!nVFXTimer)
    {
        // Loop and remove the previous invisibility effect
        effect eTest = GetFirstEffect(oListener);
        while(GetIsEffectValid(eTest))
        {
            int nEffectType = GetEffectType(eTest);
            if(nEffectType == EFFECT_TYPE_VISUALEFFECT || nEffectType == EFFECT_TYPE_CUTSCENEGHOST)
                RemoveEffect(oListener, eTest);
            eTest = GetNextEffect(oListener);
        }
        //Reapply effects
        DelayCommand(0.0f, ApplyEffects(oListener));
            //The RemoveEffect calls above don't take effect until this script has finished running, so delay reapplying the effects until after that happens.
            //Otherwise, the effects that we add here may be deleted when the effects are actually removed later.
        nVFXTimer = 1500;
    }
    SetLocalInt(oListener, "PRC_GenericListener_VFXRefreshTimer", nVFXTimer);

    if(GetLocalInt(oListener, "PRC_GenericListener_HasLimitedDuration"))
    {
        int nDeathTimer = GetLocalInt(oListener, "PRC_GenericListener_DestroyTimer") - 1;
        if(nDeathTimer <= 0)
        {
            DestroyListener(oListener);
        }

        SetLocalInt(oListener, "PRC_GenericListener_DestroyTimer", nDeathTimer);
        DoDebug("Listener duration left: " + IntToString(nDeathTimer * 6));
    }
}
