//::///////////////////////////////////////////////
//:: Bane
//:: X0_S0_Bane.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
Bane
Enchantment (Compulsion) [Fear, Mind-Affecting]
Level:            Clr 1
Components:       V, S, DF
Casting Time:     1 standard action
Range:            50 ft.
Area:             All enemies within 50 ft.
Duration:         1 min./level
Saving Throw:     Will negates
Spell Resistance: Yes

Bane fills your enemies with fear and doubt. Each
affected creature takes a -1 penalty on attack
rolls and a -1 penalty on saving throws against
fear effects.

Bane counters and dispels bless.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 24, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001
//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff

#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
    if (!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_ENCHANTMENT);

    //Declare major variables
    object oCaster = OBJECT_SELF;
    location lLoc = GetLocation(oCaster);
    int nCasterLvl = PRCGetCasterLevel(oCaster);
    int nPenetr = nCasterLvl + SPGetPenetr();
    int nMetaMagic = PRCGetMetaMagicFeat();
    float fDuration = TurnsToSeconds(nCasterLvl);
    float fRange = FeetToMeters(50.0);
    float fDelay;

    //Metamagic duration check
    if(nMetaMagic & METAMAGIC_EXTEND)
        fDuration *= 2;   //Duration is +100%

    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_EVIL);
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_EVIL_30);

    //Apply Impact
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lLoc);

    effect eAttack = EffectAttackDecrease(1);
    effect eSave   = EffectSavingThrowDecrease(SAVING_THROW_ALL, 1, SAVING_THROW_TYPE_FEAR);
    effect eDur    = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink   = EffectLinkEffects(eAttack, eSave);
           eLink   = EffectLinkEffects(eLink, eDur);

    //Get the first target in the radius around the caster
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, fRange, lLoc);
    while(GetIsObjectValid(oTarget))
    {
        if(spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCaster))
        {
             //Fire spell cast at event for target
             SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_BANE, FALSE));

             if(!PRCDoResistSpell(oCaster, oTarget, nPenetr))
             {
                int nSpellDC = PRCGetSaveDC(oTarget, oCaster);

                if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nSpellDC, SAVING_THROW_TYPE_MIND_SPELLS))
                {
                    fDelay = PRCGetRandomDelay(0.4, 1.1);

                    if(GetHasSpellEffect(SPELL_BLESS, oTarget))
                        //Remove Bless spell
                        DelayCommand(fDelay, PRCRemoveEffectsFromSpell(oTarget, SPELL_BLESS));
                    else
                    {
                        //Apply penalty effect
                        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, SPELL_BANE, nCasterLvl));
                    }
                    //Apply VFX impact
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                }
            }
        }
        //Get the next target in the specified area around the caster
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, fRange, lLoc);
    }
    PRCSetSchool();
}