/*:://////////////////////////////////////////////
//:: Name Spell Resistance, spell immunity checking Include
//:: FileName SMP_INC_RESIST
//:://////////////////////////////////////////////
    This includes all in one functions for:

    - Spell resistance only
        - SR: 1d20 + Caster Level >= Enemy SR
        - Magic Immunity: "EffectSpellImmunity(nSpellId)", and Globes
        - Absorbsion: EffectSpellLevelAbsorption(Y, X), X >= 1.
    - Total immunity to all spells/magic
    - Total immunity to general effects
    - Immunity check against XXX effect.


    All 3 DO include Mantals, ONLY because they are ONLY used for Globes and
    the like (Are basically an unlimited version of them).

    We use:

    // Do a Spell Resistance check between oCaster and oTarget, returning TRUE if
    // the spell was resisted.
    // * Return value if oCaster or oTarget is an invalid object: FALSE
    // * Return value if spell cast is not a player spell: - 1
    // * Return value if spell resisted: 1
    // * Return value if spell resisted via magic immunity: 2
    // * Return value if spell resisted via spell absorption: 3
    int ResistSpell(object oCaster, object oTarget)

    Remeber:
    - Cannot be used for none-player spells (not that any of these apply for them)
    - Using invalid caster objects (IE: Dead, destroyed) ignore spell resistance
      and so on, normally applicable for area of effects.
    - The order is crap. Basically, don't use anything but SMP_SpellResistanceCheck,
      which is the default one.

    NOTE: 19 April

    - Added in a check for point-blank spell immunity and general everything immunity.
      - Spell immunity includes the check for everything immunity
      - The general everything immunity should be used for non-spells.
    - That is so that Magical Force spells cannot be affected by any kind of
      magical bonuses or penalties.
    Functions:
    SMP_GeneralEverythingImmunity().
    SMP_AllSpellsImmunity().

    NOTE: 19 July

    - Added in Spellguard thing in SMP_SpellResistanceCheck(), simple really. See
      the spell description.

    Note: 23rd september

    - Wish needed a resist spell check, but it only requires Spell Resistance
      and immunity by level checks anyway. These can be done by checking the
      hide of the creature, the plot status (as normal) and GetSpellResistance().

    Note: 31 January
    - Added in the Get Can Hear/See checks to this file, so abilties can use it
    - They are resistances basically anyway
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//:: Created On: October
//::////////////////////////////////////////////*/

#include "SMP_INC_ARRAY"
#include "SMP_INC_CONSTANT"
// For SMP_GetHasEffect()
#include "SMP_INC_REMOVE"

// IMMUNITY: All Spells.
const string SMP_SPELL_IMMUNITY_ALL = "SMP_SPELL_IMMUNITY_ALL";
// IMMUNITY: Everything! Overrides above. Also valid when plot flag is on.
const string SMP_SPELL_ALL_EFFECTS_IMMUNE = "SMP_SPELL_ALL_EFFECTS_IMMUNE";

// SMP_INC_RESIST. Do a Spell Resistance and immunity check. TRUE if they resist the spell.
// - Most use this.
// - Checks spell resistance, Globes, and Spell Immunity.
//   - EffectSpellImmunity, EffectSpellResistanceIncrease, EffectSpellLevelAbsorption.
// * Only returns TRUE or FALSE.
int SMP_SpellResistanceCheck(object oCaster, object oTarget, float fDelay = 0.0);
// SMP_INC_RESIST. Do a Spell Resistance check. TRUE if they resist the spell.
// - We check Spell Resistance, but not Immunity or Globes
//int SMP_SpellResistanceOnlyCheck(object oCaster, object oTarget, float fDelay = 0.0);
// SMP_INC_RESIST. Do a Spell Immunity check. TRUE if they resist the spell.
//   BIG NOTE: THIS MIGHT NOT BE NEEDED. Any spell which doesn't allow SR will not
//   allow any immunity to the spell, or shouldn't. Also, SMP_TotalSpellImmunity()
//   is in every spell anyway.
// - We check Immunity and Globes, but not Spell Resistance
//int SMP_SpellImmunityCheck(object oCaster, object oTarget, float fDelay = 0.0);

