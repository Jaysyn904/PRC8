/*:://////////////////////////////////////////////
//:: Name Spell Saves include
//:: FileName SMP_INC_SAVES
//:://////////////////////////////////////////////
    This includes all the spell save functions, for easy reference

    Things like Spell Craft, special save or whatnot can be used.

    It does, of course, have the default way of doing it too.

    There is a special save function for non-spells :-D

    Added a non-vfx version for some mass-save spells (thinking mords disjunktion
    and the items, mainly). The VFX shoulnd't be applied twice in one script, they
    don't really "overlap" and are unnoticable!
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//:: Created On: October
//::////////////////////////////////////////////*/

#include "SMP_INC_CONSTANT"
#include "SMP_INC_REMOVE"
#include "SMP_INC_ITEMPROP"

// SMP_INC_SAVES
// Required for spell saves. If they haven't got the diamond, the spell is lost
void SMP_RemoveProtectionSpellEffects(object oTarget);

// SMP_INC_SAVES - Returns the spell's Save DC, mainly using GetSpellSaveDC()
// (10 + spell level + relevant ability bonus).
// * Note: Sets the last save DC, from GetSpellId(), to ourselves each time.
int SMP_GetSpellSaveDC();

// SMP_INC_SAVES - Returns the caster level of oCaster, commonly OBJECT_SELF.
// * Wrappered so it can be changed at any time
// * Returns at least 1
// * Staffs, if activated, will return the default level - or the activating
//   classes level (if higher). Minimum of 1 again.
int SMP_GetCasterLevel(object oCaster = OBJECT_SELF);
// Gathers together the various bonuses for oCaster casting a spell, for thier
// caster level (such as Death Knell), but things which are not applied to the
// innate levels of spell casting items
int SMP_GetCasterLevelBonuses(object oCaster);

// SMP_INC_SAVES - Returns the metamagic that the spell will use.
// Wrapper for GetMetaMagicFeat();
// "Get the metamagic type (METAMAGIC_*) of the last spell cast by the caller
//  * Return value if the caster is not a valid object: -1"
int SMP_GetMetaMagicFeat();

// "Used to route the saving throws through this function to check for spell
// countering by a saving throw." - Bioware
// This uses most of the Bioware default commands and things.

// SMP_INC_SAVES
// Returns TRUE for a save, or immunity to nSaveType, or FALSE otherwise.
// - This will INCLUDE getting a result 2, IE: Immunity to nSaveType (EG: Mind save)
// - This does NOT include added effect VFX_IMP_DEATH for cirtain spells. Done in spell scripts.
// * Will check for undead/no con, and be immune if it is SAVING_THROW_FORT.
int SMP_SavingThrow(int nSavingThrow, object oTarget, int nDC, int nSaveType = SAVING_THROW_TYPE_NONE, object oSaveVersus = OBJECT_SELF, float fDelay = 0.0);

// SMP_INC_SAVES
// No VFX version of SMP_SavingThrow(). Same return values:
// * Returns TRUE for a save, or immunity to nSaveType, or FALSE otherwise.
// * No VFX means no delay is required for this function to operate.
int SMP_SavingThrowNoVFX(int nSavingThrow, object oTarget, int nDC, int nSaveType = SAVING_THROW_TYPE_NONE, object oSaveVersus = OBJECT_SELF);

// Will adjust nDam as if oTarget has evasion feats, and also depending on
// nResult.
// * Will half nDam as normal if nResult is passed.
// * Uses FEAT_EVASION and FEAT_IMPROVED_EVASION
int SMP_ReflexAdjustDamage(int nResult, int nDam, object oTarget);

// SMP_INC_SAVES - Monster non-spell ability save.
// - Uses     SAVING_THROW_WILL, SAVING_THROW_REFLEX, SAVING_THROW_FORT.
// functions: WillSave           ReflexSave           FortitudeSave.
int SMP_NotSpellSavingThrow(int nSavingThrow, object oTarget, int nDC, int nSaveType = SAVING_THROW_TYPE_NONE, object oSaveVersus = OBJECT_SELF, float fDelay = 0.0);

