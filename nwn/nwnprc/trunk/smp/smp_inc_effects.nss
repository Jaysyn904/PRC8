/*:://////////////////////////////////////////////
//:: Name Effect's include
//:: FileName SMP_INC_EFFECTS
//:://////////////////////////////////////////////
    This holds all effect creating functions.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

// Note on EffectSkillDecrease/Increase. SKILL_ALL_SKILLS can be used!

#include "SMP_INC_CONSTANT"
// A kind of effect, the repulsing ones
#include "SMP_INC_REPULSE"

// Effect returns

// SMP_INC_EFFECTS. Linked effect of Shaken - fear induced.
// * -2 to attack, Damage, Saves and Skills.
effect SMP_CreateShakenEffectsLink();

// SMP_INC_EFFECTS. Links all the "Statue" elements of Petrify, and returns that and the VFX.
// * More "Proper", but still all gets removed with Petrify, as linked.
effect SMP_CreateProperPetrifyEffectLink();

// SMP_INC_EFFECTS. Returns a haste effect as par 3.5E
// +1 AC, +1 attack bonus, +1 Attack at full BAB, +50% move speed (30 feet in 3.5)
// * Note: This will be used, cannot get around EffectHaste's 50% reduction in
//   casting times - extending it to 6 second casting times is too hard on concentration
//   and doesn't look right at all.
effect SMP_CreateHasteEffect();
// SMP_INC_EFFECTS. Returns a slow effect as par 3.5E
// -1 AC, -1 attack bonus, -1 Attack at full BAB, -50% move speed (30 feet in 3.5)
// - Also no attack decreases (we have no "Actions" in rounds ETC)
//effect SMP_CreateSlowEffect();

// SMP_INC_EFFECTS. Returns an EffectCurse specifically for nAbility with nPenalty.
// * You can only (via. game limitations) apply 1 curse at a time.
effect SMP_SpecificAbilityCurse(int nAbility, int nPenalty);

// SMP_INC_EFFECTS. Returns -1 Attack, -1 Spot and -1 Search.
effect SMP_DazzleEffectLink();

// SMP_INC_EFFECTS. Link all immunities
// - 100% Damage immunities. All Spell immunities. All Misc. Immunties.
effect SMP_AllImmunitiesLink();

// SMP_INC_EFFECTS. Skills to do with Armor Penalties:
// - Tumble, Set Trap, Pick Pocket, Parry, Move Silent, Hide
// Does them all decreased by nPenalty
effect SMP_EffectArmorSkillsDecrease(int nPenalty);

// SMP_INC_EFFECTS. Creates a link of immunities to spells for:
// "Protection From", "Cloak of Chaos...etc", and so on.
// Basically is Immunity: Charm and Immunity: Domination. See actual function for
// more info.
effect SMP_CreateCompulsionImmunityLink();

// SMP_INC_EFFECTS.
// Creates a 1 damage resistance to all different damages. Useful for linking
// to a more permanent effect you want cancled when attacked...although it
// doesn't pick up any non-damage related things.
effect SMP_Create1DRLink();

// SMP_INC_EFFECTS. Summon creatures by putting one (or more then one in a link)
// into eSummon, and it'll be created at lTarget's location. It sets current
// summons to undestroyable and then turns it off again.
void SMP_ApplySummonMonster(int nDurationType, effect sSummon, location lTarget, float fDuration = 0.0);

// SMP_INC_EFFECTS. Linked effect of Shaken - fear induced.
// * -2 to attack, Damage, Saves and Skills.
effect SMP_CreateShakenEffectsLink()
{
    //Declare major variables
    effect eSaves = EffectSavingThrowDecrease(SAVING_THROW_ALL, 2);
    effect eAttack = EffectAttackDecrease(2);
    effect eDamage = EffectDamageDecrease(2);
    effect eSkill = EffectSkillDecrease(SKILL_ALL_SKILLS, 2);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    effect eLink = EffectLinkEffects(eAttack, eDamage);
    eLink = EffectLinkEffects(eLink, eSaves);
    eLink = EffectLinkEffects(eLink, eSkill);
    eLink = EffectLinkEffects(eLink, eDur);

    return eLink;
}

// SMP_INC_EFFECTS. Links all the "Statue" elements of Petrify, and returns that and the VFX.
// * More "Proper", but still all gets removed with Petrify, as linked.
effect SMP_CreateProperPetrifyEffectLink()
{
    // Declare effects
    effect ePetrify = EffectPetrify();
    effect eImmunity1 = EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT);
    effect eImmunity2 = EffectImmunity(IMMUNITY_TYPE_DEATH);
    effect eImmunity3 = EffectImmunity(IMMUNITY_TYPE_DISEASE);
    effect eImmunity4 = EffectImmunity(IMMUNITY_TYPE_NEGATIVE_LEVEL);
    effect eImmunity5 = EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
    effect eImmunity6 = EffectImmunity(IMMUNITY_TYPE_POISON);
    effect eImmunity7 = EffectImmunity(IMMUNITY_TYPE_SNEAK_ATTACK);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    // Link effects
    effect eLink = EffectLinkEffects(eDur, ePetrify);
    eLink = EffectLinkEffects(eLink, eImmunity1);
    eLink = EffectLinkEffects(eLink, eImmunity2);
    eLink = EffectLinkEffects(eLink, eImmunity3);
    eLink = EffectLinkEffects(eLink, eImmunity4);
    eLink = EffectLinkEffects(eLink, eImmunity5);
    eLink = EffectLinkEffects(eLink, eImmunity6);
    eLink = EffectLinkEffects(eLink, eImmunity7);

    return eLink;
}


// SMP_INC_EFFECTS. Returns a haste effect as par 3.5E
// +1 AC, +1 attack bonus, +1 Attack at full BAB, +50% move speed (30 feet in 3.5)
// * Note: This will be used, cannot get around EffectHaste's 50% reduction in
//   casting times - extending it to 6 second casting times is too hard on concentration
//   and doesn't look right at all.
effect SMP_CreateHasteEffect()
{
    effect eMove = EffectMovementSpeedIncrease(50);
    effect eAttackBonus = EffectAttackIncrease(1);
    effect eAttackExtra = EffectModifyAttacks(1);
    effect eAC = EffectACIncrease(1, AC_DODGE_BONUS);
    // Link
    effect eLink = EffectLinkEffects(eMove, eAttackBonus);
    eLink = EffectLinkEffects(eLink, eAttackExtra);
    eLink = EffectLinkEffects(eLink, eAC);

    return eLink;
}
/*
// SMP_INC_EFFECTS. Returns a slow effect as par 3.5E
// -1 AC, -1 attack bonus, -1 Attack at full BAB, -50% move speed (30 feet in 3.5)
// - Also no attack decreases (we have no "Actions" in rounds ETC)
effect SMP_CreateSlowEffect()
{
    effect eMove = EffectMovementSpeedDecrease(50);
    effect eAttackBonus = EffectAttackDecrease(1);
    effect eAC = EffectACDecrease(1, AC_DODGE_BONUS);
    // Link
    effect eLink = EffectLinkEffects(eMove, eAttackBonus);
    eLink = EffectLinkEffects(eLink, eAC);

    return eLink;
}
*/
// SMP_INC_EFFECTS. Returns an EffectCurse specifically for nAbility with nPenalty.
// * You can only (via. game limitations) apply 1 curse at a time.
effect SMP_SpecificAbilityCurse(int nAbility, int nPenalty)
{
    effect eReturn;

    switch(nAbility)
    {
        case ABILITY_CHARISMA:     eReturn = EffectCurse(0, 0, 0, 0, 0, nPenalty); break;
        case ABILITY_CONSTITUTION: eReturn = EffectCurse(0, 0, nPenalty, 0, 0, 0); break;
        case ABILITY_DEXTERITY:    eReturn = EffectCurse(0, nPenalty, 0, 0, 0, 0); break;
        case ABILITY_INTELLIGENCE: eReturn = EffectCurse(0, 0, 0, nPenalty, 0, 0); break;
        case ABILITY_STRENGTH:     eReturn = EffectCurse(nPenalty, 0, 0, 0, 0, 0); break;
        case ABILITY_WISDOM:       eReturn = EffectCurse(0, 0, 0, 0, nPenalty, 0); break;
        // Default = Strength
        default:                   eReturn = EffectCurse(nPenalty, 0, 0, 0, 0, 0); break;
    }
    return eReturn;
}

