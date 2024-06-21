//::///////////////////////////////////////////////
//:: Force Missiles
//:: sp_forcemissiles
//:: Copyright (c) 2022 PRC
//:://////////////////////////////////////////////
/*/
Force Missiles
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

/*/
//:://////////////////////////////////////////////
//:: Created By: Tsurani Nevericy
//:: Created On: 05/15/2024
//:://////////////////////////////////////////////
//:: Last Updated By: Tsurani Nevericy
//:: Last Updated On: 05/15/2024
//:://////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_inc_spells"
#include "x2_inc_spellhook"

void SendMissileBomb(object oCaster, object oTarget, float fDelay=0.0, float fTime=0.0)
{
    int nMetaMagic = PRCGetMetaMagicFeat();
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_MIRV), oTarget);
    location lLoc = GetLocation(oTarget);
    object oLoop = GetFirstObjectInShape(SHAPE_SPHERE, 5.0, lLoc, TRUE);
    while (GetIsObjectValid(oLoop))
    {
        SignalEvent(oLoop, EventSpellCastAt(oCaster, PRCGetSpellId()));
        if (oLoop == oTarget)
        {
            int nDam = d6(2);
            if (nMetaMagic == METAMAGIC_MAXIMIZE)
                  nDam = 12;
            if (nMetaMagic == METAMAGIC_EMPOWER)
                  nDam += nDam/2;
            DelayCommand(fTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDam, DAMAGE_TYPE_MAGICAL), oLoop));
            DelayCommand(fTime, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_IMP_MAGBLUE, FALSE, 4.0f), oLoop));
        }
        else if (!PRCDoResistSpell(oCaster, oLoop, FloatToInt(fDelay)))
        {
            int nDam = d6(1);
            if (nMetaMagic == METAMAGIC_MAXIMIZE)
                  nDam = 6;
            if (nMetaMagic == METAMAGIC_EMPOWER)
                  nDam += nDam/2;
            DelayCommand(fTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDam, DAMAGE_TYPE_MAGICAL), oLoop));
            DelayCommand(fTime, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_IMP_MAGBLUE), oLoop));
        }
        oLoop = GetNextObjectInShape(SHAPE_SPHERE, 5.0, lLoc, TRUE);
    }
}

//Implements the spell impact, put code here
//  if called in many places, return TRUE if
//  stored charges should be decreased
//  eg. touch attack hits
//
//  Variables passed may be changed if necessary
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)
{
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nSaveDC = PRCGetSaveDC(oTarget, oCaster);
    int nPenetr = nCasterLevel + SPGetPenetr();
	int i;
    int nTargets;
    int nCnt = 1;
	float fDist, fDelay, fDelay2, fTime;

	if (nCasterLevel > 40) nCasterLevel = 40;
    int nMissiles = nCasterLevel/4;
    if (nMissiles < 1) nMissiles = 1;	
	
	location lTarget = PRCGetSpellTargetLocation();

    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 9.144, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCaster) && oTarget != oCaster)
        {
            nTargets++;
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, 9.144, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
	if (!nTargets)
		return FALSE;

    int nExtraMissiles = nMissiles / nTargets;

    if (nExtraMissiles <= 0)
        nExtraMissiles = 1;

    int nRemainder = 0;

    if (nTargets > nMissiles) nTargets = nMissiles;

    nRemainder = nMissiles % nTargets;

    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 9.144, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oTarget) && nCnt <= nTargets)
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCaster) && oTarget != oCaster)
        {
            if (!PRCDoResistSpell(oCaster, oTarget, FloatToInt(fDelay)))
            {
                int i;
                for (i=1; i <= nExtraMissiles + nRemainder; i++)
                {
                    fDist = GetDistanceBetween(oCaster, oTarget);
                    fDelay = fDist/(3.0 * log(fDist) + 2.0);
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
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, 9.144, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
	
	return TRUE;
}

void main()
{
    object oCaster = OBJECT_SELF;
	object oTarget = PRCGetSpellTargetObject();
	
    int nCasterLevel = PRCGetCasterLevel(oCaster);
	int i;
    int nTargets;
    int nCnt = 1;
	float fDist, fDelay, fDelay2, fTime;
	
    PRCSetSchool(GetSpellSchool(PRCGetSpellId()));
	
    if (!X2PreSpellCastCode()) return;
	
    int nEvent = GetLocalInt(oCaster, PRC_SPELL_EVENT); //use bitwise & to extract flags
    if(!nEvent) //normal cast
    {
        if(GetLocalInt(oCaster, PRC_SPELL_HOLD) && oCaster == oTarget)
        {   //holding the charge, casting spell on self
            SetLocalSpellVariables(oCaster, 1);   //change 1 to number of charges
            return;
        }
        DoSpell(oCaster, oTarget, nCasterLevel, nEvent);
    }
    else
    {
        if(nEvent & PRC_SPELL_EVENT_ATTACK)
        {
            if(DoSpell(oCaster, oTarget, nCasterLevel, nEvent))
                DecrementSpellCharges(oCaster);
        }
    }
    PRCSetSchool();
}

//::///////////////////////////////////////////////////////////////////