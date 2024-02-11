/*:://////////////////////////////////////////////
//:: Name Spell Hook file
//:: FileName SMP_SpellHook
//:://////////////////////////////////////////////
//:: Notes
//:://////////////////////////////////////////////
    Spell hook file.

    This is executed on any PC casters who cast a spell with SMP_SpellHookCheck()
    at the beginning.

    This has all the things like Domain spells and stuff and everything.

    Affects PCs only.

    Its sets the local variable "SMP_SPELLHOOK_RETURN" to TRUE if the spellhook interrupts
    the spell.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPLLHOOK"
#include "SMP_INC_CRAFT"

// This returns bResult
// * FALSE and stops the rest of the spell firing.
// * TRUE and the rest of the spell fires normally.
void ReturnResult(int bResult);

void main()
{
    // Declare things we may, or may not use.
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    object oSpellItem = GetSpellCastItem();
    object oArea = GetArea(oCaster);
    int nCasterClass = GetLastSpellCastClass();
    int nSpellSaveDC = SMP_GetSpellSaveDC();
    int nRoll;
    string sMessage;

    // Check nSpellID
    int nSpellId = GetSpellId();
    // Note: Get master as appropriate too.
    // * Is this needed?
    // int nMasterSpell = GetMaster(nSpellId);

    // Get info from nSpellId
    string sName = SMP_ArrayGetSpellName(nSpellId);
    int nSpellLevel = SMP_ArrayGetSpellLevel(nSpellId, nCasterClass);

    // DEBUG MESSAGE
    SpeakString("Cast: " + sName + ". ID (Input): " + IntToString(nSpellId) + ". Target: " + GetName(oTarget) + ". Class: " + IntToString(nCasterClass));

    // We MUST set the caster level for this spell onto the caster, using nSpellID.
    int nCasterLevel = SMP_GetCasterLevel();
    SetLocalInt(oCaster, "SMP_SPELL_CAST_BY_LEVEL_" + IntToString(nSpellId), nCasterLevel);
    // We also must set the level of the spell cast
    SetLocalInt(oCaster, "SMP_SPELL_CAST_SPELL_LEVEL" + IntToString(nSpellId), nSpellLevel);
    // We also set the DC used, if we need it later.
    SetLocalInt(oCaster, "SMP_SPELL_CAST_SPELL_SAVEDC" + IntToString(nSpellId), nSpellSaveDC);
    // We also set the Metamagic used, if we need it later.
    int nMetaMagic = GetMetaMagicFeat();
    SetLocalInt(oCaster, "SMP_SPELL_CAST_SPELL_METAMAGIC" + IntToString(nSpellId), nMetaMagic);

/*:://////////////////////////////////////////////
    Section 1: Anything that should happen whenever a spell is attempted.
    ----------
    Basically, things which do not stop the spell from being cast, but
    will be activated even if the spell fails - it is the mear action of attempting
    to cast the spell (even if it is unsucessful) which this section uses.
//::////////////////////////////////////////////*/

    // Concentration for spells such as Black Blade of Disaster
    SMP_SpecialConcentrationChecks(oCaster);

    // Check for damage via. Spell Curse and Greater Spell curse.
    SMP_SpellCurseCheck(nSpellLevel, nCasterClass, oSpellItem, oCaster);


    // We may turn of Expertise. Bioware setting.
    if(SMP_SettingGetGlobal(SMP_SETTING_BIO_STOP_EXPERTISE_ABUSE) == TRUE)
    {
        SetActionMode(oCaster, ACTION_MODE_EXPERTISE, FALSE);
        SetActionMode(oCaster, ACTION_MODE_IMPROVED_EXPERTISE, FALSE);
    }

