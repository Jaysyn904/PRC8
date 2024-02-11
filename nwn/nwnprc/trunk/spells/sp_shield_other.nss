/*
    sp_shield_other

    Shield Other
    Abjuration
    Level: Clr 2, Pal 2, Protection 2
    Components: V, S, F
    Casting Time: 1 standard action
    Range: Close (25 ft. + 5 ft./2 levels)
    Target: One creature
    Duration: 1 hour/level (D)
    Saving Throw: Will negates (harmless)
    Spell Resistance: Yes (harmless)

    This spell wards the subject and creates a
    mystic connection between you and the
    subject so that some of its wounds are
    transferred to you. The subject gains a +1
    deflection bonus to AC and a +1 resistance
    bonus on saves. Additionally, the subject
    takes only half damage from all wounds
    and attacks (including that dealt by special
    abilities) that deal hit point damage. The
    amount of damage not taken by the
    warded creature is taken by you. Forms of
    harm that do not involve hit points, such
    as charm effects, temporary ability damage,
    level draining, and death effects, are not
    affected. If the subject suffers a reduction
    of hit points from a lowered Constitution
    score, the reduction is not split with you
    because it is not hit point damage. When
    the spell ends, subsequent damage is no
    longer divided between the subject and
    you, but damage already split is not
    reassigned to the subject.
    If you and the subject of the spell move
    out of range of each other, the spell ends.
    Focus: A pair of platinum rings (worth at
    least 50 gp each) worn by both you and the
    warded creature.

    By: Flaming_Sword
    Created: Oct 19, 2008
    Modified: Oct 22, 2008

*/
#include "prc_inc_spells"

void main()
{
    // Run the pre-spell code
    PRCSetSchool(GetSpellSchool(PRCGetSpellId()));
    if (!X2PreSpellCastCode()) return;

    object oCaster   = OBJECT_SELF;
    object oTarget   = PRCGetSpellTargetObject();
    int bGuardian;      //put shield guardian caster check here
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    int nDuration = nCasterLevel;

    effect eLink = EffectLinkEffects(EffectACIncrease(1, AC_DEFLECTION_BONUS), EffectSavingThrowIncrease(SAVING_THROW_ALL, 1));
    eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_GLOBE_MINOR));

    SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_AC_BONUS), oTarget);
    //add shield guardian code here
    if(bGuardian)
    {
        SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget, 0.0,TRUE,-1,nCasterLevel);
    }
    else
    {

        if(CheckMetaMagic(PRCGetMetaMagicFeat(), METAMAGIC_EXTEND)) nDuration *= 2;
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDuration),TRUE,-1,nCasterLevel);
    }

    PRCSetSchool();
}