// SMP_INC_EFFECTS. Returns -1 Attack, -1 Spot and -1 Search.
effect SMP_DazzleEffectLink()
{
    effect eDazzle1 = EffectAttackDecrease(1);
    effect eDazzle2 = EffectSkillDecrease(SKILL_SPOT, 1);
    effect eDazzle3 = EffectSkillDecrease(SKILL_SEARCH, 1);

    effect eReturn = EffectLinkEffects(eDazzle1, eDazzle2);
    eReturn = EffectLinkEffects(eReturn, eDazzle3);

    return eReturn;
}

// SMP_INC_EFFECTS. Link all immunities
// - 100% Damage immunities. All Spell immunities. All Misc. Immunties.
effect SMP_AllImmunitiesLink()
{
    effect eImmuneLink;
    effect eAddToLink;
    int nCnt;
//int    DAMAGE_TYPE_BLUDGEONING  = 1;
//...doubles...
//int    DAMAGE_TYPE_SONIC        = 2048;
    nCnt = 1;
    while(nCnt <= 2048)
    {
        // Add to immune list
        eAddToLink = EffectDamageImmunityIncrease(nCnt, 100);
        eImmuneLink = EffectLinkEffects(eImmuneLink, eAddToLink);
        // Double nCnt
        nCnt *= 2;
    }
    // All IMMUNITY_TYPE_* to encompass other things.
//int IMMUNITY_TYPE_NONE              = 0;
//...
//int IMMUNITY_TYPE_DEATH             = 32;
    for(nCnt = 1; nCnt <= 32; nCnt++)
    {
        // Add to immune list
        eAddToLink = EffectImmunity(nCnt);
        eImmuneLink = EffectLinkEffects(eImmuneLink, eAddToLink);
    }
    // And all spells immunity
    eAddToLink = EffectSpellLevelAbsorption(9);
    eImmuneLink = EffectLinkEffects(eImmuneLink, eAddToLink);

    // Return
    return eImmuneLink;
}