/*:://////////////////////////////////////////////
    Section 2: Stop if the spell hook catches something
    ----------
    If there is something that would stop the spell, such as, for example,
    wild magic, an invalid target, or a fail at a blink check, it is done here.

    The order is basically the "Damaging" parts first, and later, the checks
    for things like "Blink" and "Divine Focus".

    Uses, in each case, ReturnResult(FALSE); if it wants to stop the spell script
    from firing.
//::////////////////////////////////////////////*/

    // You can NOT cast a spell on another person or thing if you are in
    // "Meld into Stone"
    if(GetHasSpellEffect(SMP_SPELL_MELD_INTO_STONE, oCaster))
    {
        // Check the target
        if(oTarget != oCaster)
        {
            // Stop the casting
            FloatingTextStringOnCreature("*You cannot cast a spell onto anything but yourself if you are Melded into Stone*", oCaster, FALSE);
            ReturnResult(FALSE);
            return;
        }
    }

    // Cannot cast hostile spells (any) while in timestop.
    if(GetHasSpellEffect(SMP_SPELL_TIME_STOP, oCaster))
    {
        // Is it hositle?
        if(SMP_ArrayGetIsHostile(nSpellId))
        {
            // Stop the casting
            FloatingTextStringOnCreature("*You are unable to affect with hostile spells in timestop*", oCaster, FALSE);
            ReturnResult(FALSE);
            return;
        }
    }

    // Note:
    // - We automatically exit for all NPC's, only doing wild magic checks
    if(!GetIsPC(oCaster))
    {
        ReturnResult(SMP_WildMagicAreaSurge(oArea, oCaster));
        return;
    }

    // Make a check for explosive runes
    if(SMP_ExplosiveRunes())
    {
        ReturnResult(FALSE);
        return;
    }

    // Making sure they are not in time stop and casting spells against a target.
    if(GetIsObjectValid(oTarget) && oTarget != oCaster)
    {
        if(GetHasSpellEffect(SMP_SPELL_TIME_STOP, oCaster))
        {
            FloatingTextStringOnCreature("*You cannot cast spells against objects other then yourself under the effects of Time Stop*", oCaster, FALSE);
            ReturnResult(FALSE);
            return;
        }
    }

    // Divine Focus check
    // * Must have the correct alignment-orientated relic to power spells
    if(!SMP_DivineFocusCheck(sName))
    {
        ReturnResult(FALSE);
        return;
    }

    // Scroll casting
    if(!SMP_SpellScrollCastingCheck(nSpellId, nSpellLevel, oSpellItem, nCasterClass, oCaster))
    {
        ReturnResult(FALSE);
        return;
    }

    // Clerical divine domain spell Check
    // * Make sure a cleric isn't trying to cast 2 domain spells for one level.
    if(!SMP_DomainSpellCheck(nSpellId, oSpellItem, nCasterClass, oCaster))
    {
        ReturnResult(FALSE);
        return;
    }

    // Check use magical device
    // * Check UMD, if an item is being used to cast the spell with.
    if(!SMP_UMDCheck(sName, nSpellLevel, nSpellId))
    {
        ReturnResult(FALSE);
        return;
    }

    // Check breaking concentration incase normal hardcoded things where overriden
    // * Concentration from other sources:
    //   - Entanglement
    if(!SMP_BreakConcentrationCheck(nSpellLevel, oCaster))
    {
        // Failed: We do a special VFX to show it was concentration failure
        SMP_ApplyVFX(oCaster, EffectVisualEffect(SMP_VFX_FNF_SPELL_FAIL_HAND));
        ReturnResult(FALSE);
        return;
    }

    // We cannot have a sorceror or bard casting a quickened spell - we did
    // warn them its against the rules.
    if((nCasterClass == CLASS_TYPE_BARD ||
        nCasterClass == CLASS_TYPE_SORCERER) &&
        GetMetaMagicFeat() == METAMAGIC_QUICKEN)
    {
        SendMessageToPC(oCaster, "You cannot use the quicken metamagic feat with a bard or sorceror spell");
        ReturnResult(FALSE);
        return;
    }

    // Wild magic area + Effects.
    if(!SMP_WildMagicAreaSurge(oArea, oCaster))
    {
        ReturnResult(FALSE);
        return;
    }

    // Crafting checks
    if(SMP_CraftASpellOntoSomething(oCaster, nSpellId, nSpellLevel, nCasterClass, nCasterLevel, oTarget))
    {
        // Crafting checks are sucessful, stop the spell
        ReturnResult(FALSE);
        return;
    }

    // Spell components check.
    if(!SMP_SpellComponentsHookCheck(oCaster, nSpellId))
    {
        // Return FALSE, it failed as we do not have the components.
        ReturnResult(FALSE);
        return;
    }

    // Make sure Blink doesn't stop the spell from working (if it is a
    // single target spell!)
    if(GetIsObjectValid(oTarget) && GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
    {
        // Blink check
        if(!SMP_BlinkCheck(oTarget, oCaster))
        {
            // Stop if the roll fails.
            ReturnResult(FALSE);
            return;
        }
    }

    // NEED:
    // - Check for SEQUENCER ROBES!

    // Can this be cast on an item? Bioware for now...
//    if(Get2DAString("crafting 2da need this string completeing", "CastOnItems", GetSpellId()) != "1")
//    {
//        FloatingTextStrRefOnCreature(83453, OBJECT_SELF); // not cast spell on item
//        ReturnResult(FALSE);
//        return;
//    }

    // Return TRUE if we can cast the spell
    ReturnResult(TRUE);
}

// This returns bResult
// * FALSE and stops the rest of the spell firing.
// * TRUE and the rest of the spell fires normally.
void ReturnResult(int bResult)
{
    SMP_Debug("HOOK RESULT:" + IntToString(bResult));
    // Return value
    // FALSE - stops the spell
    // TRUE - fires the spell normally
    SetLocalInt(OBJECT_SELF, "SMP_SPELLHOOK_RETURN", bResult);
}
