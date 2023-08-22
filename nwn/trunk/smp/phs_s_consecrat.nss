/*:://////////////////////////////////////////////
//:: Spell Name Consecrate
//:: Spell FileName PHS_S_Consecrat
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Evocation [Good]
    Level: Clr 2
    Components: V, S, M, DF
    Casting Time: 1 standard action
    Range: Close (8M)
    Area: 6.67-M.-radius emanation
    Duration: 2 hours/level
    Saving Throw: None
    Spell Resistance: No

    This spell blesses an area with positive energy. Each Charisma check made to
    turn undead within this area gains a +3 sacred bonus. Every undead creature
    entering a consecrated area suffers minor disruption, giving it a -1 penalty
    on attack rolls, damage rolls, and saves. Undead cannot be created within or
    summoned into a consecrated area.

    Consecrate counters and dispels desecrate.

    Material Component: A vial of holy water and 25 gp worth (5 pounds) of silver
    dust, all of which must be sprinkled around the area.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    It removes the "alter or thingy to thier god for bonuses" and stuff, 'cause
    it is too complicated otherwise (and utterly pointless in most cases).

    Oh, in here, if there is a desecrate AOE within the range of 6.67M of the
    target location, we apply the VFX impact, and just destroy it (or them).

    Effects applied OnEnter, and removed OnExit.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_CONSECRATE)) return;

    // Declare major variables
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int bStop = FALSE;

    // Need holy water and silver dust. Need both!
    if(!PHS_ComponentExactItemRemove(PHS_ITEM_HOLY_WATER, "Holy Water", "Consecrate")) return;

    if(!PHS_ComponentExactItemRemove(PHS_ITEM_SILVER_DUST_25, "Silver Dust", "Consecrate")) return;

    // Duration in hours
    float fDuration = PHS_GetDuration(PHS_HOURS, nCasterLevel * 2, nMetaMagic);

    // Declare effects
    effect eAOE = EffectAreaOfEffect(PHS_AOE_PER_CONSECRATE);
    effect eImpact = EffectVisualEffect(VFX_FNF_STRIKE_HOLY);

    // Apply impact VFX
    PHS_ApplyLocationVFX(lTarget, eImpact);

    // Are we going to remove desecrate AOE's instead?
    int nCnt = 1;
    object oAOE = GetNearestObjectToLocation(OBJECT_TYPE_AREA_OF_EFFECT, lTarget, nCnt);
    // Distance and validity check
    while(GetIsObjectValid(oAOE) &&
          GetDistanceBetweenLocations(lTarget, GetLocation(oAOE)) <= 6.67)
    {
        // Check for desecrate
        if(GetTag(oAOE) == PHS_AOE_TAG_PER_DESECRATE)
        {
            // Destroy and not do anything else
            DestroyObject(oAOE);
            bStop = TRUE;
        }
        nCnt++;
        oAOE = GetNearestObjectToLocation(OBJECT_TYPE_AREA_OF_EFFECT, lTarget, nCnt);
    }

    if(bStop != TRUE)
    {
        // Apply effects
        PHS_ApplyLocationDuration(lTarget, eAOE, fDuration);
    }
}