// SMP_INC_EFFECTS. Skills to do with Armor Penalties:
// - Tumble, Set Trap, Pick Pocket, Parry, Move Silent, Hide
// Does them all decreased by nPenalty
effect SMP_EffectArmorSkillsDecrease(int nPenalty)
{
    // Penalties linked in eReturn
    effect ePenalty1 = EffectSkillDecrease(SKILL_HIDE, nPenalty);
    effect ePenalty2 = EffectSkillDecrease(SKILL_MOVE_SILENTLY, nPenalty);
    effect ePenalty3 = EffectSkillDecrease(SKILL_PARRY, nPenalty);
    effect ePenalty4 = EffectSkillDecrease(SKILL_PICK_POCKET, nPenalty);
    effect ePenalty5 = EffectSkillDecrease(SKILL_SET_TRAP, nPenalty);
    effect ePenalty6 = EffectSkillDecrease(SKILL_TUMBLE, nPenalty);

    effect eReturn = EffectLinkEffects(ePenalty1, ePenalty2);
    eReturn = EffectLinkEffects(eReturn, ePenalty3);
    eReturn = EffectLinkEffects(eReturn, ePenalty4);
    eReturn = EffectLinkEffects(eReturn, ePenalty5);
    eReturn = EffectLinkEffects(eReturn, ePenalty6);

    return eReturn;
}