// SMP_INC_RESIST. Check if they should be affected by any EFFECTS (Not
// anything specific, nor only limited to spells). "Magical Force" beings,
// and spell effects will have this return TRUE.
// * TRUE - If they should have no effects affecting them
// * FALSE - If they are normal.
// Called in all files for all targets, normally though TotalSpellImmunity()
int SMP_TotalEverythingImmunity(object oTarget);

// SMP_INC_RESIST. Check if they should be affected by any SPELLS
// This is really to stop damaging spells, but can be used to script in things
// for specific monsters.
// * Note that EffectSpellLevelAbsorption() is NOT the same. This affects FRIENDLY
//   spells as well as HOSTILE spells!
// * TRUE - If they should have no spells affecting them
// * FALSE - If they are normal.
// Called in all spell files for all targets. Also calls SMP_TotalEverythingImmunity().
// * Called form all ResistSpell() using functions in SMP_INC_RESIST
int SMP_TotalSpellImmunity(object oTarget);

// SMP_INC_RESIST
// Checks GetIsImmune(oTarget, nImmunityType), and will apply a special visual
// if TRUE.
// * If TRUE, immune to nImmunityType.
// * Note: Should use for all SAVING_THROW_TYPE_XXX immunity checks, before
//   the saving throw. This displays a message similar to that of just applying
//   the effect (like Charm effect) and they are immune.
// * oCaster - The spellcaster (see GetIsImmune parameters) for Racial type ETC checks.
int SMP_ImmunityCheck(object oTarget, int nImmunityType, float fDelay = 0.0, object oCaster = OBJECT_SELF);

// SMP_INC_RESIST. This will do a simplified spell resistance check. It will
// return TRUE if they passed, and the spell shouldn't affect them.
// * Note: Requires a level input!
// * Note 2: Use oCaster for relay information.
int SMP_SpellResistanceManualCheck(object oCaster, object oTarget, int nCasterLevel, int nSpellLevel, float fDelay = 0.0);

// SMP_INC_RESIST. Returns TRUE if oTarget can see.
// - Is not blinded
// - Is not a creature with no eyes
// - Local variable also allowed for "I have no eyes"
int SMP_GetCanSee(object oTarget);
// SMP_INC_RESIST. Returns TRUE if oTarget can hear.
// - Is not deafened or silenced (sound doesn't pass through silence!)
// - Is not a creature with no ears
// - Local variable also allowed for "I have no ears"
int SMP_GetCanHear(object oTarget);

