#include "prc_inc_spells"
#include "prc_add_spell_dc"
void main()
{
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
    if (!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_EVOCATION);

    // Apply a burst visual effect at the target location.    
    location lTarget = PRCGetSpellTargetLocation();
    effect eImpact = EffectVisualEffect(VFX_FNF_BLINDDEAF);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);

    // Create needed effects.
    effect eDazzle = EffectLinkEffects(EffectDazzle(),
        EffectVisualEffect(VFX_IMP_STUN));
    effect eBlindness = EffectLinkEffects(EffectBlindness(), 
        EffectVisualEffect(VFX_DUR_BLIND));

       int nCasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget);
    while(GetIsObjectValid(oTarget))
    {
        if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            PRCSignalSpellEvent(oTarget);

            // Apply impact vfx.            
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, 
                EffectVisualEffect(VFX_IMP_SONIC), oTarget);

            // Creatures are dazzled whether they save or not.
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDazzle, oTarget, RoundsToSeconds(1),TRUE,-1,nCasterLvl);
            
            // Let the creature make a will save, if it fails it's blinded.
            if (!PRCDoResistSpell(OBJECT_SELF, oTarget) &&
                !PRCMySavingThrow(SAVING_THROW_WILL, oTarget, PRCGetSaveDC(oTarget,OBJECT_SELF)))
            {
                // Determine the spell's duration, the duration can be empower,
                // maximized, or extended (since it's variable, empower/maximize
                // apply.
                int nRounds = PRCGetMetaMagicDamage(DAMAGE_TYPE_MAGICAL, 2, 8);
                float fDuration = PRCGetMetaMagicDuration(RoundsToSeconds(nRounds));

                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlindness, oTarget, fDuration,TRUE,-1,nCasterLvl);
            }
        }
        
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget);
    }

    PRCSetSchool();
}