// SMP_INC_EFFECTS. Creates a link of immunities to spells for:
// "Protection From", "Cloak of Chaos...etc", and so on.
// Basically is Immunity: Charm and Immunity: Domination. See actual function for
// more info.
effect SMP_CreateCompulsionImmunityLink()
{
/* INFO:
    DIRECT CONTROL (Compulsion) only:
    Second, the barrier blocks any attempt to possess the warded creature
    (by a magic jar attack, for example) or to exercise mental control over the
    creature (including enchantment (charm) effects and enchantment
    (compulsion) effects that grant the caster ongoing control over the subject,
    such as dominate person).

    * More:

    The second function of the protection from evil spell blocks any attempt to
    possess the warded creature or to exercise mental control over the creature.
    What, exactly, counts as mental control?

    “Mental control” includes all spells of the school of Enchantment that have
    the Charm subschool, such as animal friendship, charm person, and charm
    monster. It also includes some Enchantment spells of the Compulsion subschool
    if those spells grant the caster ongoing control over the subject; such spells
    include dominate person and dominate monster.

    Compulsions that merely dictate the subject’s action at the time the spell
    takes effect are not blocked. Such spells include command, hold person,
    geas/quest, hypnotism, insanity, Otto’s irresistible dance, random action,
    suggestion, and zone of truth.
*/
    // Link effects
    effect eDominateImmune = EffectImmunity(IMMUNITY_TYPE_CHARM);
    effect eCharmImmune = EffectImmunity(IMMUNITY_TYPE_DOMINATE);
    //effect eSpellImmune1 = EffectSpellImmunity();
    //effect eSpellImmune2 = EffectSpellImmunity();
    //effect eSpellImmune3 = EffectSpellImmunity();

    // Return link
    effect eReturn = EffectLinkEffects(eDominateImmune, eCharmImmune);
    //eReturn = EffectLinkEffects(eReturn, eSpellImmune1);
    //eReturn = EffectLinkEffects(eReturn, eSpellImmune2);
    //eReturn = EffectLinkEffects(eReturn, eSpellImmune3);

    return eReturn;
}
// SMP_INC_EFFECTS.
// Creates a 1 damage resistance to all different damages. Useful for linking
// to a more permanent effect you want cancled when attacked...although it
// doesn't pick up any non-damage related things.
effect SMP_Create1DRLink()
{
    effect eReturn, eAddToLink;
//int    DAMAGE_TYPE_BLUDGEONING  = 1;
//...doubles...
//int    DAMAGE_TYPE_SONIC        = 2048;
    int nCnt = 1;
    while(nCnt <= 2048)
    {
        // Add to immune list
        eAddToLink = EffectDamageResistance(nCnt, 1, 1);
        eReturn = EffectLinkEffects(eReturn, eAddToLink);
        // Double nCnt
        nCnt *= 2;
    }
    // Return eReturn
    return eReturn;
}

// SMP_INC_EFFECTS. Summon creatures by putting one (or more then one in a link)
// into eSummon, and it'll be created at lTarget's location. It sets current
// summons to undestroyable and then turns it off again.
void SMP_ApplySummonMonster(int nDurationType, effect sSummon, location lTarget, float fDuration = 0.0)
{
    // Set the associates (summons) to destroyable: FALSE for a sec.
    int nCnt = 1;
    object oAssociate = GetAssociate(ASSOCIATE_TYPE_SUMMONED, OBJECT_SELF, nCnt);
    while(GetIsObjectValid(oAssociate))
    {
        // Set is Destroyable.
        AssignCommand(oAssociate, SetIsDestroyable(FALSE));
        DelayCommand(0.01, AssignCommand(oAssociate, SetIsDestroyable(TRUE)));
        // Get next one
        nCnt++;
        oAssociate = GetAssociate(ASSOCIATE_TYPE_SUMMONED, OBJECT_SELF, nCnt);
    }
    // Apply the effect at the location
    ApplyEffectAtLocation(nDurationType, sSummon, lTarget, fDuration);
}

// End of file Debug lines. Uncomment below "/*" with "//" and compile.
/*
void main()
{
    return;
}
//*/
