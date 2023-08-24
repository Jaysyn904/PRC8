/*:://////////////////////////////////////////////
//:: Spell Name Prismatic Sphere: Normal On Enter
//:: Spell FileName PHS_S_PrisSpherA
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Changes include the fact it won't do all 7 effects, it is affected by dispel
    magic normally, it has a duration (might extend it higher, its a level 7
    spell).

    It still is immobile, and does blindness normally too (a second AOE)

    How does the spell stopping work?

    Well, it will add a new check into the spell hook. If we cast a spell
    into the AOE's location (can use GetNearestObjectByTag() and distance check)
    but we are not ourselves in it, it will fail.

    Ranged weapons have 100% miss chance from both inside and outside (100%
    concealment + 100% miss chance applied on enter, whatever).
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

// Applies the effect determined by nDiceRoll, onto oTarget with nSpellSaveDC,
// using oCaster as the caster of the spell. Used in all Prismatic spells.
// * nDiceRoll 1-7 (8 is ignored as par description).
// * Use fDelay to state a delay for the effects to be applied.
// Make sure SR checks are done before this is called.
void ApplyPrismaticEffect(int nDiceRoll, object oTarget, float fDelay, int nMetaMagic, int nSpellSaveDC, object oCaster = OBJECT_SELF);

void main()
{
    // Check AOE
    if(!PHS_CheckAOECreator()) return;

    // Declare major variables
    object oTarget = GetEnteringObject();
    object oCaster = GetAreaOfEffectCreator();
    int nMetaMagic = PHS_GetAOEMetaMagic();
    int nSpellSaveDC = PHS_GetAOESpellSaveDC();

    // Check if oCaster isn't oTarget
    if(oCaster == oTarget) return;

    // We make sure it isn't at the start.
    if(GetLocalInt(oCaster, PHS_MOVING_BARRIER_START + IntToString(PHS_SPELL_PRISMATIC_SPHERE))) return;

    // Declare major effects that are always applied
    effect eConseal = EffectConcealment(100, MISS_CHANCE_TYPE_VS_RANGED);
    effect eMiss = EffectMissChance(100, MISS_CHANCE_TYPE_VS_RANGED);

    // Link
    effect eLink = EffectLinkEffects(eConseal, eMiss);

    // Fire cast spell at event for the target
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_PRISMATIC_SPHERE);

    // Always apply these effects
    PHS_AOE_OnEnterEffects(eLink, oTarget, PHS_SPELL_PRISMATIC_SPHERE);

    // Now, prismatic effects

    // PvP Check
    if(!GetIsReactionTypeFriendly(oTarget, oCaster) &&
    // Make sure they are not immune to spells
       !PHS_TotalSpellImmunity(oTarget))
    {
        // Check spell resistance
        if(!PHS_SpellResistanceCheck(oCaster, oTarget))
        {
            // Determine if 1 or 2 effects are going to be applied
            int nRandom = d8();
            if(nRandom == 8)
            {
                // Apply 2 different colors
                ApplyPrismaticEffect(d8(), oTarget, 0.0, nMetaMagic, nSpellSaveDC, oCaster);
                ApplyPrismaticEffect(d8(), oTarget, 0.0, nMetaMagic, nSpellSaveDC, oCaster);
            }
            else
            {
                // Apply 1 color
                ApplyPrismaticEffect(nRandom, oTarget, 0.0, nMetaMagic, nSpellSaveDC, oCaster);
            }
        }
    }
}

// Applies the effect determined by nDiceRoll, onto oTarget with nSpellSaveDC,
// using oCaster as the caster of the spell. Used in all Prismatic spells.
// * nDiceRoll 1-7 (8 is ignored as par description).
// * Use fDelay to state a delay for the effects to be applied.
// Make sure SR checks are done before this is called.
void ApplyPrismaticEffect(int nDiceRoll, object oTarget, float fDelay, int nMetaMagic, int nSpellSaveDC, object oCaster = OBJECT_SELF)
{
    int nRoll;
    effect eVis;
    switch(nDiceRoll)
    {
//    1   Red     20 points fire damage (Reflex half)
        case 1:
        {
            // Get damage via. save.
            nRoll = PHS_GetAdjustedDamage(SAVING_THROW_REFLEX, 20, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_FIRE, oCaster);

            // Do damage
            if(nRoll > 0)
            {
                eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
                DelayCommand(fDelay, PHS_ApplyDamageVFXToObject(oTarget, eVis, nRoll, DAMAGE_TYPE_FIRE));
            }
        }
        break;
//    2   Orange  40 points acid damage (Reflex half)
        case 2:
        {
            // Get damage via. save.
            nRoll = PHS_GetAdjustedDamage(SAVING_THROW_REFLEX, 40, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_ACID, oCaster);

            // Do damage
            if(nRoll > 0)
            {
                eVis = EffectVisualEffect(VFX_IMP_ACID_S);
                DelayCommand(fDelay, PHS_ApplyDamageVFXToObject(oTarget, eVis, nRoll, DAMAGE_TYPE_ACID));
            }
        }
        break;
//    3   Yellow  80 points electricity damage (Reflex half)
        case 3:
        {
            // Get damage via. save.
            nRoll = PHS_GetAdjustedDamage(SAVING_THROW_REFLEX, 80, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_ELECTRICITY, oCaster);

            // Do damage
            if(nRoll > 0)
            {
                eVis = EffectVisualEffect(VFX_IMP_LIGHTNING_M);
                DelayCommand(fDelay, PHS_ApplyDamageVFXToObject(oTarget, eVis, nRoll, DAMAGE_TYPE_ELECTRICAL));
            }
        }
        break;
//    4   Green   Poison (Kills; Fortitude partial, take 1d6 points of Con damage instead)
        case 4:
        {
            // Posion immunity
            if(PHS_ImmunityCheck(oTarget, IMMUNITY_TYPE_POISON, fDelay, oCaster))
            {
                eVis = EffectVisualEffect(VFX_IMP_POISON_S);
                // Fortitude save
                if(PHS_SavingThrow(SAVING_THROW_FORT, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_POISON, oCaster))
                {
                    // Apply some con damage
                    nRoll = PHS_MaximizeOrEmpower(6, 1, nMetaMagic);
                    effect ePoison = EffectAbilityDecrease(ABILITY_CONSTITUTION, nRoll);
                    PHS_ApplyPermanentAndVFX(oTarget, eVis, ePoison);
                }
                else
                {
                    // Death via. damage
                    DelayCommand(fDelay, PHS_ApplyDeathByDamageAndVFX(oTarget, eVis));
                }
            }
        }
        break;
//    5   Blue    Turned to stone (Fortitude negates)
        case 5:
        {
            // Turned to stone via. the function in PHS_INC_SPELL
            // * Take caster level as 20, this is meant to be pretty harsh anyway.
            PHS_SpellFortitudePetrify(oTarget, 20, nSpellSaveDC);
        }
        break;
//    6   Indigo  Insane, as insanity spell (Will negates)
        case 6:
        {
            // Will negates
            if(!PHS_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_MIND_SPELLS, oCaster, fDelay))
            {
                // Insanity, eh? Supernatural, permament, Confusion
                // Declare effects - Confusion
                eVis = EffectVisualEffect(PHS_VFX_IMP_INSANITY);
                effect eDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
                effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
                effect eConfusion = EffectConfused();
                effect eLink = EffectLinkEffects(eConfusion, eDur);
                eLink = EffectLinkEffects(eLink, eCessate);

                // Make it a supernatural effect
                // - Cannot be dispelled
                // - Cannot be removed VIA sleep
                eLink = SupernaturalEffect(eLink);

                // Apply the effect
                PHS_ApplyPermanentAndVFX(oTarget, eVis, eLink);
            }
        }
        break;
//    7   Violet  Sent to another plane (Will negates)
        case 7:
        {
            // Send to another plane, eh?

            // The location will be set as the tagged waypoint "PHS_PRISMATIC_PLANE"
            object oWP = GetWaypointByTag("PHS_PRISMATIC_PLANE");

            if(GetIsObjectValid(oWP))
            {
                location lTarget = GetLocation(oWP);

                // We must force them to move. We remove all movement stoppers and
                // thusly move them.
                eVis = EffectVisualEffect(VFX_IMP_UNSUMMON);
                // Move them
                if(fDelay > 0.1)
                {
                    // Use special function for the "teleporting"
                    // Some delay
                    DelayCommand(fDelay - 0.1, AssignCommand(oTarget, PHS_ForceMovementToLocation(lTarget, VFX_IMP_UNSUMMON, VFX_FNF_SUMMON_MONSTER_3)));
                }
                else
                {
                    // No delay
                    AssignCommand(oTarget, PHS_ForceMovementToLocation(lTarget, VFX_IMP_UNSUMMON, VFX_FNF_SUMMON_MONSTER_3));
                }
            }
        }
        break;
//    8   Struck by two colors; roll twice more, ignoring any “8” results.
        case 8:
        {
            return;
        }
        break;
    }
}