// SMP_INC_SAVES
// Similar to GetReflexAdjustedDamage. It uses the 3 save types.
// Normally halfs damave. Relfex saves are adjusted for extra evasion ETC.
// Cirtain spells provide extra protection against attacks.
// (Note: Do not use for monster spells)
// * Will check for undead/no con, and be immune if it is SAVING_THROW_FORT.
int SMP_GetAdjustedDamage(int nSavingThrow, int nDamage, object oTarget, int nDC, int nSaveType=SAVING_THROW_TYPE_NONE, object oSaveVersus=OBJECT_SELF, float fDelay = 0.0);

// SMP_INC_SAVES. This will return a damage amount.
// - If oTarget is not a creature, it will half nDamage (can be 0).
// - This is used to be closer to PHB - all elemental damage only does half to non-creatures.
// - It also removes an amout set to SMP_ELEMENTAL_RESISTANCE, if oTarget has any.
int SMP_GetElementalDamage(int nDamage, object oTarget);

// SMP_INC_SAVES. This is used for any Hold Person/Monster/Mass ETC. spell, and
// is the "each round do a will save to remove paralysis".
void SMP_HoldWillSave(object oTarget, object oCaster, int nSpellId, int nCastTimes, int nSpellSaveDC);

// SMP_INC_SAVES. This is used for any Hold Person/Monster/Mass ETC. spell, and
// is the "each round do a will save to remove paralysis". This is called from
// the spell script and calls SMP_HoldWillSave() in a 6 second delay.
void SMP_HoldWillSaveStart(object oTarget, object oCaster, int nSpellId, int nSpellSaveDC);


// Required for spell saves. If they haven't got the diamond, the spell is lost
void SMP_RemoveProtectionSpellEffects(object oTarget)
{
    effect eCheck = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eCheck))
    {
        // Check spell
        if(GetEffectSpellId(eCheck) == SMP_SPELL_PROTECTION_FROM_SPELLS)
        {
            RemoveEffect(oTarget, eCheck);
        }
    }
}

// Returns the spell's Save DC, mainly using GetSpellSaveDC()
// (10 + spell level + relevant ability bonus).
// * Note: Sets the last save DC, from GetSpellId(), to ourselves each time.
int SMP_GetSpellSaveDC()
{
    // Get the spell save Dc
    int nDC = GetSpellSaveDC();

    // Get spell Id, set to local if needed later somehow.
    SetLocalInt(OBJECT_SELF, "SMP_LAST_SAVE_DC_" + IntToString(GetSpellId()), nDC);

    return GetSpellSaveDC();
}

// Returns the caster level of oCaster, commonly OBJECT_SELF.
// - Wrappered so it can be changed at any time
// * Staffs, if activated, will return the default level - or the activating
//   classes level (if higher). Minimum of 1 again.
int SMP_GetCasterLevel(object oCaster = OBJECT_SELF)
{
    int nReturn = GetCasterLevel(oCaster);
    // Error checking
    if(nReturn < 0)
    {
        nReturn = 1;
    }

    // Check for caster level for staffs
    object oItem = GetSpellCastItem();
    if(GetIsObjectValid(oItem))
    {
        if(GetBaseItemType(oItem) == BASE_ITEM_MAGICSTAFF)
        {
            // Check the activators caster level
            int nActivatorLevel = SMP_SpellItemHighestLevelActivator(oItem, oCaster);
            // Is it valid?
            if(nActivatorLevel > 0)
            {
                // Add bonuses to this level
                nActivatorLevel += SMP_GetCasterLevelBonuses(oCaster);
                if(nActivatorLevel > nReturn)
                {
                    // Use this level.
                    nReturn = nActivatorLevel;
                }
            }
        }
    }
    // Not cast from an item. Add on bonuses
    else
    {
        nReturn += SMP_GetCasterLevelBonuses(oCaster);
    }
    return nReturn;
}

