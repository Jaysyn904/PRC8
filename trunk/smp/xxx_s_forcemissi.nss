/*:://////////////////////////////////////////////
//:: Spell Name Force Missiles
//:: Spell FileName XXX_S_ForceMissi
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Evocation [Force]
    Also known as: Mordenkainen's Force Missiles
    Level: Sor/Wiz 4
    Components: V, S
    Casting Time: 1 standard action
    Range: Medium (20M)
    Targets: Up to four enemy creatures in a 1.67M-radius sphere (5ft)
    Duration: Instantaneous
    Saving Throw: None or Reflex half (see text)
    Spell Resistance: Yes
    Source: Various (WotC Spellbook)

    You create a powerful missile of magical force, which darts from your
    fingertips and unerringly strikes its target, dealing 2d6 points of damage.
    The missile then bursts in a 1.67-meter blast of force that inflicts half
    this amount of damage to any creatures in the area (other than the primary
    target). The primary target is not entitled to a saving throw against the
    burst, but creatures affected by the burst may attempt a Reflex save for
    half damage.

    If the missiles' burst areas overlap, secondary targets make only one saving
    throw attempt (and only one SR check, if applicable). A character can be
    struck by one missile (or more) and also be caught in the burst of another
    missile. In such a case, the character may attempt a Reflex save to halve
    the burst damage, and SR might apply.

    The missile strikes unerringly, even if the target is in melee or has
    anything less than total cover or concealment.

    For every five caster levels, the caster gains one missile. A caster has two
    missiles at 9th level or lower, three missiles from 10th to 14th level, and
    four missiles at 15th level or higher. If you can fire more then one
    missile, and target one person, all missiles fly towards that target. If you
    target the ground, the nearest 2 or more enemies will get hit in a 3M
    radius sphere.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Using the magic missile effect, it'll do burst damage against those in
    the area *at the time of casting*, thus it might look a little odd, oh well.

    The way the "Only one save and SR check" is done is that a local is set
    and checked for each target each blast.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

// Do the AOE blast using oOriginalTarget's location
// * Damages oOriginalTarget fully.
// * Uses the visuals eMissile and eVis.
void DoMissileAndBlast(object oOriginalTarget, object oCaster, int nSpellSaveDC, string sSRLocal, string sSaveLocal, int nMissiles, int nMetaMagic, effect eMissile, effect eVis);

// Reflex adjust nDamage, using stored stuff.
int ReturnReflexDamage(int nDamage, string sSaveLocal, object oTarget, int nDC, object oSaveVersus, float fDelay);
// Check SR, using stored stuff.
// * TRUE is resisted, FALSE isn't.
int ReturnSRCheck(object oTarget, object oCaster, string sSRLocal, float fDelay = 0.0);

void main()
{
    // Spell Hook Check.
    if(!SMP_SpellHookCheck(SMP_SPELL_FORCE_MISSILES)) return;

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    location lTarget = GetSpellTargetLocation();
    int nMetaMagic = SMP_GetMetaMagicFeat();
    int nCasterLevel = SMP_GetCasterLevel();
    int nSpellSaveDC = SMP_GetSpellSaveDC();
    int nPeopleDone;
    string sSRLocal = IntToString(SMP_SPELL_FORCE_MISSILES) + ObjectToString(oCaster) + "SR";
    string sSaveLocal = IntToString(SMP_SPELL_FORCE_MISSILES) + ObjectToString(oCaster) + "SAVE";

    // For every five caster levels, the caster gains one missile.
    int nMissiles = SMP_LimitInteger(nCasterLevel/5, 4, 1);

    // Declare Effects
    effect eMissile = EffectVisualEffect(VFX_IMP_MIRV);
    effect eVis = EffectVisualEffect(VFX_IMP_MAGBLUE);

    // Is it one target?
    if(GetIsObjectValid(oTarget) && GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
    {
        // Check PvP
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            // Use function
            DoMissileAndBlast(oTarget, oCaster, nSpellSaveDC, sSRLocal, sSaveLocal, nMissiles, nMetaMagic, eMissile, eVis);
        }
    }
    else
    {
        // We loop targets in the LOS of 2M sphere
        oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 2.0, lTarget, TRUE, OBJECT_TYPE_CREATURE);
        while(GetIsObjectValid(oTarget) && nPeopleDone < nMissiles)
        {
            // Check if an enemy and is seen
            if(GetIsReactionTypeHostile(oTarget) && GetObjectSeen(oTarget))
            {
                // Use function - 1 missile blast
                DoMissileAndBlast(oTarget, oCaster, nSpellSaveDC, sSRLocal, sSaveLocal, 1, nMetaMagic, eMissile, eVis);
                // Add one to done list
                nPeopleDone++;
            }
            oTarget = GetNextObjectInShape(SHAPE_SPHERE, 2.0, lTarget, TRUE, OBJECT_TYPE_CREATURE);
        }
    }
}

// Do the AOE blast using oOriginalTarget's location
// * Damages oOriginalTarget fully.
// * Uses the visuals eMissile and eVis.
void DoMissileAndBlast(object oOriginalTarget, object oCaster, int nSpellSaveDC, string sSRLocal, string sSaveLocal, int nMissiles, int nMetaMagic, effect eMissile, effect eVis)
{
    // Get delay for hitting.
    float fDist = GetDistanceBetween(oCaster, oOriginalTarget);
    float fDelay = fDist/(3.0 * log(fDist) + 2.0);
    float fDelay2;
    float fAOEDelay;
    object oAOETarget;
    int nCnt, nDam, nSR, nSave;
    location lTarget;

    // Apply visual effect (Magic Missiles)
    for(nCnt = 1; nCnt <= nMissiles; nCnt++)
    {
        fDelay2 += 0.1;
        DelayCommand(fDelay2, SMP_ApplyVFX(oOriginalTarget, eMissile));

        // Signal Spell cast at, once
        if(GetLocalInt(oOriginalTarget, sSRLocal) != FALSE)
        {
            SMP_SignalSpellCastAt(oOriginalTarget, SMP_SPELL_FORCE_MISSILES);
        }

        // Do damage to oOriginalTarget, if they fail thier SR. No save!
        // Check SR
        if(!ReturnSRCheck(oOriginalTarget, oCaster, sSRLocal, fDelay))
        {
            // Do damage
            nDam = SMP_MaximizeOrEmpower(6, 2, nMetaMagic);
            DelayCommand(fDelay, SMP_ApplyDamageVFXToObject(oOriginalTarget, eVis, nDam));
        }

        // For each blast, we loop targets in the AOE
        // We loop targets in the LOS of 1.67M sphere
        lTarget = GetLocation(oOriginalTarget);
        oAOETarget = GetFirstObjectInShape(SHAPE_SPHERE, 1.67, lTarget, TRUE, OBJECT_TYPE_CREATURE);
        while(GetIsObjectValid(oAOETarget))
        {
            // PvP Check and is NOT original target
            if(!GetIsReactionTypeFriendly(oAOETarget) &&
                oAOETarget != oOriginalTarget)
            {
                // Signal Spell cast at, once
                if(GetLocalInt(oAOETarget, sSRLocal) != FALSE)
                {
                    // Signal Spell cast at
                    SMP_SignalSpellCastAt(oAOETarget, SMP_SPELL_FORCE_MISSILES);
                }
                // Make sure we check SR as the original target
                fAOEDelay = fDelay + GetDistanceBetweenLocations(lTarget, GetLocation(oAOETarget))/20;

                // Do damage to oAOETarget, if they fail thier SR. No save!
                if(!ReturnSRCheck(oAOETarget, oCaster, sSRLocal, fAOEDelay))
                {
                    // Get damage to do
                    nDam = SMP_MaximizeOrEmpower(6, 1, nMetaMagic);

                    // Adjust it due to saves, done already or not.
                    nDam = ReturnReflexDamage(nDam, sSaveLocal, oAOETarget, nSpellSaveDC, oCaster, fAOEDelay);

                    // Do the damage, if any
                    if(nDam > 0)
                    {
                        DelayCommand(fDelay, SMP_ApplyDamageVFXToObject(oOriginalTarget, eVis, nDam));
                    }
                }
            }
            oAOETarget = GetNextObjectInShape(SHAPE_SPHERE, 1.67, lTarget, TRUE, OBJECT_TYPE_CREATURE);
        }
    }
}

// Reflex adjust nDamage, using stored stuff.
int ReturnReflexDamage(int nDamage, string sSaveLocal, object oTarget, int nDC, object oSaveVersus, float fDelay)
{
    // Check if saved already
    int nSave = GetLocalInt(oTarget, sSaveLocal);

    // 0 = not attempted
    // 1 = saved
    // 2 = Not saved, failed in the attempt.

    if(nSave > 0)
    {
        if(nSave == 1)
        {
            // Saved
            return SMP_ReflexAdjustDamage(TRUE, nDamage, oTarget);
        }
        else//if(nSave == 2)
        {
            // Failed
            return SMP_ReflexAdjustDamage(FALSE, nDamage, oTarget);
        }
    }
    else
    {
        // New save
        nSave = SMP_SavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_NONE, oSaveVersus, fDelay);

        // Saved?
        if(nSave == FALSE)
        {
            // Didn't save. Set and return.
            SetLocalInt(oTarget, sSaveLocal, 2);
            DelayCommand(0.1, DeleteLocalInt(oTarget, sSaveLocal));

            // Failed
            return SMP_ReflexAdjustDamage(FALSE, nDamage, oTarget);
        }
        else// is over 1
        {
            // Passed
            SetLocalInt(oTarget, sSaveLocal, 1);
            DelayCommand(0.1, DeleteLocalInt(oTarget, sSaveLocal));

            // Passed
            return SMP_ReflexAdjustDamage(TRUE, nDamage, oTarget);
        }
    }
    return nDamage;
}

// Check SR, using stored stuff.
// * TRUE is resisted, FALSE isn't.
int ReturnSRCheck(object oTarget, object oCaster, string sSRLocal, float fDelay = 0.0)
{
    // Get old result
    int nResult = GetLocalInt(oTarget, sSRLocal);
    if(nResult != TRUE)// Resisted already
    {
        // TRUE means we pass, and no damage, else we check if we need to do it.
        // 1 Means we have passed, and do not need to do one.
        // 2 means we failed the check, no more checks.
        // 0 Means an absense of a check
        if(nResult == 2)
        {
            // Failed already.
            return FALSE;
        }
        else //if(nSR == 0)
        {
            // Make a new SR check - our first one!
            nResult = SMP_SpellResistanceCheck(oCaster, oTarget, fDelay);

            if(nResult == FALSE)
            {
                // Failed
                // Set we always failed - 2
                SetLocalInt(oTarget, sSRLocal, 2);
                DelayCommand(0.1, DeleteLocalInt(oTarget, sSRLocal));
                return FALSE;
            }
            else //must have passed somehow
            {
                // Passed/resisted always. Set always pass - 1
                SetLocalInt(oTarget, sSRLocal, 1);
                DelayCommand(0.1, DeleteLocalInt(oTarget, sSRLocal));
                // Return TRUE, passed
                return TRUE;
            }
        }
    }
    else
    {
        // Resisted, it was a 1
        return TRUE;
    }
    // Return DIDN'T resist, as a defualt.
    return FALSE;
}
