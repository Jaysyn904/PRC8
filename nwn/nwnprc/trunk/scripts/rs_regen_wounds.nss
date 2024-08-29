//::///////////////////////////////////////////////
//:: [Regenerate X Wounds]
//:: [rs_regen_wounds.nss]
//:: [Jaysyn - PRC8 2024-08-29 12:26:40]
//:: 
//:: RunScript for Regeneration effect
//::
//::///////////////////////////////////////////////
/**@file Regenerate X Wounds
(Masters of the Wild: A Guidebook to Barbarians, 
Druids, and Rangers)

Conjuration (Healing)
Level: Cleric 1-4, Druid 1-4,
Components: V, S,
Casting Time: 1 action
Range: Touch
Target: Living creature touched
Duration: 10 rounds + 1 round/level
Saving Throw: Will negates (harmless)
Spell Resistance: Yes (harmless)

With a touch of your hand, you boost the subject's 
life energy, granting him or her the fast healing 
ability for the duration of the spell.

This healing applies only to damage sustained during 
the spell's duration, not to that from previous injuries.

The subject heals 1 hit point per round of such 
damage until the spell ends and is automatically stabilized 
if he or she begins dying from hit point loss during that time.

Regenerate light wounds does not restore hit points lost from 
starvation, thirst, or suffocation, nor does it allow a creature 
to regrow or attach lost body parts.

The effects of multiple regenerate spells do not stack, only 
the highest-level effect applies.

Applying a second regenerate spell of equal level extends the 
first spell's duration by the full duration of the second spell.

*//////////////////////////////////////////////////
#include "prc_inc_spells"

void ControlledRegeneration(object oTarget, int nRegenRate)
{
    int nCurrentHP = GetCurrentHitPoints(oTarget);
    int nInitialHP = GetLocalInt(oTarget, "INITIAL_HIT_POINTS");

    if(DEBUG) DoDebug("rs_regen_wounds > ControlledRegeneration: Initial HP = " + IntToString(nInitialHP) + ".");
    if(DEBUG) DoDebug("rs_regen_wounds > ControlledRegeneration: Current HP = " + IntToString(nCurrentHP) + ".");

    if (nCurrentHP < nInitialHP)
    {
        int nHealAmount = min(nRegenRate, nInitialHP - nCurrentHP); // Ensure not to heal beyond the initial hit points
        if(DEBUG) DoDebug( "rs_regen_wounds > ControlledRegeneration: Healing " + IntToString(nHealAmount) + " HP.");
        effect eFakeRegen = EffectHeal(nHealAmount);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eFakeRegen, oTarget);

        effect eVis = EffectVisualEffect(VFX_DUR_GLOW_LIGHT_GREEN);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 6.0f); // Temporary visual effect
    }
}

void main()
{
    // Get the event type
    int nEvent = GetLastRunScriptEffectScriptType();
    // Get original effect
    effect eOriginal = GetLastRunScriptEffect();
    // Get creator
    object oCaster = GetEffectCreator(eOriginal);
    // Get healing amount from sData
    int nHealing = StringToInt(GetEffectString(eOriginal, 0));
    // Target is OBJECT_SELF, needed for AssignCommand later
    object oTarget = OBJECT_SELF;

    // We apply healing on the start and interval scripts
    switch(nEvent)
    {
        case RUNSCRIPT_EFFECT_SCRIPT_TYPE_ON_APPLIED:
        case RUNSCRIPT_EFFECT_SCRIPT_TYPE_ON_INTERVAL:
        {
            // Apply Healing
            ControlledRegeneration(oTarget, nHealing);
        }
        break;
        case RUNSCRIPT_EFFECT_SCRIPT_TYPE_ON_REMOVED:
        {
            // Cessate
            effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCessate, oTarget, 0.1);
        }
        break;
    }
}