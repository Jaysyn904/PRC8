//::///////////////////////////////////////////////
//:: [Sound Burst]
//:: [NW_S0_SndBurst.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
/*
Evocation [Sonic]
Level:            Brd 2, Clr 2
Components:       V, S, F/DF
Casting Time:     1 standard action
Range:            Close (25 ft. + 5 ft./2 levels)
Area:             10-ft.-radius spread
Duration:         Instantaneous
Saving Throw:     Fortitude partial
Spell Resistance: Yes

You blast an area with a tremendous cacophony.
Every creature in the area takes 1d8 points of
sonic damage and must succeed on a Fortitude save
to avoid being stunned for 1 round.

Creatures that cannot hear are not stunned but
are still damaged.

Arcane Focus
A musical instrument.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 31, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Georg Z, Oct. 2003
//:: modified by mr_bumpkin  Dec 4, 2003

#include "prc_inc_spells" 
#include "prc_add_spell_dc"

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_EVOCATION);

    //Declare major variables
    object oCaster = OBJECT_SELF;
    location lLoc = PRCGetSpellTargetLocation();
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    int nPenetr = nCasterLevel + SPGetPenetr();
    int nMetaMagic = PRCGetMetaMagicFeat();
    int EleDmg = ChangedElementalDamage(oCaster, DAMAGE_TYPE_SONIC);
    int nSaveType = ChangedSaveType(EleDmg);

    effect eFNF  = EffectVisualEffect(VFX_FNF_SOUND_BURST);
    effect eVis  = EffectVisualEffect(VFX_IMP_SONIC);

    effect eStun = EffectStunned();
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eDur  = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink = EffectLinkEffects(eStun, eMind);
           eLink = EffectLinkEffects(eLink, eDur);

    //Apply the FNF to the spell location
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, lLoc);

    //Get the first target in the spell area
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lLoc);
    while(GetIsObjectValid(oTarget))
    {
        if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_SOUND_BURST));
            //Make a SR check
            if(!PRCDoResistSpell(oCaster, oTarget, nPenetr))
            {
                // Should not work on creatures already deafened or silenced
                if(!PRCGetHasEffect(EFFECT_TYPE_DEAF, oTarget) && !PRCGetHasEffect(EFFECT_TYPE_SILENCE, oTarget))
                {
                    int nDC = PRCGetSaveDC(oTarget, oCaster);
                    //Make a Fortitude roll to avoid being stunned
                    if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, nSaveType))
                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(2), TRUE, SPELL_SOUND_BURST, nCasterLevel);
                }

                //Roll damage
                int nDamage = d8();
                //Make meta magic checks
                if(nMetaMagic & METAMAGIC_MAXIMIZE)
                    nDamage = 8;
                if(nMetaMagic & METAMAGIC_EMPOWER)
                    nDamage += nDamage / 2;

                //Set the damage effect
                nDamage += SpellDamagePerDice(oCaster, 1);
                effect eDam = PRCEffectDamage(oTarget, nDamage, EleDmg);
                //Apply the VFX impact and damage effect
                DelayCommand(0.01, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
        }
        //Get the next target in the spell area
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lLoc);
    }
    PRCSetSchool();
}
