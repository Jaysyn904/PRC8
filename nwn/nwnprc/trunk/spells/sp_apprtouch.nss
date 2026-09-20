//::///////////////////////////////////////////////  
//:: Appraising Touch  
//:: [sp_apprtouch.nss]  
//:://////////////////////////////////////////////  
/*  
Divination  
Level: Bard 1, Sorcerer 1, Wizard 1  
Components: V, S  
Casting Time: 1 standard action  
Range: Personal  
Target: You  
Duration: 1 hour/level  
  
+10 insight bonus on Appraise checks while touching items.  
Merchant interface handles the rest; script only applies the bonus.  
*/  
//:://////////////////////////////////////////////  
#include "prc_inc_spells"  
  
void main()  
{  
    object oCaster = OBJECT_SELF;  
    int nCasterLevel = PRCGetCasterLevel(oCaster);  
  
    effect eSkill = EffectSkillIncrease(SKILL_APPRAISE, 10);  
    effect eVis = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);  
  
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSkill, oCaster, HoursToSeconds(nCasterLevel));  
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oCaster);  
}