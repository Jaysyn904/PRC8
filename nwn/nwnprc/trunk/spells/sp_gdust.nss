#include "prc_inc_spells"
#include "prc_add_spell_dc"
void main()
{
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
    if (!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_CONJURATION);

    // Apply a burst visual effect at the target location.
    location lTarget = PRCGetSpellTargetLocation();
    effect eImpact = EffectVisualEffect(VFX_FNF_GLITTERDUST);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);

    int nCasterLvl = PRCGetCasterLevel(OBJECT_SELF);

    // Determine the spell's duration.
    float fDuration = PRCGetMetaMagicDuration(RoundsToSeconds(nCasterLvl));

    effect eBlindness = EffectLinkEffects(EffectBlindness(),
        EffectVisualEffect(VFX_DUR_BLIND));
    effect eHidePenalty = EffectLinkEffects(EffectSkillDecrease(SKILL_HIDE, 40),
        EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));

    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget);
    while(GetIsObjectValid(oTarget))
    {
        if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
			// Mastery of shapes check  
			if(!CheckMasteryOfShapes(OBJECT_SELF, oTarget))  
			{  
				PRCSignalSpellEvent(oTarget);

				// Apply impact vfx.
				DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT,
				EffectVisualEffect(VFX_IMP_SPARKS), oTarget));

				// Creatures take the hide penalty whether they save or not.
				SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHidePenalty, oTarget, fDuration,TRUE,-1,nCasterLvl);

				// Creatures that are invisible become visible whether they save or not.  We do
				// this by looping through all the creature's effects looking for invisibility
				// effects and removing them.
				effect eTarget = GetFirstEffect(oTarget);
				while (GetIsEffectValid(eTarget))
				{
					int nType = GetEffectType(eTarget);
					if (EFFECT_TYPE_INVISIBILITY == nType || EFFECT_TYPE_IMPROVEDINVISIBILITY == nType)
						RemoveEffect (oTarget, eTarget);

					eTarget = GetNextEffect(oTarget);
				}

				// Let the creature make a will save, if it fails it's blinded.
				if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, PRCGetSaveDC(oTarget,OBJECT_SELF)))
					SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlindness, oTarget, fDuration,TRUE,-1,nCasterLvl);
			}
			
		}

        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget);
    }

    PRCSetSchool();
}
