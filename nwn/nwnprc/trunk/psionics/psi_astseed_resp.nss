//::///////////////////////////////////////////////
//:: Astral Seed: Respawn
//:: psi_inc_augment
//::///////////////////////////////////////////////
/** @file
    The script triggered when a creature that has
    used Astral Seed dies. If the seed still exists,
    the creature is resurrected and transported to
    it's location.
    The creature then spends a day regrowing it's
    body. Since it cannot really be transported
    to the Astral Plane (in NWN), it spends the
    time invulnerable in stasis.


    @author Ornedan
    @date   Created - 2005.12.04
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "psi_inc_psifunc"
#include "prc_inc_switch"

const float JUMP_DELAY = 0.0f; // Testing showed Jump delay works best with lower delay after respawning


void main()
{
    //object oPC   = OBJECT_SELF;   // incorrect use of OBJECT_SELF. 
                                    // From inc_eventhook:  * All the scripts will be ExecuteScripted on OBJECT_SELF, so they will behave as if being in the script slot for that event. *
                                    // Within the death event, OBJECT_SELF is the module, not the PC, so we need to get the PC the same way we would for any death script:

    object oPC   = GetLastPlayerDied();
    object oSeed = GetLocalObject(oPC, "PRC_AstralSeed_SeedObject");

    // If the seed has gotten in the meantime, the PC remains dead
    if(!GetIsObjectValid(oSeed))
    {
        // Added PC notification message
        FloatingTextStringOnCreature("Astral Seed not found: Resurrection failed!", oPC, FALSE);
        return;
    }

    // Resurrect the PC
    effect eRes = EffectResurrection();
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eRes, oPC);

    // Schedule jump to the seed's location
    location lSeed = GetLocation(oSeed);
    DelayCommand(JUMP_DELAY, AssignCommand(oPC, JumpToLocation(lSeed)));

    // Make a composite effect that turns the creature invulnerable and inactive
    effect ePara = EffectCutsceneParalyze();
    effect eGhost = EffectCutsceneGhost();
    effect eInvis = EffectEthereal();
    effect eSpell = EffectSpellImmunity(SPELL_ALL_SPELLS);
    effect eDam1 = EffectDamageImmunityIncrease(DAMAGE_TYPE_ACID, 100);
    effect eDam2 = EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING, 100);
    effect eDam3 = EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 100);
    effect eDam4 = EffectDamageImmunityIncrease(DAMAGE_TYPE_DIVINE, 100);
    effect eDam5 = EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL, 100);
    effect eDam6 = EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, 100);
    effect eDam7 = EffectDamageImmunityIncrease(DAMAGE_TYPE_MAGICAL, 100);
    effect eDam8 = EffectDamageImmunityIncrease(DAMAGE_TYPE_NEGATIVE, 100);
    effect eDam9 = EffectDamageImmunityIncrease(DAMAGE_TYPE_PIERCING, 100);
    effect eDam10 = EffectDamageImmunityIncrease(DAMAGE_TYPE_POSITIVE, 100);
    effect eDam11 = EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING, 100);
    effect eDam12 = EffectDamageImmunityIncrease(DAMAGE_TYPE_SONIC, 100);

    effect eLink = EffectLinkEffects(eSpell, eDam1);
    eLink = EffectLinkEffects(eLink, eDam2);
    eLink = EffectLinkEffects(eLink, eDam3);
    eLink = EffectLinkEffects(eLink, eDam4);
    eLink = EffectLinkEffects(eLink, eDam5);
    eLink = EffectLinkEffects(eLink, eDam6);
    eLink = EffectLinkEffects(eLink, eDam7);
    eLink = EffectLinkEffects(eLink, eDam8);
    eLink = EffectLinkEffects(eLink, eDam9);
    eLink = EffectLinkEffects(eLink, eDam10);
    eLink = EffectLinkEffects(eLink, eDam11);
    eLink = EffectLinkEffects(eLink, eDam12);
    eLink = EffectLinkEffects(eLink, ePara);
    eLink = EffectLinkEffects(eLink, eGhost);
    eLink = EffectLinkEffects(eLink, eInvis);

    eLink = SupernaturalEffect(eLink);

    // Default time is 24 hours
    float fDur = HoursToSeconds(24);

    // Get global flag for respawn delay
    int iDelay = GetPRCSwitch(PRC_PSI_ASTRAL_SEED_RESPAWN_DELAY_X1000);
    if (iDelay < 0)
        fDur =  2.0; // 2 seconds, nearly instant
    else if (iDelay > 0)
        fDur = HoursToSeconds(24)/1000*iDelay; // Divide by 1000, then multiply by value set

    // Apply the effect, with slight delay to allow jump to occur first
    DelayCommand(JUMP_DELAY+0.5, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDur, FALSE));

    // Get global flag for respawn level loss (Default is to lose a level)
    int iNoLevelLoss = GetPRCSwitch(PRC_PSI_ASTRAL_SEED_RESPAWN_NO_LEVEL_LOSS); 

    if (!iNoLevelLoss)
    {
        // Do the level loss
        int nHD = GetHitDice(oPC);
        int nCurrentLevel = ((nHD * (nHD - 1)) / 2) * 1000;
        nHD -= 1;
        int nLevelDown = ((nHD * (nHD - 1)) / 2) * 1000;
        int nNewXP = (nCurrentLevel + nLevelDown)/2;
        SetXP(oPC,nNewXP);
    }

    // Destroy the seed object
    DeleteLocalObject(oPC, "PRC_AstralSeed_SeedObject");
    MyDestroyObject(oSeed);

    // Persistant World death hooks
    ExecuteScript("prc_pw_astralseed", oPC);
    if(GetPRCSwitch(PRC_PW_DEATH_TRACKING) && GetIsPC(oPC))
        SetPersistantLocalInt(oPC, "persist_dead", FALSE);
}
