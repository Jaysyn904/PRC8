/*:://////////////////////////////////////////////
//:: Spell Name Dimension Door
//:: Spell FileName PHS_S_DimenDoor
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Conjuration (Teleportation)
    Level: Brd 4, Sor/Wiz 4, Travel 4
    Components: V
    Casting Time: 1 standard action
    Range: Long (40M)
    Target: You and allied willing creatures
    Duration: Instantaneous
    Saving Throw: None and Will negates (object)
    Spell Resistance: No and Yes (object)

    You instantly transfer yourself from your current location to any other spot
    within range. You always arrive at exactly the spot desired-whether by simply
    visualizing the area or by stating direction. After using this spell, you
    can’t take any other actions until your next turn. You may also bring one
    additional willing Medium or smaller creature or its equivalent per three
    caster levels. A Large creature counts as two Medium creatures, a Huge
    creature counts as two Large creatures, and so forth. All creatures to be
    transported must be within 5M of the caster, and doing nothing to be
    considered people to teleport.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Like teleport, but this is simpler - it is just a JumpToLocation to the
    place.

    Note: Teleport can be disabled if the creature is in a "No teleport" box,
    or attempts to jump into one, or the area is a "no teleport" area.

    Could do with a door visual like BG2

    The caster is always moved. Then, each creature within 5M (nearest to futhest)
    and making sure the size is right, gets moved too at the same time. Visuals
    are applied for each one, and JumpToLocation is used.

    They must not be in combat, however.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_DIMENSION_DOOR)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    location lTarget = GetSpellTargetLocation();
    location lCaster = GetLocation(oCaster);
    int nCasterLevel = PHS_GetCasterLevel();
    object oParty;
    int nPartySize, nCnt, nTotalSizesGot;

    // 1 medium other creature per 3 caster levels
    int nTotalSizesLimit = PHS_LimitInteger(nCasterLevel/3);

    // Duration is 1 round
    float fDuration = RoundsToSeconds(1);

    // Declare effects
    effect eDissappear = EffectVisualEffect(PHS_VFX_IMP_DIMENSION_DOOR_DISS);
    effect eAppear = EffectVisualEffect(PHS_VFX_IMP_DIMENSION_DOOR_APPR);

    // Duration effect for stopping the caster do anything else
    effect eDur = EffectCutsceneImmobilize();

    // Make sure we can teleport
    if(!PHS_CannotTeleport(oCaster, lTarget))
    {
        // Jump to the target location with visual effects
        PHS_ApplyLocationVFX(lCaster, eDissappear);
        PHS_ApplyLocationVFX(lTarget, eAppear);

        // Jump
        DelayCommand(1.0, JumpToLocation(lTarget));

        // Get party members
        nCnt = 1;
        oParty = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_FRIEND, oCaster, nCnt);
        while(GetIsObjectValid(oParty) &&
              GetDistanceToObject(oParty) < 5.0 &&
              nTotalSizesGot < nTotalSizesLimit)
        {
            // - Faction equal check
            // - Make sure the creature is not doing anything
            // - Not got the dimension stopping effects
            if(GetFactionEqual(oParty) &&
               GetCurrentAction(oParty) == ACTION_INVALID &&
              !PHS_GetDimensionalAnchor(oParty) &&
               GetCommandable(oParty))
            {
                // Check size
                nPartySize = PHS_GetSizeModifier(oParty);

                // Makes sure we can currently teleport the creature
                if(nPartySize + nTotalSizesGot < nTotalSizesLimit)
                {
                    AssignCommand(oParty, JumpToLocation(lTarget));
                    // Add amount to what we jumped with us
                    nTotalSizesGot += nPartySize;
                }
            }
            nCnt++;
            oParty = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_FRIEND, oCaster, nCnt);
        }
        // Caster cannot move for 1 round now.
        DelayCommand(1.5, SendMessageToPC(oCaster, "You cannot perform any more actions for 1 round due to the casting of Dimension Door"));
        DelayCommand(2.0, PHS_ApplyDuration(oCaster, eDur, fDuration));
    }
}
