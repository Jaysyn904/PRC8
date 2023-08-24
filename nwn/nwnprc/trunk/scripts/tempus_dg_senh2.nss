#include "prc_feat_const"

void main()
{
    object oPC = GetPCSpeaker();

   if (GetLocalInt(oPC,"WeapEchant1")==TEMPUS_ABILITY_ENHANC2)
        return;

    if(!GetLocalInt(oPC,"WeapEchant1"))
      SetLocalInt(oPC,"WeapEchant1",TEMPUS_ABILITY_ENHANC2);
    else if(!GetLocalInt(oPC,"WeapEchant2"))
      SetLocalInt(oPC,"WeapEchant2",TEMPUS_ABILITY_ENHANC2);

     SetLocalInt(oPC,"TempusPower",GetLocalInt(oPC,"TempusPower")-2);

}
