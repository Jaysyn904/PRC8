#include "prc_alterations"

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("prc_frostmage running, event: " + IntToString(nEvent));

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

    int nClass = GetLevelByClass(CLASS_TYPE_FROST_MAGE, oPC);
    int nAC = 1;
    if (nClass >= 4) nAC += 1;
    if (nClass >= 7) nAC += 1;
    if (nClass >= 10) nAC += 1;
    
    //FloatingTextStringOnCreature("Frost Mage Natural Armor "+IntToString(nAC),oPC,FALSE);

    //SetCompositeBonus(oSkin, "FrostMageAC", nAC, AC_NATURAL_BONUS, ITEM_PROPERTY_AC_BONUS);
    //ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectACIncrease(nAC, AC_NATURAL_BONUS), oPC);
}
