
#include "prc_alterations"

void main()
{
    object oPC = PRCGetSpellTargetObject();

    //PRCRemoveEffectsFromSpell(oPC, GetSpellId());

    int nLevel = GetLevelByClass(CLASS_TYPE_SACREDFIST, oPC);
    int iSpeed = (nLevel > 2) ? 10 : 0;
        iSpeed = (nLevel > 5) ? 20 : iSpeed;
        iSpeed = (nLevel > 7) ? 30 : iSpeed;

    int nEFLevel = GetLevelByClass(CLASS_TYPE_ENLIGHTENEDFIST, oPC);
    int nMonkLevel = GetLevelByClass(CLASS_TYPE_MONK, oPC);
    iSpeed += (((nMonkLevel % 3) + nEFLevel) / 3) * 10;

    if (GetHasFeat(FEAT_TYPE_ELEMENTAL, oPC) >= 10 && GetHasFeat(FEAT_BONDED_AIR,oPC))
        iSpeed += 30;

    if (iSpeed > 99) iSpeed = 99;

    if (iSpeed != 0)
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,ExtraordinaryEffect(EffectMovementSpeedIncrease(iSpeed)),oPC);
}
