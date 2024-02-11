/*:://////////////////////////////////////////////
//:: Spell Name Pre-spell hook
//:: Spell FileName SMP_INC_SPLLHOOK
//:://////////////////////////////////////////////
//:: Notes
//:://////////////////////////////////////////////
    The call in this script is called before each spell.

    It can return TRUE or FALSE.

    - TRUE - the spell can be cast normally
    - FALSE - the spell will not cast correctly, and the spellscript will not run.

    This will not actually fire the script SMP_SPELLHOOK, but the function
    SMP_SpellHookCheck() will.

    Thusly, you only need to edit SMP_SPELLHOOK to have edits to the spellhook.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

// - Contains the normal Use Magical Device checks
#include "SMP_INC_UMDCHECK"
// Array things for names
#include "SMP_INC_ARRAY"

// Include the default spell includes too
#include "SMP_INC_SPELLS"

// SMP_INC_SPLLHOOK. Checks if a paladin, or cleric, casting the spell has an item of divine focus.
int SMP_DivineFocusCheck(string sSpellName);

// SMP_INC_SPLLHOOK. This checks Blink effects - there is a 50% chance a spell
// just will not affect them! :-)
// - Of course, seeing eathreal (True Seeing, ETC) eliminates this
// - Returns TRUE if they pass the test, FALSE means that oTarget is blinked :-)
int SMP_BlinkCheck(object oTarget, object oCaster = OBJECT_SELF);

// SMP_INC_SPLLHOOK. This will check if the area is toggled to be wild magic,
// and if so, do random effects.
// * FALSE if wild magic check was failed, so something special happened
// * TRUE if the pass was sucessful, or no wild magic.
int SMP_WildMagicAreaSurge(object oCasterArea, object oCaster = OBJECT_SELF);

// SMP_INC_SPLLHOOK. Check for concentration - that is, if we don't concentrate,
// then something will happen, but this will not stop the spell cast operating.
// * Will not return anything. The in-built checks here will not stop the spell,
//   but will stop another that is being concentrated upon.
void SMP_SpecialConcentrationChecks(object oCaster = OBJECT_SELF);

// SMP_INC_SPLLHOOK. This makes sure the caster isn't in some kind of state that
// stops spells being cast, such as Entanglement, which are not handled under
// the normal concentration checks via. damage.
// * TRUE means they passed, no bad effects or sucess at passing the DC checks
// * FALSE means some bad effect if possed on the caster, or a failed check.
// Note: Make sure the spell hook applies a special visual when FALSE is returned.
int SMP_BreakConcentrationCheck(int nSpellLevel, object oCaster = OBJECT_SELF);

// SMP_INC_SPLLHOOK. We check for the spells SMP_SPELL_SPELL_CURSE and
// SMP_SPELL_SPELL_CURSE_GREATER, and do 1d6 + nSpellLevel, or
// 2d6 + (2*nSpellLevel) in damage, half for will save.
// * No return value
// * Only works if a normal spell class, and no item.
void SMP_SpellCurseCheck(int nSpellLevel, int nCasterClass, object oCastItem, object oCaster = OBJECT_SELF);

// SMP_INC_SPLLHOOK. This will check if this spell is a cleric is casting it.
// - We can cast a limit of 1 Domain spell a day.
// (NOT IN: We can cast a limit of XXX spells - 1 for other spells, using normal slots.)
// TRUE if the check failed and they cannot cast it.
int SMP_DomainSpellCheck(int nSpellId, object oCastItem, int nSpellCastClass, object oCaster = OBJECT_SELF);
// SMP_INC_SPLLHOOK. Get if nSpellId is a domain spell. Returns TRUE if it is.
int SMP_GetIsDomainSpell(int nSpellId);
// SMP_INC_SPLLHOOK. Removes ALL domain spells from nLevel on oTarget - removes the casting of them that is!
void SMP_RemoveDomainSpells(object oTarget, int nLevel);

// SMP_INC_SPLLHOOK. This will check if, casting from a spell scroll, they have
// the correct stats to do so.
// Do this before UMD. Returns FALSE if they are using UMD or it was used
// sucessfully, or FALSE if they tried to use it and failed a check or something.
// * TRUE = Can cast this spell according to this.
// * FALSE = Failed, no spell script.
int SMP_SpellScrollCastingCheck(int nSpellId, int nSpellLevel, object oCastItem, int nSpellCastClass, object oCaster = OBJECT_SELF);

// SMP_INC_SPLLHOOK. Returns the level of the spell on the scroll. Of course,
// there is only ever one level a scroll can be - it can have only one spell to cast on it.
int SMP_GetSpellScrollLevel(object oScroll);

// Checks if a paladin, or cleric, casting the spell has an item of divine focus.
int SMP_DivineFocusCheck(string sSpellName)
{
    // Make sure it wasn't cast from an item
    if(GetIsObjectValid(GetSpellCastItem())) return TRUE;

    int nCasterClass = GetLastSpellCastClass();

    if(nCasterClass == CLASS_TYPE_CLERIC ||
       nCasterClass == CLASS_TYPE_PALADIN)
    {
        // If this returns FALSE, the focus failed.
        if(!SMP_ComponentExactItem(SMP_ITEM_DIVINE_FOCUS, "Item of Divine Focus", sSpellName))
        {
            effect eVis = EffectVisualEffect(VFX_IMP_MAGIC_RESISTANCE_USE);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
            return FALSE;
        }
    }
    return TRUE;
}
// This checks Blink effects - there is a 50% chance a spell just will not
// affect them! :-)
// - Of course, seeing eathreal (True Seeing, ETC) eliminates this
// - Returns TRUE if they pass the test, FALSE means that oTarget is blinked :-)
int SMP_BlinkCheck(object oTarget, object oCaster = OBJECT_SELF)
{
    if(GetHasSpellEffect(SMP_SPELL_BLINK, oTarget))
    {
        // Spells which stop Blinking:
        if(!GetHasSpellEffect(SMP_SPELL_TRUE_SEEING, oCaster) &&
        // Hide effect - Trueseeing
           !GetItemHasItemProperty(GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCaster), ITEM_PROPERTY_TRUE_SEEING))
        {
            // Make the 50% check
            if(d2() == 1)
            {
                // Pass!
                SendMessageToPC(oTarget, "Your blinking upset someones attempt to cast a spell at you");
                SendMessageToPC(oCaster, GetName(oTarget) + " was blinking, and was not in this plane at the time!");
                return FALSE;
            }
            // we don't report a pass - it is like Inside Knowledge, knowing
            // that they are blinking (yeah, right). It is really, just more
            // annoying, as many messages could possibly come up for many blinkers
        }
    }
    return TRUE;
}

// This will check if the area is toggled to be wild magic, and if so, do random
// effects.
// * FALSE if wild magic check was failed, so something special happened
// * TRUE if the pass was sucessful, or no wild magic.
int SMP_WildMagicAreaSurge(object oCasterArea, object oCaster = OBJECT_SELF)
{
    // Get if the area has the wildmagic check flag
    // - This is also the % for failure
    int nWildPercent = GetLocalInt(oCasterArea, "SMP_AREA_WILDMAGIC");
    int nDice;

    // Check if there is a 1% or higher failure rate
    if(nWildPercent > FALSE)
    {
        // Check dice
        nDice = d100();
        if(nDice <= nWildPercent)
        {
            // We fail! Floating text, damage, and visual
            // - Executed script
            ExecuteScript(SMP_WILD_MAGIC_SCRIPT, oCaster);
            // Also stop the spell
            return FALSE;
        }
    }
    return TRUE;
}
// Check for concentration - that is, if we don't concentrate, then something
// will happen.
// * Will not return anything. The in-built checks here will not stop the spell,
//   but will stop another that is being concentrated upon.
void SMP_SpecialConcentrationChecks(object oCaster = OBJECT_SELF)
{
    // * At the moment we got only one concentration spell, black blade of disaster

    object oAssoc = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oCaster);
    if (GetIsObjectValid(oAssoc) && GetIsPC(oCaster)) // only applies to PCS
    {
        if(GetTag(oAssoc) == "x2_s_bblade") // black blade of disaster
        {
            if (GetLocalInt(OBJECT_SELF,"X2_L_CREATURE_NEEDS_CONCENTRATION"))
            {
                SignalEvent(oAssoc,EventUserDefined(1));
            }
        }
    }
}

// This makes sure the caster isn't in some kind of state that stops spells
// being cast, such as Entanglement, which are not handled under the normal
// concentration checks via. damage.
// * TRUE means they passed, no bad effects or sucess at passing the DC checks
// * FALSE means some bad effect if possed on the caster, or a failed check.
// Note: Make sure the spell hook applies a special visual when FALSE is returned.
int SMP_BreakConcentrationCheck(int nSpellLevel, object oCaster = OBJECT_SELF)
{
    // Checks for status effects and spells which induce extra concentration
    // checks.

    // - Entanglement has an extra DC 15 concentration check
    if(SMP_GetHasEffect(EFFECT_TYPE_ENTANGLE, oCaster))
    {
        // DC15
        if(!GetIsSkillSuccessful(oCaster, SKILL_CONCENTRATION, 15))
        {
            // Failed
            FloatingTextStringOnCreature("*Entanglement Concentration failed*", oCaster, FALSE);
            return FALSE;
        }
        else
        {
            // Passed
            FloatingTextStringOnCreature("*Entanglement Concentration passed*", oCaster, FALSE);
        }
    }

    // * TRUE means successful pass
    return TRUE;
}

// We check for the spells SMP_SPELL_SPELL_CURSE and SMP_SPELL_SPELL_CURSE_GREATER,
// and do 1d6 + nSpellLevel, or 2d6 + (2*nSpellLevel) in damage, half for will save.
// * No return value
// * Only works if a normal spell class, and no item.
void SMP_SpellCurseCheck(int nSpellLevel, int nCasterClass, object oCastItem, object oCaster = OBJECT_SELF)
{
    // We do not do it if they cast from an item, or cast from a special ability.
    if(GetIsObjectValid(oCastItem) ||
       nCasterClass == CLASS_TYPE_INVALID)
    {
        return;
    }

    // So, we check for the spell
    object oEnemy;
    int nSpellSaveDC, nDam;
    effect eDam;

    // - Greater Spell Curse
    if(GetHasSpellEffect(SMP_SPELL_SPELL_CURSE_GREATER, oCaster))
    {
        // Make sure the caster is valid.
        oEnemy = SMP_FirstCasterOfSpellEffect(SMP_SPELL_SPELL_CURSE_GREATER, oCaster);

        // Validity
        if(GetIsObjectValid(oEnemy))
        {
            // We check for will save DC
            nSpellSaveDC = GetLocalInt(oEnemy, "SMP_SPELL_CAST_SPELL_SAVEDC" + IntToString(SMP_SPELL_SPELL_CURSE_GREATER));

            // Make sure its 10 or more
            if(nSpellSaveDC < 10) nSpellSaveDC = 10;

            // Get damage
            // 2d6 + 2 * spell level
            nDam = SMP_MaximizeOrEmpower(6, 2, FALSE, nSpellLevel * 2);

            // Do the save for half damage
            nDam = SMP_GetAdjustedDamage(SAVING_THROW_WILL, nDam, oCaster, nSpellSaveDC, SAVING_THROW_TYPE_NONE, oEnemy);

            // Do damage
            if(nDam > 0)
            {
                eDam = EffectDamage(nDam);
                AssignCommand(oEnemy, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oCaster));
            }
            // Stop!
            return;
        }
        else
        {
            // Else, cannot be valid greater spell curse. Need enemy.
            SMP_RemoveSpellEffectsFromTarget(SMP_SPELL_SPELL_CURSE_GREATER, oCaster);
        }
    }
    // Now check the normal version, 1d6 + spell level in damage.
    if(GetHasSpellEffect(SMP_SPELL_SPELL_CURSE, oCaster))
    {
        // Make sure the cast is valid.
        oEnemy = SMP_FirstCasterOfSpellEffect(SMP_SPELL_SPELL_CURSE, oCaster);

        // Validity
        if(GetIsObjectValid(oEnemy))
        {
            // We check for will save DC
            nSpellSaveDC = GetLocalInt(oEnemy, "SMP_SPELL_CAST_SPELL_SAVEDC" + IntToString(SMP_SPELL_SPELL_CURSE));

            // Make sure its 10 or more
            if(nSpellSaveDC < 10) nSpellSaveDC = 10;

            // Get damage
            // 1d6 + spell level
            nDam = SMP_MaximizeOrEmpower(6, 1, FALSE, nSpellLevel);

            // Do the save for half damage
            nDam = SMP_GetAdjustedDamage(SAVING_THROW_WILL, nDam, oCaster, nSpellSaveDC, SAVING_THROW_TYPE_NONE, oEnemy);

            // Do damage
            if(nDam > 0)
            {
                eDam = EffectDamage(nDam);
                AssignCommand(oEnemy, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oCaster));
            }
            // Stop!
            return;
        }
        else
        {
            // Else, cannot be valid greater spell curse. Need enemy.
            SMP_RemoveSpellEffectsFromTarget(SMP_SPELL_SPELL_CURSE, oCaster);
        }
    }
}


// This will check if this spell is a Domain spell, and a cleric is casting it.
// - No items will be used.
// - If so, we will not be able to use more then one per rest.
int SMP_DomainSpellCheck(int nSpellId, object oCastItem, int nSpellCastClass, object oCaster = OBJECT_SELF)
{
    // PCs only
    if(!GetIsPC(oCaster)) return TRUE;

    // Module setting, if we have no setting to use this, ignore it
    if(!SMP_SettingGetGlobal(SMP_SETTING_DOMAIN_SPELL_LIMIT_ENFORCE)) return TRUE;

    // If they are not casting as a cleric, or using a valid item (EG: scroll)
    // we do not need this
    if(nSpellCastClass != CLASS_TYPE_CLERIC || GetIsObjectValid(oCastItem)) return TRUE;

    // We are a cleric casting a normal spell...thus will be a clerical stored
    // spell (A normal one, spontaeous one, or a domain one!)

    // Check the spell by nSpellId to see if it is a domain spell.
    if(SMP_GetIsDomainSpell(nSpellId))
    {
        // Get domain spell level
        int nLevel = SMP_ArrayGetSpellLevel(nSpellId, CLASS_TYPE_INVALID);

        // Remove other domain spells from this level
        SMP_RemoveDomainSpells(oCaster, nLevel);
    }

    // If this is a normal cleric spell (checked now) from whatever level, we
    // will make sure, if this is the first casting of a cleric spell from that
    // level, we remove all but 1 domain spell, oh, and make sure that at least
    // 1 of the spells are a domain spell from that level.

    // * Need to test for wisdom bonuses, slots, etc. To see if it was the first
    //   spell. Note, it could be abused - however, extra wisdom is only tempoary,
    //   so we'll not check for bonus to wisdom from effects, only items and
    //   inherant bonuses (Maybe just take off all temp wisdom bonuses...by applying
    //   a +12 bonus, then removing it?)

    // Therefore: If we rest, it'll check again on the first casting of a spell
    // from that level. no need for rest event changing.

    // True, we can cast the spell
    return TRUE;
}

// Get if nSpellId is a domain spell. Returns TRUE if it is.
int SMP_GetIsDomainSpell(int nSpellId)
{
    switch(nSpellId)
    {
        // Air
        case SMP_SPELL_DOMAIN_AIR_OBSCURING_MIST:
        case SMP_SPELL_DOMAIN_AIR_WIND_WALL:
        case SMP_SPELL_DOMAIN_AIR_GASEOUS_FORM:
        case SMP_SPELL_DOMAIN_AIR_AIR_WALK:
        case SMP_SPELL_DOMAIN_AIR_CONTROL_WINDS:
        case SMP_SPELL_DOMAIN_AIR_CHAIN_LIGHTNING:
        case SMP_SPELL_DOMAIN_AIR_CONTROL_WEATHER:
        case SMP_SPELL_DOMAIN_AIR_WHIRLWIND:
        case SMP_SPELL_DOMAIN_AIR_ELEMENTAL_SWARM:
        // Animal
        case SMP_SPELL_DOMAIN_ANIMAL_CALM_ANIMALS:
        case SMP_SPELL_DOMAIN_ANIMAL_HOLD_ANIMAL:
        case SMP_SPELL_DOMAIN_ANIMAL_DOMINATE_ANIMAL:
        case SMP_SPELL_DOMAIN_ANIMAL_SUMMON_NATURES_ALLY_IV:
        case SMP_SPELL_DOMAIN_ANIMAL_COMMUNE_WITH_NATURE:
        case SMP_SPELL_DOMAIN_ANIMAL_ANTILIFE_SHELL:
        case SMP_SPELL_DOMAIN_ANIMAL_ANIMAL_SHAPES:
        case SMP_SPELL_DOMAIN_ANIMAL_SUMMON_NATURES_ALLY_VII:
        case SMP_SPELL_DOMAIN_ANIMAL_SHAPECHANGE:
        // Chaos
        case SMP_SPELL_DOMAIN_CHAOS_PROTECTION_FROM_LAW:
        case SMP_SPELL_DOMAIN_CHAOS_SHATTER:
        case SMP_SPELL_DOMAIN_CHAOS_MAGIC_CIRCLE_AGAINST_LAW:
        case SMP_SPELL_DOMAIN_CHAOS_CHAOS_HAMMER:
        case SMP_SPELL_DOMAIN_CHAOS_DISPEL_LAW:
        case SMP_SPELL_DOMAIN_CHAOS_ANIMATE_OBJECTS:
        case SMP_SPELL_DOMAIN_CHAOS_WORD_OF_CHAOS:
        case SMP_SPELL_DOMAIN_CHAOS_CLOAK_OF_CHAOS:
        case SMP_SPELL_DOMAIN_CHAOS_SUMMON_MONSTER_IX:
        // Death
        case SMP_SPELL_DOMAIN_DEATH_CAUSE_FEAR:
        case SMP_SPELL_DOMAIN_DEATH_DEATH_KNELL:
        case SMP_SPELL_DOMAIN_DEATH_ANIMATE_DEAD:
        case SMP_SPELL_DOMAIN_DEATH_DEATH_WARD:
        case SMP_SPELL_DOMAIN_DEATH_SLAY_LIVING:
        case SMP_SPELL_DOMAIN_DEATH_CREATE_UNDEAD:
        case SMP_SPELL_DOMAIN_DEATH_DESTRUCTION:
        case SMP_SPELL_DOMAIN_DEATH_CREATE_GREATER_UNDEAD:
        case SMP_SPELL_DOMAIN_DEATH_WAIL_OF_THE_BANSHEE:
        // Destruction
        case SMP_SPELL_DOMAIN_DESTRUCTION_INFLICT_LIGHT_WOUNDS:
        case SMP_SPELL_DOMAIN_DESTRUCTION_SHATTER:
        case SMP_SPELL_DOMAIN_DESTRUCTION_CONTAGION:
        case SMP_SPELL_DOMAIN_DESTRUCTION_INFLICT_CRITICAL_WOUNDS:
        case SMP_SPELL_DOMAIN_DESTRUCTION_INFLICT_LIGHT_WOUNDS_MASS:
        case SMP_SPELL_DOMAIN_DESTRUCTION_HARM:
        case SMP_SPELL_DOMAIN_DESTRUCTION_DISINTEGRATE:
        case SMP_SPELL_DOMAIN_DESTRUCTION_EARTHQUAKE:
        case SMP_SPELL_DOMAIN_DESTRUCTION_IMPLOSION:
        // Earth
        case SMP_SPELL_DOMAIN_EARTH_MAGIC_STONE:
        case SMP_SPELL_DOMAIN_EARTH_SOFTEN_EARTH_AND_STONE:
        case SMP_SPELL_DOMAIN_EARTH_STONE_SHAPE:
        case SMP_SPELL_DOMAIN_EARTH_SPIKE_STONES:
        case SMP_SPELL_DOMAIN_EARTH_WALL_OF_STONE:
        case SMP_SPELL_DOMAIN_EARTH_STONESKIN:
        case SMP_SPELL_DOMAIN_EARTH_EARTHQUAKE:
        case SMP_SPELL_DOMAIN_EARTH_IRON_BODY:
        case SMP_SPELL_DOMAIN_EARTH_ELEMENTAL_SWARM:
        // Evil
        case SMP_SPELL_DOMAIN_EVIL_PROTECTION_FROM_GOOD:
        case SMP_SPELL_DOMAIN_EVIL_DESECRATE:
        case SMP_SPELL_DOMAIN_EVIL_MAGIC_CIRCLE_AGAINST_GOOD:
        case SMP_SPELL_DOMAIN_EVIL_UNHOLY_BLIGHT:
        case SMP_SPELL_DOMAIN_EVIL_DISPEL_GOOD:
        case SMP_SPELL_DOMAIN_EVIL_CREATE_UNDEAD:
        case SMP_SPELL_DOMAIN_EVIL_BLASPHEMY:
        case SMP_SPELL_DOMAIN_EVIL_UNHOLY_AURA:
        case SMP_SPELL_DOMAIN_EVIL_SUMMON_MONSTER_IX:
        // Fire
        case SMP_SPELL_DOMAIN_FIRE_BURNING_HANDS:
        case SMP_SPELL_DOMAIN_FIRE_PRODUCE_FLAME:
        case SMP_SPELL_DOMAIN_FIRE_RESIST_ENERGY:
        case SMP_SPELL_DOMAIN_FIRE_WALL_OF_FIRE:
        case SMP_SPELL_DOMAIN_FIRE_FIRE_SHIELD:
        case SMP_SPELL_DOMAIN_FIRE_FIRE_SEEDS:
        case SMP_SPELL_DOMAIN_FIRE_FIRE_STORM:
        case SMP_SPELL_DOMAIN_FIRE_INCENDIARY_CLOUD:
        case SMP_SPELL_DOMAIN_FIRE_ELEMENTAL_SWARM:
        // Good
        case SMP_SPELL_DOMAIN_GOOD_PROTECTION_FROM_EVIL:
        case SMP_SPELL_DOMAIN_GOOD_AID:
        case SMP_SPELL_DOMAIN_GOOD_MAGIC_CIRCLE_AGAINST_EVIL:
        case SMP_SPELL_DOMAIN_GOOD_HOLY_SMITE:
        case SMP_SPELL_DOMAIN_GOOD_DISPEL_EVIL:
        case SMP_SPELL_DOMAIN_GOOD_BLADE_BARRIER:
        case SMP_SPELL_DOMAIN_GOOD_HOLY_WORD:
        case SMP_SPELL_DOMAIN_GOOD_HOLY_AURA:
        case SMP_SPELL_DOMAIN_GOOD_SUMMON_MONSTER_IX:
        // Healing
        case SMP_SPELL_DOMAIN_HEALING_CURE_LIGHT_WOUNDS:
        case SMP_SPELL_DOMAIN_HEALING_CURE_MODERATE_WOUNDS:
        case SMP_SPELL_DOMAIN_HEALING_CURE_SERIOUS_WOUNDS:
        case SMP_SPELL_DOMAIN_HEALING_CURE_CRITICAL_WOUNDS:
        case SMP_SPELL_DOMAIN_HEALING_CURE_LIGHT_WOUNDS_MASS:
        case SMP_SPELL_DOMAIN_HEALING_HEAL:
        case SMP_SPELL_DOMAIN_HEALING_REGENERATE:
        case SMP_SPELL_DOMAIN_HEALING_CURE_CRITICAL_WOUNDS_MASS:
        case SMP_SPELL_DOMAIN_HEALING_HEAL_MASS:
        // Knowledge
        case SMP_SPELL_DOMAIN_KNOWLEDGE_DETECT_SECRET_DOOS:
        case SMP_SPELL_DOMAIN_KNOWLEDGE_DETECT_THOUGHTS:
        case SMP_SPELL_DOMAIN_KNOWLEDGE_CLAIRAUDIENCE_CLAIRVOYANCE:
        case SMP_SPELL_DOMAIN_KNOWLEDGE_DIVINATION:
        case SMP_SPELL_DOMAIN_KNOWLEDGE_TRUE_SEEING:
        case SMP_SPELL_DOMAIN_KNOWLEDGE_FIND_THE_PATH:
        case SMP_SPELL_DOMAIN_KNOWLEDGE_LEGEND_LORE:
        case SMP_SPELL_DOMAIN_KNOWLEDGE_DISCERN_LOCATION:
        case SMP_SPELL_DOMAIN_KNOWLEDGE_FORESIGHT:
        // Law
        case SMP_SPELL_DOMAIN_LAW_PROTECTION_FROM_CHAOS:
        case SMP_SPELL_DOMAIN_LAW_CALM_EMOTIONS:
        case SMP_SPELL_DOMAIN_LAW_MAGIC_CIRCLE_AGAINST_CHAOS:
        case SMP_SPELL_DOMAIN_LAW_ORDERS_WRATH:
        case SMP_SPELL_DOMAIN_LAW_DISPEL_CHAOS:
        case SMP_SPELL_DOMAIN_LAW_HOLD_MONSTER:
        case SMP_SPELL_DOMAIN_LAW_DICTUM:
        case SMP_SPELL_DOMAIN_LAW_SHIELD_OF_LAW:
        case SMP_SPELL_DOMAIN_LAW_SUMMON_MONSTER_IX:
        // Luck
        case SMP_SPELL_DOMAIN_LUCK_ENTROPIC_SHIELD:
        case SMP_SPELL_DOMAIN_LUCK_AID:
        case SMP_SPELL_DOMAIN_LUCK_PROTECTION_FROM_ENERGY:
        case SMP_SPELL_DOMAIN_LUCK_FREEDOM_OF_MOVEMENT:
        case SMP_SPELL_DOMAIN_LUCK_BREAK_ENCHANTMENT:
        case SMP_SPELL_DOMAIN_LUCK_MISLEAD:
        case SMP_SPELL_DOMAIN_LUCK_SPELL_TURNING:
        case SMP_SPELL_DOMAIN_LUCK_MOMENT_OF_PRESCIENCE:
        case SMP_SPELL_DOMAIN_LUCK_MIRACLE:
        // Magic
        case SMP_SPELL_DOMAIN_MAGIC_MAGIC_AURA:
        case SMP_SPELL_DOMAIN_MAGIC_IDENTIFY:
        case SMP_SPELL_DOMAIN_MAGIC_DISPEL_MAGIC:
        case SMP_SPELL_DOMAIN_MAGIC_IMBUNE_WITH_SPELL_ABILITY:
        case SMP_SPELL_DOMAIN_MAGIC_SPELL_RESISTANCE:
        case SMP_SPELL_DOMAIN_MAGIC_ANTIMAGIC_FIELD:
        case SMP_SPELL_DOMAIN_MAGIC_SPELL_TURNING:
        case SMP_SPELL_DOMAIN_MAGIC_PROTECTION_FROM_SPELLS:
        case SMP_SPELL_DOMAIN_MAGIC_MAGES_DISJUNCTION:
        // Plant
        case SMP_SPELL_DOMAIN_PLANT_ENTANGLE:
        case SMP_SPELL_DOMAIN_PLANT_BARKSKIN:
        case SMP_SPELL_DOMAIN_PLANT_PLANT_GROWTH:
        case SMP_SPELL_DOMAIN_PLANT_COMMAND_PLANTS:
        case SMP_SPELL_DOMAIN_PLANT_WALL_OF_THORNS:
        case SMP_SPELL_DOMAIN_PLANT_REPEL_WOOD:
        case SMP_SPELL_DOMAIN_PLANT_ANIMATE_PLANTS:
        case SMP_SPELL_DOMAIN_PLANT_CONTROL_PLANTS:
        case SMP_SPELL_DOMAIN_PLANT_SHAMBLER:
        // Protection
        case SMP_SPELL_DOMAIN_PROTECTION_SANCTUARY:
        case SMP_SPELL_DOMAIN_PROTECTION_SHIELD_OTHER:
        case SMP_SPELL_DOMAIN_PROTECTION_PROTECTION_FROM_ENERGY:
        case SMP_SPELL_DOMAIN_PROTECTION_SPELL_IMMUNITY:
        case SMP_SPELL_DOMAIN_PROTECTION_SPELL_RESISTANCE:
        case SMP_SPELL_DOMAIN_PROTECTION_ANTIMAGIC_FIELD:
        case SMP_SPELL_DOMAIN_PROTECTION_REPULSION:
        case SMP_SPELL_DOMAIN_PROTECTION_MIND_BLANK:
        case SMP_SPELL_DOMAIN_PROTECTION_PRISMATIC_SPHERE:
        // Strength
        case SMP_SPELL_DOMAIN_STRENGTH_ENLARGE_PERSON:
        case SMP_SPELL_DOMAIN_STRENGTH_BULLS_STRENGTH:
        case SMP_SPELL_DOMAIN_STRENGTH_MAGIC_VESTMENT:
        case SMP_SPELL_DOMAIN_STRENGTH_SPELL_IMMUNITY:
        case SMP_SPELL_DOMAIN_STRENGTH_RIGHTEOUS_MIGHT:
        case SMP_SPELL_DOMAIN_STRENGTH_STONESKIN:
        case SMP_SPELL_DOMAIN_STRENGTH_GRASPING_HAND:
        case SMP_SPELL_DOMAIN_STRENGTH_CLENCHED_FIST:
        case SMP_SPELL_DOMAIN_STRENGTH_CRUSHING_HAND:
        // Sun
        case SMP_SPELL_DOMAIN_SUN_ENDURE_ELEMENTS:
        case SMP_SPELL_DOMAIN_SUN_HEAT_METAL:
        case SMP_SPELL_DOMAIN_SUN_SEARING_LIGHT:
        case SMP_SPELL_DOMAIN_SUN_FIRE_SHIELD:
        case SMP_SPELL_DOMAIN_SUN_FLAME_STRIKE:
        case SMP_SPELL_DOMAIN_SUN_FIRE_SEEDS:
        case SMP_SPELL_DOMAIN_SUN_SUNBEAM:
        case SMP_SPELL_DOMAIN_SUN_SUNBURST:
        case SMP_SPELL_DOMAIN_SUN_PRISMATIC_SPHERE:
        // Travel
        case SMP_SPELL_DOMAIN_TRAVEL_LONGSTRIDER:
        case SMP_SPELL_DOMAIN_TRAVEL_LOCATE_OBJECT:
        case SMP_SPELL_DOMAIN_TRAVEL_FLY:
        case SMP_SPELL_DOMAIN_TRAVEL_DIMENSION_DOOR:
        case SMP_SPELL_DOMAIN_TRAVEL_TELEPORT:
        case SMP_SPELL_DOMAIN_TRAVEL_FIND_THE_PATH:
        case SMP_SPELL_DOMAIN_TRAVEL_TELEPORT_GREATER:
        case SMP_SPELL_DOMAIN_TRAVEL_PHASE_DOOR:
        case SMP_SPELL_DOMAIN_TRAVEL_ASTRAL_PROJECTION:
        // Trickery
        case SMP_SPELL_DOMAIN_TRICKERY_DISGUISE_SELF:
        case SMP_SPELL_DOMAIN_TRICKERY_INVISIBILITY:
        case SMP_SPELL_DOMAIN_TRICKERY_NONDETECTION:
        case SMP_SPELL_DOMAIN_TRICKERY_CONFUSION:
        case SMP_SPELL_DOMAIN_TRICKERY_FALSE_VISION:
        case SMP_SPELL_DOMAIN_TRICKERY_MISLEAD:
        case SMP_SPELL_DOMAIN_TRICKERY_SCREEN:
        case SMP_SPELL_DOMAIN_TRICKERY_POLYMORPH_ANY_OBJECT:
        case SMP_SPELL_DOMAIN_TRICKERY_TIME_STOP:
        // War
        case SMP_SPELL_DOMAIN_WAR_MAGIC_WEAPON:
        case SMP_SPELL_DOMAIN_WAR_SPIRITUAL_WEAPON:
        case SMP_SPELL_DOMAIN_WAR_MAGIC_VESTMENT:
        case SMP_SPELL_DOMAIN_WAR_DIVINE_POWER:
        case SMP_SPELL_DOMAIN_WAR_FLAME_STRIKE:
        case SMP_SPELL_DOMAIN_WAR_BLADE_BARRIER:
        case SMP_SPELL_DOMAIN_WAR_POWER_WORD_BLIND:
        case SMP_SPELL_DOMAIN_WAR_POWER_WORD_STUN:
        case SMP_SPELL_DOMAIN_WAR_POWER_WORD_KILL:
        // War
        case SMP_SPELL_DOMAIN_WATER_OBSCURING_MIST:
        case SMP_SPELL_DOMAIN_WATER_FOG_CLOUD:
        case SMP_SPELL_DOMAIN_WATER_WATER_BREATHING:
        case SMP_SPELL_DOMAIN_WATER_CONTROL_WATER:
        case SMP_SPELL_DOMAIN_WATER_ICE_STORM:
        case SMP_SPELL_DOMAIN_WATER_CONE_OF_COLD:
        case SMP_SPELL_DOMAIN_WATER_ACID_FOG:
        case SMP_SPELL_DOMAIN_WATER_HORRID_WILTING:
        case SMP_SPELL_DOMAIN_WATER_ELEMENTAL_SWARM:
        {
            return TRUE;
        }
    }
    return FALSE;
}

// Removes ALL domain spells from nLevel on oTarget - removes the casting of them that is!
void SMP_RemoveDomainSpells(object oTarget, int nLevel)
{
    switch(nLevel)
    {
        case 1:
        {
            // Remove all level 1 domain spells
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_AIR_OBSCURING_MIST);// Air
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_ANIMAL_CALM_ANIMALS);// Animal
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_CHAOS_PROTECTION_FROM_LAW);// Chaos
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_DEATH_CAUSE_FEAR);// Death
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_DESTRUCTION_INFLICT_LIGHT_WOUNDS);// Destruction
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_EARTH_MAGIC_STONE);// Earth
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_EVIL_PROTECTION_FROM_GOOD);// Evil
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_FIRE_BURNING_HANDS);// Fire
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_GOOD_PROTECTION_FROM_EVIL);// Good
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_HEALING_CURE_LIGHT_WOUNDS);// Healing
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_KNOWLEDGE_DETECT_SECRET_DOOS);// Knowledge
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_LAW_PROTECTION_FROM_CHAOS);// Law
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_LUCK_ENTROPIC_SHIELD);// Luck
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_MAGIC_MAGIC_AURA);// Magic
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_PLANT_ENTANGLE);// Plant
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_PROTECTION_SANCTUARY);// Protection
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_STRENGTH_ENLARGE_PERSON);// Strength
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_SUN_ENDURE_ELEMENTS);// Sun
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_TRAVEL_LONGSTRIDER);// Travel
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_TRICKERY_DISGUISE_SELF);// Trickery
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_WAR_MAGIC_WEAPON);// War
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_WATER_OBSCURING_MIST);// Water
        }
        break;
        case 2:
        {
            // Remove all level 2 domain spells
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_AIR_WIND_WALL);// Air
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_ANIMAL_HOLD_ANIMAL);// Animal
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_CHAOS_SHATTER);// Chaos
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_DEATH_DEATH_KNELL);// Death
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_DESTRUCTION_SHATTER);// Destruction
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_EARTH_SOFTEN_EARTH_AND_STONE);// Earth
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_EVIL_DESECRATE);// Evil
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_FIRE_PRODUCE_FLAME);// Fire
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_GOOD_AID);// Good
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_HEALING_CURE_MODERATE_WOUNDS);// Healing
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_KNOWLEDGE_DETECT_THOUGHTS);// Knowledge
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_LAW_CALM_EMOTIONS);// Law
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_LUCK_AID);// Luck
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_MAGIC_IDENTIFY);// Magic
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_PLANT_BARKSKIN);// Plant
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_PROTECTION_SHIELD_OTHER);// Protection
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_STRENGTH_BULLS_STRENGTH);// Strength
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_SUN_HEAT_METAL);// Sun
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_TRAVEL_LOCATE_OBJECT);// Travel
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_TRICKERY_INVISIBILITY);// Trickery
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_WAR_SPIRITUAL_WEAPON);// War
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_WATER_FOG_CLOUD);// Water
        }
        break;
        case 3:
        {
            // Remove all level 3 domain spells
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_AIR_GASEOUS_FORM);// Air
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_ANIMAL_DOMINATE_ANIMAL);// Animal
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_CHAOS_MAGIC_CIRCLE_AGAINST_LAW);// Chaos
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_DEATH_ANIMATE_DEAD);// Death
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_DESTRUCTION_CONTAGION);// Destruction
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_EARTH_STONE_SHAPE);// Earth
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_EVIL_MAGIC_CIRCLE_AGAINST_GOOD);// Evil
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_FIRE_RESIST_ENERGY);// Fire
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_GOOD_MAGIC_CIRCLE_AGAINST_EVIL);// Good
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_HEALING_CURE_SERIOUS_WOUNDS);// Healing
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_KNOWLEDGE_CLAIRAUDIENCE_CLAIRVOYANCE);// Knowledge
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_LAW_MAGIC_CIRCLE_AGAINST_CHAOS);// Law
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_LUCK_PROTECTION_FROM_ENERGY);// Luck
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_MAGIC_DISPEL_MAGIC);// Magic
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_PLANT_PLANT_GROWTH);// Plant
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_PROTECTION_PROTECTION_FROM_ENERGY);// Protection
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_STRENGTH_MAGIC_VESTMENT);// Strength
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_SUN_SEARING_LIGHT);// Sun
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_TRAVEL_FLY);// Travel
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_TRICKERY_NONDETECTION);// Trickery
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_WAR_MAGIC_VESTMENT);// War
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_WATER_WATER_BREATHING);// Water
        }
        break;
        case 4:
        {
            // Remove all level 4 domain spells
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_AIR_AIR_WALK);// Air
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_ANIMAL_SUMMON_NATURES_ALLY_IV);// Animal
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_CHAOS_CHAOS_HAMMER);// Chaos
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_DEATH_DEATH_WARD);// Death
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_DESTRUCTION_INFLICT_CRITICAL_WOUNDS);// Destruction
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_EARTH_SPIKE_STONES);// Earth
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_EVIL_UNHOLY_BLIGHT);// Evil
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_FIRE_WALL_OF_FIRE);// Fire
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_GOOD_HOLY_SMITE);// Good
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_HEALING_CURE_CRITICAL_WOUNDS);// Healing
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_KNOWLEDGE_DIVINATION);// Knowledge
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_LAW_ORDERS_WRATH);// Law
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_LUCK_FREEDOM_OF_MOVEMENT);// Luck
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_MAGIC_IMBUNE_WITH_SPELL_ABILITY);// Magic
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_PLANT_COMMAND_PLANTS);// Plant
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_PROTECTION_SPELL_IMMUNITY);// Protection
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_STRENGTH_SPELL_IMMUNITY);// Strength
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_SUN_FIRE_SHIELD);// Sun
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_TRAVEL_DIMENSION_DOOR);// Travel
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_TRICKERY_CONFUSION);// Trickery
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_WAR_DIVINE_POWER);// War
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_WATER_CONTROL_WATER);// Water
        }
        break;
        case 5:
        {
            // Remove all level 5 domain spells
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_AIR_CONTROL_WINDS);// Air
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_ANIMAL_COMMUNE_WITH_NATURE);// Animal
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_CHAOS_DISPEL_LAW);// Chaos
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_DEATH_SLAY_LIVING);// Death
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_DESTRUCTION_INFLICT_LIGHT_WOUNDS_MASS);// Destruction
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_EARTH_WALL_OF_STONE);// Earth
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_EVIL_DISPEL_GOOD);// Evil
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_FIRE_FIRE_SHIELD);// Fire
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_GOOD_DISPEL_EVIL);// Good
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_HEALING_CURE_LIGHT_WOUNDS_MASS);// Healing
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_KNOWLEDGE_TRUE_SEEING);// Knowledge
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_LAW_DISPEL_CHAOS);// Law
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_LUCK_BREAK_ENCHANTMENT);// Luck
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_MAGIC_SPELL_RESISTANCE);// Magic
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_PLANT_WALL_OF_THORNS);// Plant
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_PROTECTION_SPELL_RESISTANCE);// Protection
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_STRENGTH_RIGHTEOUS_MIGHT);// Strength
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_SUN_FLAME_STRIKE);// Sun
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_TRAVEL_TELEPORT);// Travel
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_TRICKERY_FALSE_VISION);// Trickery
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_WAR_FLAME_STRIKE);// War
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_WATER_ICE_STORM);// Water
        }
        break;
        case 6:
        {
            // Remove all level 6 domain spells
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_AIR_CHAIN_LIGHTNING);// Air
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_ANIMAL_ANTILIFE_SHELL);// Animal
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_CHAOS_ANIMATE_OBJECTS);// Chaos
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_DEATH_CREATE_UNDEAD);// Death
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_DESTRUCTION_HARM);// Destruction
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_EARTH_STONESKIN);// Earth
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_EVIL_CREATE_UNDEAD);// Evil
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_FIRE_FIRE_SEEDS);// Fire
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_GOOD_BLADE_BARRIER);// Good
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_HEALING_HEAL);// Healing
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_KNOWLEDGE_FIND_THE_PATH);// Knowledge
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_LAW_HOLD_MONSTER);// Law
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_LUCK_MISLEAD);// Luck
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_MAGIC_ANTIMAGIC_FIELD);// Magic
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_PLANT_REPEL_WOOD);// Plant
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_PROTECTION_ANTIMAGIC_FIELD);// Protection
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_STRENGTH_STONESKIN);// Strength
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_SUN_FIRE_SEEDS);// Sun
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_TRAVEL_FIND_THE_PATH);// Travel
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_TRICKERY_MISLEAD);// Trickery
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_WAR_BLADE_BARRIER);// War
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_WATER_CONE_OF_COLD);// Water
        }
        break;
        case 7:
        {
            // Remove all level 7 domain spells
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_AIR_CONTROL_WEATHER);// Air
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_ANIMAL_ANIMAL_SHAPES);// Animal
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_CHAOS_WORD_OF_CHAOS);// Chaos
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_DEATH_DESTRUCTION);// Death
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_DESTRUCTION_DISINTEGRATE);// Destruction
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_EARTH_EARTHQUAKE);// Earth
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_EVIL_BLASPHEMY);// Evil
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_FIRE_FIRE_STORM);// Fire
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_GOOD_HOLY_WORD);// Good
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_HEALING_REGENERATE);// Healing
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_KNOWLEDGE_LEGEND_LORE);// Knowledge
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_LAW_DICTUM);// Law
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_LUCK_SPELL_TURNING);// Luck
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_MAGIC_SPELL_TURNING);// Magic
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_PLANT_ANIMATE_PLANTS);// Plant
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_PROTECTION_REPULSION);// Protection
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_STRENGTH_GRASPING_HAND);// Strength
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_SUN_SUNBEAM);// Sun
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_TRAVEL_TELEPORT_GREATER);// Travel
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_TRICKERY_SCREEN);// Trickery
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_WAR_POWER_WORD_BLIND);// War
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_WATER_ACID_FOG);// Water
        }
        break;
        case 8:
        {
            // Remove all level 8 domain spells
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_AIR_WHIRLWIND);// Air
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_ANIMAL_SUMMON_NATURES_ALLY_VII);// Animal
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_CHAOS_CLOAK_OF_CHAOS);// Chaos
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_DEATH_CREATE_GREATER_UNDEAD);// Death
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_DESTRUCTION_EARTHQUAKE);// Destruction
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_EARTH_IRON_BODY);// Earth
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_EVIL_UNHOLY_AURA);// Evil
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_FIRE_INCENDIARY_CLOUD);// Fire
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_GOOD_HOLY_AURA);// Good
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_HEALING_CURE_CRITICAL_WOUNDS_MASS);// Healing
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_KNOWLEDGE_DISCERN_LOCATION);// Knowledge
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_LAW_SHIELD_OF_LAW);// Law
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_LUCK_MOMENT_OF_PRESCIENCE);// Luck
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_MAGIC_PROTECTION_FROM_SPELLS);// Magic
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_PLANT_CONTROL_PLANTS);// Plant
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_PROTECTION_MIND_BLANK);// Protection
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_STRENGTH_CLENCHED_FIST);// Strength
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_SUN_SUNBURST);// Sun
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_TRAVEL_PHASE_DOOR);// Travel
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_TRICKERY_POLYMORPH_ANY_OBJECT);// Trickery
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_WAR_POWER_WORD_STUN);// War
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_WATER_HORRID_WILTING);// Water
        }
        break;
        case 9:
        {
            // Remove all level 9 domain spells
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_AIR_ELEMENTAL_SWARM);// Air
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_ANIMAL_SHAPECHANGE);// Animal
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_CHAOS_SUMMON_MONSTER_IX);// Chaos
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_DEATH_WAIL_OF_THE_BANSHEE);// Death
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_DESTRUCTION_IMPLOSION);// Destruction
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_EARTH_ELEMENTAL_SWARM);// Earth
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_EVIL_SUMMON_MONSTER_IX);// Evil
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_FIRE_ELEMENTAL_SWARM);// Fire
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_GOOD_SUMMON_MONSTER_IX);// Good
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_HEALING_HEAL_MASS);// Healing
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_KNOWLEDGE_FORESIGHT);// Knowledge
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_LAW_SUMMON_MONSTER_IX);// Law
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_LUCK_MIRACLE);// Luck
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_MAGIC_MAGES_DISJUNCTION);// Magic
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_PLANT_SHAMBLER);// Plant
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_PROTECTION_PRISMATIC_SPHERE);// Protection
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_STRENGTH_CRUSHING_HAND);// Strength
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_SUN_PRISMATIC_SPHERE);// Sun
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_TRAVEL_ASTRAL_PROJECTION);// Travel
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_TRICKERY_TIME_STOP);// Trickery
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_WAR_POWER_WORD_KILL);// War
            SMP_DecrementAllRemainingSpellUses(oTarget, SMP_SPELL_DOMAIN_WATER_ELEMENTAL_SWARM);// Water
        }
        break;
    }
}

// This will check if, casting from a spell scroll, they have the correct stats
// to do so.
// Do this before UMD. Returns FALSE if they are using UMD or it was used
// sucessfully, or FALSE if they tried to use it and failed a check or something.
int SMP_SpellScrollCastingCheck(int nSpellId, int nSpellLevel, object oCastItem, int nSpellCastClass, object oCaster = OBJECT_SELF)
{
/*
    To have any chance of activating a scroll spell, the scroll user must meet
    the following requirements.

    * The spell must be of the correct type (arcane or divine). Arcane
      spellcasters (wizards, sorcerers, and bards) can only use scrolls
      containing arcane spells, and divine spellcasters (clerics, druids,
      paladins, and rangers) can only use scrolls containing divine spells.
      (The type of scroll a character creates is also determined by his or her
      class.)
    * The user must have the spell on his or her class list.
    * The user must have the requisite ability score.

    If the user meets all the requirements noted above, and her caster level is
    at least equal to the spell’s caster level, she can automatically activate
    the spell without a check. If she meets all three requirements but her own
    caster level is lower than the scroll spell’s caster level, then she has to
    make a caster level check (DC = scroll’s caster level + 1) to cast the spell
    successfully. If she fails, she must make a DC 5 Wisdom check to avoid a
    mishap (see Scroll Mishaps, below). A natural roll of 1 always fails,
    whatever the modifiers.
*/
    // Is it a scroll?
    if(GetBaseItemType(oCastItem) == BASE_ITEM_SCROLL)
    {
        // No: Not a scroll. Can cast normally.
        return TRUE;
    }

    // Has it any restrictions on class?
    if(!GetItemHasItemProperty(oCastItem, ITEM_PROPERTY_USE_LIMITATION_CLASS))
    {
        // No: Can cast normally
        return TRUE;
    }

    // Do the checks above.
    // Is it on our spell list
    int nClassLevel = SMP_SpellItemHighestLevelActivator(oCastItem, oCaster);
    // If FALSE, we return 0.
    if(nClassLevel == FALSE)
    {
        // No: Using UMD. Can cast normally.
        return TRUE;
    }

    // If the user meets all the requirements noted above, and her caster level is
    // at least equal to the spell’s caster level, she can automatically activate
    // the spell without a check.
    int nScrollLevel = SMP_GetSpellScrollLevel(oCastItem);
    if(nClassLevel >= nScrollLevel)
    {
        // All A-OK, as normal. Can cast normally.
        return TRUE;
    }

    // Else, need a spellcraft check to cast this scroll.

    // If she meets all three requirements but her own caster level is lower
    // than the scroll spell’s caster level, then she has to make a caster
    // level check (DC = scroll’s caster level + 1) to cast the spell successfully.
    int nDC = nScrollLevel + 1;
    if(nClassLevel + d20() >= nDC)
    {
        // All OK. Can cast normally.
        FloatingTextStringOnCreature("*Caster level check for casting a higher level scroll sucessful*", oCaster, FALSE);
        return TRUE;
    }
    // Else, not alright, we must check for random badness
