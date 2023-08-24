/*:://////////////////////////////////////////////
//:: Spell Name Heroes’ Feast
//:: Spell FileName PHS_S_HeroesFeas
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Conjuration [Creation]
    Level: Brd 6, Clr 6
    Components: V, S, DF
    Casting Time: 10 minutes
    Range: Close (8M)
    Effect: Feast for one creature/level
    Duration: 1 hour plus 12 hours; see text
    Saving Throw: None
    Spell Resistance: No

    You bring forth a great feast, including a magnificent table, chairs, service,
    and food and drink, with chairs for an amount all party members, or up to
    your caster level. The feast takes 1 hour to consume by sitting in a chair
    for the required time, and the beneficial effects do not set in until this
    hour is over. Every creature partaking of the feast is cured of all diseases,
    sickness, and nausea; becomes immune to poison for 12 hours; and gains 1d8
    temporary hit points +1 point per two caster levels (maximum +10) after
    imbibing the nectar-like beverage that is part of the feast. The ambrosial
    food that is consumed grants each creature that partakes a +1 morale bonus
    on attack rolls and Will saves and immunity to fear effects for 12 hours.

    If the feast is interrupted for any reason, the spell is ruined and all
    effects of the spell are negated.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Special placeables are created:

    - Tables - Must be used by each party member and members must stay within
      the tables (5M).
    - cousins, mats or Chairs are used. Tables change accordingly.

    After an hour, unless any of the placeables are destroyed (uh-oh!) it'll
    do the effects.

    Oh, and this spell has the Delay Command with the stuff in a eDur. Its more
    laggy, probably, but just as good as anything else. It won't do anything
    if oCaster is invalid of course.

    NOT COMPLETE JUST YET.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

// Need to have the right integer set, but it loops all party members (up to
// nCasterLevel) until it finds the amount to heal which still have the integer
// "PHS_FEAST_EATING", which is equal to nCastTimes.
// * Uses nCastTimes to make sure heroes feasts don't overlap. Only one will work.
void DoFeastHealing(object oCaster, int nCasterLevel, int nCastTimes, effect eLink, effect eVis);

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_HEAL)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    // Max to heal is 150
    int nMaxHealHarm = PHS_LimitInteger(nCasterLevel * 10, 150);
    int nTouch;

    // We need to eat for 1 hour
    float fTime = HoursToSeconds(1);

    // More temp HP is 1d8 + 1/2 caster levels
    int nHP = PHS_MaximizeOrEmpower(8, 1, nMetaMagic, nCasterLevel/2);

    // Declare effects
    effect eTempHP = EffectTemporaryHitpoints(nHP);
    effect ePoisonImmune = EffectImmunity(IMMUNITY_TYPE_POISON);
    effect eFearImmune = EffectImmunity(IMMUNITY_TYPE_FEAR);
    effect eWill = EffectSavingThrowIncrease(SAVING_THROW_WILL, 1);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eVis = EffectVisualEffect(VFX_IMP_REMOVE_CONDITION);

    effect eLink = EffectLinkEffects(eTempHP, ePoisonImmune);
    eLink = EffectLinkEffects(eLink, eFearImmune);
    eLink = EffectLinkEffects(eLink, eWill);
    eLink = EffectLinkEffects(eLink, eCessate);

    // Create the placeables


    // We increment the cast times, and make the placeables use this
    int nCastTimes = PHS_IncreaseStoredInteger(oCaster, "PHS_HEROES_FEAST_TIMES_CAST");

    // Delay the feast healing
    DelayCommand(fTime, DoFeastHealing(oCaster, nCasterLevel, nCastTimes, eLink, eVis));

}

// Need to have the right integer set, but it loops all party members (up to
// nCasterLevel) until it finds the amount to heal which still have the integer
// "PHS_FEAST_EATING".
void DoFeastHealing(object oCaster, int nCasterLevel, int nCastTimes, effect eLink, effect eVis)
{
    // Heal PC's
    object oTarget = GetFirstFactionMember(oCaster, TRUE);
    float fDuration = HoursToSeconds(12);
    int nCnt = 0;
    effect eCheck;

    // Loop
    while(GetIsObjectValid(oTarget) && nCnt < nCasterLevel)
    {
        // Must be alive to heal
        if(PHS_GetIsAliveCreature(oTarget) &&
        // Local variable
           GetLocalInt(oTarget, "PHS_FEAST_EATING") == nCastTimes &&
        // Make sure they are not immune to spells
           !PHS_TotalSpellImmunity(oTarget))
        {
            // Remove fatigue
            PHS_RemoveFatigue(oTarget);

            // We remove all the things in a effect loop.
            eCheck = GetFirstEffect(oTarget);
            while(GetIsEffectValid(eCheck))
            {
                // Remove diseases
                if(GetEffectType(eCheck) == EFFECT_TYPE_DISEASE)
                {
                    RemoveEffect(oTarget, eCheck);
                }
                eCheck = GetNextEffect(oTarget);
            }
            // We then apply things
            PHS_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration);
        }
        oTarget = GetNextFactionMember(oCaster, TRUE);
    }
}
