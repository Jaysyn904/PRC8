#include "prc_inc_spells"

void main()
{
    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nCasterLvl = PRCGetCasterLevel(oCaster);
    int nPenetr = nCasterLvl + SPGetPenetr();
    float fDur = RoundsToSeconds(d6(2));

    if (!PRCDoResistSpell(oCaster, oTarget, nPenetr))
    {
        SetLocalInt(oTarget, "WildMageStrike", TRUE);
        DelayCommand(fDur, DeleteLocalInt(oTarget, "WildMageStrike"));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_PRISMATIC_SPHERE), oTarget, fDur);
    }
}
