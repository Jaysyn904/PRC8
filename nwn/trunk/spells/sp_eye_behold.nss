//::///////////////////////////////////////////////
//:: Name      Eye of the Beholder
//:: FileName  sp_eye_behold.nss
//:://////////////////////////////////////////////
/**@file Eye of the Beholder 
Transmutation [Evil] 
Level: Sor/Wiz 7 
Components: V S 
Casting Time: 1 action 
Range: Personal 
Target: Caster 
Duration: 1 round/level

One of the caster's eyes grows out of her head on 
an eyestalk, becoming like that of a beholder. Due
to the mobility of the eye, the caster gains a +2 
circumstance bonus on Spot checks. More important,
the eye has one of the beholder's eye powers,
determined randomly. The caster can use this power
as a standard action during the spell's duration.

Each type of eye produces an effect identical to 
that of a spell cast by a 13th level caster, but 
it follows the rules for a ray (see Aiming a Spell 
in Chapter 10 of the Player's Handbook). All of 
these effects have a range of 150 feet and a save 
DC of 18.

Roll 1d10 to see which eye the caster gains. 

1d10     Eye Effect

1        Charm Person: Target must make a Will save 
         or be affected as though by the spell.

2        Charm Monster: Target must make a Will save
         or be affected as though by the spell.

3        Sleep: As the spell, except that it affects
         one creature with any number of Hit Dice. 
         Target must make a Will save to resist.

4        Flesh to Stone: Target must make a Fortitude
         save or be affected as though by the spell.

5        Disintegrate: Target must make a Fortitude 
         save or be affected as though by the spell.

6        Fear: As the spell, except that it targets 
         one creature. Target must make a Will save 
         or be affected as though by the spell.

7        Slow: As the spell, except that it affects 
         one creature. Target must make a Will save 
         to resist.

8        Inflict Moderate Wounds: As the spell, dealing
         2d8+10 points of damage (Will half).

9        Finger of Death: Target must make a Fortitude
         save or be slain as though by the spell. The
         target   takes 3d6+13 points of damage if his 
         save succeeds.

10       Telekinesis: The eye can move objects or 
         creatures that weigh up to 325 pounds, as 
         though with a telekinesis spell. Creatures can
         resist the effect with a successful Will save. 


Author:    Tenjac
Created:   6/12/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);

    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nCasterLevel = PRCGetCasterLevel(oPC);
    float fDur = RoundsToSeconds(nCasterLevel);
    itemproperty iEye;

    if(nMetaMagic & METAMAGIC_EXTEND)
        fDur += fDur;

    switch(Random(9))
    {
        case 0:
            iEye = PRCItemPropertyBonusFeat(IP_FEAT_RAY_CHARM_PERSON);
            break;

        case 1:
            iEye = PRCItemPropertyBonusFeat(IP_FEAT_RAY_CHARM_MONSTER);
            break;

        case 2:
            iEye = PRCItemPropertyBonusFeat(IP_FEAT_RAY_SLEEP);
            break;

        case 3:
            iEye = PRCItemPropertyBonusFeat(IP_FEAT_RAY_FLESH_TO_STONE);
            break;

        case 4:
            iEye = PRCItemPropertyBonusFeat(IP_FEAT_RAY_DISINTEGRATE);
            break;

        case 5:
            iEye = PRCItemPropertyBonusFeat(IP_FEAT_RAY_FEAR);
            break;

        case 6:
            iEye = PRCItemPropertyBonusFeat(IP_FEAT_RAY_SLOW);
            break;

        case 7:
            iEye = PRCItemPropertyBonusFeat(IP_FEAT_RAY_INFLICT_MODERATE_WOUNDS);
            break;

        case 8:
            iEye = PRCItemPropertyBonusFeat(IP_FEAT_RAY_FINGER_OF_DEATH);
            break;
    }

    AddItemProperty(DURATION_TYPE_TEMPORARY, iEye, oSkin, fDur);

    effect eSkill = EffectSkillIncrease(SKILL_SPOT, 2);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSkill, oPC, fDur);

    PRCSetSchool();
}