/*:://////////////////////////////////////////////
//:: Name Spell Removal of Effects include
//:: FileName SMP_INC_REMOVE
//:://////////////////////////////////////////////
    All the removal of effects

    - All return 1 or 0 if it removes spell effects
    - Ones which remove only effects cast by the caster
    - Ones which remove only 1 interation of the spell

    And includes and destroying functions.

    Dispel functions are in SMP_INC_DISPEL
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//:: Created On: October
//::////////////////////////////////////////////*/

#include "SMP_INC_ARRAY"
#include "SMP_INC_CONSTANT"

const int SUBTYPE_IGNORE = -1;

// SMP_INC_REMOVE. Searches through a persons effects and removes those from a particular spell by a particular caster.
// - Removes if after fDelay
// - Returns TRUE if it removes any
int SMP_PRCRemoveSpellEffects(int nSpell_ID, object oCaster, object oTarget, float fDelay = 0.0);
// SMP_INC_REMOVE. Searches through a persons effects and removes all those of a specific type.
// - Returns TRUE if it removes any effect of nEffecTypeID
// * Use SUBTYPE_IGNORE to ignore nSubtype parameter.
int SMP_RemoveSpecificEffect(int nEffectTypeID, object oTarget, int nSubtype = SUBTYPE_MAGICAL);
// SMP_INC_REMOVE. Searches through a persons effects and removes all those of
// a specific type, from nSpellId.
// - Returns TRUE if it removes any effect of nEffecTypeID from nSpellId
// * Use SUBTYPE_IGNORE to ignore nSubtype parameter.
int SMP_RemoveSpecificEffectFromSpell(int nEffectTypeID, int nSpellId, object oTarget, int nSubtype = SUBTYPE_MAGICAL);
// SMP_INC_REMOVE. Remove all protections from nSpell_ID on oTarget, any caster.
// TRUE if it does remove any.
//  - Checks for them before it does it.
//  - Will not remove extraodinary effects
//  - fDelay - Is the delay for the effect to be removed.
int SMP_RemoveSpellEffectsFromTarget(int nSpell_ID, object oTarget = OBJECT_SELF, float fDelay = 0.0);
// SMP_INC_REMOVE. Remove all spell protections from a specific spell on oTarget.
// TRUE if it does remove any.
//  - Checks for them before it does it.
//  - Will not remove extraodinary effects
//  - fDelay - Is the delay for the effect to be removed.
int SMP_RemoveMultipleSpellEffectsFromTarget(object oTarget, int nSpell_ID1, int nSpell_ID2, int nSpell_ID3 = 0, int nSpell_ID4 = 0, int nSpell_ID5 = 0, int nSpell_ID6 = 0);
// SMP_INC_REMOVE. Removes all AOE's from the area
// * sTag - the tag of the AOE.
// * oCreator - created by this object, in the same area as this object.
int SMP_RemoveAllAOEsOfTag(string sTag, object oCreator);
// SMP_INC_REMOVE. Removes all spells effects created by oCreator, under
// nSpellId, from all creatures
// in the area (using OBJECT_SELF as just the thing).
// * VERY COSTLY as it is a LARGER LOOP
void SMP_RemoveAllSpellsFromCreator(int nSpellId, object oCreator);
// SMP_INC_REMOVE. Removes all effects of any type on oTarget. No return value.
void SMP_RemoveAllEffects(object oTarget);
// SMP_INC_REMOVE. Removes all effects from nSpell_ID from anyone in oTarget's
// faction (party), using bPCOnly for the GetFirstFactionMember() check.
// - Returns TRUE if it removes any.
int SMP_RemoveSpellEffectsFromFaction(int nSpell_ID, object oTarget, int bPCOnly = TRUE, float fDelay = 0.0);
// SMP_INC_REMOVE. Removes all effects from nSpell_ID from anyone in oTarget's
// faction (party), using bPCOnly for the GetFirstFactionMember() check.
// In addition, spell must be from oCaster
// - Returns TRUE if it removes any.
int SMP_RemoveSpellEffectsFromFactionCaster(int nSpell_ID, object oCaster, object oTarget, int bPCOnly = TRUE, float fDelay = 0.0);



