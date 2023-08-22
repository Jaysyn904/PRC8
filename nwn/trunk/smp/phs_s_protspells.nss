/*:://////////////////////////////////////////////
//:: Spell Name Protection from Spells
//:: Spell FileName PHS_S_ProtSpells
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Abjuration
    Level: Magic 8, Sor/Wiz 8
    Components: V, S, M, F
    Casting Time: 1 standard action
    Range: 3.33M
    Targets: Up to one allied creature in a 3.33M-radius centred on the caster
    Duration: 10 min./level
    Saving Throw: Will negates (harmless)
    Spell Resistance: Yes (harmless)

    The subject gains a +8 resistance bonus on saving throws against spells and
    spell-like abilities (but not against supernatural and extraordinary abilities).

    Material Component: A diamond of at least 500 gp value, which must be
    crushed and sprinkled over the targets.

    Focus: One 1,000 gp diamond per creature to be granted the protection. Each
    subject must carry one such gem for the duration of the spell. If a subject
    loses the gem, the spell ceases to affect him.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As the spell. Some modifications to the save functions used for spells
    reduces the save DC's.

    The save functions also check the validness of thier item.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_PROTECTION_FROM_SPELLS)) return;

    // Check for 500GP diamond to use up
    // We use any Diamond Gem which is 500GP or more value
    if(!PHS_ComponentItemGemCheck("Protection from Spells", 500, "Diamond")) return;

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget;
    object oTargetDiamond;
    // 1 creature/4 levels.
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Max creatures to affect
    int nMaxCreatures = PHS_LimitInteger(nCasterLevel/4); // Cannot be 0

    // Note: This does increase by 1 if caster is affected
    int nDoneCreatures = 0;
    int nCnt;

    // 10 Mins/level duration
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel * 10, nMetaMagic);

    // Delcare effects
    effect eVis = EffectVisualEffect(VFX_IMP_MAGIC_PROTECTION);
    effect eDur = EffectVisualEffect(PHS_VFX_DUR_PROTECTION_FROM_SPELLS);

    // Loop all targets without effect nearby. Start with the caster!
    oTarget = oCaster;
    // Loop for 3.33M or 10ft
    while(GetIsObjectValid(oTarget) && nDoneCreatures < nCasterLevel &&
          GetDistanceToObject(oTarget) <= RADIUS_SIZE_FEET_10)
    {
        // Make sure they are in our LOS, are a friend too.
        if((LineOfSightObject(oCaster, oTarget) &&
           (GetIsFriend(oTarget) || GetFactionEqual(oTarget))) ||
           (oTarget == oCaster))
        {
            // Check for any diamond
            oTargetDiamond = PHS_ComponentLowestGemOfValue(1000, "Diamond", oTarget);
            if(GetIsObjectValid(oTargetDiamond))
            {
                // Add one to nDoneCreatures
                nDoneCreatures++;

                // Signal spell cast at event
                PHS_SignalSpellCastAt(oTarget, PHS_SPELL_PROTECTION_FROM_SPELLS, FALSE);

                // Remove previous castings
                PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_PROTECTION_FROM_SPELLS, oTarget);

                // Apply effects
                // - Spell save things take care of the actual modifications of
                //   the spell save DC's according to this spell.
                PHS_ApplyDurationAndVFX(oTarget, eVis, eDur, fDuration);

                // Store the item on the target
                SetLocalObject(oTarget, PHS_STORED_PROT_SPELLS_ITEM, oTargetDiamond);
            }
        }
        // Get next nearest target
        nCnt++;
        oTarget = GetNearestObject(OBJECT_TYPE_CREATURE, oCaster, nCnt);
    }
}
