/*
Detect Magic
*/

#include "prc_inc_s_det"

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_DIVINATION);

    object oCaster = OBJECT_SELF;
    int nLevel = PRCGetCasterLevel(oCaster);
    float fDuration = TurnsToSeconds(nLevel) * 10;

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_DETECT), oCaster, fDuration);

    DetectMagicAura(0, GetLocation(oCaster), VFX_BEAM_MIND, FeetToMeters(60.0));

    PRCSetSchool();
}