// SMP_INC_REMOVE. Checks for iEffect on oTarget. TRUE if any of nEffect is found
int SMP_GetHasEffect(int nEffect, object oTarget);
// SMP_INC_REMOVE. More checks then SMP_GetHasEffect().
// * oTarget - Target to check
// * oCreator - Creator of the effect (or OBJECT_INVALID)
// * nEffect - Effect ID (or EFFECT_TYPE_INVALIDEFFECT)
// * nSpellId - Spell Id (or SPELL_INVALID)
// * nDuration - Duration type (or DURATION_INVALID)
// * nSubType - Subtype (or SUBTYPE_IGNORE)
int SMP_GetHasEffectSpecific(object oTarget, object oCreator = OBJECT_INVALID, int nEffect = EFFECT_TYPE_INVALIDEFFECT, int nSpellId = SPELL_INVALID, int nDuration = DURATION_INVALID, int nSubType = SUBTYPE_IGNORE);
// SMP_INC_REMOVE. Checks for nEffect on oTarget, cast by oCaster.
int SMP_GetHasEffectFromCaster(int nEffect, object oTarget, object oCaster);
// SMP_INC_REMOVE. Checks for nEffect, nSpellId on oTarget, which is nSpellId
// * Can use nDuration if wanted. DURATION_INVALID to ignore.
int SMP_GetHasEffectFromSpell(int nEffect, object oTarget, int nSpellId, int nDuration = DURATION_INVALID);
// SMP_INC_REMOVE. Checks for nSpellId on oTarget, cast by oCaster.
int SMP_GetHasSpellEffectFromCaster(int nSpellId, object oTarget, object oCaster);
// SMP_INC_REMOVE. Checks for nSpellId on oTarget, which is nDuration
int SMP_GetHasSpellEffectDurationType(int nSpellId, object oTarget, int nDuration);

// SMP_INC_REMOVE. Special to remove all interposing hand effects, so they don't
// stack (IE: Movement decrease would be dreadful)
// * Also used in disintegration
int SMP_RemoveInterposingHands(object oTarget);
// SMP_INC_REMOVE. Special to remove all "Protection from alignment" of X alignment.
// * Note, it will use the power level, nPower, and will NOT return higher spells.
//   If it finds they have a higher level spell, it will return TRUE, else FALSE.
// * TRUE means do NOT apply any effects from that power spell.
// 1 = Protection From X, 2 = Magic Circle against X, 3 = Cloak Of/Shield Of etc.
// * Note: nAlignment is what is PROTECTED AGAINST, so Shield of Law would be ALIGNMENT_CHAOTIC.
int SMP_RemoveProtectionFromAlignment(object oTarget, int nAlignment, int nPower);

// SMP_INC_REMOVE. Special to check if they have any spells on them currently
// which provide a bonus of nBonus, to nAbility. If they have any which are
// == nBonusToApply, will return 1, if > nBonusToApply, will return 2.
// * So, use 1 in cases where you want to miss out the bonus (Iron Body), and
//   2 in cases when you want to stop the effect being applied at all (Bulls Strength).
// * Use to prevent, for example, a bonus of +4 being applied over a bonus of +8.
int SMP_GetHasAbilityBonusOfPower(object oTarget, int nAbility, int nBonusToApply);
// SMP_INC_REMOVE. Special to remove ALL bonuses from nAbility on oTarget.
// * Make sure to check, beforhand, of any of greater power (if applicable) via.
//   GetHasAbilityBonusOfPower.
// * TRUE if it removes any
// * The powers must be <= nBonus Power, or 100 to ignore (as it'll catch any bonus power).
int SMP_RemoveAnyAbilityBonuses(object oTarget, int nAbility, int nBonusPower = 100);

// SMP_INC_REMOVE. Searchs through a persons effects and removes those from a particular spell by a particular caster.
// - Removes if after fDelay
// - Returns TRUE if it removes any
int SMP_PRCRemoveSpellEffects(int nSpell_ID, object oCaster, object oTarget, float fDelay = 0.0)
{
    //Declare major variables
    effect eCheck;
    int bReturn = FALSE;
    if(GetHasSpellEffect(nSpell_ID, oTarget))
    {
        //Search through the valid effects on the target.
        eCheck = GetFirstEffect(oTarget);
        while(GetIsEffectValid(eCheck))
        {
            if(GetEffectCreator(eCheck) == oCaster)
            {
                //If the effect was created by the spell then remove it
                if(GetEffectSpellId(eCheck) == nSpell_ID)
                {
                    if(fDelay > 0.0)
                    {
                        DelayCommand(fDelay, RemoveEffect(oTarget, eCheck));
                    }
                    else
                    {
                        RemoveEffect(oTarget, eCheck);
                    }
                    bReturn = TRUE;
                }
            }
            //Get next effect on the target
            eCheck = GetNextEffect(oTarget);
        }
    }
    return bReturn;
}
// SMP_INC_REMOVE. Searchs through a persons effects and removes all those of a specific type.
// - Returns TRUE if it removes any effect of nEffecTypeID
// * Use SUBTYPE_IGNORE to ignore nSubtype parameter.
int SMP_RemoveSpecificEffect(int nEffectTypeID, object oTarget, int nSubtype = SUBTYPE_MAGICAL)
{
    //Declare major variables
    effect eCheck;
    int bReturn = FALSE;
    //Search through the valid effects on the target.
    eCheck = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eCheck))
    {
        // Must be of correct effect ID, eg: Entanglement effects.
        if(GetEffectType(eCheck) == nEffectTypeID)
        {
            // We can ignore the subtype parameter and remove any type of effect.
            if(nSubtype == SUBTYPE_IGNORE ||
               GetEffectSubType(eCheck) == nSubtype)
            {
                //If the effect was nEffectTypeID, remove
                RemoveEffect(oTarget, eCheck);
                bReturn = TRUE;
            }
        }
        //Get next effect on the target
        eCheck = GetNextEffect(oTarget);
    }
    return bReturn;
}
// SMP_INC_REMOVE. Searchs through a persons effects and removes all those of
// a specific type, from nSpellId.
// - Returns TRUE if it removes any effect of nEffecTypeID from nSpellId
// * Use SUBTYPE_IGNORE to ignore nSubtype parameter.
int SMP_RemoveSpecificEffectFromSpell(int nEffectTypeID, int nSpellId, object oTarget, int nSubtype = SUBTYPE_MAGICAL)
{
    //Declare major variables
    effect eCheck;
    int bReturn = FALSE;
    // Search through the valid effects on the target.
    eCheck = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eCheck))
    {
        // Check effect type
        if(GetEffectType(eCheck) == nEffectTypeID)
        {
            // We can ignore the subtype parameter and remove any type of effect.
            if(nSubtype == SUBTYPE_IGNORE ||
               GetEffectSubType(eCheck) == nSubtype)
            {
                // We remove all spell effects from nSpellId of nEffectTypeID
                if(GetEffectSpellId(eCheck) == nSpellId)
                {
                    //If the effect was created by the spell then remove it
                    RemoveEffect(oTarget, eCheck);
                    bReturn = TRUE;
                }
            }
        }
        //Get next effect on the target
        eCheck = GetNextEffect(oTarget);
    }
    return bReturn;
}

