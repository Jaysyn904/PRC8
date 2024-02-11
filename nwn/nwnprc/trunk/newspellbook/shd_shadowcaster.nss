#include "prc_inc_function"
#include "shd_inc_shdfunc"      

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("shd_shadowcaster running, event: " + IntToString(nEvent));

    // Get the PC. This is event-dependent
    object oShadow;
    switch(nEvent)
    {
        case EVENT_ONPLAYERREST_FINISHED:   oShadow = GetLastBeingRested();      break;
        case EVENT_ONCLIENTENTER:           oShadow = GetEnteringObject();       break;

        default:
            oShadow = OBJECT_SELF;
    }

    // We aren't being called from any event, instead from EvalPRCFeats
    if(nEvent == FALSE)
    {
        // Hook in the events, needed from level 1 for Mysteries
        if(DEBUG) DoDebug("shd_shadowcaster: Adding eventhooks");
        if (GetLevelByClass(CLASS_TYPE_SHADOWCASTER) >= 20)
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(EffectImmunity(IMMUNITY_TYPE_SLEEP)), oShadow);
    }
}