/*
    If she fails, she must make a DC 5 Wisdom check to avoid a mishap (see
    Scroll Mishaps, below). A natural roll of 1 always fails, whatever the
    modifiers.
*/
    // Fail visual
    SMP_ApplyVFX(oCaster, EffectVisualEffect(SMP_VFX_FNF_SPELL_FAIL_HAND));

    // DC 5 Wisdom Check. A 1 auto-fails.
    int n20 = d20();
    if(GetAbilityScore(oCaster, ABILITY_WISDOM) + n20 <= 5 || n20 == 1)
    {
        SendMessageToPC(oCaster, "Wisdom Ability Check: Fail");
/*
    Scroll Mishaps: When a mishap occurs, the spell on the scroll has a reversed
    or harmful effect. Possible mishaps are given below.

    * A surge of uncontrolled magical energy deals 1d6 points of damage per
      spell level to the scroll user.
    * The scroll user suffers some minor but bizarre effect related to the spell
      in some way. Most such effects should last only as long as the original
      spell’s duration, or 2d10 minutes for instantaneous spells.
    * Some innocuous item or items appear in the spell’s area.
*/
        FloatingTextStringOnCreature("*You failed to cast the spell on the scroll, and a mishap happened!*", oCaster, FALSE);
        location lTarget = GetSpellTargetLocation();

        // Randomly determine the effects.
        switch(d4())
        {
            // 1: d6 points per spell level of damage to the scroll user.
            case 1:
            {
                // Do damage
                effect eVis = EffectVisualEffect(VFX_IMP_MIRV);
                SMP_ApplyDamageVFXToObject(oCaster, eVis, d6(nScrollLevel));
            }
            break;
            // 2: Minor but bizarre effect...this case, it is being a visual effect
            case 2:
            {
                effect eDur = EffectVisualEffect(SMP_VFX_DUR_SCROLL_MISHAP);
                float fDuration = SMP_GetRandomDuration(SMP_MINUTES, 10, 2, FALSE);
                SMP_ApplyDuration(oCaster, eDur, fDuration);
            }
            break;
            // "Some innocuous item or items appear in the spell’s area."
            case 3:
            {
                // Create some stuff there.

            }
            break;
            // Some bizarre visual effect at the spells location
            case 4:
            {
                effect eImpact = EffectVisualEffect(SMP_VFX_FNF_SCROLL_MISHAP);
                SMP_ApplyLocationVFX(lTarget, eImpact);
            }
            break;
        }
    }

    // Passed, but cannot use the scroll still!
    SendMessageToPC(oCaster, "Wisdom Ability Check: Pass");
    FloatingTextStringOnCreature("*You failed to cast the spell on the scroll, but no mishap happens*", oCaster, FALSE);

    // Not good. something bad happened. Stop the spell.
    return FALSE;
}

// Returns the level of the spell on the scroll
int SMP_GetSpellScrollLevel(object oScroll)
{
    // Check item properties
    itemproperty IP_Check = GetFirstItemProperty(oScroll);
    while(GetIsItemPropertyValid(IP_Check))
    {
        // Check for the spell on the scroll.
        if(GetItemPropertyType(IP_Check) == ITEM_PROPERTY_CAST_SPELL)
        {
            // only one property for each scroll. First one, return the level.
            // Get it from the 2da file.
            return SMP_ArrayItemCasterLevel(GetItemPropertySubType(IP_Check));
        }
        // Next property
        IP_Check = GetNextItemProperty(oScroll);
    }
    return FALSE;
}

// End of file Debug lines. Uncomment below "/*" with "//" and compile.
/*
void main()
{
    return;
}
//*/
