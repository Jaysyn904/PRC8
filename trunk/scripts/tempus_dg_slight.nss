#include "prc_feat_const"

void main()
{
    object oPC = GetPCSpeaker();
   if (GetLocalInt(oPC,"WeapEchant1")==TEMPUS_ABILITY_LIGHTBOLT)
        return;

    if(!GetLocalInt(oPC,"WeapEchant1"))
      SetLocalInt(oPC,"WeapEchant1",TEMPUS_ABILITY_LIGHTBOLT);
    else if(!GetLocalInt(oPC,"WeapEchant2"))
      SetLocalInt(oPC,"WeapEchant2",TEMPUS_ABILITY_LIGHTBOLT);

     SetLocalInt(oPC,"TempusPower",GetLocalInt(oPC,"TempusPower")-2);

}
