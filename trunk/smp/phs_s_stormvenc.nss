/*:://////////////////////////////////////////////
//:: Spell Name Storm of Vengance On Heartbeat
//:: Spell FileName PHS_S_StormVenC
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    2nd round: Acid rain, 1d6 damage to everyone in AOE. No save.
    3rd round: 6 bolts of lightning. 6 enemies affected. 10d6 reflex electrcity.
    4th round: Hailstones, for 5d6 points of bludgeoning damage. No save.
    5th to 10th rounds: Speed reduced by 3/4ths, and 20% miss chance.

    No ranged attacks in the cloud. Spells cast within the area are disrupted unless
    the caster succeeds on a Concentration check against a DC equal to the storm
    of vengeance’s save DC + the level of the spell the caster is trying to cast.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As above, really!

    Concentration checks are made here in 2 second delay command heartbeats,
    which are checked for the integer each time in the heartbeat.

    If concentration is broken, the AOE is destroyed.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Check AOE creator
    if(!PHS_CheckAOECreator()) return;

    // Declare major variables
    object oCaster = GetAreaOfEffectCreator();
    object oTarget;
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    float fDelay;
    int nDamage;

    // Get what round this is...we start at 0, obviously (as GetLocalInt returns
    // 0 if it doesn't exsist) so we add one and use that
    int nRound = PHS_IncreaseStoredInteger(OBJECT_SELF, "ROUNDS_DONE", 1);

    // At round 1, we do nothing
    if(nRound == 1)
    {
        return;
    }
    // 2nd round: Acid rain, 1d6 damage to everyone in AOE. No save.
    else if(nRound == 2)
    {
        effect eAcidVis = EffectVisualEffect(VFX_IMP_ACID_S);
        // For lag reasons, only if we get 1 on a d4 do we apply a visual
        oTarget = GetFirstInPersistentObject();
        while(GetIsObjectValid(oTarget))
        {
            // PvP Check
            if(!GetIsReactionTypeFriendly(oTarget, oCaster))
            {
                // Signal event
                PHS_SignalSpellCastAt(oTarget, PHS_SPELL_STORM_OF_VENGEANCE);

                // Random delay
                fDelay = PHS_GetRandomDelay(0.1, 1.0);

                // Spell resistance + Immunity check
                if(!PHS_SpellResistanceCheck(oCaster, oTarget, fDelay))
                {
                    // Do damage, maybe visual - 1d6 acid.
                    if(d4() == 1)
                    {
                        DelayCommand(fDelay, PHS_ApplyDamageVFXToObject(oTarget, eAcidVis, d6(), DAMAGE_TYPE_ACID));
                    }
                    else
                    {
                        DelayCommand(fDelay, PHS_ApplyDamageToObject(oTarget, d6(), DAMAGE_TYPE_ACID));
                    }
                }
            }
            oTarget = GetNextInPersistentObject();
        }
    }
    //3rd round: 6 bolts of lightning. 6 enemies affected. 10d6 reflex electrcity.
    else if(nRound == 3)
    {
        // Get the first 6 enemies to the centre of the AOE.
        effect eVis = EffectVisualEffect(VFX_IMP_LIGHTNING_M);
        int nBolts, nCnt = 1;
        oTarget = GetNearestObject(OBJECT_TYPE_CREATURE, OBJECT_SELF, nCnt);
        while(GetIsObjectValid(oTarget) && nBolts <= 6 &&
              GetIsInSubArea(oTarget, OBJECT_SELF))
        {
            // PvP check
            if(!GetIsReactionTypeFriendly(oTarget, oCaster))
            {
                // Enemy? In our area?
                if(!GetFactionEqual(oTarget, oCaster) && GetIsEnemy(oTarget, oCaster))
                {
                    // Signal event
                    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_STORM_OF_VENGEANCE);

                    // One more bolt
                    nBolts++;

                    // Random delay
                    fDelay = PHS_GetRandomDelay(0.1, 1.0);

                    // Enemy: In our area: We cast a lightning bolt on them
                    if(!PHS_SpellResistanceCheck(oCaster, oTarget, fDelay))
                    {
                        // Damage
                        nDamage = PHS_MaximizeOrEmpower(6, 10, METAMAGIC_NONE);

                        // Reflex damage
                        nDamage = PHS_GetAdjustedDamage(SAVING_THROW_REFLEX, nDamage, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_ELECTRICITY, oCaster);

                        // Do damage (if any)
                        if(nDamage > 0)
                        {
                            DelayCommand(fDelay, PHS_ApplyDamageVFXToObject(oTarget, eVis, nDamage, DAMAGE_TYPE_ELECTRICAL));
                        }
                    }
                }
            }
            // Get next
            nCnt++;
            oTarget = GetNearestObject(OBJECT_TYPE_CREATURE, OBJECT_SELF, nCnt);
        }
    }
    // 4th round: Hailstones, for 5d6 points of bludgeoning damage. No save.
    else if(nRound == 4)
    {
        // Apply hailstone VFX
        effect eAOE = EffectVisualEffect(PHS_VFX_FNF_STORM_VENGANCE_HAIL);
        PHS_ApplyLocationVFX(GetLocation(OBJECT_SELF), eAOE);

        // Loop objects.
        oTarget = GetFirstInPersistentObject();
        while(GetIsObjectValid(oTarget))
        {
            // PvP Check
            if(!GetIsReactionTypeFriendly(oTarget, oCaster))
            {
                // Signal event
                PHS_SignalSpellCastAt(oTarget, PHS_SPELL_STORM_OF_VENGEANCE);

                // Random delay
                fDelay = PHS_GetRandomDelay(0.1, 1.0);

                // Spell resistance + Immunity check
                if(!PHS_SpellResistanceCheck(oCaster, oTarget, fDelay))
                {
                    // Get damage
                    nDamage = PHS_MaximizeOrEmpower(6, 5, METAMAGIC_NONE);

                    // Do damage
                    DelayCommand(fDelay, PHS_ApplyDamageToObject(oTarget, nDamage, DAMAGE_TYPE_BLUDGEONING));
                }
            }
            oTarget = GetNextInPersistentObject();
        }
    }
    // 5th to 10th rounds: Speed reduced by 3/4ths, and 20% miss chance.
    else
    {
        // Apply 6 seconds of these linked effects
        effect eSpeed = EffectMovementSpeedDecrease(75);
        effect eMiss = EffectMissChance(20);
        effect eLink = EffectLinkEffects(eSpeed, eMiss);

        // Loop objects.
        oTarget = GetFirstInPersistentObject();
        while(GetIsObjectValid(oTarget))
        {
            // Signal event
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_STORM_OF_VENGEANCE);

            // Apply effects
            PHS_ApplyDuration(oTarget, eLink, 6.0);

            // Next person
            oTarget = GetNextInPersistentObject();
        }
    }
}
