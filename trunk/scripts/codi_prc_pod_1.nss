#include "prc_alterations"
void main()
{
    object oItem = GetInventoryDisturbItem();
    object oPC = GetLastDisturbed();
    if(GetPlotFlag(oItem))
    {
        FloatingTextStringOnCreature("You cannot sacrifice plot items.", oPC, FALSE);
        ActionGiveItem(oItem, oPC);
        return;
    }
    if(!GetIdentified(oItem) && !GetPRCSwitch(PRC_SAMURAI_ALLOW_UNIDENTIFIED_SACRIFICE))
    {
        FloatingTextStringOnCreature("You cannot sacrifice unidentified items.", oPC, FALSE);
        ActionGiveItem(oItem, oPC);
        return;
    }
    if(GetStolenFlag(oItem) && !GetPRCSwitch(PRC_SAMURAI_ALLOW_STOLEN_SACRIFICE))
    {
        FloatingTextStringOnCreature("You cannot sacrifice stolen items.", oPC, FALSE);
        ActionGiveItem(oItem, oPC);
        return;
    }
    SetIdentified(oItem, TRUE);
    int iValue = GetGoldPieceValue(oItem);
    if(GetPRCSwitch(PRC_SAMURAI_SACRIFICE_SCALAR_x100))
        iValue *= FloatToInt(IntToFloat(iValue)*(IntToFloat(GetPRCSwitch(PRC_SAMURAI_SACRIFICE_SCALAR_x100))/100.0));
    DestroyObject(oItem);
    if (iValue > 0)
    {
        int iCurrentValue = GetPersistantLocalInt(oPC, "CODI_SAMURAI");
        SetPersistantLocalInt(oPC, "CODI_SAMURAI", iCurrentValue + iValue);
        FloatingTextStringOnCreature("Your sacrifice is accepted. You now have " + IntToString(iCurrentValue + iValue) + " gold in sacrifices.", oPC);
    }
}