// Do a Spell Resistance and immunity check. TRUE if they resist the spell.
// - Most use this.
// - Checks spell resistance, Globes, and Spell Immunity.
//   - EffectSpellImmunity, EffectSpellResistanceIncrease, EffectSpellLevelAbsorption.
int SMP_SpellResistanceCheck(object oCaster, object oTarget, float fDelay = 0.0)
{
    // Total effect immunity check (Includes spell immunity check)
    if(SMP_TotalSpellImmunity(oTarget))
    {
        return TRUE;
    }
    // We do this for any flying projectiles to hit a barrier.
    if(fDelay > 0.5)
    {
        fDelay -= 0.1;
    }
    // Change: 12 August. Moved the effect declarations into each seperate result
    // to make it work a tiny bit faster.
    // Also changed to a swtich() statement, cause it looks cool, ya know.
    switch(ResistSpell(oCaster, oTarget))
    {
        // Resisted: 1 (Spell Resistance)
        case 1:
        {
            effect eSR = EffectVisualEffect(VFX_IMP_MAGIC_RESISTANCE_USE);
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eSR, oTarget));
            return TRUE;
        }
        break;
        // Resisted via magic immunity: 2 (Globe, ETC - EffectSpellLevelAbsorption with no limit)
        case 2:
        {
            effect eGlobe = EffectVisualEffect(VFX_IMP_GLOBE_USE);
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eGlobe, oTarget));
            return TRUE;

        }
        break;
        // Resisted via spell absorption: 3 (Spell Mantle ETC - EffectSpellLevelAbsorption with a limit)
        case 3:
        {
            // More delay off. Improves how it looks.
            if(fDelay > 0.5)
            {
                fDelay -= 0.1;
            }
            effect eMantle = EffectVisualEffect(VFX_IMP_SPELL_MANTLE_USE);
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eMantle, oTarget));
            return TRUE;
        }
        break;
        // Not resisted
        default:
        {
            // Spellguard's effects
            if(GetHasSpellEffect(SMP_SPELL_SPELLGUARD, oTarget))
            {
                // Check spellcraft against the set DC, caster level + ability bonus
                int nDC = GetLocalInt(oTarget, "SMP_SPELL_SPELLGUARD_DC");

                // Check spellcraft against it
                if(!GetIsSkillSuccessful(oCaster, SKILL_SPELLCRAFT, nDC))
                {
                    // Complete message for failed
                    string sMessage = "<cRGB>" + GetName(oTarget) + " : <c GB>Resisted Spell via. Spellguard ";
                    // Check if in our own AOE.
                    if(oTarget != oCaster)
                    {
                        // Send to self, the caster
                        SendMessageToPC(oCaster, sMessage);
                    }
                    // Send to the target
                    SendMessageToPC(oTarget, sMessage);

                    // Failed to penetrate
                    effect eSpellguard = EffectVisualEffect(VFX_IMP_SPELL_MANTLE_USE);
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eSpellguard, oTarget));
                    return TRUE;
                }
            }
        }
        break;
    }
    // Defualt: Nothing stopped the spell
    return FALSE;
}
/*
// Do a Spell Resistance check. TRUE if they resist the spell.
// - We check Spell Resistance, but not Immunity or Globes
int SMP_SpellResistanceOnlyCheck(object oCaster, object oTarget, float fDelay = 0.0)
{
    // Total effect immunity check (Includes spell immunity check)
    if(SMP_TotalSpellImmunity(oTarget))
    {
        return TRUE;;
    }
    // We do this for any flying projectiles to hit a barrier.
    if(fDelay > 0.5)
    {
        fDelay -= 0.1;
    }
    int nResist = ResistSpell(oCaster, oTarget);
    effect eSR = EffectVisualEffect(VFX_IMP_MAGIC_RESISTANCE_USE);
    if(nResist == 1) //Spell Resistance - only one to check for
    {
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eSR, oTarget));
        return TRUE;
    }
    return FALSE;
}

// Do a Spell Immunity check. TRUE if they resist the spell.
// - We check Immunity and Globes, but not Spell Resistance
int SMP_SpellImmunityCheck(object oCaster, object oTarget, float fDelay = 0.0)
{
    // Total effect immunity check (Includes spell immunity check)
    if(SMP_TotalSpellImmunity(oTarget))
    {
        return TRUE;;
    }
    // We do this for any flying projectiles to hit a barrier.
    if(fDelay > 0.5)
    {
        fDelay -= 0.1;
    }
    int nResist = ResistSpell(oCaster, oTarget);
    effect eGlobe = EffectVisualEffect(VFX_IMP_GLOBE_USE);
    effect eMantle = EffectVisualEffect(VFX_IMP_SPELL_MANTLE_USE);
    if(nResist == 2) //Globe - only one to check for
    {
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eGlobe, oTarget));
        return TRUE;
    }
    else if(nResist == 3) // Resisted via spell absorption: 3 (Spell Mantle ETC - EffectSpellLevelAbsorption with a limit)
    {
        // More delay off. Improves how it looks.
        if(fDelay > 0.5)
        {
            fDelay -= 0.1;
        }
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eMantle, oTarget));
        return TRUE;
    }
    return FALSE;
}
*/
// SMP_INC_RESIST. Check if they should be affected by ANY EFFECT (Not
// anything specific, nor only limited to spells). "Magical Force" beings,
// and spell effects will have this return TRUE.
// * TRUE - If they should have no effects affecting them
// * FALSE - If they are normal.
// Called in all files for all targets.
int SMP_GeneralEverythingImmunity(object oTarget)
{
    // Local constant check
    if(GetLocalInt(oTarget, SMP_SPELL_ALL_EFFECTS_IMMUNE) ||
       GetPlotFlag(oTarget) == TRUE)
    {
        return TRUE;
    }
    return FALSE;
}

