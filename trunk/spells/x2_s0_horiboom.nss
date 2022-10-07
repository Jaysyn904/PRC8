//::///////////////////////////////////////////////
//:: Horizikaul's Boom
//:: X2_S0_HoriBoom
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// You blast the target with loud and high-pitched
// sounds. The target takes 1d4 points of sonic
// damage per two caster levels (maximum 5d4) and
// must make a Will save or be deafened for 1d4
// rounds.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 22, 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Andrew Nobbs, 02/06/2003


//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "prc_inc_spells"



#include "prc_add_spell_dc"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);
/*
  Spellcast Hook Code
  Added 2003-07-07 by Georg Zoeller
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables  ( fDist / (3.0f * log( fDist ) + 2.0f) )
    object oTarget = PRCGetSpellTargetObject();
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);

    int nCasterLvl = CasterLvl/2;
    int nRounds = d4(1);
    int nMetaMagic = PRCGetMetaMagicFeat();
    effect eVis = EffectVisualEffect(VFX_IMP_SONIC);
    effect eDeaf = EffectDeaf();
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink = EffectLinkEffects(eDeaf, eDur);

    //Minimum caster level of 1, maximum of 15.
    if(nCasterLvl == 0)
    {
        nCasterLvl = 1;
    }
    else if (nCasterLvl > 5)
    {
        nCasterLvl = 5;
    }

    CasterLvl +=SPGetPenetr();

    if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    {
        if(!PRCDoResistSpell(OBJECT_SELF, oTarget,CasterLvl))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HORIZIKAULS_BOOM));
            //Roll damage
            int nDam = d4(nCasterLvl);
            //Enter Metamagic conditions
            if ((nMetaMagic & METAMAGIC_MAXIMIZE))
            {
                nDam = 4 * nCasterLvl; //Damage is at max
            }
            if ((nMetaMagic & METAMAGIC_EMPOWER))
            {
                nDam = nDam + nDam/2; //Damage/Healing is +50%
            }
            if(nMetaMagic & METAMAGIC_EXTEND)
            {
                nRounds *= 2;
            }
            nDam += SpellDamagePerDice(OBJECT_SELF, nCasterLvl);
            //nDam += ApplySpellBetrayalStrikeDamage(oTarget, OBJECT_SELF, FALSE);
            //Set damage effect
            effect eDam = PRCEffectDamage(oTarget, nDam, ChangedElementalDamage(OBJECT_SELF, DAMAGE_TYPE_SONIC));
            //Apply the MIRV and damage effect
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
            PRCBonusDamage(oTarget);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

            //Should not work on creatures already deafened or silenced
            if(!PRCGetHasEffect(EFFECT_TYPE_DEAF, oTarget) && !PRCGetHasEffect(EFFECT_TYPE_SILENCE, oTarget))
            {
                if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, (PRCGetSaveDC(oTarget,OBJECT_SELF)), SAVING_THROW_TYPE_MIND_SPELLS))
                {
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDeaf, oTarget, RoundsToSeconds(nRounds));
                }
            }
        }
    }


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school
}
