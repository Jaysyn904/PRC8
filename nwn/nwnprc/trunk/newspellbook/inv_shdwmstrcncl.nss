

#include "prc_sp_func"
#include "inv_inc_invfunc"

void main()
{
    
    object oCaster = OBJECT_SELF;
    int nCasterLevel = GetInvokerLevel(OBJECT_SELF, CLASS_TYPE_WARLOCK);
    
    effect eInvis = EffectConcealment(50);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eInvis, eDur);
    
    effect eVis = EffectVisualEffect(VFX_IMP_DEATH_WARD );

    //Apply the VFX impact and effects
    SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oCaster, HoursToSeconds(24),TRUE,-1,nCasterLevel);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oCaster);
}