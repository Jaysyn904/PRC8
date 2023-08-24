//::///////////////////////////////////////////////
//:: Name      Hammer of Righteousness
//:: FileName  sp_ham_right.nss
//:://////////////////////////////////////////////
/**@file Hammer of Righteousness
Evocation [Force, Good]
Level: Sanctified 3
Components: V, S, Sacrifice
Casting Time: 1 standard action
Range: Medium (100 ft. + 10 ft./level)
Effect: Magic warhammer of force
Duration: Instantaneous
Saving Throw: Fortitude half
Spell Resistance: Yes

A great warhammer of positive energy springs into
existence, launches toward a target that you can
see within the range of the spell, and strikes
unerringly.

The hammer of righteousness deals 1d6 points of
damage per caster level to the target, or 1d8
points of damage per caster level if the target is
evil. The caster can decide to deal non-lethal
damage instead of lethal damage with the hammer,
or can split the damage evenly between the two
types. How the damage is split must be decided
before damage is rolled. The hammer is considered
a force effect and has no miss chance when striking
an incorporeal target. A successful Fortitude save
halves the damage.

Sacrifice: 1d3 points of Strength damage.

Author:    Tenjac
Created:   6/14/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
        if(!X2PreSpellCastCode()) return;

        PRCSetSchool(SPELL_SCHOOL_EVOCATION);

        object oPC = OBJECT_SELF;
        object oTarget = PRCGetSpellTargetObject();
        int nCasterLvl = PRCGetCasterLevel(oPC);
        int nDC = PRCGetSaveDC(oTarget, oPC);
        int nAlign = GetAlignmentGoodEvil(oTarget);
        int nMetaMagic = PRCGetMetaMagicFeat();

        PRCSignalSpellEvent(oTarget,TRUE, SPELL_HAMMER_OF_RIGHTEOUSNESS, oPC);

        if(!PRCDoResistSpell(OBJECT_SELF, oTarget, nCasterLvl + SPGetPenetr()))
        {
                int nDam = d6(nCasterLvl);

                if(nMetaMagic & METAMAGIC_MAXIMIZE)
                {
                        nDam = 6 * (nCasterLvl);
                }

                if(nAlign == ALIGNMENT_EVIL)
                {
                        nDam = d8(nCasterLvl);

                        if(nMetaMagic & METAMAGIC_MAXIMIZE)
                        {
                                nDam = 8 * (nCasterLvl);
                        }
                }

                if(nMetaMagic & METAMAGIC_EMPOWER)
                {
                        nDam += (nDam/2);
                }
				nDam += SpellDamagePerDice(oPC, nCasterLvl);
                //Save for 1/2
                if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_GOOD))
                {
                        nDam = (nDam/2);

                        if(GetHasMettle(oTarget, SAVING_THROW_FORT))
                        {
                                nDam = 0;
                        }
                }

                //Play VFX
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_STRIKE_HOLY), oTarget);

                //Apply damage
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_MAGICAL), oTarget);
        }
        DoCorruptionCost(oPC, ABILITY_STRENGTH, d3(1), 0);

        //Sanctified spells get mandatory 10 pt good adjustment, regardless of switch
        AdjustAlignment(oPC, ALIGNMENT_GOOD, 10, FALSE);

        //SPGoodShift(oPC);

        PRCSetSchool();
}