// SMP_INC_REMOVE. Remove all spell protections from a specific spell on oTarget.
// TRUE if it does remove any.
//  - Checks for them before it does it.
//  - Will not remove extraodinary effects
//  - fDelay - Is the delay for the effect to be removed.
int SMP_RemoveSpellEffectsFromTarget(int nSpell_ID, object oTarget = OBJECT_SELF, float fDelay = 0.0)
{
    //Declare major variables
    effect eProtection;
    int bReturn = FALSE;
    if(GetHasSpellEffect(nSpell_ID, oTarget))
    {
        //Search through the valid effects on the target.
        eProtection = GetFirstEffect(oTarget);
        while(GetIsEffectValid(eProtection))
        {
            //If the effect was created by the spell then remove it (after fDelay)
            if(GetEffectSpellId(eProtection) == nSpell_ID)
            {
                if(fDelay > 0.0)
                {
                    DelayCommand(fDelay, RemoveEffect(oTarget, eProtection));
                }
                else
                {
                    RemoveEffect(oTarget, eProtection);
                }
                //return TRUE
                bReturn = TRUE;
            }
            //Get next effect on the target
            eProtection = GetNextEffect(oTarget);
        }
    }
    return bReturn;
}

// SMP_INC_REMOVE. Remove all spell protections from a specific spell on oTarget.
// TRUE if it does remove any.
//  - Checks for them before it does it.
//  - Will not remove extraodinary effects
//  - fDelay - Is the delay for the effect to be removed.
int SMP_RemoveMultipleSpellEffectsFromTarget(object oTarget, int nSpell_ID1, int nSpell_ID2, int nSpell_ID3 = 0, int nSpell_ID4 = 0, int nSpell_ID5 = 0, int nSpell_ID6 = 0)
{
    // Check validness
    if(nSpell_ID2 == FALSE) nSpell_ID2 = -1;
    if(nSpell_ID3 == FALSE) nSpell_ID3 = -1;
    if(nSpell_ID4 == FALSE) nSpell_ID4 = -1;
    if(nSpell_ID5 == FALSE) nSpell_ID5 = -1;
    if(nSpell_ID6 == FALSE) nSpell_ID6 = -1;

    //Declare major variables
    effect eProtection;
    int nEffectID;
    int bReturn = FALSE;
    if(GetHasSpellEffect(nSpell_ID1, oTarget) ||
       GetHasSpellEffect(nSpell_ID2, oTarget) ||
       GetHasSpellEffect(nSpell_ID3, oTarget) ||
       GetHasSpellEffect(nSpell_ID4, oTarget) ||
       GetHasSpellEffect(nSpell_ID5, oTarget) ||
       GetHasSpellEffect(nSpell_ID6, oTarget))
    {
        //Search through the valid effects on the target.
        eProtection = GetFirstEffect(oTarget);
        while(GetIsEffectValid(eProtection))
        {
            nEffectID = GetEffectSpellId(eProtection);
            //If the effect was created by the spell then remove it (after fDelay)
            if(nEffectID == nSpell_ID1 || nEffectID == nSpell_ID2 ||
               nEffectID == nSpell_ID3 || nEffectID == nSpell_ID4 ||
               nEffectID == nSpell_ID5 || nEffectID == nSpell_ID6)
            {
                RemoveEffect(oTarget, eProtection);
                //return TRUE
                bReturn = TRUE;
            }
            //Get next effect on the target
            eProtection = GetNextEffect(oTarget);
        }
    }
    return bReturn;
}

