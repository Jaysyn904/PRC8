/*:://////////////////////////////////////////////
//:: Spell Name Magic Missile
//:: Spell FileName PHS_S_MagicMiss
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Evocation [Force]
    Level: Sor/Wiz 1
    Components: V, S
    Casting Time: 1 standard action
    Range: Medium (20M)
    Targets: Up to five enemy creatures in a 2M-radius sphere
    Duration: Instantaneous
    Saving Throw: None
    Spell Resistance: Yes

    A missile of magical energy darts forth from your fingertip and strikes
    its target, dealing 1d4+1 points of force damage. Inanimate objects are
    not damaged by the spell.

    For every two caster levels beyond 1st, you gain an additional missile-two
    at 3rd level, three at 5th, four at 7th, and the maximum of five missiles
    at 9th level or higher.

    If you shoot multiple missiles, you can have them strike a single creature
    or several creatures. You can target the ground to have missiles spread out
    among the area. A single missile can strike only one creature if multiple
    creatures are targeted.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Same as the spell -

    The multiple version is kinda like the Issac Missiles storm thing.

    Anyway, either single target or multiple target.

    The target is the way we determine what to do, single or multiple.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

// Missile Person - does the missile loop up to nMissiles.
void MissilePerson(object oTarget, object oCaster, int nMissiles, int nMetaMagic, effect eMissile, effect eVis);

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_MAGIC_MISSILE)) return;

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    location lTarget = GetSpellTargetLocation();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nCasterLevel = PHS_GetCasterLevel();
    int nPeopleDone;

    // 1 + 1 Missile per 2 caster levels after 1. - Max of 5
    int nMissiles = 1 + PHS_LimitInteger((nCasterLevel - 1)/2, 5);

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
            MissilePerson(oTarget, oCaster, nMissiles, nMetaMagic, eMissile, eVis);
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
                // Use function - only 1 missile!
                MissilePerson(oTarget, oCaster, 1, nMetaMagic, eMissile, eVis);
                // Add one to done list
                nPeopleDone++;
            }
            oTarget = GetNextObjectInShape(SHAPE_SPHERE, 2.0, lTarget, TRUE, OBJECT_TYPE_CREATURE);
        }
    }
}

void MissilePerson(object oTarget, object oCaster, int nMissiles, int nMetaMagic, effect eMissile, effect eVis)
{
    // Get delay for hitting.
    float fDist = GetDistanceBetween(oCaster, oTarget);
    float fDelay = fDist/(3.0 * log(fDist) + 2.0);
    float fDelay2;
    int nCnt, nDam;

    // Signal Spell cast at
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_MAGIC_MISSILE);

    // Apply visual effect (Magic Missiles)
    for(nCnt = 1; nCnt <= nMissiles; nCnt++)
    {
        fDelay2 += 0.1;
        DelayCommand(fDelay2, PHS_ApplyVFX(oTarget, eMissile));
    }

    // Spell resistance and immunity check
    if(!PHS_SpellResistanceCheck(oCaster, oTarget, fDelay))
    {
        //Apply a single damage hit for each missile instead of as a single mass
        for(nCnt = 1; nCnt <= nMissiles; nCnt++)
        {
            // Damage
            nDam = PHS_MaximizeOrEmpower(4, 1, nMetaMagic);

            // fDelay should add 0.1 for each damage.
            fDelay += 0.1;

            // Apply the MIRV and damage effect
            DelayCommand(fDelay, PHS_ApplyDamageVFXToObject(oTarget, eVis, nDam));
        }
    }
}
