#include "x2_inc_switches"
#include "x2_inc_spellhook"

void main()
{
    effect eVis = EffectVisualEffect(VFX_DUR_SPELLTURNING);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,ExtraordinaryEffect(eVis),OBJECT_SELF);
    FloatingTextStringOnCreature("Channeling Activated",OBJECT_SELF);
    SetLocalString(OBJECT_SELF,"ovscript",PRCGetUserSpecificSpellScript());
    PRCSetUserSpecificSpellScript("prc_spell_chanel");
}
