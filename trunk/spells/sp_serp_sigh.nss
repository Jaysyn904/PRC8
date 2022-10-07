#include "prc_inc_spells"
#include "spinc_bolt"
#include "spinc_cone"

void main()
{
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
    if (!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_EVOCATION);

    // Get the number of damage dice.
    int nCasterLevel = PRCGetCasterLevel(OBJECT_SELF);
    int nDice = nCasterLevel > 10 ? 10 : nCasterLevel;
    int nSpell = GetSpellId();
    int nVfx;

    if(nSpell == SPELL_SERPENTS_SIGH_BOLT_ACID)
    {
        DoBolt(nCasterLevel, 6, 0, nDice, 447 /* VFX_BEAM_DISINTEGRATE */, VFX_IMP_ACID_S,
               DAMAGE_TYPE_ACID, SAVING_THROW_TYPE_ACID,
               SPELL_SCHOOL_EVOCATION, FALSE, SPELL_SERPENTS_SIGH);
        nVfx = VFX_IMP_ACID_S;
    }
    else if(nSpell == SPELL_SERPENTS_SIGH_BOLT_LIGHTNING)
    {
        DoBolt(nCasterLevel, 6, 0, nDice, VFX_BEAM_LIGHTNING, VFX_IMP_LIGHTNING_S,
               DAMAGE_TYPE_ELECTRICAL, SAVING_THROW_TYPE_ELECTRICITY,
               SPELL_SCHOOL_EVOCATION, FALSE, SPELL_SERPENTS_SIGH);
        nVfx = VFX_IMP_LIGHTNING_S;
    }
    else if(nSpell == SPELL_SERPENTS_SIGH_CONE_ACID)
    {
        DoCone(6, 0, 10, -1, VFX_IMP_ACID_S,
               DAMAGE_TYPE_ACID, SAVING_THROW_TYPE_ACID,
               SPELL_SCHOOL_EVOCATION, SPELL_SERPENTS_SIGH);
        nVfx = VFX_IMP_ACID_S;
    }
    else if(nSpell == SPELL_SERPENTS_SIGH_CONE_COLD)
    {
        DoCone(6, 0, 10, -1, VFX_IMP_FROST_S,
               DAMAGE_TYPE_COLD, SAVING_THROW_TYPE_COLD,
               SPELL_SCHOOL_EVOCATION, SPELL_SERPENTS_SIGH);
        nVfx = VFX_IMP_FROST_S;
    }
    else if(nSpell == SPELL_SERPENTS_SIGH_CONE_FIRE)
    {
        DoCone(6, 0, 10, -1, VFX_IMP_FLAME_S,
               DAMAGE_TYPE_FIRE, SAVING_THROW_TYPE_FIRE,
               SPELL_SCHOOL_EVOCATION, SPELL_SERPENTS_SIGH);
        nVfx = VFX_IMP_FLAME_S;
    }

    //The caster takes 1 hit point of damage per hit die of damage dealt.
    ApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(OBJECT_SELF, nDice, DAMAGE_TYPE_MAGICAL), OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(nVfx), OBJECT_SELF);

    PRCSetSchool();
}