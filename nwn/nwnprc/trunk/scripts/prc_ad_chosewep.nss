#include "prc_alterations"
#include "prc_class_const"

void ChooseWeapon(object oPC, object oWeapon)
{
    string sName = GetName(oWeapon);

    SetLocalInt(oPC, "HAS_CHOSEN_WEAPON", 2);
    SetLocalInt(oWeapon, "CHOSEN_WEAPON", 2);
    SetLocalObject(oPC, "CHOSEN_WEAPON", oWeapon);
    if (GetPlotFlag(oWeapon) == FALSE)
    {
       SetLocalInt(oWeapon, "CHOSEN_WEAPON_PLOT", TRUE);
       SetPlotFlag(oWeapon, TRUE);
    }
    SendMessageToPC(oPC, "You have chosen "+sName+" to be your chosen weapon.");
    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyVisualEffect(ITEM_VISUAL_HOLY), oWeapon, 0.0);

    DelayCommand(0.1, ExecuteScript("prc_arcduel", oPC)); // reevaluate things so the weapon bonus is applied.
}

void UnchooseWeapon(object oPC)
{
    object oWeapon = GetLocalObject(oPC, "CHOSEN_WEAPON");
    string sName = GetName(oWeapon);

    DeleteLocalInt(oWeapon, "CHOSEN_WEAPON");
    if (GetLocalInt(oWeapon, "CHOSEN_WEAPON_PLOT"))
    {
        DeleteLocalInt(oWeapon, "CHOSEN_WEAPON_PLOT");
        SetPlotFlag(oWeapon, FALSE);
    }
    SendMessageToPC(oPC, sName+" is no longer your chosen weapon.");
    RemoveSpecificProperty(oWeapon, ITEM_PROPERTY_VISUALEFFECT);
}

void main()
{
    object oWeapon = PRCGetSpellTargetObject();
    object oPC = OBJECT_SELF;
    int iChosen = GetLocalInt(oPC, "HAS_CHOSEN_WEAPON");

    if (iChosen == 2)
    {
        if (oWeapon == GetLocalObject(oPC, "CHOSEN_WEAPON"))
        {
            SendMessageToPC(oPC, "That weapon is already your chosen weapon.");
            return;
        }

        SendMessageToPC(oPC, "You begin to bond with the new weapon.  It will be your chosen weapon in 20 turns.");
        DelayCommand(TurnsToSeconds(20)+0.0, UnchooseWeapon(oPC));
        DelayCommand(TurnsToSeconds(20)+0.1, ChooseWeapon(oPC, oWeapon));
    }
    else
    {
        ChooseWeapon(oPC, oWeapon);
    }
}

