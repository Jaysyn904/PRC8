/*

    prc_spellfire_hb.nss - Spellfire heartbeat functions go here, for when
        stored spellfire levels > CON, runs every round

    notes: data stored as persistant local ints

    By: Flaming_Sword
    Created: December 18, 2005
    Modified: December 18, 2005

*/

#include "prc_alterations"
#include "prc_spellf_inc"

void main()
{
    object oPC = OBJECT_SELF;
    //sanity check - should probably kill the thread, but...
    if(!GetHasFeat(FEAT_SPELLFIRE_WIELDER, oPC)) return;

    int nOverflow;
    string sMessage;
    int nStored = GetPersistantLocalInt(oPC, "SpellfireLevelStored");
    if(DEBUG) DoDebug("CheckSpellfire: " + IntToString(nStored) + " levels", oPC);
    int nCON = GetAbilityScore(oPC, ABILITY_CONSTITUTION);

    int nTimerMax = 0;   //For timer
    int nTimer = GetLocalInt(oPC, "SpellfireTimer");
    SetLocalInt(oPC, "SpellfireTimer", nTimer + 1);

    int nCap = ((GetLevelByClass(CLASS_TYPE_SPELLFIRE, oPC) + 1) / 2) + 1;
    if(nCap > 5) nCap = 5;
    int nMax = nCON * nCap;
    if(DEBUG) DoDebug("CheckSpellfire: Maximum " + IntToString(nMax), oPC);

    //time functions, spellfire channeler, go here

    if(nStored > nMax)
    {
        nOverflow = nStored - nMax;
        object oTarget = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE, oPC, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN);
        if((oTarget == OBJECT_INVALID) || (GetDistanceBetween(oPC, oTarget) > 40.0))   //no nearby targets, discharge on self
        {
            sMessage = "Spellfire levels stored exceeds maximum, discharging excess at self!";
            oTarget = oPC;
        }
        else
        {
            sMessage = "Spellfire levels stored exceeds maximum, discharging excess at " + GetName(oTarget) + "!";
        }
        ClearAllActions(TRUE);
        //ActionCastFakeSpellAtObject(SPELL_SPELLFIRE_ATTACK, oTarget);
        SetPersistantLocalInt(oPC, "SpellfireLevelStored", nMax);
        //SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_SPELLFIRE, oCaster, BODY_NODE_HAND, !nRoll), oTarget, 1.2);
        /*ActionDoCommand(*/SpellfireAttackRoll(oPC, oTarget, nOverflow, 0, 20, TRUE)/*)*/;
    }
    else if(nStored > 4 * nCON) //every round
        nTimerMax = 1;
    else if(nStored > 3 * nCON) //every minute
        nTimerMax = 10;                                     //every 10 rounds
    else if(nStored > 2 * nCON) //every hour
        nTimerMax = FloatToInt(HoursToSeconds(1) / 6.0);    //hour length set by module
    else if(nStored > nCON)     //every day
        nTimerMax = FloatToInt(HoursToSeconds(1)) * 4;      //dependent upon hour length

    if(nTimerMax && (nTimer >= nTimerMax))
    {
        if(d20() + GetAbilityModifier(ABILITY_CONSTITUTION, oPC) < 10)
        {
            nStored--;
            SetPersistantLocalInt(oPC, "SpellfireLevelStored", nStored);
            SpellfireAttackRoll(oPC, oPC, 1);
        }
        if(nTimerMax == 1 && !PRCMySavingThrow(SAVING_THROW_WILL, oPC, 25))
        {
            object oTarget = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE, oPC, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN);
            if((oTarget == OBJECT_INVALID) || (GetDistanceBetween(oPC, oTarget) > 10.0))   //no nearby targets, discharge on self
            {
                sMessage = "Will save failed! Maximum strength blast directed at self!";
                oTarget = oPC;
            }
            else
            {
                sMessage = "Will save failed! Maximum strength blast directed at " + GetName(oTarget) + "!";
            }
            ClearAllActions();
            //ActionCastFakeSpellAtObject(SPELL_SPELLFIRE_ATTACK, oTarget);
            SetPersistantLocalInt(oPC, "SpellfireLevelStored", 0);
            //SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_SPELLFIRE, oCaster, BODY_NODE_HAND, !nRoll), oTarget, 1.2);
            /*ActionDoCommand(*/SpellfireAttackRoll(oPC, oTarget, nStored, 0, 20, TRUE)/*)*/;    //OUCH!
        }
        DeleteLocalInt(oPC, "SpellfireTimer");
    }

    if(GetLocalInt(oPC, "SpellfireCrown"))  //crown of fire heartbeat
    {
        if(nStored < 10)
        {
            DeleteLocalInt(oPC, "SpellfireCrown");
            PRCRemoveEffectsFromSpell(oPC, SPELL_SPELLFIRE_CROWN);
            FloatingTextStringOnCreature("*Crown of Fire Failed*", oPC);
        }
        else
        {
            SetPersistantLocalInt(oPC, "SpellfireLevelStored", nStored - 10);   //10/round
        }
    }

    if(GetIsPC(oPC) && sMessage != "")
        SendMessageToPC(oPC, sMessage);
}