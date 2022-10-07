/*:://////////////////////////////////////////////
//:: Spell Name Raise Dead
//:: Spell FileName PHS_S_RaiseDead
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Conjuration (Healing)
    Level: Clr 5
    Components: V, S, M, DF
    Casting Time: 1 minute
    Range: Touch
    Target: Dead creature touched
    Duration: Instantaneous
    Saving Throw: None; see text
    Spell Resistance: Yes (harmless)

    You restore life to a deceased creature. You can raise a creature that has
    been dead for no longer than one day per caster level. In addition, the
    subject’s soul must be free and willing to return. If the subject’s soul is
    not willing to return, the spell does not work; therefore, a subject that
    wants to return receives no saving throw.

    Coming back from the dead is an ordeal. The subject of the spell loses one
    level (or 1 Hit Die) when it is raised. If the subject is 1st level, it
    loses all its experience instead. This level/HD loss cannot be repaired by
    any means. A character who died with spells prepared
    has a 50% chance of losing any given spell upon being raised, in addition
    to losing spells for losing a level. A spellcasting creature that doesn’t
    prepare spells (such as a sorcerer) has a 50% chance of losing any given
    unused spell slot as if it had been used to cast a spell, in addition to
    losing spell slots for losing a level.

    A raised creature has a number of hit points equal to its current Hit Dice.
    Any ability damage, poison and disease are cured in the process of raising
    the subject. While the spell closes mortal wounds and repairs lethal damage
    of most kinds, the body of the creature to be raised must be whole.
    Otherwise, the spell fails. None of the dead creature’s equipment or
    possessions are affected in any way by this spell.

    A creature who has been turned into an undead creature or killed by a death
    effect can’t be raised by this spell. Constructs, elementals, outsiders, and
    undead creatures can’t be raised. The spell cannot bring back a creature
    that has died of old age.

    Material Component: Diamonds worth a total of least 5,000 gp.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    This is not too easy without the death system in place.

    The outline will be completed - until the 2 other raising spells (Resurrection,
    True Ressurection) are completed.

    Corpses ideas:
    - Placable corpse created at the time will contain all the players
      items (bar cursed/plot ones, which are skipped by all death scripts)
    - Corpse stored in the database each time something is taken (bar the corpse
      itself, an additional "item", which will basically still store the corpses
      contents, but allow people to move it).
    (Note: Above can be turned off of course)
    - The corpse will be created at an exiting objects location, if they leave
      with a corpse (stupid gits)
    - All corpses are removed On Cleint Enter too.
      - If, On Client Enter, someone comes in and doesn't have a corpse lying
        around, one will be created at an approprate location.

    - The player will be ghostly in limbo. No items. No PvP. No traps.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

// Removes randomly prepared spells.
void RemoveRandomPreparedSpells(object oTarget);

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_RAISE_DEAD)) return;

    // Check material components - 5000GP worth of diamonds
    if(!PHS_ComponentItemGemCheck("Raise Dead", 5000, "Diamond")) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();// Should be a corpse object/dead creature
    object oRaise;
    int bDead = GetIsDead(oTarget);
    int nRace = GetRacialType(oTarget);
    int nHD, nNewXP;

    // Raise effect
    effect eVis = EffectVisualEffect(VFX_IMP_RAISE_DEAD);
    effect eRaise = EffectResurrection();
    effect eHeal;

    // Is it an actual dead body?
    if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
    {
        // Check if dead
        if(bDead == FALSE)
        {
            FloatingTextStringOnCreature("*You cannot raise an alive being*", oCaster, FALSE);
            return;
        }
        else if(nRace == RACIAL_TYPE_CONSTRUCT ||
                nRace == RACIAL_TYPE_ELEMENTAL ||
                nRace == RACIAL_TYPE_OUTSIDER ||
                nRace == RACIAL_TYPE_UNDEAD)
        {
            // Cannot raise these races
            FloatingTextStringOnCreature("*You cannot raise this creature*", oCaster, FALSE);
            return;
        }
        else
        {
            // Raise oTarget
            oRaise = oTarget;
            // Check if they are friendly or not, if not friendly, we cannot
            // raise them
            if(GetIsFriend(oCaster, oRaise) ||
               GetFactionEqual(oCaster, oRaise))
            {
                // Level loss them first
                nHD = PHS_GetCharacterLevel(oRaise);

                // Corpse system can be off.
                if(GetIsPC(oRaise))
                {
                    // Lose a level
                    // We put them back to exactly the point of the last level.
                    // EG: At level 4, we might be between 6000 and 10000 exp.
                    //     We will go instantly down to 3000 XP, the amount
                    //     needed to get to level 3.
                    nNewXP = PHS_GetLevelLossXP(nHD);

                    // Set XP
                    SetXP(oRaise, nNewXP);
                }

                // Signal spell cast at
                PHS_SignalSpellCastAt(oRaise, PHS_SPELL_RAISE_DEAD, FALSE);

                // Raise them
                PHS_ApplyInstantAndVFX(oRaise, eVis, eRaise);
                // Remove randomly prepared spells.
                RemoveRandomPreparedSpells(oTarget);

                // Heal them
                if(nHD >= 2)
                {
                    // Heal them thier HD worth - 1 (because of there being 1 healed
                    // already)
                    eHeal = EffectHeal(nHD - 1);

                    // Apply it
                    PHS_ApplyInstant(oRaise, eHeal);
                }
            }
            else
            {
                // Cannot raise
                FloatingTextStringOnCreature("*Target is not friendly, and thusly is not willing to return to life*", oCaster, FALSE);
            }
        }
    }
    else //if(GetObjectType(oTarget) == OBJECT_TYPE_PLACABLE)
    {
        // Corpse object
        // Check tag
        if(GetTag(oTarget) == "CORPSE")
        {
            // Get object to raise
            oRaise = GetLocalObject(oTarget, "TO_RAISE");

            // Level loss them first
            nHD = PHS_GetCharacterLevel(oRaise);

            // Lose a level
            // We put them back to exactly the point of the last level.
            // EG: At level 4, we might be between 6000 and 10000 exp.
            //     We will go instantly down to 3000 XP, the amount
            //     needed to get to level 3.
            nNewXP = PHS_GetLevelLossXP(nHD);

            // Set XP
            SetXP(oRaise, nNewXP);

            // Signal spell cast at
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_RAISE_DEAD, FALSE);

            // Move them from limbo
            AssignCommand(oRaise, PHS_ForceMovementToLocation(GetLocation(oTarget), VFX_IMP_RAISE_DEAD, VFX_IMP_RAISE_DEAD));
            // Remove randomly prepared spells.
            RemoveRandomPreparedSpells(oTarget);

            // Heal them
            if(nHD >= 2)
            {
                // Heal them thier HD worth - 1 (because of there being 1 healed
                // already)
                eHeal = EffectHeal(nHD - 1);

                // Apply it
                PHS_ApplyInstant(oRaise, eHeal);
            }
        }
    }
}

// Removes randomly prepared spells.
void RemoveRandomPreparedSpells(object oTarget)
{
    // Tell oTarget
    FloatingTextStringOnCreature("*You feel a drain on your power, possibly some of your prepared spells have depissitated*", oTarget, FALSE);

    // NOTE ON BARDS/SORCERORS!
    // This will probably remove all of thier spells - they can have, for example,
    // 6 spells to cast up to 6 times. This will loop all 6 spells, and if there
    // are any castings left, will do the 50% chance. This is kinda bad...but
    // I am tired right now, might change later.

    int nCnt1, nCnt2;
    // Loop all spells
    for(nCnt1 = 0; nCnt1 <= PHS_SPELLS_2DA_MAX_ENTRY; nCnt1++)
    {
        for(nCnt2 = GetHasSpell(nCnt1, oTarget); nCnt2 > 0; nCnt2--)
        {
            // 50% chance of losing that prepared spell.
            if(d2() == 1)
            {
                DecrementRemainingSpellUses(oTarget, nCnt1);
            }
        }
    }
}
