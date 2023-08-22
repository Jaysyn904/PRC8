//::///////////////////////////////////////////////
//:: Name      Channeled Pyroburst
//:: FileName  sp_chan_pyrob.nss
//:://////////////////////////////////////////////
/**@file Channeled Pyroburst
Evocation [Fire]
Level: Duskblade 4, sorcerer/wizard 4
Components: V,S
Casting Time: See text
Range: Medium
Area: See text
Duration: Instantaneous
Saving Throw: Reflex half
Spell Resistance: Yes

This spell creates a bolt of fiery energy that blasts
your enemies.  The spell's strength depends on the
amount of time you spend channeling energy into it.

If you cast this spell as a swift action, it deals
1d4 points of fire damage per two caster levels
(maximum 10d4) against a single target of your choice.

If you cast this spell as a standard action, it deals
1d6 points of fire damage per caster level
(maximum 10d6) to all creatures in a 10-foot-radius
spread.

If you cast this spell as a full-round action, it deals
1d8 points of fire damage per caster level
(maximum 10d8) to all creatures in a 15-foot-radius
spread.

If you spend 2 rounds casting this spell, it deals 1d10
points of fire damage per caster level (maximum 10d10)
to all creatures in a 20-foot-radius spread.

You do not need to declare ahead of time how long you
want to spend casting the spell. When you begin casting
the spell, you decide that you are finished casting after
the appropriate time has passed.

**/

#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_EVOCATION);

    object oPC = OBJECT_SELF;
    int nSpell = PRCGetSpellId();
    int nCasterLvl = PRCGetCasterLevel(oPC);
    object oTarget = PRCGetSpellTargetObject();
    location lLoc = PRCGetSpellTargetLocation();
    int nDC = PRCGetSaveDC(oTarget, oPC);
    int nDam;
    int nMetaMagic = PRCGetMetaMagicFeat();
    float fRadius = 0.0f;

    PRCSignalSpellEvent(oTarget, TRUE, SPELL_CHANNELED_PYROBURST, oPC);

    //Check Spell Resistance
    if(!PRCDoResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
    {
        //swift
        if(nSpell == SPELL_CHANNELED_PYROBURST_1)
        {
            if(!TakeSwiftAction(oPC))
            {
                return;
            }

            nDam = d4(min((nCasterLvl/2), 10));

            if(nMetaMagic & METAMAGIC_MAXIMIZE)
            {
                nDam = 4 * (min((nCasterLvl/2), 10));
            }
        }

        //standard
        else if(nSpell == SPELL_CHANNELED_PYROBURST_2)
        {
            nDam = d6(min(10, nCasterLvl));
            fRadius = 3.048f;

            if(nMetaMagic & METAMAGIC_MAXIMIZE)
            {
                nDam = 6 * (min(10, nCasterLvl));
            }
        }

        //full round
        else if(nSpell == SPELL_CHANNELED_PYROBURST_3)
        {
            nDam = d8(min(10, nCasterLvl));
            fRadius = 4.57f;

            if(nMetaMagic & METAMAGIC_MAXIMIZE)
            {
                nDam = 8 * (min(10, nCasterLvl));
            }
        }

        //two rounds
        else if(nSpell == SPELL_CHANNELED_PYROBURST_4)
        {
            nDam = d10(min(10, nCasterLvl));
            fRadius = 6.10f;

            if(nMetaMagic & METAMAGIC_MAXIMIZE)
            {
                nDam = 10 * (min(10, nCasterLvl));
            }
        }

        else
        {
            PRCSetSchool();
            return;
        }

        //Metamagic Empower
        if(nMetaMagic & METAMAGIC_EMPOWER)
        {
            nDam += (nDam/2);
        }
        nDam += SpellDamagePerDice(oPC, min(10, nCasterLvl));

        if(PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_FIRE))
        {
            nDam = nDam/2;
        }

        effect eDam = PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_FIRE);

        if(fRadius == 0.0f)
        {
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
        }

        else
        {
            oTarget = MyFirstObjectInShape(SHAPE_SPHERE, fRadius, lLoc, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);

            while(GetIsObjectValid(oTarget))
            {
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);

                oTarget = MyNextObjectInShape(SHAPE_SPHERE, fRadius, lLoc, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
            }
        }
    }
    PRCSetSchool();
}