// SMP_INC_REMOVE. Removes all AOE's from the area
// * sTag - the tag of the AOE.
// * oCreator - created by this object, in the same area as this object.
int SMP_RemoveAllAOEsOfTag(string sTag, object oCreator)
{
    int bReturn = FALSE;
    // Loop all AOE's
    int nCnt = 1;
    object oAOE = GetNearestObject(OBJECT_TYPE_AREA_OF_EFFECT, oCreator, nCnt);
    while(GetIsObjectValid(oAOE))
    {
        if(GetTag(oAOE) == sTag &&
           GetAreaOfEffectCreator(oAOE) == oCreator)
        {
            SetPlotFlag(oAOE, FALSE);
            DestroyObject(oAOE);
            bReturn = TRUE;
        }
        nCnt++;
        oAOE = GetNearestObject(OBJECT_TYPE_AREA_OF_EFFECT, oCreator, nCnt);
    }
    // Return value
    return bReturn;
}

// SMP_INC_REMOVE. Removes all spells effects created by oCreator, under
// nSpellId, from all creatures
// in the area (using OBJECT_SELF as just the thing).
// * VERY COSTLY as it is a LARGER LOOP
void SMP_RemoveAllSpellsFromCreator(int nSpellId, object oCreator)
{
    int nCnt = 1;
    object oCreature = GetNearestObject(OBJECT_TYPE_CREATURE, OBJECT_SELF, nCnt);
    while(GetIsObjectValid(oCreature))
    {
        // Remove the effects of the spell.
        SMP_PRCRemoveSpellEffects(nSpellId, oCreator, oCreature);

        // Next target
        nCnt++;
        oCreature = GetNearestObject(OBJECT_TYPE_CREATURE, OBJECT_SELF, nCnt);
    }
}

// SMP_INC_REMOVE. Removes all effects of any type on oTarget. No return value.
void SMP_RemoveAllEffects(object oTarget)
{
    // Search through the valid effects on the target.
    effect eCheck = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eCheck))
    {
        // Remove it
        RemoveEffect(oTarget, eCheck);
        eCheck = GetNextEffect(oTarget);
    }
}
// SMP_INC_REMOVE. Removes all effects from nSpell_ID from anyone in oTarget's
// faction (party), using bPCOnly for the GetFirstFactionMember() check.
// - Returns TRUE if it removes any.
int SMP_RemoveSpellEffectsFromFaction(int nSpell_ID, object oTarget, int bPCOnly = TRUE, float fDelay = 0.0)
{
    int bReturn = FALSE;
    // Get first faction member
    object oFaction = GetFirstFactionMember(oTarget, bPCOnly);
    while(GetIsObjectValid(oFaction))
    {
        // Remove the spell
        bReturn += SMP_RemoveSpellEffectsFromTarget(nSpell_ID, oFaction, fDelay);

        // Get next member
        oFaction = GetNextFactionMember(oTarget, bPCOnly);
    }
    if(bReturn > TRUE) bReturn = TRUE;
    return bReturn;
}
// SMP_INC_REMOVE. Removes all effects from nSpell_ID from anyone in oTarget's
// faction (party), using bPCOnly for the GetFirstFactionMember() check.
// In addition, spell must be from oCaster
// - Returns TRUE if it removes any.
int SMP_RemoveSpellEffectsFromFactionCaster(int nSpell_ID, object oCaster, object oTarget, int bPCOnly = TRUE, float fDelay = 0.0)
{
    int bReturn = FALSE;
    // Get first faction member
    object oFaction = GetFirstFactionMember(oTarget, bPCOnly);
    while(GetIsObjectValid(oFaction))
    {
        // Remove the spell
        bReturn += SMP_PRCRemoveSpellEffects(nSpell_ID, oCaster, oFaction, fDelay);

        // Get next member
        oFaction = GetNextFactionMember(oTarget, bPCOnly);
    }
    if(bReturn > TRUE) bReturn = TRUE;
    return bReturn;
}

