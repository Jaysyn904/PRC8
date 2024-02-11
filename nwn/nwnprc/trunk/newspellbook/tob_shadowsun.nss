/*
   ----------------
   Shadow Sun Ninja class script

   tob_shadowsun.nss
   ----------------

    18 MAR 09 by GC
*/ /** @file
*/

#include "tob_inc_tobfunc"
#include "tob_inc_recovery"
#include "prc_inc_unarmed"

void main()
{
    object oInitiator = OBJECT_SELF;
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("tob_shadowsun running, event: " + IntToString(nEvent));

    int nClass = GetPrimaryBladeMagicClass(oInitiator);
    int nMoveTotal = GetKnownManeuversModifier(oInitiator, nClass, MANEUVER_TYPE_MANEUVER);
    int nStncTotal = GetKnownManeuversModifier(oInitiator, nClass, MANEUVER_TYPE_STANCE);
    int nRdyTotal = GetReadiedManeuversModifier(oInitiator, nClass);

    int nSSLvl = GetLevelByClass(CLASS_TYPE_SHADOW_SUN_NINJA, oInitiator);
    int nSSBonusMove = (nSSLvl / 3) + (nSSLvl > 0);
    int nSSBonusReady = nSSLvl / 5;
    int nMod;
    
    //Evaluate The Unarmed Strike Feats
    SetLocalInt(oInitiator, CALL_UNARMED_FEATS, TRUE);
    SetLocalInt(oInitiator, CALL_UNARMED_FISTS, TRUE);    

    // We aren't being called from any event, instead from EvalPRCFeats
    if(nEvent == FALSE)
    {
        // Allows gaining of maneuvers by prestige classes
        nMod = nSSBonusMove - GetPersistantLocalInt(oInitiator, "ToBShadowSunNinjaMove");
        if(nMod)
        {
            SetKnownManeuversModifier(oInitiator, nClass, nMoveTotal + nMod, MANEUVER_TYPE_MANEUVER);
            SetPersistantLocalInt(oInitiator, "ToBShadowSunNinjaMove", nSSBonusMove);
            SetPersistantLocalInt(oInitiator, "AllowedDisciplines", 48);//DISCIPLINE_SETTING_SUN + DISCIPLINE_SHADOW_HAND
        }

        if(nSSLvl > 4 && !GetPersistantLocalInt(oInitiator, "ToBShadowSunNinjaStance"))
        {
            SetKnownManeuversModifier(oInitiator, nClass, ++nStncTotal, MANEUVER_TYPE_STANCE);
            SetPersistantLocalInt(oInitiator, "ToBShadowSunNinjaStance", TRUE);
            SetPersistantLocalInt(oInitiator, "AllowedDisciplines", 48);//DISCIPLINE_SETTING_SUN + DISCIPLINE_SHADOW_HAND
        }

        nMod = nSSBonusReady - GetPersistantLocalInt(oInitiator, "ToBShadowSunNinjaReadied");
        if(nMod)
        {
            SetReadiedManeuversModifier(oInitiator, nClass, nRdyTotal + nMod);
            SetPersistantLocalInt(oInitiator, "ToBShadowSunNinjaReadied", nSSBonusReady);
        }

        // Hook to OnLevelDown to remove the maneuver slots granted here
        AddEventScript(oInitiator, EVENT_ONPLAYERLEVELDOWN, "tob_shadowsun", TRUE, FALSE);
    }
    else if(nEvent == EVENT_ONPLAYERLEVELDOWN)
    {
        // Has lost Maneuver, but the slot is still present
        nMod = GetPersistantLocalInt(oInitiator, "ToBShadowSunNinjaMove") - nSSBonusMove;
        if(nMod)
        {
            SetKnownManeuversModifier(oInitiator, nClass, nMoveTotal - nMod, MANEUVER_TYPE_MANEUVER);
            SetPersistantLocalInt(oInitiator, "ToBShadowSunNinjaMove", nSSBonusMove);
        }

        if(nSSLvl < 5 && GetPersistantLocalInt(oInitiator, "ToBShadowSunNinjaStance"))
        {
            SetKnownManeuversModifier(oInitiator, nClass, --nStncTotal, MANEUVER_TYPE_STANCE);
            DeletePersistantLocalInt(oInitiator, "ToBShadowSunNinjaStance");
        }

        nMod = GetPersistantLocalInt(oInitiator, "ToBShadowSunNinjaReadied") - nSSBonusReady;
        if(nMod)
        {
            SetReadiedManeuversModifier(oInitiator, nClass, nRdyTotal - nMod);
            SetPersistantLocalInt(oInitiator, "ToBShadowSunNinjaReadied", nSSBonusReady);
        }

        // Remove eventhook if the character no longer has levels in Eernal Blade
        if(!nSSLvl)
        {
            RemoveEventScript(oInitiator, EVENT_ONPLAYERLEVELDOWN, "tob_shadowsun", TRUE, FALSE);
            DeletePersistantLocalInt(oInitiator, "ToBShadowSunNinjaMove");
            DeletePersistantLocalInt(oInitiator, "ToBShadowSunNinjaReadied");
        }
    }
}