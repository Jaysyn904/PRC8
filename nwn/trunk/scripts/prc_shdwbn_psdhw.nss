#include "prc_inc_spells"

void main()
{
    object oPC = OBJECT_SELF;

    if(!CheckTurnUndeadUses(oPC, 1))
    {
        SpeakStringByStrRef(40550);
        return;
    }
    
    int nClass = GetLevelByClass(CLASS_TYPE_SHADOWBANE_INQUISITOR, oPC);
    float fDur = nClass * 600.0;  // 10 minutes a level
    SetLocalInt(oPC, "PierceShadows", TRUE);
    DelayCommand(fDur, DeleteLocalInt(oPC, "PierceShadows"));

    effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_LIGHT_WHITE_20), EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
    eLink = SupernaturalEffect(eLink);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDur);
}