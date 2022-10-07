#include "prc_alterations"

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("prc_juggernaut running, event: " + IntToString(nEvent));

    // Get the PC. This is event-dependent
    object oPC;
    object oSkin = GetPCSkin(oPC);
    switch(nEvent)
    {
        case EVENT_ITEM_ONHIT:          oPC = OBJECT_SELF;               break;
        case EVENT_ONPLAYEREQUIPITEM:   oPC = GetItemLastEquippedBy();   break;
        case EVENT_ONPLAYERUNEQUIPITEM: oPC = GetItemLastUnequippedBy(); break;
        case EVENT_ONHEARTBEAT:         oPC = OBJECT_SELF;               break;

        default:
            oPC = OBJECT_SELF;
    }

    int nClass = GetLevelByClass(CLASS_TYPE_WARFORGED_JUGGERNAUT, oPC);
    
    if (nClass >= 4)
    {
        IPSafeAddItemProperty(oSkin, ItemPropertySpellImmunitySchool(IP_CONST_SPELLSCHOOL_NECROMANCY), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    }        
}
