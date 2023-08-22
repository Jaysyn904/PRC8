/*:://////////////////////////////////////////////
//:: Name AOE Include
//:: FileName SMP_INC_AOE
//:://////////////////////////////////////////////
//:: Notes
//:://////////////////////////////////////////////
    This is just a set of AOE include functions, used in many AOE's.

    Special:

    - Effects apply On Enter are not added each time a new one is entered, and
      do not stack (why would you get more consealment just because of more gas
      if the original has a lot of gas?)

    - Generic On Enter, and On Exit functions are used to apply the effects,
      and remove them once the exit ALL AOE's

//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_REMOVE"
#include "SMP_INC_CONSTANT"
#include "SMP_INC_RESIST"

// SMP_INC_AOE. Assigns a debug string to the Area of Effect Creator
void SMP_AssignAOEDebugString(string sString);
// SMP_INC_AOE. Mobile AOE check.
// * If the AOE is moving, then the caster get the spell removed.
// * Use On Enter - with a 0.1 second delay.
void SMP_MobileAOECheck(object oCaster, int nSpellID, vector vBefore, object oAreaBefore);
// SMP_INC_AOE. Mobile AOE check - Repulsion
// * If the AOE is moving, then the caster get the spell removed.
// * Use On Enter - with a 0.1 second delay.
// Note: This will only make the local SMP_MOVING_BARRIER_START + nSpellID add
// 1 for 3 seconds, then reduce by 1.
void SMP_MobileRepulsionAOECheck(object oCaster, int nSpellID, vector vBefore, object oAreaBefore);
// SMP_INC_AOE. Increase or decrease a stored integer on oTarget, by
// nAmount, under sName
// * No return value. Used in SMP_MobileRepulsionAOECheck() mainly.
void SMP_MobileRepulsionSetInteger(object oTarget, string sName, int nAmount);

// SMP_INC_AOE. This will add counter set to nSpellId, on oTarget, and if they
// have not got any effects from the spell already, apply eLink to the target.
// * Makes eLink Supernatural, to stop dispelling and resting, as it is removed OnExit.
//   * Because of it applying supernatural effects, it will only check for nSpellId
//     which are permament and supernatural, else apply eLink normally.
void SMP_AOE_OnEnterEffects(effect eLink, object oTarget, int nSpellId);
// SMP_INC_AOE. Applies SMP_AOE_OnEnterEffects(), with eVis.
// * Will also apply eVis if it doesn't have nSpellId on it.
void SMP_AOE_OnEnterEffectsVFX(effect eLink, object oTarget, effect eVis, int nSpellId);
// SMP_INC_AOE.
// This will take 1 off oTarget's "AOe's of nSpellId's we are affected with".
// - At 0, it will remove all of nSpellId's effects.
// - If not got any of nSpellID's effects, deletes the local
// * Only removes supernatural effects, IE: Those applied via. the OnEnter version of this.
void SMP_AOE_OnExitEffects(int nSpellId);
// SMP_INC_AOE. As SMP_AOE_OnExitEffects(), however, it will also always
// apply eAfter for fDuration as a normal effect, thus it won't matter and isn't
// picked up by the On Enter version, or removed by futher On Exit calls.
void SMP_AOE_OnExitEffectsPersistant(int nSpellId, effect eAfter, float fDuration);

// SMP_INC_AOE. Functions like a normal effect loop. However, it will only return TRUE if
// they have nSpellId, have it as a supernatural, permament effect of some kind.
int SMP_GetHasAOEEffects(int nSpellId, object oTarget);

// SMP_INC_AOE. Get the caster level of an AOE (Being OBJECT_SELF). Stores in a local for futher use.
int SMP_GetAOECasterLevel(object oAOE = OBJECT_SELF);

// SMP_INC_AOE. Returns FALSE if there is no AOE creator and the object is destroyed.
// * bDead - If TRUE, it will check GetIsDead(oCreator) with the same results.
// - Only put this ON ENTER and ON HEARTBEAT
int SMP_CheckAOECreator(int bDead = FALSE);

// SMP_INC_AOE. Get the spell save DC of an AOE (Being OBJECT_SELF). Stores in a local for futher use.
int SMP_GetAOESpellSaveDC();

// SMP_INC_AOE. Returns the meta magic feat associated with the spell. Stores in a local for futher use.
int SMP_GetAOEMetaMagic();

// SMP_INC_AOE. Returns TRUE if oAOE's tag is one of a fire spell.
int SMP_GetIsFireyAOE(object oAOE);

//Assigns a debug string to the Area of Effect Creator
void SMP_AssignAOEDebugString(string sString)
{
    object oTarget = GetAreaOfEffectCreator();
    AssignCommand(oTarget, SpeakString(sString));
}

// Mobile AOE check.
// * If the AOE is moving, then the caster get the spell removed.
// * Use On Enter.
void SMP_MobileAOECheck(object oCaster, int nSpellID, vector vBefore, object oAreaBefore)
{
    // If now the caster has changed its location, or area, it means he was moving (as
    // this is delayed by 0.1 seconds)
    if(GetArea(oCaster) != oAreaBefore ||
       vBefore != GetPosition(oCaster) ||
       GetCurrentAction(oCaster) == ACTION_MOVETOPOINT)
    {
        SendMessageToPC(oCaster, "You are moving, and cannot force a barrier onto someone, so it collapses");
        SMP_RemoveSpellEffectsFromTarget(nSpellID, oCaster);
    }
}
// SMP_INC_AOE. Mobile AOE check - Repulsion
// * If the AOE is moving, then the caster get the spell removed.
// * Use On Enter - with a 0.1 second delay.
// Note: This will only make the local SMP_MOVING_BARRIER_START + nSpellID add
// 1 for 3 seconds, then reduce by 1.
void SMP_MobileRepulsionAOECheck(object oCaster, int nSpellID, vector vBefore, object oAreaBefore)
{
    // If now the caster has changed its location, or area, it means he was moving (as
    // this is delayed by 0.1 seconds)
    if(GetArea(oCaster) != oAreaBefore ||
       vBefore != GetPosition(oCaster) ||
       GetCurrentAction(oCaster) == ACTION_MOVETOPOINT)
    {
        SendMessageToPC(oCaster, "You are moving. Your barrier has stopped working for a few seconds.");
        // Increase by 1
        string sName = SMP_MOVING_BARRIER_START + IntToString(nSpellID);
        SMP_MobileRepulsionSetInteger(oCaster, sName, 1);
        // Delay a reduction by 1
        DelayCommand(3.0, SMP_MobileRepulsionSetInteger(oCaster, sName, -1));
    }
}

// SMP_INC_AOE. Increase or decrease a stored integer on oTarget, by
// nAmount, under sName
// * No return value. Used in SMP_MobileRepulsionAOECheck() mainly.
void SMP_MobileRepulsionSetInteger(object oTarget, string sName, int nAmount)
{
    // Get old
    int nOriginal = GetLocalInt(oTarget, sName);
    // Add new
    int nNew = nOriginal + nAmount;
    // Set new
    SetLocalInt(oTarget, sName, nNew);
}
// SMP_INC_AOE. This will add counter set to nSpellID, on oTarget, and if they
// have not got any effects from the spell already, apply eLink to the target.
// * Makes eLink Supernatural, to stop dispelling and resting, as it is removed OnExit.
void SMP_AOE_OnEnterEffects(effect eLink, object oTarget, int nSpellId)
{
    // Check if immune to spells
    if(SMP_TotalSpellImmunity(oTarget)) return;

    // If they already have this spell's effects, we just up the local integer
    string sId = SMP_SPELL_AOE_AMOUNT + IntToString(nSpellId);
    // Original amount of spells we are affected with.
    int nOriginal = GetLocalInt(oTarget, sId);

    // Make it supernatural
    effect eSuper = SupernaturalEffect(eLink);

    // Increase by 1
    int nNew = nOriginal + 1;

    // Set new value
    SetLocalInt(oTarget, sId, nNew);

    // If not got it, apply new effects
    if(!SMP_GetHasAOEEffects(nSpellId, oTarget))
    {
        // Linked effects - removed OnExit.
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSuper, oTarget);
    }
}

// This will add counter set to iSpellID, on oTarget, and if they have not got
// any effects from the spell already, apply eLink to the target
// * Will also apply eVis if it doesn't have GetSpellId() on it.
void SMP_AOE_OnEnterEffectsVFX(effect eLink, object oTarget, effect eVis, int nSpellId)
{
    // Check if immune to spells
    if(SMP_TotalSpellImmunity(oTarget)) return;

    // If not got it, apply new effects
    if(!SMP_GetHasAOEEffects(nSpellId, oTarget))
    {
        // Apply visual
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }
    // Do function above
    SMP_AOE_OnEnterEffects(eLink, oTarget, nSpellId);
}

// This will take 1 off oTarget's "AOE's of nSpellID's we are affected with".
// - At 0, it will remove all of nSpellID's effects.
// - If not got any of nSpellID's effects, deletes the local
// * Only removes supernatural effects, IE: Those applied via. the OnEnter version of this.
void SMP_AOE_OnExitEffects(int nSpellId)
{
    // Immune?
    object oTarget = GetExitingObject();

    // Check if immune to spells
    if(SMP_TotalSpellImmunity(oTarget)) return;

    // We decrease the local integer set on oTarget by 1, IE, they have exited
    // or got out of 1 AOE.
    string sId = SMP_SPELL_AOE_AMOUNT + IntToString(nSpellId);
    int nOriginal = GetLocalInt(oTarget, sId);

    // Take one
    int nNew = nOriginal - 1;

    // If not got it, delete the local and stop
    if(!SMP_GetHasAOEEffects(nSpellId, oTarget))
    {
        DeleteLocalInt(oTarget, sId);
        return;
    }
    else if(nNew > 0)
    {
        // If nOriginal is over 0, we set the new amount left, but remove
        // no effects
        SetLocalInt(oTarget, sId, nNew);
    }
    else //if(nNew <= 0)
    {
        // At 0, delete local.
        DeleteLocalInt(oTarget, sId);

        // Else, we remove the effects of the spell, as they are in no more AOE's

        // Search through the valid effects on the target.
        effect eAOE = GetFirstEffect(oTarget);
        while(GetIsEffectValid(eAOE))
        {
            // If the effect was created by the nSpellToRemove, and it is
            // supernatural, then remove it
            // * Never remove AOE's
            if(GetEffectSpellId(eAOE) == nSpellId)
            {
                if(GetEffectSubType(eAOE) == SUBTYPE_SUPERNATURAL &&
                   GetEffectDurationType(eAOE) == DURATION_TYPE_PERMANENT &&
                   GetEffectType(eAOE) != EFFECT_TYPE_AREA_OF_EFFECT)
                {
                    // Remove all effects from spell
                    RemoveEffect(oTarget, eAOE);
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
}
// SMP_INC_AOE. As SMP_AOE_OnExitEffects(), however, it will also always
// apply eAfter for fDuration as a normal effect, thus it won't matter and isn't
// picked up by the On Enter version, or removed by futher On Exit calls.
void SMP_AOE_OnExitEffectsPersistant(int nSpellId, effect eAfter, float fDuration)
{
    // Check if immune to spells
    object oTarget = GetExitingObject();
    if(SMP_TotalSpellImmunity(oTarget)) return;

    // Do SMP_AOE_OnExitEffects()
    SMP_AOE_OnExitEffects(nSpellId);

    // Always apply eAfter as normal
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAfter, oTarget, fDuration);
}

// Functions like a normal effect loop. However, it will only return TRUE if
// they have nSpellId, have it as a supernatural, permament effect of some kind.
int SMP_GetHasAOEEffects(int nSpellId, object oTarget)
{
    // Must have it normally anyway.
    if(GetHasSpellEffect(nSpellId, oTarget))
    {
        // Loop effects
        effect eCheck = GetFirstEffect(oTarget);
        while(GetIsEffectValid(eCheck))
        {
            // Check for nSpellId
            if(GetEffectSpellId(eCheck) == nSpellId)
            {
                // Check for permament durations, and supernatural effect
                // * Can NOT be an AOE itself!
                if(GetEffectSubType(eCheck) == SUBTYPE_SUPERNATURAL &&
                   GetEffectDurationType(eCheck) == DURATION_TYPE_PERMANENT &&
                   GetEffectType(eCheck) != EFFECT_TYPE_AREA_OF_EFFECT)
                {
                    // Stop as we have got the effect from nSpellId's AOE.
                    return TRUE;
                }
            }
            // Get next effect
            eCheck = GetNextEffect(oTarget);
        }
    }
    return FALSE;
}
// Get the caster level of an AOE (Being OBJECT_SELF). Stores in a local for futher use.
int SMP_GetAOECasterLevel(object oAOE = OBJECT_SELF)
{
    // Check for previous values
    int nLevel = GetLocalInt(oAOE, SMP_AOE_CASTER_LEVEL);
    if(nLevel >= 1)
    {
        // Stop and return
        return nLevel;
    }
    // Else get it - first time
    // Get the creator of OBJECT_SELF - the AOE
    object oCreator = GetAreaOfEffectCreator(oAOE);

    // If it is a placeable, the caster level is going to be special
    if(GetObjectType(oCreator) != OBJECT_TYPE_CREATURE)
    {
        // Get the caster level
        nLevel = GetCasterLevel(oCreator);
    }
    else
    {
        // Get the caster level
        nLevel = GetCasterLevel(oCreator);
    }

    // Make sure it is not 0 (Placeable casting maybe)
    if(nLevel < 1)
    {
        nLevel = 1;
    }

    // Set the local, and return the value
    SetLocalInt(oAOE, SMP_AOE_CASTER_LEVEL, nLevel);

    // Return value
    return nLevel;
}

// Get the spell save DC of an AOE (Being OBJECT_SELF). Stores in a local for futher use.
int SMP_GetAOESpellSaveDC()
{
    // Check for previous values
    int nDC = GetLocalInt(OBJECT_SELF, SMP_AOE_SPELL_SAVE_DC);
    if(nDC >= 1)
    {
        // Stop and return
        return nDC;
    }
    // Else get it - first time
    // Get the creator of OBJECT_SELF - the AOE
    object oCreator = GetAreaOfEffectCreator();

    // If it is a placeable, the save DC is going to be special
    if(GetObjectType(oCreator) != OBJECT_TYPE_CREATURE)
    {
        // Get the save DC
        nDC = GetSpellSaveDC();
    }
    else
    {
        // Get the save DC
        nDC = GetSpellSaveDC();
    }

    // Make sure it is not 0 (Placeable casting maybe)
    if(nDC < 1)
    {
        nDC = 1;
    }

    // Set the local, and return the value
    SetLocalInt(OBJECT_SELF, SMP_AOE_SPELL_SAVE_DC, nDC);

    // Return value
    return nDC;
}

// Returns the meta magic feat associated with the spell. Stores in a local for futher use.
int SMP_GetAOEMetaMagic()
{
    // Check for previous values
    int nMeta = GetLocalInt(OBJECT_SELF, SMP_AOE_SPELL_METAMAGIC);
    if(nMeta != 0)
    {
        // Stop and return
        return nMeta;
    }

    // Get metamagic -
    nMeta = GetMetaMagicFeat(); // do not used SMP_GetMetaMagicFeat().

    // If it is 0, we set it to -1, an invalid metamagic number, so the local sets.
    if(nMeta < 1)
    {
        nMeta = -1;
    }

    // Set the local, and return the value
    SetLocalInt(OBJECT_SELF, SMP_AOE_SPELL_METAMAGIC, nMeta);

    // Return value
    return nMeta;
}

// Returns FALSE if there is no AOE creator and the object is destroyed.
// * bDead - If TRUE, it will check GetIsDead(oCreator) with the same results.
int SMP_CheckAOECreator(int bDead = FALSE)
{
    object oCreator = GetAreaOfEffectCreator();
    if(!GetIsObjectValid(oCreator) &&
       (bDead == FALSE || GetIsDead(oCreator) == TRUE))
    {
        SetPlotFlag(OBJECT_SELF, FALSE);
        DestroyObject(OBJECT_SELF);
        return FALSE;
    }
    return TRUE;
}

// SMP_INC_AOE. Returns TRUE if oAOE's tag is one of a fire spell.
int SMP_GetIsFireyAOE(object oAOE)
{
    // Get tag
    string sTag = GetTag(oAOE);

    // Fire AOE
    if(sTag == SMP_AOE_TAG_PER_WALL_OF_FIRE_05 ||
       sTag == SMP_AOE_TAG_PER_WALL_OF_FIRE_10 ||
       sTag == SMP_AOE_TAG_PER_WALL_OF_FIRE_15 ||
       sTag == SMP_AOE_TAG_PER_WALL_OF_FIRE_20 ||
       sTag == SMP_AOE_TAG_PER_WALL_OF_FIRE_ROUND ||
       sTag == SMP_AOE_TAG_PER_INCENDIARY_CLOUD)
    {
        return TRUE;
    }
    return FALSE;
}

// End of file Debug lines. Uncomment below "/*" with "//" and compile.
/*
void main()
{
    return;
}
//*/
