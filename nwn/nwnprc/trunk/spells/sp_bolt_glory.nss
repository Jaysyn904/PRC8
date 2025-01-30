//::///////////////////////////////////////////////
//:: Name      Bolt of Glory
//:: FileName  sp_bolt_glory
//:://////////////////////////////////////////////
/**@file Bolt of Glory
Evocation [Good]
Level: Exalted arcanist 6, Glory 6
Components: V, S, DF
Casting Time: 1 standard action
Range: Close (25 ft. + 5 ft./level)
Effect: Ray
Duration: Instantaneous
Saving Throw: None
Spell Resistance: Yes

By casting this spell, you project a bolt of
energy from the Positive Energy Plane against one
creature. You must succeed on a ranged touch
attack to strike your target. A creature struck
takes varying damage, depending on its nature,
home plane of existence and your level:

Creature's Origin        Damage

Material Plane,
Elemental,
neutral outsider         1d6/2 levels (7d6 maximum)

Positive Energy Plane,
good outsider            none

Evil outsider,
undead creature,
Negative Energy Plane    1d6/level (15d6 maximum)


Author:    Tenjac
Created:
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_sp_tch"

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_EVOCATION);

    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nTouch = PRCDoRangedTouchAttack(oTarget);
    int nCasterLevel = PRCGetCasterLevel(oPC);
    int nRace = MyPRCGetRacialType(oTarget);
    int nAlign = GetAlignmentGoodEvil(oTarget);
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nDam;

    PRCSignalSpellEvent(oTarget,TRUE, SPELL_BOLT_OF_GLORY, oPC);

    //Beam VFX.  Ornedan is my hero.
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_HOLY, oPC, BODY_NODE_HAND, !nTouch), oTarget, 1.0f);

    //Crits automatic?
    if(nTouch)
    {
        //SR
        if(!PRCDoResistSpell(OBJECT_SELF, oTarget, nCasterLevel + SPGetPenetr()))
        {
            if((nRace == RACIAL_TYPE_UNDEAD) || (nRace == RACIAL_TYPE_OUTSIDER && nAlign == ALIGNMENT_EVIL))
            {
                nDam = d6(PRCMin(nCasterLevel, 15));

                if(nMetaMagic & METAMAGIC_MAXIMIZE)
                {
                    nDam = 6 * PRCMin(nCasterLevel, 15);
                }
                if(nMetaMagic & METAMAGIC_EMPOWER)
                {
                    nDam += (nDam/2);
                }
                nDam += SpellDamagePerDice(oPC, PRCMin(nCasterLevel,15));
            }

            if((nRace == RACIAL_TYPE_ELEMENTAL) ||
            //neutral outsider
            (nRace == RACIAL_TYPE_OUTSIDER && nAlign == ALIGNMENT_NEUTRAL) ||
            //Material native and living
            (nRace != RACIAL_TYPE_OUTSIDER && nRace != RACIAL_TYPE_UNDEAD && nRace != RACIAL_TYPE_CONSTRUCT))
            {
                nDam = d6(PRCMin(nCasterLevel/2, 7));

                if(nMetaMagic & METAMAGIC_MAXIMIZE)
                {
                    nDam = 6 * PRCMin(nCasterLevel/2, 7);
                }
                if(nMetaMagic & METAMAGIC_EMPOWER)
                {
                    nDam += (nDam/2);
                }
                nDam += SpellDamagePerDice(oPC, PRCMin(nCasterLevel/2, 7));
            }

            SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_DIVINE), oTarget);
        }
    }
    //SPGoodShift(oPC);
    PRCSetSchool();
}
