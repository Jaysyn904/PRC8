//:://////////////////////////////////////////////
//:: Generic Listener object OnSpawn script
//:: prc_glist_onspwn
//:://////////////////////////////////////////////
/** @file
    The generic listener's OnSpawn script.
    Currently just for debugging.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 04.08.2005
//:://////////////////////////////////////////////


void main()
{
    object oListener = OBJECT_SELF;
    SetListening(oListener, TRUE);

    if(!GetLocalInt(oListener, "PRC_GenericListener_NoNotification"))
    {
        if(GetLocalInt(oListener, "PRC_GenericListener_ListenToSingle"))
            // "Listener ready. Due to some detail of how the NWN engine handles listening, the listener may only actually start listening during the next 3 seconds."
            AssignCommand(oListener, SendMessageToPCByStrRef(GetLocalObject(oListener, "PRC_GenericListener_ListeningTo"), 16825209));
        else
            AssignCommand(oListener, FloatingTextStrRefOnCreature(16825209, oListener, FALSE));
    }
}