// Gathers together the various bonuses for oCaster casting a spell, for thier
// caster level (such as Death Knell), but things which are not applied to the
// innate levels of spell casting items
int SMP_GetCasterLevelBonuses(object oCaster)
{
    // can return 0.
    int nReturn = 0;

    // If we have Death Knell, we get +1 effective caster level!
    if(GetHasSpellEffect(SMP_SPELL_DEATH_KNELL, oCaster))
    {
        nReturn++;
    }

    return nReturn;
}

// Returns the metamagic that the spell will use.
// Wrapper for GetMetaMagicFeat();
// "Get the metamagic type (METAMAGIC_*) of the last spell cast by the caller
//  * Return value if the caster is not a valid object: -1"
int SMP_GetMetaMagicFeat()
{
    return GetMetaMagicFeat();
}

// "Used to route the saving throws through this function to check for spell
// countering by a saving throw." - Bioware
// This uses most of the Bioware default commands and things.
// - Uses FortitudeSave, ReflexSave and WillSave.
// - This will INCLUDE spell resistance (Getting a 2 on the functions above)
// - This does NOT include added effect VFX_IMP_DEATH for cirtain spells. Done in spell scripts.
int SMP_SavingThrow(int nSavingThrow, object oTarget, int nDC, int nSaveType = SAVING_THROW_TYPE_NONE, object oSaveVersus = OBJECT_SELF, float fDelay = 0.0)
{
    // Change the DC based on spell effects, and spell-resisting things.
    int nNewDC = nDC;

    // Hardiness VS spells is +2 VS all SPELLS ONLY.
//    if(GetHasFeat(FEAT_HARDINESS_VERSUS_SPELLS, oTarget))
//    {
//        nNewDC -= 2;
//    }
    // Protection VS spells is +8 VS all SPELLS ONLY.
    if(GetHasSpellEffect(SMP_SPELL_PROTECTION_FROM_SPELLS, oTarget))
    {
        // Check item
        if(GetIsObjectValid(GetLocalObject(oTarget, SMP_STORED_PROT_SPELLS_ITEM)))
        {
            nNewDC -= 8;
        }
        else
        {
            // Remove effects of the spell
            SMP_RemoveProtectionSpellEffects(oTarget);
        }
    }
    // Spellcraft adds +1 VS spells, per 5 ranks in the craft
//    nNewDC -= GetSkillRank(SKILL_SPELLCRAFT, oTarget) / 5;

    // We take of or even add 25 to the save DC depending on the target
    // and the status of Moment of Presence.
    if(GetHasSpellEffect(SMP_SPELL_MOMENT_OF_PRESCIENCE, oTarget) &&
       SMP_GetLocalSpellSetting(oTarget, SMP_SPELL_MOMENT_OF_PRESCIENCE) == 1)
    {
        // Remove effects (and integer?)
        SMP_RemoveSpellEffectsFromTarget(SMP_SPELL_MOMENT_OF_PRESCIENCE, oTarget);
        // Take off 25 DC
        nNewDC -= 25;
    }
    // oCaster, add 25DC
    if(GetHasSpellEffect(SMP_SPELL_MOMENT_OF_PRESCIENCE, oSaveVersus) &&
       SMP_GetLocalSpellSetting(oTarget, SMP_SPELL_MOMENT_OF_PRESCIENCE) == 2)
    {
        // Remove effects (and integer?)
        SMP_RemoveSpellEffectsFromTarget(SMP_SPELL_MOMENT_OF_PRESCIENCE, oSaveVersus);
        // Add 25 DC
        nNewDC += 25;
    }

    // Min DC of 1.
    if(nNewDC < 1)
    {
        nNewDC = 1;
    }

    // Declare things
    effect eVis;
    int bValid = FALSE;
    // Fortitude saving throw
    if(nSavingThrow == SAVING_THROW_FORT)
    {
        bValid = FortitudeSave(oTarget, nNewDC, nSaveType, oSaveVersus);
        if(bValid == 1)
        {
            eVis = EffectVisualEffect(VFX_IMP_FORTITUDE_SAVING_THROW_USE);
        }
    }
    // Reflex saving throw
    else if(nSavingThrow == SAVING_THROW_REFLEX)
    {
        bValid = ReflexSave(oTarget, nNewDC, nSaveType, oSaveVersus);
        if(bValid == 1)
        {
            eVis = EffectVisualEffect(VFX_IMP_REFLEX_SAVE_THROW_USE);
        }
    }
    // Will saving throw
    else if(nSavingThrow == SAVING_THROW_WILL)
    {
        bValid = WillSave(oTarget, nNewDC, nSaveType, oSaveVersus);
        if(bValid == 1)
        {
            eVis = EffectVisualEffect(VFX_IMP_WILL_SAVING_THROW_USE);
        }
    }
    /* No error checking (keeps it fast) we'd know anyway of errors!

       Finally:
        return 0 = FAILED SAVE
        return 1 = SAVE SUCCESSFUL
        return 2 = IMMUNE TO WHAT WAS BEING SAVED AGAINST
    */

    // Spell immunity/resistance to save. (EG: Mind spell save type, immunity to mind spells)
    if(bValid == 2)
    {
        eVis = EffectVisualEffect(VFX_IMP_MAGIC_RESISTANCE_USE);
    }
    // If we save OR have immunity...
    if(bValid == 1 || bValid == 2)
    {
        /*
        OLD Bioware -
        if(bValid == 2)
        {
        If the spell is save immune then the link must be applied in order to get
        the true immunity to be resisted.  That is the reason for returing false
        and not true.  True blocks the application of effects.

            bValid = FALSE;
        }

        NEW: Me. Removed the above line. If saves, it saves!

        Me - This makes VERY little sense...not sure...Need testing.

        Ok, it breaks down like this:

        - We put in "SAVING_THROW_TYPE_POISON", and Bioware expects we'll apply
          EffectPoison() to the target!
          - If they do not have EffectPoison() put onto them, then the spell
            basically apply the effect all the time if they are immune to it (EG:
            some Con damage which is a poison save)
          - However, it works fine (and does a correct relay message) if it
            IS EffectPoison().
        - We put in some and it'll never be immune, so this doesn't apply.

        We can be immune:
            SAVING_THROW_TYPE_DEATH - By - IMMUNITY_TYPE_DEATH
            SAVING_THROW_TYPE_DISEASE - By - IMMUNITY_TYPE_DISEASE
            SAVING_THROW_TYPE_FEAR - By - IMMUNITY_TYPE_FEAR
            SAVING_THROW_TYPE_MIND_SPELLS - By - IMMUNITY_TYPE_MIND_SPELLS
            SAVING_THROW_TYPE_POISON - By - IMMUNITY_TYPE_POISON
            SAVING_THROW_TYPE_TRAP - By - IMMUNITY_TYPE_TRAP

        Ones which can't be immune to anyway:
            SAVING_THROW_TYPE_ACID
            SAVING_THROW_TYPE_ALL
            SAVING_THROW_TYPE_CHAOS
            SAVING_THROW_TYPE_COLD
            SAVING_THROW_TYPE_DIVINE
            SAVING_THROW_TYPE_ELECTRICITY
            SAVING_THROW_TYPE_EVIL
            SAVING_THROW_TYPE_FIRE
            SAVING_THROW_TYPE_GOOD
            SAVING_THROW_TYPE_LAW
            SAVING_THROW_TYPE_NEGATIVE
            SAVING_THROW_TYPE_NONE (duh)
            SAVING_THROW_TYPE_POSITIVE
            SAVING_THROW_TYPE_SONIC
            SAVING_THROW_TYPE_SPELL

        My changes:
         - It will TRUE as if they had saved normally against the effects.
            - Still does correct effect
            - Will need to test, of course
         - Can use ImmunityCheck() or something to check immunties anyway.
        */
        if(bValid == 2)
        {
            bValid = 1;
        }
        // Apply the visual
        if(fDelay > 0.0)
        {
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
        }
        else
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        }
    }
    return bValid;
}
// SMP_INC_SAVES
// No VFX version of SMP_SavingThrow(). Same return values:
// * Returns TRUE for a save, or immunity to nSaveType, or FALSE otherwise.
// * No VFX means no delay is required for this function to operate.
int SMP_SavingThrowNoVFX(int nSavingThrow, object oTarget, int nDC, int nSaveType = SAVING_THROW_TYPE_NONE, object oSaveVersus = OBJECT_SELF)
{
    // Change the DC based on spell effects, and spell-resisting things.
    int nNewDC = nDC;

    // Hardiness VS spells is +2 VS all SPELLS ONLY.
//    if(GetHasFeat(FEAT_HARDINESS_VERSUS_SPELLS, oTarget))
//    {
//        nNewDC -= 2;
//    }
    // Protection VS spells is +8 VS all SPELLS ONLY.
    if(GetHasSpellEffect(SMP_SPELL_PROTECTION_FROM_SPELLS, oTarget))
    {
        // Check item
        if(GetIsObjectValid(GetLocalObject(oTarget, SMP_STORED_PROT_SPELLS_ITEM)))
        {
            nNewDC -= 8;
        }
        else
        {
            // Remove effects of the spell
            SMP_RemoveProtectionSpellEffects(oTarget);
        }
    }
    // Spellcraft adds +1 VS spells, per 5 ranks in the craft
//    nNewDC -= GetSkillRank(SKILL_SPELLCRAFT, oTarget) / 5;

    // We take of or even add 25 to the save DC depending on the target
    // and the status of Moment of Presence.
    if(GetHasSpellEffect(SMP_SPELL_MOMENT_OF_PRESCIENCE, oTarget) &&
       SMP_GetLocalSpellSetting(oTarget, SMP_SPELL_MOMENT_OF_PRESCIENCE) == 1)
    {
        // Remove effects (and integer?)
        SMP_RemoveSpellEffectsFromTarget(SMP_SPELL_MOMENT_OF_PRESCIENCE, oTarget);
        // Take off 25 DC
        nNewDC -= 25;
    }
    // oCaster, add 25DC
    if(GetHasSpellEffect(SMP_SPELL_MOMENT_OF_PRESCIENCE, oSaveVersus) &&
       SMP_GetLocalSpellSetting(oTarget, SMP_SPELL_MOMENT_OF_PRESCIENCE) == 2)
    {
        // Remove effects (and integer?)
        SMP_RemoveSpellEffectsFromTarget(SMP_SPELL_MOMENT_OF_PRESCIENCE, oSaveVersus);
        // Add 25 DC
        nNewDC += 25;
    }

    // Min DC of 1.
    if(nNewDC < 1)
    {
        nNewDC = 1;
    }

    // Declare things
    int bValid = FALSE;
    // Fortitude saving throw
    if(nSavingThrow == SAVING_THROW_FORT)
    {
        bValid = FortitudeSave(oTarget, nNewDC, nSaveType, oSaveVersus);
    }
    // Reflex saving throw
    else if(nSavingThrow == SAVING_THROW_REFLEX)
    {
        bValid = ReflexSave(oTarget, nNewDC, nSaveType, oSaveVersus);
    }
    // Will saving throw
    else if(nSavingThrow == SAVING_THROW_WILL)
    {
        bValid = WillSave(oTarget, nNewDC, nSaveType, oSaveVersus);
    }
    /* No error checking (keeps it fast) we'd know anyway of errors!

       Finally:
        return 0 = FAILED SAVE
        return 1 = SAVE SUCCESSFUL
        return 2 = IMMUNE TO WHAT WAS BEING SAVED AGAINST
    */

    /*
        My changes:
         - It will TRUE as if they had saved normally against the effects.
            - Still does correct effect
            - Will need to test, of course
         - Can use ImmunityCheck() or something to check immunties anyway.
    */
    if(bValid == 2)
    {
        bValid = 1;
    }
    return bValid;
}


