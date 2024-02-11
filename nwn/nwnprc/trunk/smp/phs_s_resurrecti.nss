/*:://////////////////////////////////////////////
//:: Spell Name Resurrection
//:: Spell FileName PHS_S_Resurrecti
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Conjuration (Healing)
    Level: Clr 7
    Components: V, S, M, DF
    Casting Time: 10 minutes
    Range: Touch
    Target: Dead creature touched
    Duration: Instantaneous
    Saving Throw: None; see text
    Spell Resistance: Yes (harmless)

    This spell functions like raise dead, except that you are able to restore
    life and complete strength to any deceased creature.

    The condition of the remains is not a factor. So long as some small portion
    of the creature’s body still exists, it can be resurrected, but the portion
    receiving the spell must have been part of the creature’s body at the time
    of death. (The remains of a creature hit by a disintegrate spell count as a
    small portion of its body.).

    Upon completion of the spell, the creature is immediately restored to full
    hit points, vigor, and health, with no loss of prepared spells. However,
    the subject loses one level, or all experience if the subject was 1st level.
    This level loss cannot be repaired by any means.

    You can resurrect someone killed by a death effect or someone who has been
    turned into an undead creature and then destroyed. You cannot resurrect
    someone who has died of old age. Constructs, elementals, outsiders, and
    undead creatures can’t be resurrected.

    Material Component: A sprinkle of holy water and diamonds worth a total of
    at least 10,000 gp.
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

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_RESSURECTION)) return;

    // Check material components - 10000GP worth of diamonds
    if(!PHS_ComponentItemGemCheck("Ressurection", 10000, "Diamond")) return;

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
                PHS_SignalSpellCastAt(oRaise, PHS_SPELL_RESSURECTION, FALSE);

                // Raise them
                PHS_ApplyInstantAndVFX(oRaise, eVis, eRaise);

                // Heal them
                if(nHD >= 2)
                {
                    // Heal them thier HP worth
                    eHeal = EffectHeal(GetMaxHitPoints(oTarget));

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
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_RESSURECTION, FALSE);

            // Move them from limbo
            AssignCommand(oRaise, PHS_ForceMovementToLocation(GetLocation(oTarget), VFX_IMP_RAISE_DEAD, VFX_IMP_RAISE_DEAD));

            // Heal them
            if(nHD >= 2)
            {
                // Heal them all thier HP worth
                eHeal = EffectHeal(GetMaxHitPoints(oTarget));

                // Apply it
                PHS_ApplyInstant(oRaise, eHeal);
            }
        }
    }
}