// SMP_INC_REMOVE. Checks for iEffect on oTarget. TRUE if any of nEffect is found
int SMP_GetHasEffect(int nEffect, object oTarget = OBJECT_SELF)
{
    effect eCheck = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eCheck))
    {
        if(GetEffectType(eCheck) == nEffect)
        {
            return TRUE;
        }
        eCheck = GetNextEffect(oTarget);
    }
    return FALSE;
}
// SMP_INC_REMOVE. More checks then SMP_GetHasEffect().
// * oTarget - Target to check
// * oCreator - Creator of the effect (or OBJECT_INVALID)
// * nEffect - Effect ID (or EFFECT_TYPE_INVALIDEFFECT)
// * nSpellId - Spell Id (or SPELL_INVALID)
// * nDuration - Duration type (or DURATION_INVALID)
// * nSubType - Subtype (or SUBTYPE_IGNORE)
int SMP_GetHasEffectSpecific(object oTarget, object oCreator = OBJECT_INVALID, int nEffect = EFFECT_TYPE_INVALIDEFFECT, int nSpellId = SPELL_INVALID, int nDuration = DURATION_INVALID, int nSubType = SUBTYPE_IGNORE)
{
    effect eCheck = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eCheck))
    {
        // Check for effect type, or invalid.
        if(nEffect == EFFECT_TYPE_INVALIDEFFECT || GetEffectType(eCheck) == nEffect)
        {
            // Check for creator, or invalid
            if(!GetIsObjectValid(oCreator) || GetEffectCreator(eCheck) == oCreator)
            {
                // Check the spell Id
                if(nSpellId == SPELL_INVALID || GetEffectSpellId(eCheck) == nSpellId)
                {
                    // Duration type
                    if(nDuration == DURATION_INVALID || GetEffectDurationType(eCheck) == nDuration)
                    {
                        // Subtype
                        if(nSubType == SUBTYPE_IGNORE || GetEffectSubType(eCheck) == nSubType)
                        {
                            return TRUE;
                        }
                    }
                }
            }
        }
        // Else, check next effect
        eCheck = GetNextEffect(oTarget);
    }
    return FALSE;
}

// SMP_INC_REMOVE. Checks for nEffect on oTarget, cast by oCaster.
int SMP_GetHasEffectFromCaster(int nEffect, object oTarget, object oCaster)
{
    effect eCheck = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eCheck))
    {
        if(GetEffectType(eCheck) == nEffect)
        {
            if(GetEffectCreator(eCheck) == oCaster)
            {
                return TRUE;
            }
        }
        eCheck = GetNextEffect(oTarget);
    }
    return FALSE;
}
// SMP_INC_REMOVE. Checks for nEffect, nSpellId on oTarget, which is nSpellId
// * Can use nDuration if wanted. DURATION_INVALID to ignore.
int SMP_GetHasEffectFromSpell(int nEffect, object oTarget, int nSpellId, int nDuration = DURATION_INVALID)
{
    if(GetHasSpellEffect(nSpellId, oTarget))
    {
        effect eCheck = GetFirstEffect(oTarget);
        while(GetIsEffectValid(eCheck))
        {
            if(nDuration == DURATION_INVALID ||
               GetEffectDurationType(eCheck) == nDuration)
            {
                if(GetEffectType(eCheck) == nEffect)
                {
                    if(GetEffectSpellId(eCheck) == nSpellId)
                    {
                        return TRUE;
                    }
                }
            }
            eCheck = GetNextEffect(oTarget);
        }
    }
    return FALSE;
}
// SMP_INC_REMOVE. Checks for nSpellId on oTarget, cast by oCaster.
int SMP_GetHasSpellEffectFromCaster(int nSpellId, object oTarget, object oCaster)
{
    if(GetHasSpellEffect(nSpellId, oTarget))
    {
        effect eCheck = GetFirstEffect(oTarget);
        while(GetIsEffectValid(eCheck))
        {
            if(GetEffectSpellId(eCheck) == nSpellId)
            {
                if(GetEffectCreator(eCheck) == oCaster)
                {
                    return TRUE;
                }
            }
            eCheck = GetNextEffect(oTarget);
        }
    }
    return FALSE;
}
// SMP_INC_REMOVE. Checks for nSpellId on oTarget, which is nDuration
int SMP_GetHasSpellEffectDurationType(int nSpellId, object oTarget, int nDuration)
{
    if(GetHasSpellEffect(nSpellId, oTarget))
    {
        effect eCheck = GetFirstEffect(oTarget);
        while(GetIsEffectValid(eCheck))
        {
            if(GetEffectSpellId(eCheck) == nSpellId)
            {
                if(GetEffectDurationType(eCheck) == nDuration)
                {
                    return TRUE;
                }
            }
            eCheck = GetNextEffect(oTarget);
        }
    }
    return FALSE;
}

