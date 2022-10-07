/*:://////////////////////////////////////////////
//:: Spell Name Status
//:: Spell FileName PHS_S_Status
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Divination
    Level: Clr 2
    Components: V, S
    Casting Time: 1 standard action
    Range: Touch
    Targets: One living party member per three levels within 10M (30ft)
    Duration: 1 hour/level
    Saving Throw: Will negates (harmless)
    Spell Resistance: Yes (harmless)

    When you need to keep track of comrades who may get separated, status allows
    you to mentally monitor their relative positions and general condition. You
    are aware of direction and distance to the creatures and any conditions
    affecting them: unharmed, wounded, disabled, staggered, unconscious, dying,
    nauseated, panicked, stunned, poisoned, diseased, confused, or the like.
    Once the spell has been cast upon the subjects, the distance between them
    and the caster does not affect the spell as long as they are on the same
    plane of existence. If a subject leaves the plane, or if it dies, the spell
    ceases to function for it. The spell reports the status of allies once
    every 15 seconds.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Puts the effects on each party member within 10M (up to 1 per 3 caster
    levels) and then does a 15 second delayed check on party members for the
    spells effect. If it is cast again, the originals are lost.

    Anyone who dies (and thusly will lose the good visual effect on them) or
    gets it dispelled, will be ignored and removed from the array.

    Anyone in another plane (explicitly Maze and so on) will be removed from the
    array and the spell effect removed.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

const string ARRAY_NAME = "PHS_STATUS_ARRAY";

// You are aware of direction and distance to the creatures and any conditions
// affecting them: unharmed, wounded, disabled, staggered, unconscious, dying,
// nauseated, panicked, stunned, poisoned, diseased, confused, or the like.
struct StatusOfPerson
{
    // Status'
    int Poison;
    int Panicked;
    int Stunned;
    int Diseased;
    int Confused;
    int Paralyzed;
    int Stone;
    int Cursed;
    int Deaf;
    int Blind;
    // Wounds
    int Unharmed;
    int Wounded;
    int Dying;
    int Dead;
};

// Runs a check for the caster so they know what is going on for thier allies.
void StatusCheck(object oCaster, int nTimesCast);

// Do status check for the members of oCaster's party, using bPCOnly to check the
// correct stuff in GetFirstFactionMember(), thusly called twice.
void StatusOfParty(object oCaster, int bPCOnly);

// Gets the status of oPerson with integers returned.
struct StatusOfPerson GetStatusOfPerson(object oCreature);

void main()
{
    // Spell hook check.
    if(PHS_SpellHookCheck(PHS_SPELL_STATUS)) return;

    // Define ourselves.
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lSelf = GetLocation(oCaster);
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    float fDelay;
    int nMaxTargets = PHS_LimitInteger(nCasterLevel/3);
    int nCnt = 0;

    // Duration - 1 hour/level
    float fDuration = PHS_GetDuration(PHS_HOURS, nCasterLevel, nMetaMagic);

    // Declare effects
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_HOLY);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eCasterDur = EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT);

    // AOE visual applied.
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_HOLY_30);
    PHS_ApplyLocationVFX(lSelf, eImpact);

    // Add one to times cast
    int nTimesCast = PHS_IncreaseStoredInteger(oCaster, "PHS_STATUS_TIMES_CAST");

    // Remove this spells effect from all party members
    // * PC's then NPC's.
    PHS_RemoveSpellEffectsFromFactionCaster(PHS_SPELL_STATUS, oCaster, oCaster, TRUE);
    PHS_RemoveSpellEffectsFromFactionCaster(PHS_SPELL_STATUS, oCaster, oCaster, FALSE);

    // Loop allies - and apply the effects. AOE is 30ft, 10M
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_FEET_30, lSelf);
    while(GetIsObjectValid(oTarget) && nCnt < nMaxTargets)
    {
        // Only affects party members (and a special case for ourselves)
        if((GetFactionEqual(oTarget, oCaster) || oTarget == oCaster) &&
        // Make sure they are not immune to spells
           !PHS_TotalSpellImmunity(oTarget))
        {
            // Fire cast spell at event for the specified target
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_STATUS, FALSE);

            // One more target done
            nCnt++;

            // Remove previous effects from this spell (of course, you cannot
            // be in 2 parties at once! Sorts dispel problems mainly). Only
            // remove spell effects from this caster!
            PHS_RemoveSpellEffects(PHS_SPELL_STATUS, oCaster, oTarget);

            // Check if us
            if(oTarget == oCaster)
            {
                // Apply visual effect to us, a special one.
                PHS_ApplyDuration(oTarget, eCasterDur, fDuration);
            }
            else
            {
                // Delay for visuals and effects.
                fDelay = GetDistanceBetween(oCaster, oTarget)/20;

                // Apply normal cessate to track oTarget.
                DelayCommand(fDelay, PHS_ApplyVFX(oTarget, eVis));
                PHS_ApplyDuration(oTarget, eDur, fDuration);
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_FEET_30, lSelf);
    }
    // Do first 15 second heartbeat
    StatusCheck(oCaster, nTimesCast);
}

// Runs a check for the caster so they know what is going on for thier allies.
void StatusCheck(object oCaster, int nTimesCast)
{
    // Make sure we don't stop
    if(!GetIsObjectValid(oCaster) ||
       !GetHasSpellEffect(PHS_SPELL_STATUS, oCaster) ||
        GetLocalInt(oCaster, "PHS_STATUS_TIMES_CAST") != nTimesCast ||
        GetIsDead(oCaster))
    {
        PHS_RemoveSpellEffects(PHS_SPELL_STATUS, oCaster, oCaster);
        // Stop
        return;
    }

    // We check for the spell effect on party members (NPC and PC!) in any area
    // apart from different planes.
    SendMessageToPC(oCaster, "Status Check:");

    // PC's status'
    StatusOfParty(oCaster, TRUE);
    // NPC's status'
    StatusOfParty(oCaster, FALSE);

    // Delay another check
    DelayCommand(15.0, StatusCheck(oCaster, nTimesCast));
}

// Do status check for the members of oCaster's party, using bPCOnly to check the
// correct stuff in GetFirstFactionMember(), thusly called twice.
void StatusOfParty(object oCaster, int bPCOnly)
{
    // Declare stuff
    string sAffictions = "";
    struct StatusOfPerson Status;
    int nSize;

    // Get first party member
    object oParty = GetFirstFactionMember(oCaster, bPCOnly);
    while(GetIsObjectValid(oParty))
    {
        // Got the spells effects from oCaster?
        if(PHS_GetHasSpellEffectFromCaster(PHS_SPELL_STATUS, oParty, oCaster) &&
          !GetIsDead(oParty))
        {
            // If not in our plane, remove the status visuals
            if(!PHS_CheckIfSamePlane(GetLocation(oCaster), GetLocation(oParty)))
            {
                // Remove the spells effects
                PHS_RemoveSpellEffects(PHS_SPELL_STATUS, oCaster, oParty);
            }
            else
            {
                // Add on what stuff oParty has
                Status = GetStatusOfPerson(oParty);

                // Check if dead

                // Sort out sAffictions total.
                sAffictions = "Status of " + GetName(oParty) + " is that they are: ";
                nSize = GetStringLength(sAffictions);

                // Add them all as we see them
                if(Status.Poison == TRUE)
                {
                    sAffictions += "poisoned, ";
                }
                if(Status.Panicked == TRUE)
                {
                    sAffictions += "panicked, ";
                }
                if(Status.Stunned == TRUE)
                {
                    sAffictions += "stunned, ";
                }
                if(Status.Confused == TRUE)
                {
                    sAffictions += "confused, ";
                }
                if(Status.Paralyzed == TRUE)
                {
                    sAffictions += "paralyzed, ";
                }
                if(Status.Stone == TRUE)
                {
                    sAffictions += "turned to stone, ";
                }
                if(Status.Cursed == TRUE)
                {
                    sAffictions += "cursed, ";
                }
                if(Status.Deaf == TRUE)
                {
                    sAffictions += "deaf, ";
                }
                if(Status.Blind == TRUE)
                {
                    sAffictions += "blind, ";
                }
                // If we havn't added anything, we don't add "and ". However, if
                // we have added anything to sAffictions, we add a "and " to make
                // it look correct. EG:
                // "Status of George is that they are: unharmed"
                // "Status of George is that they are: blind, and wounded"
                // "Status of George is that they are: turned to stone, cursed, and unharmed"
                if(nSize != GetStringLength(sAffictions))
                {
                    // Add "and"
                    sAffictions += "and ";
                }
                // Do wounded status
                if(Status.Dying == TRUE)
                {
                    sAffictions += "dying.";
                }
                else if(Status.Wounded == TRUE)
                {
                    sAffictions += "wounded.";
                }
                // Must be unharmed!
                else //if(Status.Unharmed == TRUE)
                {
                    sAffictions += "unharmed.";
                }
                // Send message
                SendMessageToPC(oCaster, sAffictions);
            }
        }
        // Get next member
        oParty = GetNextFactionMember(oCaster, bPCOnly);
    }
}

// Gets the status of oPerson with integers returned.
struct StatusOfPerson GetStatusOfPerson(object oCreature)
{
    // Return structure
    struct StatusOfPerson Return;

    // Loop effects
    effect eCheck = GetFirstEffect(oCreature);
    while(GetIsEffectValid(eCheck))
    {
        // Check type of effect
        switch(GetEffectType(eCheck))
        {
            // Status'
            case EFFECT_TYPE_POISON:
                Return.Poison = TRUE;
            break;
            case EFFECT_TYPE_FRIGHTENED:
            case EFFECT_TYPE_TURNED:
                Return.Panicked = TRUE;
            break;
            case EFFECT_TYPE_STUNNED:
                Return.Stunned = TRUE;
            break;
            case EFFECT_TYPE_DISEASE:
                Return.Diseased = TRUE;
            break;
            case EFFECT_TYPE_CONFUSED:
                Return.Confused = TRUE;
            break;
            case EFFECT_TYPE_PARALYZE:
                Return.Paralyzed = TRUE;
            break;
            case EFFECT_TYPE_PETRIFY:
                Return.Stone = TRUE;
            break;
            case EFFECT_TYPE_CURSE:
                Return.Cursed = TRUE;
            break;
            case EFFECT_TYPE_DEAF:
                Return.Deaf = TRUE;
            break;
            case EFFECT_TYPE_BLINDNESS:
                Return.Blind = TRUE;
            break;
        }
        eCheck = GetNextEffect(oCreature);
    }
    // Wounds
    int nHP = GetCurrentHitPoints(oCreature);
    int nMaxHP = GetMaxHitPoints(oCreature);
    // Set variables
    if(nHP >= nMaxHP)
    {
        Return.Unharmed = TRUE;
    }
    else if(nHP > 0)
    {
        Return.Wounded = TRUE;
    }
    else if(nHP > -10)
    {
        Return.Dying = TRUE;
    }
    else
    {
        Return.Dead = TRUE;
    }
    // Return Return ( ;-) )
    return Return;
}
