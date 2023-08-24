//::///////////////////////////////////////////////
//:: Frenzied Berserker - Armor/Skin
//:://////////////////////////////////////////////
/*
    Script for Auto Frenzy on hit
    Moved to separate script to fix GetTotalDamageDealt() issues
*/
//:://////////////////////////////////////////////
//:: Created By: Oni5115
//:://////////////////////////////////////////////

void main()
{
     int iDam = GetTotalDamageDealt();
     iDam += GetLocalInt(OBJECT_SELF, "PC_Damage");
     SetLocalInt(OBJECT_SELF, "PC_Damage", iDam);
             
     int iCHP = GetCurrentHitPoints(OBJECT_SELF) - iDam;
             
     string sFeedback = GetName(OBJECT_SELF) + " : Current HP = " + IntToString(iCHP);
     SendMessageToPC(OBJECT_SELF, sFeedback);
}