#include "prc_alterations"
void main()
{

 if (GetHasSpellEffect(SPELL_FURIOUS_ASSAULT))
 {
     PRCRemoveSpellEffects(SPELL_FURIOUS_ASSAULT,OBJECT_SELF,OBJECT_SELF);
     string nMes = "*Furious Assault Mode Deactivated*";
     FloatingTextStringOnCreature(nMes, OBJECT_SELF, FALSE);
 }
 else
 {
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,ExtraordinaryEffect(EffectLinkEffects(EffectModifyAttacks(1),EffectAttackDecrease(2))),OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectVisualEffect(VFX_FNF_LOS_HOLY_20),OBJECT_SELF,2.0);

    string nMes = "*Furious Assault Mode Activated*";
    FloatingTextStringOnCreature(nMes, OBJECT_SELF, FALSE);
 }

}
