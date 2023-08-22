/*:://////////////////////////////////////////////
//:: Spell Name Prismatic Wall: On Enter
//:: Spell FileName PHS_S_PrisWallA
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As it stated above.

    Simplified a lot. It now doesn't stop spells or missiles (ugly!) but will
    do th effects of each thing On Enter - ugly!

    This is still powerful (very much so) for the level.
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
    int nCnt;
    float fDelay;

    // Check if oCaster isn't oTarget
    if(oCaster == oTarget) return;

    // We make sure it isn't at the start.
    if(GetLocalInt(oCaster, PHS_MOVING_BARRIER_START + IntToString(PHS_SPELL_PRISMATIC_WALL))) return;

    // Now, prismatic effects - in order!

    // PvP Check
    if(!GetIsReactionTypeFriendly(oTarget, oCaster) &&
    // Make sure they are not immune to spells
       !PHS_TotalSpellImmunity(oTarget))
    {
        // Fire cast spell at event for the target
        PHS_SignalSpellCastAt(oTarget, PHS_SPELL_PRISMATIC_WALL);

        // Loop possible effects
        for(nCnt = 1; nCnt <= 7; nCnt++)
        {
            // Add 0.05 to the delay
            fDelay += 0.05;

            // Check spell resistance
            if(!PHS_SpellResistanceCheck(oCaster, oTarget, fDelay))
            {
                // Apply the new color
                ApplyPrismaticEffect(d8(), oTarget, fDelay, nMetaMagic, nSpellSaveDC, oCaster);
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