// SMP_INC_RESIST. Check if they should be affected by any SPELLS
// This is really to stop damaging spells, but can be used to script in things
// for specific monsters.
// * Note that EffectSpellLevelAbsorption() is NOT the same. This affects FRIENDLY
//   spells as well as HOSTILE spells!
// * TRUE - If they should have no spells affecting them
// * FALSE - If they are normal.
// Called in all spell files for all targets. Also calls SMP_GeneralEverythingImmunity().
// * Called form all ResistSpell() using functions in SMP_INC_RESIST
int SMP_TotalSpellImmunity(object oTarget)
{
    // Local constant.
    if(GetLocalInt(oTarget, SMP_SPELL_IMMUNITY_ALL) ||
       SMP_GeneralEverythingImmunity(oTarget))
    {
        return TRUE;
    }
    return FALSE;
}

// SMP_INC_RESIST
// Checks GetIsImmune(oTarget, nImmunityType), and will apply a special visual
// if TRUE.
// * If TRUE, immune to nImmunityType.
// * Note: Should use for all SAVING_THROW_TYPE_XXX immunity checks, before
//   the saving throw. This displays a message similar to that of just applying
//   the effect (like Charm effect) and they are immune.
// * oCaster - The spellcaster (see GetIsImmune parameters) for Racial type ETC checks.
int SMP_ImmunityCheck(object oTarget, int nImmunityType, float fDelay = 0.0, object oCaster = OBJECT_SELF)
{
    // Use GetIsImmune with oCaster for the racial type and alignment values.
    if(GetIsImmune(oTarget, nImmunityType, oCaster))
    {
        // Visual on save
        effect eVis = EffectVisualEffect(VFX_IMP_MAGIC_RESISTANCE_USE);
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
        // Display message to the person and caste
        // to show they are immune to this immunity, just as if we applied it.

        // Get immune name
        string sType = GetLocalString(GetObjectByTag(SMP_GLOBAL_IMMUNITY_NAME), IntToString(nImmunityType));
        // Complete message
        string sMessage = "<cRGB>" + GetName(oTarget) + " : <c GB>Immune to " + sType;
        // Check if in our own AOE.
        if(oTarget != oCaster)
        {
            // Send to self, the caster
            SendMessageToPC(oCaster, sMessage);
        }
        // Send to the target
        SendMessageToPC(oTarget, sMessage);
        return TRUE;
    }
    return FALSE;
}

// SMP_INC_RESIST. This will do a simplified spell resistance check. It will
// return TRUE if they passed, and the spell shouldn't affect them.
// * Note: Requires a level input!
// * Note 2: Use oCaster for relay information.
int SMP_SpellResistanceManualCheck(object oCaster, object oTarget, int nCasterLevel, int nSpellLevel, float fDelay = 0.0)
{
    // Check level immunity (cannot have percise spell immunity to wish, etc,
    // nor have immunity to the general spell school) on the targets hide
    object oHide = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oTarget);
    string sMessage;
    if(GetIsObjectValid(oHide))
    {
        // Loop hide for the correct property
        if(GetItemHasItemProperty(oHide, ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL))
        {
            itemproperty IP_Check = GetFirstItemProperty(oHide);
            while(GetIsItemPropertyValid(IP_Check))
            {
                if(GetItemPropertyType(IP_Check) == ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL)
                {
                    // NEED TO DO - subprameter or what?
                    if(GetItemPropertyParam1Value(IP_Check) >= nSpellLevel)
                    {
                        // Immunity by level
                        // Make message
                        sMessage = "<cRGB>" + GetName(oTarget) + " : <c GB> Resisted Spell.";
                        if(oCaster != oTarget) SendMessageToPC(oTarget, sMessage);
                        SendMessageToPC(oCaster, sMessage);
                        return TRUE;
                    }
                }
                IP_Check = GetNextItemProperty(oHide);
            }
        }
    }

    // Check normal spell resistance
    int nResistance = GetSpellResistance(oTarget);

    // If over 0.
    if(nResistance > 0)
    {
        // Check - d20 + each number versus each other
        if(nCasterLevel + d20() >= nResistance + d20())
        {
            // They have failed the check - relay news.
            // Make message
            sMessage = "<cRGB>" + GetName(oTarget) + " : <c GB> Spell Resistance: Failed.";
            if(oCaster != oTarget) SendMessageToPC(oTarget, sMessage);
            SendMessageToPC(oCaster, sMessage);
            return FALSE;
        }
        else
        {
            // They have pased the check (or rather, the caster failed to penetrate it)
            // Make message
            sMessage = "<cRGB>" + GetName(oTarget) + " : <c GB> Spell Resistance: Passed.";
            if(oCaster != oTarget) SendMessageToPC(oTarget, sMessage);
            SendMessageToPC(oCaster, sMessage);
            return TRUE;
        }
    }
    // Return FALSE, spell gets through
    return FALSE;
}

