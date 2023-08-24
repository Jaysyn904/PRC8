/*:://////////////////////////////////////////////
//:: Script Name Positive Energy Plane - Major - Heartbeat
//:: Script FileName PHS_OT_PosiPlMaj
//:://////////////////////////////////////////////
//:: File Notes
//:://////////////////////////////////////////////
    Major Positive Energy Plane heartbeat. For those unlucky enough to get here...

    Description:

    Positive-Dominant: An abundance of life characterizes planes with this trait.
    The two kinds of positive-dominant traits are minor positive-dominant and
    major positive-dominant.

    A minor positive-dominant plane is a riotous explosion of life in all its
    forms. Colors are brighter, fires are hotter, noises are louder, and
    sensations are more intense as a result of the positive energy swirling
    through the plane. All individuals in a positive-dominant plane gain fast
    healing 2 as an extraordinary ability.

    Major positive-dominant planes go even further. A creature on a major
    positive-dominant plane must make a DC 15 Fortitude save to avoid being
    blinded for 10 rounds by the brilliance of the surroundings. Simply being
    on the plane grants fast healing 5 as an extraordinary ability. In addition,
    those at full hit points gain 5 additional temporary hit points per round.
    These temporary hit points fade 1d20 rounds after the creature leaves the
    major positive- dominant plane. However, a creature must make a DC 20
    Fortitude save each round that its temporary hit points exceed its normal
    hit point total. Failing the saving throw results in the creature exploding
    in a riot of energy, killing it.

    Despite the beneficial effects of the plane, it is one of the most hostile
    of the Inner Planes. An unprotected character on this plane swells with
    power as positive energy is force-fed into her. Then, her mortal frame
    unable to contain that power, she immolates as if she were a small planet
    caught at the edge of a supernova. Visits to the Positive Energy Plane
    are brief, and even then travelers must be heavily protected.

    Basically:
    - Heals 5HP per round.
    - If at full health, provides 5HP bonus in temp HP.
    - Saving throw based on how many temp HP bonuses are applied from this
      area object.
    - Temp HP is only added for 1d20 rounds, as per the description (Yes, it is
      permanent in this realm, but it is hard to remove it otherwise!)
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Loop all objects in the area. DMs excepted.
    object oTarget = GetFirstObjectInArea(OBJECT_SELF);

    if(!GetIsObjectValid(oTarget)) return;

    // Healing and Temp HP effect. Same VFX for each.
    effect eVis = EffectVisualEffect(VFX_IMP_HEALING_G);
    effect eHeal = EffectHeal(5);
    effect eHP = EffectTemporaryHitpoints(5);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = SupernaturalEffect(EffectLinkEffects(eHP, eDur));
    effect eBlind = SupernaturalEffect(EffectBlindness());
    float fDuration;

    // Loop all objects in the area. DMs excepted.
    while(GetIsObjectValid(oTarget))
    {
        // Is it a creature? (Not a DM)
        if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE &&
           PHS_CanCreatureBeDestroyed(oTarget))
        {
            // Are they dead? If yes, ignore.
            if(!GetIsDead(oTarget))
            {
                // DC 15 fortitude save for blindness for 10 rounds, if not
                // already blinded or otherwise.
                if(PHS_GetCanSee(oTarget))
                {
                    // Temp HP, and save for death.
                    // Save first:
                    if(!PHS_NotSpellSavingThrow(SAVING_THROW_FORT, oTarget, 15, SAVING_THROW_TYPE_POSITIVE))
                    {
                        // Fortitude save: Death
                        SendMessageToPC(oTarget, "You are blinded for 10 rounds due to the brilliance of the positive plane.");

                        // Duration of 10 rounds
                        fDuration = PHS_GetDuration(PHS_ROUNDS, 10, FALSE);
                        PHS_ApplyDurationAndVFX(oTarget, eVis, eBlind, fDuration);
                    }
                }

                // Heal if below max HP
                if(GetCurrentHitPoints(oTarget) < GetMaxHitPoints(oTarget))
                {
                    // Tell them
                    SendMessageToPC(oTarget, "You are healed with massive positive energy flowing through your body.");

                    // Apply healing effect
                    PHS_ApplyInstantAndVFX(oTarget, eVis, eHeal);
                }
                else
                {
                    // Temp HP, and save for death.
                    // Save first:
                    if(!PHS_NotSpellSavingThrow(SAVING_THROW_FORT, oTarget, 20, SAVING_THROW_TYPE_POSITIVE))
                    {
                        // Fortitude save: Death
                        SendMessageToPC(oTarget, "Your body explodes in a massive burst of positive energy.");
                        PHS_ApplyDeathByDamageAndVFX(oTarget, eVis, DAMAGE_TYPE_POSITIVE);
                    }
                    else
                    {
                        // Temp HP addition
                        SendMessageToPC(oTarget, "You gain temporary hit points with massive positive energy flowing through your body.");

                        // Duration of 1d20 rounds
                        fDuration = PHS_GetRandomDuration(PHS_ROUNDS, 20, 1, FALSE);
                        PHS_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration);
                    }
                }
            }
        }
        // Get next object
        oTarget = GetNextObjectInArea(OBJECT_SELF);
    }
}
