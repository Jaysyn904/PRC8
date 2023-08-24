#include "inv_inc_invfunc"

void main()
{
    SetAllAoEInts(INVOKE_NIGHTMARES_MADE_REAL,OBJECT_SELF, GetSpellSaveDC());

    int nCasterLevel = GetInvokerLevel(GetAreaOfEffectCreator(), CLASS_TYPE_WARLOCK);
    int nPenetr = SPGetPenetrAOE(GetAreaOfEffectCreator(), nCasterLevel);
    object oTarget = GetFirstInPersistentObject();
    while(GetIsObjectValid(oTarget))
    {
        if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE , GetAreaOfEffectCreator())
            && PRCGetHasEffect(EFFECT_TYPE_ENTANGLE, oTarget)
            && oTarget != GetAreaOfEffectCreator()
            && GetCreatureFlag(oTarget, CREATURE_VAR_IS_INCORPOREAL) != TRUE)
        {
            //Fire cast spell at event for the target
            SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(),
                INVOKE_NIGHTMARES_MADE_REAL));
                
            effect eDamage = EffectDamage(d6(), DAMAGE_TYPE_MAGICAL);
            eDamage = EffectLinkEffects(eDamage, EffectVisualEffect(VFX_IMP_MAGBLUE));
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
        }
        oTarget = GetNextInPersistentObject();
    }


}
