/*:://////////////////////////////////////////////
//:: Name Dispel Include
//:: FileName SMP_INC_DISPEL
//:://////////////////////////////////////////////
    All dispel magic things.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_AOE"
#include "SMP_INC_REMOVE"

const string SMP_IMMUNNITY_TO_DISPEL = "SMP_IMMUNNITY_TO_DISPEL";

// SMP_INC_DISPEL. This will dispel magic (All, IE targeted) on oTarget.
// * Checks spell effects for special things when ended.
// * No special reaction checks.
// * Put in eDispel, all effect.
// * Removes all friendly-spell effects off oTarget, by oCaster if "good" spells.
// * Will check items equipped by oTarget, and dispel ALL possible ones.
void SMP_DispelMagicAll(object oTarget, effect eDispel, effect eVis, object oCaster = OBJECT_SELF);

// SMP_INC_DISPEL. This will dispel magic (All, IE targeted) on oTarget.
// * Checks spell effects for special things when ended.
// * No special reaction checks.
// * Put in eDispel, best effect.
// * Removes all friendly-spell effects off oTarget, by oCaster if "good" spells.
// * Will check items equipped by oTarget, and dispel ONE possible effect.
void SMP_DispelMagicBest(object oTarget, effect eDispel, effect eVis, object oCaster = OBJECT_SELF);

// SMP_INC_DISPEL. Dispels all magic on oItem.
// * TRUE if we dispel anything.
int SMP_DispelMagicAllOnItem(object oItem);
// SMP_INC_DISPEL. Dispels one spell on oItem.
// * TRUE if we dispel anything.
int SMP_DispelMagicBestOnItem(object oItem);

// SMP_INC_DISPEL. This will disjoin magical effects on oTarget (Mage's Disjuction).
// - Checks spell effects for special things when ended.
// - No special reaction checks.
// - It will remove all SUBTYPE_MAGICAL effects which have
//   GetEffectSpellId() != SPELL_INVALID
// * Note it can remove some effects Dispel Magic cannot. And does so here.
void SMP_DisjoinMagic(object oTarget, int nVFX = VFX_IMP_DISPEL, object oCaster = OBJECT_SELF);


// SMP_INC_DISPEL.
// This will dispel magic - on an area of effect. Each one will need a seperate
// caster check to destroy and must be from a spell, of course.
void SMP_DispelMagicAreaOfEffect(object oAOE, int nCasterLevel);

// SMP_INC_DISPEL.
// By putting in nMPH, it will see if it can remove oAOE, if it is a fog-based AOE.
void SMP_DispelWindAreaOfEffect(object oAOE, int nMPH);

// SMP_INC_DISPEL.
// This will remove all "friendly" effects from oTarget which are from spells.
// - Only do this if oTarget is an enemy.
void SMP_DispelAllFriendlySpells(object oTarget, object oCaster = OBJECT_SELF);

// SMP_INC_DISPEL.
// Does a dispel check against oTarget for all effects from spells which are of
// nEffectType, using nCasterLevel.
// * Returns TRUE if any are removed (for VFX's)
int SMP_DispelAllEffectsOfType(object oTarget, int nCasterLevel, int nEffectType);

// SMP_INC_DISPEL.
// Does a dispel check against oTarget for all effects from spells which are
// nSpellId, using nCasterLevel. Once one is tested, all are removed.
// * Returns TRUE if any are removed (for VFX's)
int SMP_DispelAllSpellsOfId(object oTarget, int nCasterLevel, int nSpellId);

// SMP_INC_DISPEL.
// Does a dispel check against oTarget for all effects from spells cast by
// Good/Evil Alignment nAlignment. Goes from Best to Worse, using nCasterLevel.
// * Also the list will try any GoodEvil spells of nAlignment
// * Returns TRUE if any are removed, and 2 if any are found. (for VFX's)
int SMP_DispelBestSpellFromGoodEvilAlignment(object oTarget, int nCasterLevel, int nAlignment);

// SMP_INC_DISPEL.
// Does a dispel check against oTarget for all effects from spells cast by
// Good/Evil Alignment nAlignment.
// * Also the list will try any GoodEvil spells of nAlignment
// * Returns TRUE if any are removed (for VFX's)
int SMP_DispelAllSpellFromGoodEvilAlignment(object oTarget, int nCasterLevel, int nAlignment);

// SMP_INC_DISPEL.
// Does a dispel check against oTarget for all effects from spells cast by
// Law/Chaos Alignment nAlignment. Goes from Best to Worse, using nCasterLevel.
// * Also the list will try any LawChaos spells of nAlignment
// * Returns TRUE if any are removed, and 2 if any are found. (for VFX's)
int SMP_DispelBestSpellFromLawChaosAlignment(object oTarget, int nCasterLevel, int nAlignment);

// SMP_INC_DISPEL.
// Does a dispel check against oTarget for all effects from spells cast by
// Law/Chaos Alignment nAlignment.
// * Also the list will try any LawChaos spells of nAlignment
// * Returns TRUE if any are removed (for VFX's)
int SMP_DispelAllSpellFromLawChaosAlignment(object oTarget, int nCasterLevel, int nAlignment);

// SMP_INC_DISPEL.
// Get the caster level of nSpellId from oCaster. This will get the last caster level
// of the spell cast by oCaster of nSpellId.
// * Used in dispel functions.
// * If oCaster is invalid, it will use the Spell Level (Innate) + 1 / 2 to get the
//   minimum caster level for at least a half-decent DC
int SMP_DispelGetCasterLevelOfSpell(int nSpellId, object oCaster);
// SMP_INC_DISPEL. Get the level of the spell, nSpellId, last cast by oCreator.
// * Use the innate level if the caster is invalid.
int SMP_DispelGetLevelOfSpell(int nSpellId, object oCaster);

// SMP_INC_DISPEL.
// Does a dispel check against oTarget for all effects from spells which are of
// the spell school nSpellSchool.
// * If nLevelIfSpecial is over 0, and the effect is supernatural or extraodinary,
//   it will dispel it still if the spell's level is <= nLevelIfSpecial
// * Returns TRUE if any are removed (for VFX's)
int SMP_DispelAllSpellsFromSpellSchool(object oTarget, int nCasterLevel, int nSpellSchool, int nLevelIfSpecial = 0);

// SMP_INC_DISPEL. Returns an integer value of all the valid effects on oTarget.
// Used in "Best" dispel function.
int SMP_DispelCountEffectsOnTarget(object oTarget);

// Start functions

// SMP_INC_DISPEL. This will dispel magic (All, IE targeted) on oTarget.
// * Checks spell effects for special things when ended.
// * No special reaction checks.
// * Put in eDispel, all effect.
// * Removes all friendly-spell effects off oTarget, by oCaster if "good" spells.
// * Will check items equipped by oTarget, and dispel ALL possible ones.
void SMP_DispelMagicAll(object oTarget, effect eDispel, effect eVis, object oCaster = OBJECT_SELF)
{
    // If they are specifically immune to dispel, do not dispel!
    if(GetLocalInt(oTarget, SMP_IMMUNNITY_TO_DISPEL)) return;

    // We remove all friendly spell effects cast by oCaster if they are not
    // a friend/faction equal
    if(!GetIsFriend(oTarget, oCaster) && !GetFactionEqual(oTarget, oCaster))
    {
        // Remove them
        SMP_DispelAllFriendlySpells(oTarget, oCaster);
    }

    // Apply dispel
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDispel, oTarget);

    // We can also dispel all magical spells from thier items
    int nCnt;
    for(nCnt = 0; nCnt <= NUM_INVENTORY_SLOTS; nCnt++)
    {
        // Dispel the magic from that slot.
        SMP_DispelMagicAllOnItem(GetItemInSlot(nCnt, oTarget));
    }
}


// SMP_INC_DISPEL. This will dispel magic (All, IE targeted) on oTarget.
// * Checks spell effects for special things when ended.
// * No special reaction checks.
// * Put in eDispel, best effect.
// * Removes all friendly-spell effects off oTarget, by oCaster if "good" spells.
// * Will check items equipped by oTarget, and dispel ONE possible effect.
void SMP_DispelMagicBest(object oTarget, effect eDispel, effect eVis, object oCaster = OBJECT_SELF)
{
    // If they are specifically immune to dispel, do not dispel!
    if(GetLocalInt(oTarget, SMP_IMMUNNITY_TO_DISPEL)) return;

    // We remove all friendly spell effects cast by oCaster if they are not
    // a friend/faction equal
    if(!GetIsFriend(oTarget, oCaster) && !GetFactionEqual(oTarget, oCaster))
    {
        // Remove them
        SMP_DispelAllFriendlySpells(oTarget, oCaster);
    }

    // Count up the effects on oTarget before applying eDispel
    int nBefore = SMP_DispelCountEffectsOnTarget(oTarget);

    // Apply dispel
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDispel, oTarget);

    // Count up the effects on oTarget after applying eDispel
    int nAfter = SMP_DispelCountEffectsOnTarget(oTarget);

    // If we have removed at least 1 effect from oTarget, we do not dispel
    // item properties.
    if(nBefore > nAfter)
    {
        // We can also dispel the best magical spells from thier items if we have
        // not removed anything from eDispel.
        int nCnt, bDone;
        for(nCnt = 0; (bDone != TRUE && nCnt <= NUM_INVENTORY_SLOTS); nCnt++)
        {
            // Dispel the best magic from that slot.
            bDone = SMP_DispelMagicBestOnItem(GetItemInSlot(nCnt, oTarget));
        }
    }
}

// SMP_INC_DISPEL. Dispels all magic on oItem.
// * TRUE if we dispel anything.
int SMP_DispelMagicAllOnItem(object oItem)
{
    // Return value
    int bReturn, bGotSpell;

    // We need to check a local variable - is there any valid spells on the
    // item, or cast on it?
    if(GetLocalInt(oItem, "SMP_ITEM_SPELLCASTON") == TRUE)
    {
        // We loop the item properties on oItem.
        itemproperty ipCheck = GetFirstItemProperty(oItem);
        int nPropType;
        while(GetIsItemPropertyValid(ipCheck))
        {
            // Check duration
            if(GetItemPropertyDurationType(ipCheck) == DURATION_TYPE_TEMPORARY)
            {
                // We check nPropType
                nPropType = GetItemPropertyType(ipCheck);

                // Each spell will set, on the item, a valid integer for the caster
                // level of the temp item property.

                // TO DO

                // Set bGotSpell to TRUE
                bGotSpell = TRUE;
            }
        }

        // Note: Here, if we didn't find any tempoary item properties from spells, we
        // will set the local to FALSE again, by deleting it.
        if(bGotSpell == FALSE)
        {
            DeleteLocalInt(oItem, "SMP_ITEM_SPELLCASTON");
        }
    }
    return bReturn;
}
// SMP_INC_DISPEL. Dispels one spell on oItem.
// * TRUE if we dispel anything.
int SMP_DispelMagicBestOnItem(object oItem)
{
    // Return value
    int bReturn, bGotSpell;

    // We need to check a local variable - is there any valid spells on the
    // item, or cast on it?
    if(GetLocalInt(oItem, "SMP_ITEM_SPELLCASTON") == TRUE)
    {
        // We loop the item properties on oItem.
        itemproperty ipCheck = GetFirstItemProperty(oItem);
        int nPropType;
        while(GetIsItemPropertyValid(ipCheck))
        {
            // Check duration
            if(GetItemPropertyDurationType(ipCheck) == DURATION_TYPE_TEMPORARY)
            {
                // We check nPropType
                nPropType = GetItemPropertyType(ipCheck);

                // Each spell will set, on the item, a valid integer for the caster
                // level of the temp item property.

                // TO DO

                // Set bGotSpell to TRUE
                bGotSpell = TRUE;
            }
        }

        // Note: Here, if we didn't find any tempoary item properties from spells, we
        // will set the local to FALSE again, by deleting it.
        if(bGotSpell == FALSE)
        {
            DeleteLocalInt(oItem, "SMP_ITEM_SPELLCASTON");
        }
    }

    return bReturn;
}

// SMP_INC_DISPEL.
// This will dispel magic - on an area of effect. Each one will need a seperate
// caster check to destroy and must be from a spell, of course.
void SMP_DispelMagicAreaOfEffect(object oAOE, int nCasterLevel)
{
    // Can't be a plotted AOE - as it will not be destroyed anyway!
    if(GetPlotFlag(oAOE)) return;

    // Dispel the AOE
    int nEnemyCasterLevel = SMP_GetAOECasterLevel(oAOE);

    // Forbiddance:
    // Dispel magic does not dispel a forbiddance effect unless the dispeller’s
    // level is at least as high as your caster level.
    if(GetTag(oAOE) == SMP_AOE_TAG_PER_FORBIDDANCE)
    {
        if(nEnemyCasterLevel >= nCasterLevel)
        {
            // Cannot dispel!
            return;
        }
    }

    // Get the level of the AOE
    int nDC = 11 + nEnemyCasterLevel;

    // Do the roll
    int nCasterRoll = d20() + nCasterLevel;

    // If sucessful, destroy the target.
    if(nCasterRoll >= nDC)
    {
        DestroyObject(oAOE);
    }
}

// SMP_INC_DISPEL.
// By putting in nMPH, it will see if it can remove oAOE, if it is a fog-based AOE.
void SMP_DispelWindAreaOfEffect(object oAOE, int nMPH)
{
    // Can't be a plotted AOE - as it will not be destroyed anyway!
    if(GetPlotFlag(oAOE)) return;

    // Spells used in: Gust of Wind (50MPH)

    // We check the tag of oAOE
    string sTag = GetTag(oAOE);
    // We get the DC of the MPH needed. It will be slightly randomised.
    // - Note that it is the "is removed in 1 round" MPH needed. This is an instant
    //   gust of wind.
    int nDC;

    // Will finish later.
    if(sTag == SMP_AOE_TAG_PER_ACID_FOG)
    {
        nDC = 40 + Random(11);
    }

    // If sucessful, destroy the target.
    if(nMPH >= nDC)
    {
        DestroyObject(oAOE);
    }
}

// SMP_INC_DISPEL. This will disjoin magical effects on oTarget (Mage's Disjuction).
// - Checks spell effects for special things when ended.
// - No special reaction checks.
// - It will remove all SUBTYPE_MAGICAL effects which have
//   GetEffectSpellId() != SPELL_INVALID
// * Note it can remove some effects Dispel Magic cannot. And does so here.
void SMP_DisjoinMagic(object oTarget, int nVFX = VFX_IMP_DISPEL, object oCaster = OBJECT_SELF)
{
    // If they are specifically immune to dispel, do not dispel!
    if(GetLocalInt(oTarget, SMP_IMMUNNITY_TO_DISPEL)) return;

    // We do not affect ourselves:
    // All magical effects from spells and magic items within the radius of the
    // spell, |||except for those that you carry or touch|||, are disjoined.
    if(oTarget == oCaster) return;

    // Declare effects
    effect eVis = EffectVisualEffect(nVFX);
    int nSpellId;

    // Set if the target has any spell effects that have effects applied
    // when ended.

    // - Stuff

    // Apply dispel
    effect eCheck = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eCheck))
    {
        nSpellId = GetEffectSpellId(eCheck);
        // Remove all magical spell applied effects
        if(nSpellId != SPELL_INVALID &&
           GetEffectSubType(eCheck) == SUBTYPE_MAGICAL)
        {
            RemoveEffect(oTarget, eCheck);
        }
        // * Seal magic is also disjoined
        else if(nSpellId == SMP_SPELL_SEAL_MAGIC)
        {
            RemoveEffect(oTarget, eCheck);
        }
        eCheck = GetNextEffect(oTarget);
    }
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

    // And apply the effects of spells removed.

    // - Stuff
}

// SMP_INC_DISPEL.
// This will remove all "friendly" effects from oTarget which are from spells.
// - Only do this if oTarget is an enemy.
void SMP_DispelAllFriendlySpells(object oTarget, object oCaster = OBJECT_SELF)
{
    // Get first effect from oTarget
    effect eCheck = GetFirstEffect(oTarget);
    int nSpellId = -1;
    // Remove all from oCaster, which have a valid spell ID and friendly status.
    while(GetIsEffectValid(eCheck))
    {
        if(GetEffectCreator(eCheck) == oCaster)
        {
            //If the effect was created by the spell then remove it
            nSpellId = GetEffectSpellId(eCheck);
            if(nSpellId >= 0)
            {
                // Check if not-hostile.
                if(SMP_ArrayGetIsHostile(nSpellId) == FALSE)
                {
                    RemoveEffect(oTarget, eCheck);
                }
            }
        }
        //Get next effect on the target
        eCheck = GetNextEffect(oTarget);
    }
}

// SMP_INC_DISPEL.
// Does a dispel check against oTarget for all effects from spells which are of
// nEffectType, using nCasterLevel.
// * Returns TRUE if any are removed (for VFX's)
int SMP_DispelAllEffectsOfType(object oTarget, int nCasterLevel, int nEffectType)
{
    int bReturn = FALSE;
    int nEffectCasterLevel, nSpellId, nDC;
    // Loop effects and try and dispel each one!
    effect eCheck = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eCheck))
    {
        // Magical subtype and must be from a spell, and nEffectType must match!
        nSpellId = GetEffectSpellId(eCheck);
        if(nSpellId >= 0 && GetEffectType(eCheck) == nEffectType &&
           GetEffectSubType(eCheck) == SUBTYPE_MAGICAL)
        {
            // We try and dispel the spells effects
            nEffectCasterLevel = SMP_DispelGetCasterLevelOfSpell(nSpellId, GetEffectCreator(eCheck));

            // DC is always 11 + nEffectCasterLevel
            nDC = 11 + nEffectCasterLevel;

            // Dispel!
            if(nCasterLevel + d20() >= nDC)
            {
                // Remove the effect!
                RemoveEffect(oTarget, eCheck);
                bReturn = TRUE;
            }
        }
        eCheck = GetNextEffect(oTarget);
    }

    return bReturn;
}

// SMP_INC_DISPEL.
// Does a dispel check against oTarget for all effects from spells which are
// nSpellId, using nCasterLevel. Once one is tested, all are removed.
// * Returns TRUE if any are removed (for VFX's)
int SMP_DispelAllSpellsOfId(object oTarget, int nCasterLevel, int nSpellId)
{
    int bReturn = FALSE;
    int nEffectCasterLevel, nSpellId, nDC;
    // Loop effects and try and dispel each one!
    effect eCheck = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eCheck))
    {
        // Magical subtype and must be from nSpellId.
        nSpellId = GetEffectSpellId(eCheck);
        if(nSpellId == nSpellId &&
           GetEffectSubType(eCheck) == SUBTYPE_MAGICAL)
        {
            // We try and dispel the spells effects
            nEffectCasterLevel = SMP_DispelGetCasterLevelOfSpell(nSpellId, GetEffectCreator(eCheck));

            // DC is always 11 + nEffectCasterLevel
            nDC = 11 + nEffectCasterLevel;

            // Dispel!
            if(nCasterLevel + d20() >= nDC)
            {
                // Remove the effect!
                RemoveEffect(oTarget, eCheck);
                bReturn = TRUE;
            }
        }
        eCheck = GetNextEffect(oTarget);
    }

    return bReturn;
}

// SMP_INC_DISPEL.
// Does a dispel check against oTarget for all effects from spells cast by
// Good/Evil Alignment nAlignment. Goes from Best to Worse, using nCasterLevel.
// * Also the list will try any GoodEvil spells of nAlignment
// * Returns TRUE if any are removed, and 2 if any are found. (for VFX's)
int SMP_DispelBestSpellFromGoodEvilAlignment(object oTarget, int nCasterLevel, int nAlignment)
{
    // BEST VERSION. This will only dispel the best evil spell on the target.
    // Decided:
    // - Going to just dispel the FIST evil spell on the target...

    int bReturn = FALSE;
    int nEffectCasterLevel, nSpellId, nDC;
    object oCreator;
    // Loop effects to get the best to worst spells.
    effect eCheck = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eCheck) && bReturn != TRUE)
    {
        // Magical subtype and must be from nSpellId.
        nSpellId = GetEffectSpellId(eCheck);
        oCreator = GetEffectCreator(eCheck);
        if(nSpellId >= 0 &&
           GetEffectSubType(eCheck) == SUBTYPE_MAGICAL)
        {
            // Check alignment GOOD/EVIL
            if(SMP_ArrayGetSpellGoodEvilAlignment(nSpellId) == nAlignment ||
               // Note: Returns -1 if invalid, so this is good to use easily.
               GetAlignmentGoodEvil(oCreator) == nAlignment)
            {
                // Dispel found
                bReturn = 2;

                // We try and dispel the spells effects
                nEffectCasterLevel = SMP_DispelGetCasterLevelOfSpell(nSpellId, oCreator);

                // DC is always 11 + nEffectCasterLevel
                nDC = 11 + nEffectCasterLevel;

                // Dispel!
                if(nCasterLevel + d20() >= nDC)
                {
                    // Remove all effects from the spell by oCreator
                    SMP_PRCRemoveSpellEffects(nSpellId, oCreator, oTarget, 0.1);
                    bReturn = TRUE;
                }
            }
        }
        eCheck = GetNextEffect(oTarget);
    }
    return bReturn;
}
// SMP_INC_DISPEL.
// Does a dispel check against oTarget for all effects from spells cast by
// Good/Evil Alignment nAlignment.
// * Also the list will try any GoodEvil spells of nAlignment
// * Returns TRUE if any are removed (for VFX's)
int SMP_DispelAllSpellFromGoodEvilAlignment(object oTarget, int nCasterLevel, int nAlignment)
{
    int bReturn = FALSE;
    int nEffectCasterLevel, nSpellId, nDC;
    object oCreator;
    string sId;
    // Loop effects and try and dispel each one!
    effect eCheck = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eCheck))
    {
        // Magical subtype and must be from nSpellId.
        nSpellId = GetEffectSpellId(eCheck);
        sId = "SMP_ALIGNMENTDISPEL" + IntToString(nSpellId);
        oCreator = GetEffectCreator(eCheck);
        // We check if we have dispelled this spells' effect already
        // * Local will be either an alignment (>= 1), -1 for invalid alignment
        //   or -2 for "never dispel this effect". -2 will never match.
        if(GetAlignmentGoodEvil(oCreator) == GetLocalInt(OBJECT_SELF, sId))
        {
            // Remove
            // * Note to self: could make it more complexe and, say, check the
            //   effect creator. Would need more complexe integers, however.
            // * We do, though, check the alignment of the spellcaster against
            //   the local, this is a partial check.
            RemoveEffect(oTarget, eCheck);
        }
        else if(nSpellId >= 0 &&
           GetEffectSubType(eCheck) == SUBTYPE_MAGICAL &&
           GetLocalInt(OBJECT_SELF, sId) != -2)
        {

            // Check alignment GOOD/EVIL
            if(SMP_ArrayGetSpellGoodEvilAlignment(nSpellId) == nAlignment ||
               // Note: Returns -1 if invalid, so this is good to use easily.
               GetAlignmentGoodEvil(oCreator) == nAlignment)
            {
                // We try and dispel the spells effects
                nEffectCasterLevel = SMP_DispelGetCasterLevelOfSpell(nSpellId, oCreator);

                // DC is always 11 + nEffectCasterLevel
                nDC = 11 + nEffectCasterLevel;

                // Dispel!
                if(nCasterLevel + d20() >= nDC)
                {
                    // Remove the effect!
                    RemoveEffect(oTarget, eCheck);
                    // NOTE:
                    // - Because we have dispelled this spell - other effects
                    // from this spell (like visuals) might still be present.
                    // This isn't the case when we check specific effects, but
                    // it is when we dispel all spells of nSpellId, from oTarget.

                    // This means I'll set a local variable to the caster (OBJECT_SELF)
                    // so it'll remove futher effects from nSpellId.

                    // GetAlignmentGoodEvil() is DISPEL ALL OTHERS
                    SetLocalInt(OBJECT_SELF, sId, GetAlignmentGoodEvil(oCreator));
                    DelayCommand(1.0, DeleteLocalInt(OBJECT_SELF, sId));

                    bReturn = TRUE;
                }
                else
                {
                    // See above, but the dispel failed, so we set to NEVER
                    // remove futher effects from nSpellId.

                    // -2 is IGNORE ALL OTHERS
                    SetLocalInt(OBJECT_SELF, sId, -2);
                    DelayCommand(1.0, DeleteLocalInt(OBJECT_SELF, sId));
                }
            }
        }
        eCheck = GetNextEffect(oTarget);
    }
    return bReturn;
}
// SMP_INC_DISPEL.
// Does a dispel check against oTarget for all effects from spells cast by
// Law/Chaos Alignment nAlignment. Goes from Best to Worse, using nCasterLevel.
// * Also the list will try any LawChaos spells of nAlignment
// * Returns TRUE if any are removed, and 2 if any are found. (for VFX's)
int SMP_DispelBestSpellFromLawChaosAlignment(object oTarget, int nCasterLevel, int nAlignment)
{
    // BEST VERSION. This will only dispel the best evil spell on the target.
    // Decided:
    // - Going to just dispel the FIST evil spell on the target...

    int bReturn = FALSE;
    int nEffectCasterLevel, nSpellId, nDC;
    object oCreator;
    // Loop effects to get the best to worst spells.
    effect eCheck = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eCheck) && bReturn != TRUE)
    {
        // Magical subtype and must be from nSpellId.
        nSpellId = GetEffectSpellId(eCheck);
        oCreator = GetEffectCreator(eCheck);
        if(nSpellId >= 0 &&
           GetEffectSubType(eCheck) == SUBTYPE_MAGICAL)
        {
            // Check alignment LAW/CHAOS
            if(SMP_ArrayGetSpellLawChaosAlignment(nSpellId) == nAlignment ||
               // Note: Returns -1 if invalid, so this is good to use easily.
               GetAlignmentLawChaos(oCreator) == nAlignment)
            {
                // Dispel found
                bReturn = 2;

                // We try and dispel the spells effects
                nEffectCasterLevel = SMP_DispelGetCasterLevelOfSpell(nSpellId, oCreator);

                // DC is always 11 + nEffectCasterLevel
                nDC = 11 + nEffectCasterLevel;

                // Dispel!
                if(nCasterLevel + d20() >= nDC)
                {
                    // Remove all effects from the spell by oCreator
                    SMP_PRCRemoveSpellEffects(nSpellId, oCreator, oTarget, 0.1);
                    bReturn = TRUE;
                }
            }
        }
        eCheck = GetNextEffect(oTarget);
    }
    return bReturn;
}
// SMP_INC_DISPEL.
// Does a dispel check against oTarget for all effects from spells cast by
// Law/Chaos Alignment nAlignment.
// * Also the list will try any LawChaos spells of nAlignment
// * Returns TRUE if any are removed (for VFX's)
int SMP_DispelAllSpellFromLawChaosAlignment(object oTarget, int nCasterLevel, int nAlignment)
{
    int bReturn = FALSE;
    int nEffectCasterLevel, nSpellId, nDC;
    object oCreator;
    string sId;
    // Loop effects and try and dispel each one!
    effect eCheck = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eCheck))
    {
        // Magical subtype and must be from nSpellId.
        nSpellId = GetEffectSpellId(eCheck);
        sId = "SMP_ALIGNMENTDISPEL" + IntToString(nSpellId);
        oCreator = GetEffectCreator(eCheck);
        // We check if we have dispelled this spells' effect already
        // * Local will be either an alignment (>= 1), -1 for invalid alignment
        //   or -2 for "never dispel this effect". -2 will never match.
        if(GetAlignmentLawChaos(oCreator) == GetLocalInt(OBJECT_SELF, sId))
        {
            // Remove
            // * Note to self: could make it more complexe and, say, check the
            //   effect creator. Would need more complexe integers, however.
            // * We do, though, check the alignment of the spellcaster against
            //   the local, this is a partial check.
            RemoveEffect(oTarget, eCheck);
        }
        else if(nSpellId >= 0 &&
           GetEffectSubType(eCheck) == SUBTYPE_MAGICAL &&
           GetLocalInt(OBJECT_SELF, sId) != -2)
        {

            // Check alignment LAW/CHAOS
            if(SMP_ArrayGetSpellLawChaosAlignment(nSpellId) == nAlignment ||
               // Note: Returns -1 if invalid, so this is good to use easily.
               GetAlignmentLawChaos(oCreator) == nAlignment)
            {
                // We try and dispel the spells effects
                nEffectCasterLevel = SMP_DispelGetCasterLevelOfSpell(nSpellId, oCreator);

                // DC is always 11 + nEffectCasterLevel
                nDC = 11 + nEffectCasterLevel;

                // Dispel!
                if(nCasterLevel + d20() >= nDC)
                {
                    // Remove the effect!
                    RemoveEffect(oTarget, eCheck);
                    // NOTE:
                    // - Because we have dispelled this spell - other effects
                    // from this spell (like visuals) might still be present.
                    // This isn't the case when we check specific effects, but
                    // it is when we dispel all spells of nSpellId, from oTarget.

                    // This means I'll set a local variable to the caster (OBJECT_SELF)
                    // so it'll remove futher effects from nSpellId.

                    // GetAlignmentGoodEvil() is DISPEL ALL OTHERS
                    SetLocalInt(OBJECT_SELF, sId, GetAlignmentLawChaos(oCreator));
                    DelayCommand(1.0, DeleteLocalInt(OBJECT_SELF, sId));

                    bReturn = TRUE;
                }
                else
                {
                    // See above, but the dispel failed, so we set to NEVER
                    // remove futher effects from nSpellId.

                    // -2 is IGNORE ALL OTHERS
                    SetLocalInt(OBJECT_SELF, sId, -2);
                    DelayCommand(1.0, DeleteLocalInt(OBJECT_SELF, sId));
                }
            }
        }
        eCheck = GetNextEffect(oTarget);
    }
    return bReturn;
}

// SMP_INC_DISPEL.
// Get the caster level of nSpellId from oCaster. This will get the last caster level
// of the spell cast by oCaster of nSpellId.
// * Used in dispel functions.
// * If oCaster is invalid, it will use the Spell Level (Innate) + 1 / 2 to get the
//   minimum caster level for at least a half-decent DC
int SMP_DispelGetCasterLevelOfSpell(int nSpellId, object oCaster)
{
    int nReturn;
    if(GetIsObjectValid(oCaster))
    {
        // Get value stored SMP_inc_spellhook
        nReturn = GetLocalInt(oCaster, "SMP_SPELL_CAST_BY_LEVEL_" + IntToString(nSpellId));
    }
    else
    {
        // If oCaster is invalid, it will use the Spell Level (Innate) + 1 / 2 to
        // get the minimum caster level for at least a half-decent DC
        nReturn = (SMP_ArrayGetInteger(SMP_2DA_NAME_SPELLS, SMP_2DA_COLUMN_SPELLS_INNATE, nSpellId) + 1) / 2;
    }
    return nReturn;
}

// SMP_INC_DISPEL. Get the level of the spell, nSpellId, last cast by oCreator.
// * Use the innate level if the caster is invalid.
int SMP_DispelGetLevelOfSpell(int nSpellId, object oCaster)
{
    int nReturn;
    if(GetIsObjectValid(oCaster))
    {
        // Get value stored SMP_inc_spellhook
        nReturn = GetLocalInt(oCaster, "SMP_SPELL_CAST_SPELL_LEVEL" + IntToString(nSpellId));
    }
    else
    {
        // If oCaster is invalid, it will use the Spell Level (Innate)
        nReturn = SMP_ArrayGetInteger(SMP_2DA_NAME_SPELLS, SMP_2DA_COLUMN_SPELLS_INNATE, nSpellId);
    }
    return nReturn;
}

// SMP_INC_DISPEL.
// Does a dispel check against oTarget for all effects from spells which are of
// the spell school nSpellSchool.
// * If nLevelIfSpecial is over 0, and the effect is supernatural or extraodinary,
//   it will dispel it still if the spell's level is <= nLevelIfSpecial
// * Returns TRUE if any are removed (for VFX's)
int SMP_DispelAllSpellsFromSpellSchool(object oTarget, int nCasterLevel, int nSpellSchool, int nLevelIfSpecial = 0)
{
    int bReturn = FALSE;
    int nEffectCasterLevel, nSpellLevel, nSpellId, nDC;
    object oCreator;
    string sId;
    // Loop effects and try and dispel each one!
    effect eCheck = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eCheck))
    {
        // Magical subtype and must be from nSpellId.
        nSpellId = GetEffectSpellId(eCheck);
        sId = "SMP_SPELLSCHOOLDISPEL" + IntToString(nSpellId);
        oCreator = GetEffectCreator(eCheck);
        // We check if we have dispelled this spells' effect already
        // * Local will be either be 1, for dispel all spells of this spell ID,
        //   or -2 for "never dispel this effect". -2 will never match.
        if(GetLocalInt(OBJECT_SELF, sId) == TRUE)
        {
            // Remove
            // * Note to self: could make it more complexe and, say, check the
            //   effect creator. Would need more complexe integers, however.
            // * In this case (against the alignment thing) we don't check
            //   alignment.
            RemoveEffect(oTarget, eCheck);
        }
        else if(nSpellId >= 0 &&
           // Check spell school
           SMP_ArrayGetSpellSchool(nSpellId) == nSpellSchool &&
           // Special: If it isn't a magical subtype, we may still dispel
           // if the spells level is <= nLevelIfSpecial.
          (GetEffectSubType(eCheck) == SUBTYPE_MAGICAL ||
           // * NOTE: Using special function, will at least return innate column
           //         or the value, if present, set in the spell hook.
           SMP_DispelGetLevelOfSpell(nSpellId, oCreator) <= nLevelIfSpecial) &&
           GetLocalInt(OBJECT_SELF, sId) != -2)
        {
            // We try and dispel the spells effects
            nEffectCasterLevel = SMP_DispelGetCasterLevelOfSpell(nSpellId, oCreator);

            // DC is always 11 + nEffectCasterLevel
            nDC = 11 + nEffectCasterLevel;

            // Dispel!
            if(nCasterLevel + d20() >= nDC)
            {
                // Remove the effect!
                RemoveEffect(oTarget, eCheck);
                // NOTE:
                // - Because we have dispelled this spell - other effects
                // from this spell (like visuals) might still be present.
                // This isn't the case when we check specific effects, but
                // it is when we dispel all spells of nSpellId, from oTarget.

                // This means I'll set a local variable to the caster (OBJECT_SELF)
                // so it'll remove futher effects from nSpellId.

                // We use a mear TRUE value for this for now.
                SetLocalInt(OBJECT_SELF, sId, TRUE);
                DelayCommand(1.0, DeleteLocalInt(OBJECT_SELF, sId));

                bReturn = TRUE;
            }
            else
            {
                // -2 is IGNORE ALL OTHERS
                SetLocalInt(OBJECT_SELF, sId, -2);
                DelayCommand(1.0, DeleteLocalInt(OBJECT_SELF, sId));
            }
        }
        eCheck = GetNextEffect(oTarget);
    }
    return bReturn;
}

// SMP_INC_DISPEL. Returns an integer value of all the valid effects on oTarget.
// Used in "Best" dispel function.
int SMP_DispelCountEffectsOnTarget(object oTarget)
{
    int nReturn = 0;
    effect eCheck = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eCheck))
    {
        // Add one to effects found
        nReturn++;
        eCheck = GetNextEffect(oTarget);
    }
    // Return the amount
    return nReturn;
}


// End of file Debug lines. Uncomment below "/*" with "//" and compile.
/*
void main()
{
    return;
}
//*/
