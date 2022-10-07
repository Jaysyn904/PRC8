/*
    sp_nght_caress

    School: Necromancy [Evil]
    Level: Sorc/Wiz 5
    Compnents: V,S
    Range: Touch
    Duration: Instantaneous
    Save: Fortitude partial
    Spell Resistance: Yes

    A touch from your hand, which sheds darkness like
    the blackest of night, disrupts the life force of
    a living creature.  Your touch deals 1d6 points of
    damage per caster level (max 15d6), and 1d6+2
    points of Constituion damage (a sucessful Fortitude
    saving throw negates the Constitution damage.)

    The spell has a special effect on an undead creature.
    An undead touched by you takes no damage, but it
    must make a successful Will saving throw or flee
    as if panicked for 1d4 rounds + 1 round per caster
    level.

    By: Tenjac
    Created: Dec 13, 2005
    Modified: Jul 2, 2006

    added spell betrayal/spellstrike damage, touch attack damage
    set vfx to DURATION_TYPE_INSTANT
*/

#include "prc_sp_func"
#include "prc_inc_sp_tch"
#include "prc_add_spell_dc"

//Implements the spell impact, put code here
//  if called in many places, return TRUE if
//  stored charges should be decreased
//  eg. touch attack hits
//
//  Variables passed may be changed if necessary
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)
{
    int nCasterLevel = PRCGetCasterLevel(OBJECT_SELF);
    int nDC = PRCGetSaveDC(oTarget, oCaster);
    int nMetaMagic = PRCGetMetaMagicFeat();
    PRCSignalSpellEvent(oTarget, TRUE, SPELL_NIGHTS_CARESS, oCaster);

    //Make touch attack
    int nTouch = PRCDoMeleeTouchAttack(oTarget);
    if(nTouch)
    {
        if(MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
        {
            //Will saving throw
            if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_EVIL))
            {
                float fRounds = RoundsToSeconds(d4(1) + nCasterLevel);
                if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND)) fRounds *= 2;
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectLinkEffects(EffectFrightened(), EffectVisualEffect(VFX_IMP_HEAD_EVIL)), oTarget, fRounds);
            }
        }
        //Spell Resistance
        else if (!PRCDoResistSpell(oCaster, oTarget, nCasterLevel + SPGetPenetr()) && PRCGetIsAliveCreature(oTarget))
        {
            //Max of 15 caster levels
            if (nCasterLevel > 15) nCasterLevel = 15;
            int nDam = d6(nCasterLevel);
            //Metmagic: Maximize
            if (nMetaMagic & METAMAGIC_MAXIMIZE) nDam = 6 * nCasterLevel;
            //Metmagic: Empower
            if (nMetaMagic & METAMAGIC_EMPOWER) nDam += (nDam/2);
            nDam += SpellDamagePerDice(oCaster, nCasterLevel);
            //Apply damage as magical
            ApplyTouchAttackDamage(oCaster, oTarget, nTouch, nDam, DAMAGE_TYPE_MAGICAL);

            // Fort saving throw
            if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_EVIL))
            {
                int nConDam = (d6(1) + 2);
                if (nMetaMagic & METAMAGIC_MAXIMIZE) nConDam = 8;
                if (nMetaMagic & METAMAGIC_EMPOWER) nConDam += (nConDam/2);
                //Ability damage healing 1 point per hour
                ApplyAbilityDamage(oTarget, ABILITY_CONSTITUTION, nConDam, DURATION_TYPE_TEMPORARY, TRUE, -1.0, FALSE, oCaster);
                //Drain VFX
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE), oTarget);
            }
        }
    }

    return nTouch;    //return TRUE if spell charges should be decremented
}

void main()
{
    object oCaster = OBJECT_SELF;
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    PRCSetSchool(GetSpellSchool(PRCGetSpellId()));
    if (!X2PreSpellCastCode()) return;
    object oTarget = PRCGetSpellTargetObject();
    int nEvent = GetLocalInt(oCaster, PRC_SPELL_EVENT); //use bitwise & to extract flags
    if(!nEvent) //normal cast
    {
        //SPEvilShift(oCaster);
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