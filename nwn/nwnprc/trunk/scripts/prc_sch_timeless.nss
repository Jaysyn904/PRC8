//::///////////////////////////////////////////////
//:: Song of Timelessness
//:: prc_sch_timeless.nss
//:://////////////////////////////////////////////
/*
    Envelopes a single creature withing 60 feet in a field of timelessness.
    Will save vs 10 + Sublime Chord level + CHA mod negates.
*/
//:://////////////////////////////////////////////
//:: Created By: xwarren
//:: Created On: Dec 8, 2009
//:://////////////////////////////////////////////
#include "prc_inc_spells"

void main()
{
   object oCaster = OBJECT_SELF;

    if (PRCGetHasEffect(EFFECT_TYPE_SILENCE,OBJECT_SELF))
    {
        FloatingTextStrRefOnCreature(85764,OBJECT_SELF); // not useable when silenced
        return;
    }
    else if(GetSkillRank(SKILL_PERFORM, oCaster) < 16)
    {
        FloatingTextStringOnCreature("You need 16 or more ranks in perform skill.", oCaster, FALSE);
        return;
    }
    else if (!GetHasFeat(FEAT_BARD_SONGS, oCaster))
    {
        //SpeakStringByStrRef(40550);
        FloatingTextStringOnCreature("No Bard Song uses!", oCaster, FALSE);
        return;
    }
    else
    {
        //Declare major variables
        object oTarget = PRCGetSpellTargetObject();
        int nLevel = GetLevelByClass(CLASS_TYPE_SUBLIME_CHORD, oCaster);
        int nDC = 10 + nLevel + GetAbilityModifier(ABILITY_CHARISMA, oCaster);

        effect eLink    = EffectSpellImmunity(SPELL_ALL_SPELLS);
        // Damage immunities
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_ACID,        100));
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING, 100));
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD,        100));
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_DIVINE,      100));
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL,  100));
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE,        100));
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_MAGICAL,     100));
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_NEGATIVE,    100));
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_PIERCING,    100));
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_POSITIVE,    100));
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING,    100));
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_SONIC,       100));
        // Specific immunities
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_BLINDNESS));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_DEAFNESS));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_DEATH));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_DISEASE));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_ENTANGLE));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_SLOW));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_KNOCKDOWN));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_NEGATIVE_LEVEL));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_PARALYSIS));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_SILENCE));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_SNEAK_ATTACK));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_TRAP));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS));

               eLink    = EffectLinkEffects(eLink, EffectCutsceneParalyze());
               eLink    = EffectLinkEffects(eLink, EffectVisualEffect(PSI_DUR_TIMELESS_BODY));

        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

        //Saving Throw
        if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC))
        {
            //Apply Link and VFX effects to the target
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nLevel));
            SetLocalInt(OBJECT_SELF, "SpellConc", 1);
        }

        DecrementRemainingFeatUses(OBJECT_SELF, FEAT_BARD_SONGS);
    }
}