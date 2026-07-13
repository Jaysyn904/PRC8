//;:
//:: cv_limited_wish
//::
#include "inc_dynconv"
#include "inv_inc_invfunc" 
 
// Stage constants
const int STAGE_MAIN = 0;
 
// Choice value constants
const int CHOICE_WIZ6_ALLOWED   = 1;
const int CHOICE_OTHER5_ALLOWED = 2;
const int CHOICE_WIZ5_BANNED    = 3;
const int CHOICE_OTHER4_BANNED  = 4;
const int CHOICE_WARLOCK_INV    = 5;
const int CHOICE_UNDO_HARM      = 6;
 
void BuildMainMenu(object oPC)
{
    SetHeader(
        "A limited wish lets you create nearly any type of effect. " +
        "What would you wish for?",
        oPC
    );
    AddChoice("Duplicate a sorcerer/wizard spell of 6th level or lower (allowed school).",
              CHOICE_WIZ6_ALLOWED, oPC);
    AddChoice("Duplicate any other spell of 5th level or lower (allowed school).",
              CHOICE_OTHER5_ALLOWED, oPC);
    AddChoice("Duplicate a sorcerer/wizard spell of 5th level or lower (even prohibited school).",
              CHOICE_WIZ5_BANNED, oPC);
    AddChoice("Duplicate any other spell of 4th level or lower (even prohibited school).",
              CHOICE_OTHER4_BANNED, oPC);
    AddChoice("Duplicate a warlock invocation of Greater grade or lower.",
              CHOICE_WARLOCK_INV, oPC);
    AddChoice("Remove all harmful status effects from your person.",
              CHOICE_UNDO_HARM, oPC);
}
 
void main()
{
    object oPC    = GetPCSpeaker();
    int    nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);
    int    nStage = GetStage(oPC);
 
    if (nValue == 0) return;
 
    // -------------------------------------------------------
    // SETUP STAGE: build UI, called before rendering
    // -------------------------------------------------------
    if (nValue == DYNCONV_SETUP_STAGE)
    {
        if (!GetIsStageSetUp(nStage, oPC))
        {
            if (nStage == STAGE_MAIN)
            {
                BuildMainMenu(oPC);
                MarkStageSetUp(nStage, oPC);
                SetDefaultTokens();
            }
        }
        SetupTokens(oPC);
        return;
    }
 
    // -------------------------------------------------------
    // EXITED / ABORTED
    // -------------------------------------------------------
    if (nValue == DYNCONV_EXITED || nValue == DYNCONV_ABORTED)
    {
        DeleteLocalInt(oPC, "LW_WishType");
        DeleteLocalInt(oPC, "LW_InvMaxGrade");
        return;
    }
 
    // -------------------------------------------------------
    // PLAYER MADE A CHOICE
    // -------------------------------------------------------
    int nChoice = GetChoice(oPC);
 
    switch (nChoice)
    {
        case CHOICE_WIZ6_ALLOWED:
        {
            SetLocalInt(oPC, "LW_WishType", CHOICE_WIZ6_ALLOWED);
            BranchDynamicConversation(
                "sp_lw_spellpick",
                STAGE_MAIN,
                DYNCONV_EXIT_ALLOWED_SHOW_CHOICE,
                FALSE,
                oPC);
            return;
        }
        case CHOICE_OTHER5_ALLOWED:
        {
            SetLocalInt(oPC, "LW_WishType", CHOICE_OTHER5_ALLOWED);
            BranchDynamicConversation(
                "sp_lw_spellpick",
                STAGE_MAIN,
                DYNCONV_EXIT_ALLOWED_SHOW_CHOICE,
                FALSE,
                oPC);
            return;
        }
        case CHOICE_WIZ5_BANNED:
        {
            SetLocalInt(oPC, "LW_WishType", CHOICE_WIZ5_BANNED);
            BranchDynamicConversation(
                "sp_lw_spellpick",
                STAGE_MAIN,
                DYNCONV_EXIT_ALLOWED_SHOW_CHOICE,
                FALSE,
                oPC);
            return;
        }
        case CHOICE_OTHER4_BANNED:
        {
            SetLocalInt(oPC, "LW_WishType", CHOICE_OTHER4_BANNED);
            BranchDynamicConversation(
                "sp_lw_spellpick",
                STAGE_MAIN,
                DYNCONV_EXIT_ALLOWED_SHOW_CHOICE,
                FALSE,
                oPC);
            return;
        }
        case CHOICE_WARLOCK_INV:
        {
            SetLocalInt(oPC, "LW_WishType",    CHOICE_WARLOCK_INV);
            SetLocalInt(oPC, "LW_InvMaxGrade", 3);
            BranchDynamicConversation(
                "sp_lw_invpick",
                STAGE_MAIN,
                DYNCONV_EXIT_ALLOWED_SHOW_CHOICE,
                FALSE,
                oPC);
            return;
        }
        case CHOICE_UNDO_HARM:
        {
            // Strip negative magical effects
            effect e = GetFirstEffect(oPC);
            while (GetIsEffectValid(e))
            {
                if (GetEffectSubType(e) == SUBTYPE_MAGICAL)
                {
                    switch (GetEffectType(e))
                    {
                        case EFFECT_TYPE_ABILITY_DECREASE:
                        case EFFECT_TYPE_AC_DECREASE:
                        case EFFECT_TYPE_ATTACK_DECREASE:
                        case EFFECT_TYPE_BLINDNESS:
                        case EFFECT_TYPE_CHARMED:
                        case EFFECT_TYPE_CONFUSED:
                        case EFFECT_TYPE_CURSE:
                        case EFFECT_TYPE_DAMAGE_DECREASE:
                        case EFFECT_TYPE_DAZED:
                        case EFFECT_TYPE_DEAF:
                        case EFFECT_TYPE_DISEASE:
                        case EFFECT_TYPE_DOMINATED:
                        case EFFECT_TYPE_ENTANGLE:
                        case EFFECT_TYPE_FRIGHTENED:
                        case EFFECT_TYPE_MOVEMENT_SPEED_DECREASE:
                        case EFFECT_TYPE_NEGATIVELEVEL:
                        case EFFECT_TYPE_PARALYZE:
                        case EFFECT_TYPE_PETRIFY:
                        case EFFECT_TYPE_POISON:
                        case EFFECT_TYPE_SAVING_THROW_DECREASE:
                        case EFFECT_TYPE_SILENCE:
                        case EFFECT_TYPE_SKILL_DECREASE:
                        case EFFECT_TYPE_SLOW:
                        case EFFECT_TYPE_SPELL_FAILURE:
                        case EFFECT_TYPE_STUNNED:
                        case EFFECT_TYPE_TURNED:
                            RemoveEffect(oPC, e);
                            break;
                    }
                }
                e = GetNextEffect(oPC);
            }
 
            // VFX — dispel burst on the caster
            ApplyEffectToObject(DURATION_TYPE_INSTANT,
                EffectVisualEffect(VFX_IMP_DISPEL),
                oPC);
            ApplyEffectToObject(DURATION_TYPE_INSTANT,
                EffectVisualEffect(VFX_IMP_RESTORATION),
                oPC);
 
            FloatingTextStringOnCreature("All harmful status effects have been removed.", oPC, FALSE);
 
            // Close the conversation
			SetXP(oPC, GetXP(oPC) - 300);
            AllowExit(DYNCONV_EXIT_FORCE_EXIT, FALSE, oPC);
            return;
        }
	}
}