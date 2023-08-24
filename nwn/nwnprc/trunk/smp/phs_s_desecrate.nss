/*:://////////////////////////////////////////////
//:: Spell Name Desecrate
//:: Spell FileName PHS_S_Desecrate
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Evocation [Evil]
    Level: Clr 2, Evil 2
    Components: V, S, M, DF
    Casting Time: 1 standard action
    Range: Close (8M)
    Area: 6.67-M.-radius emanation
    Duration: 2 hours/level
    Saving Throw: None
    Spell Resistance: Yes

    This spell imbues an area with negative energy. Each Charisma check made to
    turn undead within this area takes a -3 profane penalty, and every undead
    creature entering a desecrated area gains a +1 profane bonus on attack rolls,
    damage rolls, and saving throws. An undead creature created within or
    summoned into such an area gains +1 hit points per HD.

    Furthermore, anyone who casts animate dead within this area may create as
    many as double the normal amount of undead (that is, 4 HD per caster level
    rather than 2 HD per caster level).

    Desecrate counters and dispels consecrate.

    Material Component: A vial of unholy water and 25 gp worth (5 pounds) of
    silver dust, all of which must be sprinkled around the area.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As concetrate for the most part.

    Applies effects On Enter and removes On Exit. The summoning scripts for undead
    have the special bonus HP thing.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_DESECRATE)) return;

    // Declare major variables
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int bStop = FALSE;

    // Need holy water and silver dust
    if(!PHS_ComponentExactItemRemove(PHS_ITEM_CURSED_WATER, "Cursed (Unholy) Water", "Desecrate")) return;

    if(!PHS_ComponentExactItemRemove(PHS_ITEM_SILVER_DUST_25, "Silver Dust", "Consecrate")) return;

    // Duration in hours
    float fDuration = PHS_GetDuration(PHS_HOURS, nCasterLevel * 2, nMetaMagic);

    // Declare effects
    effect eAOE = EffectAreaOfEffect(PHS_AOE_PER_DESECRATE);
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_EVIL_20);

    // Apply AOE visual
    PHS_ApplyLocationVFX(lTarget, eImpact);

    // Are we going to remove desecrate AOE's instead?
    int nCnt = 1;
    object oAOE = GetNearestObjectToLocation(OBJECT_TYPE_AREA_OF_EFFECT, lTarget, nCnt);
    // Distance and validity check
    while(GetIsObjectValid(oAOE) &&
          GetDistanceBetweenLocations(lTarget, GetLocation(oAOE)) <= 6.67)
    {
        // Check for consecrate
        if(GetTag(oAOE) == PHS_AOE_TAG_PER_CONSECRATE)
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
