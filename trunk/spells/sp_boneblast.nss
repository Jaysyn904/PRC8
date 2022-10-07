//::///////////////////////////////////////////////
//:: Name      Boneblast
//:: FileName  sp_boneblast.nss
//:://////////////////////////////////////////////
/**@file Boneblast
Necromancy [Evil]
Level: Blk 1, Clr 2
Components: V, S, M, Undead
Casting Time: 1 action
Range: Touch
Target: One creature that has a skeleton
Duration: Instantaneous
Saving Throw: Fortitude half or negates
Spell Resistance: Yes

The caster causes some bone within a touched
creature to break or crack. The caster cannot specify
which bone. Because the damage is general rather than
specific, the target takes 1d3 points of Constitution
damage. A Fortitude save reduces the Constitution damage
by half, or negates it if the full damage would have been
1 point of Constitution damage.

Material Component: The bone of a small child that still lives.


Author:    Tenjac
Created:
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
    //define vars
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nCasterLvl = PRCGetCasterLevel(oPC);
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nType = MyPRCGetRacialType(oPC);
    int nCreatureType = MyPRCGetRacialType(oTarget);
    int nDam = d3(1);
    int nDC = PRCGetSaveDC(oTarget, oPC);

    PRCSetSchool(SPELL_SCHOOL_NECROMANCY);


    //Check for PLAYER undeath
    if(nType == RACIAL_TYPE_UNDEAD)
    {
        //check for target skeleton or innate immunity
        //***RACIAL_TYPE_PLANT should also be included if it ever exists***

        if(nType != RACIAL_TYPE_UNDEAD &&
           nType != RACIAL_TYPE_OOZE   &&
           nType != RACIAL_TYPE_CONSTRUCT &&
           nType != RACIAL_TYPE_PLANT &&
           nType != RACIAL_TYPE_ELEMENTAL)

        {
            //Check for resistance
            if(!PRCDoResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
            {
                //Check for save
                if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_EVIL))
                {
                    nDam--;

                    if(GetHasMettle(oTarget, SAVING_THROW_FORT))
                    {
                        nDam = 0;
                    }
                }

                //Apply ability *DAMAGE*
                ApplyAbilityDamage(oTarget, ABILITY_CONSTITUTION, nDam, DURATION_TYPE_TEMPORARY, TRUE, -1.0f);
            }
        }
    }
    //SPEvilShift(oPC);

    PRCSetSchool();
}