// SMP_INC_RESIST. Returns TRUE if oTarget can see.
// - Is not blinded
// - Is not a creature with no eyes
// - Local variable also allowed for "I have no eyes"
int SMP_GetCanSee(object oTarget)
{
    // Are they blinded?
    if(SMP_GetHasEffect(EFFECT_TYPE_BLINDNESS, oTarget)) return FALSE;

    // Can they see? Some appearances do not have eyes, as such.
    int nAppearance = GetAppearanceType(oTarget);

    switch(nAppearance)
    {
        case APPEARANCE_TYPE_BAT:
        case APPEARANCE_TYPE_BAT_HORROR:
        case APPEARANCE_TYPE_ELEMENTAL_AIR:
        case APPEARANCE_TYPE_ELEMENTAL_AIR_ELDER:
        case APPEARANCE_TYPE_ELEMENTAL_EARTH:
        case APPEARANCE_TYPE_ELEMENTAL_EARTH_ELDER:
        case APPEARANCE_TYPE_ELEMENTAL_FIRE:
        case APPEARANCE_TYPE_ELEMENTAL_FIRE_ELDER:
        case APPEARANCE_TYPE_ELEMENTAL_WATER:
        case APPEARANCE_TYPE_ELEMENTAL_WATER_ELDER:
        case APPEARANCE_TYPE_GOLEM_BONE:
        case APPEARANCE_TYPE_GOLEM_CLAY:
        case APPEARANCE_TYPE_GOLEM_FLESH:
        case APPEARANCE_TYPE_GOLEM_IRON:
        case APPEARANCE_TYPE_GOLEM_STONE:
        case APPEARANCE_TYPE_HELMED_HORROR:
        case APPEARANCE_TYPE_SHIELD_GUARDIAN:
        case APPEARANCE_TYPE_INTELLECT_DEVOURER:
        case APPEARANCE_TYPE_SKELETAL_DEVOURER:
        case APPEARANCE_TYPE_WAR_DEVOURER:
        case APPEARANCE_TYPE_WILL_O_WISP:
        case APPEARANCE_TYPE_LANTERN_ARCHON:
        case 470: // GelatinousCube
        {
            // Cannot see
            return FALSE;
        }
        break;
    }

    // Local variable
    if(GetLocalInt(oTarget, "SMP_SPELLS_CANNOT_SEE")) return FALSE;

    // Is immune to blindness
    if(GetIsImmune(oTarget, IMMUNITY_TYPE_BLINDNESS)) return FALSE;

    return TRUE;
}
// SMP_INC_RESIST. Returns TRUE if oTarget can hear.
// - Is not deafened
// - Is not a creature with no eyes
// - Local variable also allowed for "I have no ears"
int SMP_GetCanHear(object oTarget)
{
    // Are they blinded?
    if(SMP_GetHasEffect(EFFECT_TYPE_DEAF, oTarget) ||
       SMP_GetHasEffect(EFFECT_TYPE_SILENCE, oTarget)) return FALSE;

    // Can they see? Some appearances do not have eyes, as such.
    int nAppearance = GetAppearanceType(oTarget);

    switch(nAppearance)
    {
        case 470: // GelatinousCube
        {
            // Cannot see
            return FALSE;
        }
        break;
    }

    // Local variable
    if(GetLocalInt(oTarget, "SMP_SPELLS_CANNOT_HEAR")) return FALSE;

    return TRUE;
}

// End of file Debug lines. Uncomment below "/*" with "//" and compile.
/*
void main()
{
    return;
}
//*/