// Will adjust nDam as if oTarget has evasion feats, and also depending on
// nResult.
// * Will half nDam as normal if nResult is passed.
// * Uses FEAT_EVASION and FEAT_IMPROVED_EVASION
int SMP_ReflexAdjustDamage(int nResult, int nDam, object oTarget)
{
    // Change on Evasion, Improved Evasion and so on.
    if(nResult)
    {
        // Saved - half damage (or none with evasion)
        if(GetHasFeat(FEAT_EVASION, oTarget) ||
           GetHasFeat(FEAT_IMPROVED_EVASION, oTarget))
        {
            // None with evasions of any kind
            nDam = 0;
        }
        else
        {
            // Else half damage anyway
            nDam /= 2;
        }
    }
    // Improved evasion always gives half damage
    else if(GetHasFeat(FEAT_IMPROVED_EVASION, oTarget))
    {
        nDam /= 2;
    }
    return nDam;
}

// Monster non-spell ability save.
// - Uses     SAVING_THROW_WILL, SAVING_THROW_REFLEX, SAVING_THROW_FORT.
// functions: WillSave           ReflexSave           FortitudeSave.
int SMP_NotSpellSavingThrow(int nSavingThrow, object oTarget, int nDC, int nSaveType = SAVING_THROW_TYPE_NONE, object oSaveVersus = OBJECT_SELF, float fDelay = 0.0)
{
    // This does not decrease the save if there are things like Protection from
    // Spells.
    // Declare things
    effect eVis;
    int bValid = FALSE;
    // Fortitude saving throw
    if(nSavingThrow == SAVING_THROW_FORT)
    {
        bValid = FortitudeSave(oTarget, nDC, nSaveType, oSaveVersus);
        if(bValid == 1)
        {
            eVis = EffectVisualEffect(VFX_IMP_FORTITUDE_SAVING_THROW_USE);
        }
    }
    // Reflex saving throw
    else if(nSavingThrow == SAVING_THROW_REFLEX)
    {
        bValid = ReflexSave(oTarget, nDC, nSaveType, oSaveVersus);
        if(bValid == 1)
        {
            eVis = EffectVisualEffect(VFX_IMP_REFLEX_SAVE_THROW_USE);
        }
    }
    // Will saving throw
    else if(nSavingThrow == SAVING_THROW_WILL)
    {
        bValid = WillSave(oTarget, nDC, nSaveType, oSaveVersus);
        if(bValid == 1)
        {
            eVis = EffectVisualEffect(VFX_IMP_WILL_SAVING_THROW_USE);
        }
    }
    /* No error checking (keeps it fast) we'd know anyway of errors!

       Finally:
        return 0 = FAILED SAVE
        return 1 = SAVE SUCCESSFUL
        return 2 = IMMUNE TO WHAT WAS BEING SAVED AGAINST

        We ignore 2, and say it is 0.
    */
    // If 2, ignore
    if(bValid == 2)
    {
        bValid = 0;
    }
    // If we save, apply save effect.
    else if(bValid == 1)
    {
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
    }
    return bValid;
}