// SMP_INC_REMOVE. Special to remove all interposing hand effects, so they don't
// stack (IE: Movement decrease would be dreadful)
// * Also used in disintegration
int SMP_RemoveInterposingHands(object oTarget)
{
    // Remove the hands
    int bReturn = SMP_RemoveSpecificEffectFromSpell(EFFECT_TYPE_ATTACK_DECREASE, SMP_SPELL_BIGBYS_INTERPOSING_HAND, oTarget, SUBTYPE_IGNORE)
            + SMP_RemoveSpecificEffectFromSpell(EFFECT_TYPE_ATTACK_DECREASE, SMP_SPELL_BIGBYS_FORCEFUL_HAND_INTERPOSING, oTarget, SUBTYPE_IGNORE)
            + SMP_RemoveSpecificEffectFromSpell(EFFECT_TYPE_ATTACK_DECREASE, SMP_SPELL_BIGBYS_GRASPING_HAND_INTERPOSING, oTarget, SUBTYPE_IGNORE)
            + SMP_RemoveSpecificEffectFromSpell(EFFECT_TYPE_ATTACK_DECREASE, SMP_SPELL_BIGBYS_CLENCHED_FIST_INTERPOSING, oTarget, SUBTYPE_IGNORE)
            + SMP_RemoveSpecificEffectFromSpell(EFFECT_TYPE_ATTACK_DECREASE, SMP_SPELL_BIGBYS_CRUSHING_HAND_INTERPOSING, oTarget, SUBTYPE_IGNORE);
    return bReturn;
}

// SMP_INC_REMOVE. Special to remove all "Protection from alignment" of X alignment.
// * Note, it will use the power level, nPower, and will NOT return higher spells.
//   If it finds they have a higher level spell, it will return TRUE, else FALSE.
// * TRUE means do NOT apply any effects from that power spell.
// 1 = Protection From X, 2 = Magic Circle against X, 3 = Cloak Of/Shield Of etc.
// * Note: nAlignment is what is PROTECTED AGAINST, so Shield of Law would be ALIGNMENT_CHAOTIC.
int SMP_RemoveProtectionFromAlignment(object oTarget, int nAlignment, int nPower)
{
    int nSpell1, nSpell2, nSpell3;
    // Check alignment
    // * This is what alignment we are stopping
    switch(nAlignment)
    {
        // vs. Good:
        // 1 = Protection From Good
        // 2 = Magic Circle against Good
        // 3 = Unholy Aura
        case ALIGNMENT_GOOD:
        {
            // Set spells
            nSpell1 = SMP_SPELL_PROTECTION_FROM_GOOD;
            nSpell2 = SMP_SPELL_MAGIC_CIRCLE_AGAINST_GOOD;
            nSpell3 = SMP_SPELL_UNHOLY_AURA;
        }
        break;
        // vs. Evil:
        // 1 = Protection From Evil
        // 2 = Magic Circle against Evil
        // 3 = Holy Aura
        case ALIGNMENT_EVIL:
        {
            // Set spells
            nSpell1 = SMP_SPELL_PROTECTION_FROM_EVIL;
            nSpell2 = SMP_SPELL_MAGIC_CIRCLE_AGAINST_EVIL;
            nSpell3 = SMP_SPELL_HOLY_AURA;
        }
        break;
        // vs. Law:
        // 1 = Protection From Law
        // 2 = Magic Circle against Law
        // 3 = Cloak of Chaos
        case ALIGNMENT_LAWFUL:
        {
            // Set spells
            nSpell1 = SMP_SPELL_PROTECTION_FROM_LAW;
            nSpell2 = SMP_SPELL_MAGIC_CIRCLE_AGAINST_LAW;
            nSpell3 = SMP_SPELL_CLOAK_OF_CHAOS;
        }
        break;
        // vs. Chaos:
        // 1 = Protection From Chaos
        // 2 = Magic Circle against Chaos
        // 3 = Shield of Law
        case ALIGNMENT_CHAOTIC:
        {
            // Set spells
            nSpell1 = SMP_SPELL_PROTECTION_FROM_CHAOS;
            nSpell2 = SMP_SPELL_MAGIC_CIRCLE_AGAINST_CHAOS;
            nSpell3 = SMP_SPELL_SHIELD_OF_LAW;
        }
        break;
    }
    // Check power
    switch(nPower)
    {
        // If power 3, remove all others regardless
        case 3:
        {
            // Remove, then return FALSE
            SMP_RemoveSpecificEffectFromSpell(EFFECT_TYPE_AC_INCREASE, nSpell1, oTarget);
            SMP_RemoveSpecificEffectFromSpell(EFFECT_TYPE_AC_INCREASE, nSpell2, oTarget);
            SMP_RemoveSpecificEffectFromSpell(EFFECT_TYPE_AC_INCREASE, nSpell3, oTarget);
            // Return FALSE
            return FALSE;
        }
        break;
        // If power 2, we remove 2 and 1, but will return TRUE if got power 3
        case 2:
        {
            // Check spell 3
            if(SMP_GetHasEffectFromSpell(EFFECT_TYPE_AC_INCREASE, oTarget, nSpell3)) return TRUE;

            // Remove other two otherwise.
            SMP_RemoveSpecificEffectFromSpell(EFFECT_TYPE_AC_INCREASE, nSpell1, oTarget);
            SMP_RemoveSpecificEffectFromSpell(EFFECT_TYPE_AC_INCREASE, nSpell2, oTarget);
            // Return FALSE
            return FALSE;
        }
        break;
        // If power 1, we remove 1, but will return TRUE if got power 3 or 2
        case 1:
        {
            // Check spell 3
            if(SMP_GetHasEffectFromSpell(EFFECT_TYPE_AC_INCREASE, oTarget, nSpell3)) return TRUE;
            // Check spell 2
            if(SMP_GetHasEffectFromSpell(EFFECT_TYPE_AC_INCREASE, oTarget, nSpell2)) return TRUE;

            // Remove other one otherwise.
            SMP_RemoveSpecificEffectFromSpell(EFFECT_TYPE_AC_INCREASE, nSpell1, oTarget);
            // Return FALSE
            return FALSE;
        }
        break;
    }
    // Can cast the spell.
    return FALSE;
}

