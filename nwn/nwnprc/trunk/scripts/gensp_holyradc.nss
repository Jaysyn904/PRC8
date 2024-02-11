#include "prc_alterations"
void main()
{
    effect eDam;
    effect eVis = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    float  fDelay = 1.0;

   //Get first target in spell area
    object oTarget = GetFirstInPersistentObject();
    while(GetIsObjectValid(oTarget))
    {
       if (MyPRCGetRacialType(oTarget)==RACIAL_TYPE_UNDEAD)
       {
         //Roll Damage
         int nDamage = d4();
         //Set Damage Effect with the modified damage
         eDam = EffectDamage(nDamage, DAMAGE_TYPE_DIVINE);
         DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
         DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
       }
        //Get next target in spell area
        oTarget = GetNextInPersistentObject();
    }
}