// Similar to GetReflexAdjustedDamage. It uses the 3 save types.
// Normally halfs damave. Relfex saves are adjusted for extra evasion ETC.
// Cirtain spells provide extra protection against attacks.
// (Note: Do not use for monster spells)
int SMP_GetAdjustedDamage(int nSavingThrow, int nDamage, object oTarget, int nDC, int nSaveType=SAVING_THROW_TYPE_NONE, object oSaveVersus=OBJECT_SELF, float fDelay = 0.0)
{
    int nReturn, nSave;
    nReturn = nDamage;
    if(nSavingThrow == SAVING_THROW_REFLEX)
    {
        // Default for now
        nReturn = GetReflexAdjustedDamage(nDamage, oTarget, nDC, nSaveType, oSaveVersus);

        // Do reflex saving throw visual if we saved or have full evasion at least
        if(nReturn < nDamage)
        {
            effect eVis = EffectVisualEffect(VFX_IMP_REFLEX_SAVE_THROW_USE);
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
        }
    }
    else
    {
        // Do a will saving throw.
        // This has the approprate visuals.
        nSave = SMP_SavingThrow(nSavingThrow, oTarget, nDC, nSaveType, oSaveVersus, fDelay);
    }
    // Saving throw, if sucessful, at least halves damage.
    if(nSave || nReturn < nDamage)
    {
        // Warm Shield, on a sucessful save, does no damage, if cold damage.
        // Chill shield, on a sucessful save, does no damage if fire damage.
        if((nSaveType == SAVING_THROW_TYPE_COLD &&
            GetHasSpellEffect(SMP_SPELL_FIRE_SHIELD_WARM)) ||
           (nSaveType == SAVING_THROW_TYPE_FIRE &&
            GetHasSpellEffect(SMP_SPELL_FIRE_SHIELD_CHILL)))
        {
            nReturn = 0;
        }
        else if(nSavingThrow != SAVING_THROW_REFLEX)
        {
            nReturn /= 2;
        }
    }
    // any "half immunities" can be done via. Effects, IE: EffectDamageImmunityIncrease.
    // Its only important if we need to return 0 damage from a sucessful save.
    return nReturn;
}


