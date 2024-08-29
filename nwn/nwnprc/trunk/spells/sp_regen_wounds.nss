//::///////////////////////////////////////////////
//:: [Regenerate X Wounds]
//:: [sp_regen_wounds.nss]
//:: [Jaysyn - PRC8 2024-08-29 12:26:52]
//:: 
//:: Handles all Regen X Wounds spells
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
#include "x2_inc_spellhook"
#include "prc_inc_spells"

void main()
{
    //:: Check the Spellhook
    if (!X2PreSpellCastCode()) return;

    //:: Set the Spell School
    PRCSetSchool(GetSpellSchool(PRCGetSpellId()));

    //:: Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();

    int nSpellId = PRCGetSpellId();
    int nMetamagic = PRCGetMetaMagicFeat();
    int nRegenRate = 0;
    int nDuration = 10 + PRCGetCasterLevel(oCaster);  // Duration in rounds
    int nCurrentHP = GetCurrentHitPoints(oTarget);
    int nInitialHP = GetLocalInt(oTarget, "INITIAL_HIT_POINTS");
    
    //:: Update Initial HP if the current HP are higher than the stored Initial HP
    if (nCurrentHP > nInitialHP)
    {
        nInitialHP = nCurrentHP;
        SetLocalInt(oTarget, "INITIAL_HIT_POINTS", nInitialHP);
        if(DEBUG) DoDebug("sp_regen_wounds: Updated Initial HP to " + IntToString(nInitialHP) + ".");
    }

    if (GetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT && GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)
    {
        if(DEBUG) DoDebug("sp_regen_wounds: Initial HP = " + IntToString(nInitialHP) + ".");

        switch (nSpellId)
        {
            case SPELL_REGEN_LIGHT_WOUNDS: 
            {
                nRegenRate = 1; 
                break;
            }
            case SPELL_REGEN_MODERATE_WOUNDS:
            {
                nRegenRate = 2; 
                 break;
            }
            case SPELL_REGEN_SERIOUS_WOUNDS:
            {
                nRegenRate = 3; 
                break;
            }
            case SPELL_REGEN_CRITICAL_WOUNDS:
            {
                nRegenRate = 4; 
                break;
            }
            default: return;
        }

        if (nMetamagic == METAMAGIC_EXTEND)
        {
            nDuration *= 2;
        }

        // Get the current regeneration effect and its duration
        int nCurrentRegen = GetLocalInt(oTarget, "REGEN_RATE");
        int nExistingDuration = 0;
        int bSameSpell = FALSE;

        effect eExisting = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eExisting))
        {
            if (GetEffectTag(eExisting) == "REGEN_WOUNDS")
            {
                if(DEBUG) DoDebug("sp_regen_wounds: Found existing Regeneration effect via EffectTag.");
                if (nCurrentRegen == nRegenRate)
                {
                    bSameSpell = TRUE;
                    if(DEBUG) DoDebug("sp_regen_wounds: Same regeneration spell detected.");
                    nExistingDuration = GetEffectDurationRemaining(eExisting) / 6; // Convert seconds to rounds
                    if(DEBUG) DoDebug("sp_regen_wounds: Existing Duration = " + IntToString(nExistingDuration));
                    if (nRegenRate >= nCurrentRegen)
                    {
                        // Remove existing effect if new spell is stronger
                        RemoveEffect(oTarget, eExisting);
                    }
                    else
                    {
                        // Don't apply weaker spell
                        PRCSetSchool();
                        return;
                    }
                }
                else if (nRegenRate >= nCurrentRegen)
                {
                    // Remove existing effect if new spell is stronger
                    RemoveEffect(oTarget, eExisting);
                }
            }
            eExisting = GetNextEffect(oTarget);
        }

        // Only add the duration if the new spell is the same
        if (bSameSpell)
        {
            nDuration += nExistingDuration;
            if(DEBUG) DoDebug("sp_regen_wounds: Same regeneration spell detected, " + IntToString(nDuration) + " rounds remaining.");
        }

        // Set the new regeneration rate and duration
        SetLocalInt(oTarget, "REGEN_RATE", nRegenRate);
        SetLocalInt(oTarget, "REGEN_WOUNDS_REMAINING", nDuration);

        effect eVis = EffectVisualEffect(1330); //:: VFX_DUR_BF_IOUN_STONE_GREEN
        effect eFakeRegen = EffectRunScript("rs_regen_wounds", "rs_regen_wounds", "rs_regen_wounds", 6.0f, IntToString(nRegenRate));
		
		eFakeRegen = SetEffectSpellId(eFakeRegen, nSpellId);
        eFakeRegen = EffectLinkEffects(eVis, eFakeRegen);
        eFakeRegen = TagEffect(eFakeRegen, "REGEN_WOUNDS");
        
        //:: Remove any old effect & prevent spell stacking
        PRCRemoveEffectsFromSpell(oTarget, nSpellId);

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFakeRegen, oTarget, RoundsToSeconds(nDuration));

    }
    else
    {
        SendMessageToPC(oCaster, "Regenerate Wounds only works on living creatures.");
        //:: Unset the Spell School
        PRCSetSchool();
        return;
    }
}