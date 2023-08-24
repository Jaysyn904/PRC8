//::///////////////////////////////////////////////
//:: Soul Eater: Soul Blast
//:: prc_sleat_sblast
//:://////////////////////////////////////////////
/** @file
    Soul Blast (Su): A 3rd-level may project a 100-foot ray of force that deals
     1d6 points of damage per soul eater level against one target. The target is
     allowed a Reflex saving throw to avoid the damage (DC 10 + class level
     + Cha bonus). This supernatural ability can be used once per day, and only
     on a day when the soul eater has drained levels.

    @date   Modified - 04.12.2006
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
    object oEater   = OBJECT_SELF;
    object oTarget  = PRCGetSpellTargetObject();
    int nClassLevel = GetLevelByClass(CLASS_TYPE_SOUL_EATER, oEater);
    int nDC         = 10 + nClassLevel + GetAbilityModifier(ABILITY_CHARISMA, oEater);
        nDC        += nClassLevel >= 10 ? 2 : 0; // Soul Power. We don't need to check whether the SE has drained today here, since if it hasn't, the Soul Blast won't happen anyway

    // PvP targeting limitations
    if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oEater))
    {
        // Make sure the SE has drained today
        if(GetLocalInt(oEater, "PRC_SoulEater_HasDrained"))
        {
            // Let AI know about hostilities
            SignalEvent(oTarget, EventSpellCastAt(oEater, GetSpellId(), TRUE));

            // Fire the ray
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_EVIL, oEater, BODY_NODE_HAND), oTarget, 3.0f);

            // Roll damage and do Reflex save
            int nDamage = d6(nClassLevel);
            nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, nDC, SAVING_THROW_TYPE_NONE);

            if(nDamage > 0) // Didn't evade
            {
                effect eImpact = EffectVisualEffect(VFX_IMP_PULSE_NEGATIVE);
                effect eDamage = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);

                SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectLinkEffects(eDamage, eImpact), oTarget);
            }
        }
        // Refund unused feat use, whine
        else
        {
            FloatingTextStrRefOnCreature(16832114, oEater, FALSE); // "Target is immune to negative levels"
            IncrementRemainingFeatUses(oEater, FEAT_SLEAT_SBLAST);
        }
    }
    // Refund unused feat use
    else
        IncrementRemainingFeatUses(oEater, FEAT_SLEAT_SBLAST);
}
