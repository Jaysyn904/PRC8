//::///////////////////////////////////////////////
//:: Circle of Doom
//:: nw_s0_circdoom.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
Spell level: cleric 5
Innate level: 5
School: necromancy
Descriptor: negative
Components: verbal, somatic
Range: medium (20 meters)
Area of effect: huge (6.67 meter radius)
Duration: instant
Save: fortitude 1/2
Spell resistance: yes
Additional counterspells: healing circle

All enemies within the area of effect
are struck with negative energy that causes 1d8
points of negative energy damage, +1 point per
caster level. Negative energy spells have a
reverse effect on undead, healing them instead of
harming them.
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk and Keith Soleski
//:: Created On: Jan 31, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001
//:: Update Pass By: Preston W, On: July 25, 2001
//:: modified by mr_bumpkin Dec 4, 2003
//:: Added code to maximize for Faith Healing and Blast Infidel
//:: Aaon Graywolf - Jan 7, 2003

#include "prc_inc_function"
#include "prc_add_spell_dc"

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_NECROMANCY);

    //Declare major variables
    object oCaster = OBJECT_SELF;
    location lTarget = PRCGetSpellTargetLocation();
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nPenetr = nCasterLevel + SPGetPenetr();
    int nDamage;
    float fDelay;

    //Limit Caster Level
    if(nCasterLevel > 20)
        nCasterLevel = 20;

    effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    effect eVis2 = EffectVisualEffect(VFX_IMP_HEALING_M);
    effect eFNF = EffectVisualEffect(VFX_FNF_LOS_EVIL_10);
    effect eDam;
    effect eHeal;

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, lTarget);

    //Get first target in the specified area
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget);
    while(GetIsObjectValid(oTarget))
    {
        //Roll damage
        nDamage = d8();
        //Enter Metamagic conditions
        int iBlastFaith = BlastInfidelOrFaithHeal(oCaster, oTarget, DAMAGE_TYPE_NEGATIVE, FALSE);
        if((nMetaMagic & METAMAGIC_MAXIMIZE) || iBlastFaith)
            nDamage = 8;
        if(nMetaMagic & METAMAGIC_EMPOWER)
            nDamage = nDamage + (nDamage/2);
        nDamage = nDamage + nCasterLevel;

        fDelay = PRCGetRandomDelay();

        //If the target is an allied undead it is healed
        if(MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD
        || (GetHasFeat(FEAT_TOMB_TAINTED_SOUL, oTarget) && GetAlignmentGoodEvil(oTarget) != ALIGNMENT_GOOD)
        || GetLocalInt(oTarget, "AcererakHealing"))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_CIRCLE_OF_DOOM, FALSE));
            //Set the heal effect
            eHeal = PRCEffectHeal(nDamage, oTarget);
            //Apply the impact VFX and healing effect
            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget));
            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget));
        }
        else
        {
            if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
            {
            	nDamage += SpellDamagePerDice(oCaster, 1);
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_CIRCLE_OF_DOOM));
                //Make an SR Check
                if(!PRCDoResistSpell(oCaster, oTarget, nPenetr, fDelay))
                {
                    int nDC = PRCGetSaveDC(oTarget, oCaster);
                    if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NEGATIVE, oCaster, fDelay))
                    {
                        if(GetHasMettle(oTarget, SAVING_THROW_FORT))
                            // This script does nothing if it has Mettle, bail
                            nDamage = 0;
                        else
                            nDamage = nDamage/2;
                    }
                    if(nDamage)
                    {
                        //Set Damage
                        eDam = PRCEffectDamage(oTarget, nDamage, DAMAGE_TYPE_NEGATIVE);
                        //Apply impact VFX and damage
                        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    }
                }
            }
        }
        //Get next target in the specified area
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget);
    }
    PRCSetSchool();
}