//::///////////////////////////////////////////////
//:: [Force Missiles]
//:: [sp_forcemissiles.nss]
//:: Created By: Jaysyn / Tsurani Nevericy
//:: Created On: 20220726
//:: Last Updated By: Jaysyn
//:: Last Updated On: 2024-08-16 10:01:17
//:://////////////////////////////////////////////
/**@file Force Missiles
(Spell Compendium, p. 98)

Evocation [Force]
Level: Sorcerer 4, Wizard 4,
Components: V, S,
Casting Time: 1 Standard Action
Range: Medium (100 ft. + 10 ft./level)
Target: Up to four creatures, no two of which are more than 30 ft. apart
Duration: Instantaneous
Saving Throw: None
Spell Resistance: Yes

Sparking bolts of blue magic, like giant magic missiles, streak from your
outstretched hand to strike your foes and explode in sparkling bursts.

You create powerful missiles of magical force, each of which darts from your
fingertips and unerringly strikes its target, dealing 2d6 points of damage.
The missile then explodes in a burst of force that deals half this amount of
damage to any creatures adjacent to the primary target.

The missile strikes unerringly, even if the target is in melee or has anything
less than total cover or concealment. A caster cannot single out specific parts
of a creature.

You gain one missile for every four caster levels. You can make more than one
missile strike a single target, if desired. However,you must designate targets
before rolling for spell resistance or damage.

*///////////////////////////////////////////////////////////
#include "x2_inc_spellhook"
#include "prc_inc_spells"

void SendMissileBomb(object oCaster, object oTarget, float fDelay=0.0, float fTime=0.0)
{
    int nCasterLevel 	= PRCGetCasterLevel(oCaster);
    int nPenetr 		= nCasterLevel + SPGetPenetr();
	
	int nMetaMagic = PRCGetMetaMagicFeat();
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_MIRV), oTarget);
    location lLoc = GetLocation(oTarget);
    object oLoop = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(5.0), lLoc, TRUE);

    while (GetIsObjectValid(oLoop))
    {
        SignalEvent(oLoop, EventSpellCastAt(oCaster, PRCGetSpellId()));
        int nDam;

        if (oLoop == oTarget)
        {
            nDam = d6(2);
            if (nMetaMagic == METAMAGIC_MAXIMIZE)
                nDam = 12;
            if (nMetaMagic == METAMAGIC_EMPOWER)
                nDam += nDam/2;

            DelayCommand(fTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDam, DAMAGE_TYPE_MAGICAL), oLoop));
            DelayCommand(fTime, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_IMP_MAGBLUE, FALSE, 4.0f), oLoop));
        }
        else if (!PRCDoResistSpell(oCaster, oLoop, nPenetr, fDelay))
        {
            nDam = d6(1);
            if (nMetaMagic == METAMAGIC_MAXIMIZE)
                nDam = 6;
            if (nMetaMagic == METAMAGIC_EMPOWER)
                nDam += nDam/2;

            DelayCommand(fTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDam, DAMAGE_TYPE_MAGICAL), oLoop));
            DelayCommand(fTime, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_IMP_MAGBLUE), oLoop));
        }

        oLoop = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(5.0), lLoc, TRUE);
    }
}

void main()
{
//:: Check the Spellhook
    if (!X2PreSpellCastCode()) return;

//:: Set the Spell School
    PRCSetSchool(GetSpellSchool(PRCGetSpellId()));
	
//:: Declare major variables
	int i;
    object oCaster = OBJECT_SELF;
    object oTarget;
    float fDist, fDelay, fDelay2 = 0.0, fTime;
    int nTargets = 0;
    int nCnt = 1;
    int nCasterLevel = PRCGetCasterLevel(oCaster);
	int nPenetr 		= nCasterLevel + SPGetPenetr();
    if (nCasterLevel > 40) nCasterLevel = 40;
    int nMissiles = nCasterLevel / 4;
    if (nMissiles < 1) nMissiles = 1;

    location lTarget = GetSpellTargetLocation();
    oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), lTarget, TRUE, OBJECT_TYPE_CREATURE);

    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCaster) && oTarget != oCaster)
        {
            nTargets++;
        }
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }

    if (nTargets == 0)
        return;

    int nExtraMissiles = nMissiles / nTargets;
    if (nExtraMissiles < 1)
        nExtraMissiles = 1;

    int nRemainder = nMissiles % nTargets;

    oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), lTarget, TRUE, OBJECT_TYPE_CREATURE);

    while (GetIsObjectValid(oTarget) && nCnt <= nTargets)
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCaster) && oTarget != oCaster)
        {
            if (!PRCDoResistSpell(oCaster, oTarget, nPenetr, fDelay))
            {
                for (i = 0; i < nExtraMissiles + nRemainder; i++)
                {
                    fDist = GetDistanceBetween(oCaster, oTarget);
                    fDelay = fDist / (3.0 * log(fDist) + 2.0);
                    fTime = fDelay;
                    fDelay2 += 0.1;
                    fTime += fDelay2;
                    DelayCommand(fDelay2, SendMissileBomb(oCaster, oTarget, fDelay, fTime));
                }
            }
            else
            {
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_MIRV), oTarget);
            }
            nCnt++;
            nRemainder = 0;
        }
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
//:: Unset the Spell school
    PRCSetSchool();	
}