// This will return a damage amount.
// - If oTarget is not a creature, it will half nDamage (can be 0).
// - This is used to be closer to PHB - all elemental damage only does half to non-creatures.
// - It also removes an amout set to SMP_ELEMENTAL_RESISTANCE, if oTarget has any.
int SMP_GetElementalDamage(int nDamage, object oTarget)
{
    int nReturn = nDamage;

    if(GetObjectType(oTarget) != OBJECT_TYPE_CREATURE)
    {
        nReturn /= 2;
    }
    // It also gets rid of X amount - hardyness to elemental damage.
    // - Set to SMP_ELEMENTAL_RESISTANCE
    nReturn -= GetLocalInt(oTarget, "SMP_ELEMENTAL_RESISTANCE");

    return nReturn;
}

// SMP_INC_SAVES. This is used for any Hold Person/Monster/Mass ETC. spell, and
// is the "each round do a will save to remove paralysis".
void SMP_HoldWillSave(object oTarget, object oCaster, int nSpellId, int nCastTimes, int nSpellSaveDC)
{
    // Check if they have the spell still
    if(GetHasSpellEffect(nSpellId, oTarget) &&
       GetLocalInt(oTarget, "SMP_HOLD_CASTTIMES" + IntToString(nSpellId)) == nCastTimes)
    {
        // Make the will save
        if(SMP_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_MIND_SPELLS, oCaster))
        {
            // Remove the effects
            SMP_RemoveSpellEffectsFromTarget(nSpellId, oTarget);
        }
        else
        {
            // Fail, 6 second delay
            DelayCommand(6.0, SMP_HoldWillSave(oTarget, oCaster, nSpellId, nCastTimes, nSpellSaveDC));
        }
    }
}

// SMP_INC_SAVES. This is used for any Hold Person/Monster/Mass ETC. spell, and
// is the "each round do a will save to remove paralysis". This is called from
// the spell script and calls SMP_HoldWillSave() in a 6 second delay.
void SMP_HoldWillSaveStart(object oTarget, object oCaster, int nSpellId, int nSpellSaveDC)
{
    string sName = "SMP_HOLD_CASTTIMES" + IntToString(nSpellId);
    // Get old
    int nCastTimes = GetLocalInt(oTarget, sName);
    // Add 1
    nCastTimes++;
    // Set new
    SetLocalInt(oTarget, sName, nCastTimes);

    DelayCommand(6.0, SMP_HoldWillSave(oTarget, oCaster, nSpellId, nCastTimes, nSpellSaveDC));
}

// End of file Debug lines. Uncomment below "/*" with "//" and compile.
/*
void main()
{
    return;
}
//*/