// SMP_INC_REMOVE. Special to check if they have any spells on them currently
// which provide a bonus of nBonus, to nAbility. If they have any which are
// == nBonusToApply, will return 1, if > nBonusToApply, will return 2.
// * So, use 1 in cases where you want to miss out the bonus (Iron Body), and
//   2 in cases when you want to stop the effect being applied at all (Bulls Strength).
// * Use to prevent, for example, a bonus of +4 being applied over a bonus of +8.
int SMP_GetHasAbilityBonusOfPower(object oTarget, int nAbility, int nBonusToApply)
{
    switch(nAbility)
    {
        case ABILITY_STRENGTH:
        {
            // Bulls strength (4), Mass version (4), Divine Power (6), Iron Body (6)
            //
            // NOTE: * Righteous Might (8) STACKS with other spells!
            //       * Death Knell (2) Stacks too, well, I think it should.
            //       * Rage (2) Stacks, as it acts as the rage ability, which stacks.
            //       * Fortify Golem (4) won't bother, duh, as golems won't be affected by the other spells.
            // Divine power (6) and Iron Body (6).
            if(GetHasSpellEffect(SMP_SPELL_DIVINE_POWER, oTarget) ||
               GetHasSpellEffect(SMP_SPELL_IRON_BODY, oTarget))
            {
                // Bonus of +6
                if(6 > nBonusToApply)
                {
                    return 2;
                }
                else if(nBonusToApply == 6)
                {
                    return 1;
                }
                // Else...carry on checking
            }
            if(GetHasSpellEffect(SMP_SPELL_BULLS_STRENGTH, oTarget) ||
               GetHasSpellEffect(SMP_SPELL_BULLS_STRENGTH_MASS, oTarget))
            {
                // Bonus of +4
                if(4 > nBonusToApply)
                {
                    return 2;
                }
                else if(nBonusToApply == 4)
                {
                    return 1;
                }
            }
        }
        break;
        case ABILITY_DEXTERITY:
        {
            // Cats Grace (4), Mass version (4),
            // NOTE: * Call chaos (4) is a special, chaotic one.
            //       * Fortify Golem (4) won't work with other spells, only works on golems.
            if(GetHasSpellEffect(SMP_SPELL_CATS_GRACE, oTarget) ||
               GetHasSpellEffect(SMP_SPELL_CATS_GRACE_MASS, oTarget))
            {
                // Bonus of +4
                if(4 > nBonusToApply)
                {
                    return 2;
                }
                else if(nBonusToApply == 4)
                {
                    return 1;
                }
            }
        }
        break;
        case ABILITY_CONSTITUTION:
        {
            // Bears Endurace (4), Mass version (4),
            // NOTE: * Rage (2) is as the ability, and stacks.
            if(GetHasSpellEffect(SMP_SPELL_BEARS_ENDURANCE, oTarget) ||
               GetHasSpellEffect(SMP_SPELL_BEARS_ENDURANCE_MASS, oTarget))
            {
                // Bonus of +4
                if(4 > nBonusToApply)
                {
                    return 2;
                }
                else if(nBonusToApply == 4)
                {
                    return 1;
                }
            }
        }
        break;
        case ABILITY_INTELLIGENCE:
        {
            // Foxs cunning (4), Mass version (4),
            // NOTE: * Awaken (X) is special, will stack.
            if(GetHasSpellEffect(SMP_SPELL_FOXS_CUNNING, oTarget) ||
               GetHasSpellEffect(SMP_SPELL_FOXS_CUNNING_MASS, oTarget))
            {
                // Bonus of +4
                if(4 > nBonusToApply)
                {
                    return 2;
                }
                else if(nBonusToApply == 4)
                {
                    return 1;
                }
            }
        }
        break;
        case ABILITY_WISDOM:
        {
            // Owls wisdom (4), Mass version (4)
            // No others.
            if(GetHasSpellEffect(SMP_SPELL_OWLS_WISDOM, oTarget) ||
               GetHasSpellEffect(SMP_SPELL_OWLS_WISDOM_MASS, oTarget))
            {
                // Bonus of +4
                if(4 > nBonusToApply)
                {
                    return 2;
                }
                else if(nBonusToApply == 4)
                {
                    return 1;
                }
            }
        }
        break;
        case ABILITY_CHARISMA:
        {
            // Eagles Splendor (4), Mass version (4)
            // NOTE: * Awaken (X) is special, will stack.
            if(GetHasSpellEffect(SMP_SPELL_EAGLES_SPLENDOR, oTarget) ||
               GetHasSpellEffect(SMP_SPELL_EAGLES_SPLENDOR_MASS, oTarget))
            {
                // Bonus of +4
                if(4 > nBonusToApply)
                {
                    return 2;
                }
                else if(nBonusToApply == 4)
                {
                    return 1;
                }
            }
        }
        break;
    }
    // No power of greater strength of nBonus.
    return FALSE;
}
// SMP_INC_REMOVE. Special to remove ALL bonuses from nAbility on oTarget.
// * Make sure to check, beforhand, of any of greater power (if applicable) via.
//   GetHasAbilityBonusOfPower.
// * TRUE if it removes any
// * The powers must be <= nBonus Power, or 100 to ignore (as it'll catch any bonus power).
int SMP_RemoveAnyAbilityBonuses(object oTarget, int nAbility, int nBonusPower = 100)
{
    int bReturn = FALSE;

    switch(nAbility)
    {
        case ABILITY_STRENGTH:
        {
            // Bulls strength (4), Mass version (4), Divine Power (6), Iron Body (6)
            //
            // NOTE: * Righteous Might (8) STACKS with other spells!
            //       * Death Knell (2) Stacks too, well, I think it should.
            //       * Rage (2) Stacks, as it acts as the rage ability, which stacks.
            //       * Fortify Golem (4) won't bother, duh, as golems won't be affected by the other spells.
            // Divine power (6) and Iron Body (6).
            if(nBonusPower >= 6)
            {
                bReturn = SMP_RemoveMultipleSpellEffectsFromTarget(oTarget, SMP_SPELL_DIVINE_POWER, SMP_SPELL_IRON_BODY);
            }
            else if(nBonusPower >= 4)
            {
                bReturn = SMP_RemoveMultipleSpellEffectsFromTarget(oTarget, SMP_SPELL_BULLS_STRENGTH, SMP_SPELL_BULLS_STRENGTH_MASS);
            }
        }
        break;
        case ABILITY_DEXTERITY:
        {
            // Cats Grace (4), Mass version (4),
            // NOTE: * Call chaos (4) is a special, chaotic one.
            //       * Fortify Golem (4) won't work with other spells, only works on golems.
            if(nBonusPower >= 4)
            {
                bReturn = SMP_RemoveMultipleSpellEffectsFromTarget(oTarget, SMP_SPELL_CATS_GRACE, SMP_SPELL_CATS_GRACE_MASS);
            }
        }
        break;
        case ABILITY_CONSTITUTION:
        {
            // Bears Endurace (4), Mass version (4),
            // NOTE: * Rage (2) is as the ability, and stacks.
            if(nBonusPower >= 4)
            {
                bReturn = SMP_RemoveMultipleSpellEffectsFromTarget(oTarget, SMP_SPELL_BEARS_ENDURANCE, SMP_SPELL_BEARS_ENDURANCE_MASS);
            }
        }
        break;
        case ABILITY_INTELLIGENCE:
        {
            // Foxs cunning (4), Mass version (4),
            // NOTE: * Awaken (X) is special, will stack.
            if(nBonusPower >= 4)
            {
                bReturn = SMP_RemoveMultipleSpellEffectsFromTarget(oTarget, SMP_SPELL_FOXS_CUNNING, SMP_SPELL_FOXS_CUNNING_MASS);
            }
        }
        break;
        case ABILITY_WISDOM:
        {
            // Owls wisdom (4), Mass version (4)
            // No others.
            if(nBonusPower >= 4)
            {
                bReturn = SMP_RemoveMultipleSpellEffectsFromTarget(oTarget, SMP_SPELL_OWLS_WISDOM, SMP_SPELL_OWLS_WISDOM_MASS);
            }
        }
        break;
        case ABILITY_CHARISMA:
        {
            // Eagles Splendor (4), Mass version (4)
            // NOTE: * Awaken (X) is special, will stack.
            if(nBonusPower >= 4)
            {
                bReturn = SMP_RemoveMultipleSpellEffectsFromTarget(oTarget, SMP_SPELL_EAGLES_SPLENDOR, SMP_SPELL_EAGLES_SPLENDOR_MASS);
            }
        }
        break;
    }

    return bReturn;
}


// End of file Debug lines. Uncomment below "/*" with "//" and compile.
/*
void main()
{
    return;
}
//*/
