//::///////////////////////////////////////////////
//:: Name      Unliving Weapon
//:: FileName  sp_unliv_weap.nss
//:://////////////////////////////////////////////
/**@file Unliving Weapon
Necromancy [Evil]
Level: Clr 3
Components: V, S, M
Casting Time: 1 full round
Range: Touch
Targets: One undead creature
Duration: 1 hour/level
Saving Throw: Will negates
Spell Resistance: Yes

This spell causes an undead creature to explode in a
burst of powerful energy when struck for at least 1
point of damage, or at a set time no longer than the
duration of the spell, whichever comes first. The
explosion is a 10-foot radius burst that deals 1d6
points of damage for every two caster levels
(maximum 10d6).

While this spell can be an effective form of attack
against an undead creature, necromancers often use
unliving weapon to create undead capable of suicide
attacks (if such a term can be applied to something
that is already dead). Skeletons or zombies with this
spell cast upon them can be very dangerous to foes
that would normally disregard them.

Material Component: A drop of bile and a bit of sulfur.

Author:    Tenjac
Created:   5/11/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

void HiImABomb(object oTarget, int nCounter, int nHP, int nCasterLvl, int nMetaMagic, object oCaster);

#include "prc_inc_spells"
#include "prc_add_spell_dc"
void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_NECROMANCY);

    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nCasterLvl = PRCGetCasterLevel(oPC);
    int nPenetr = nCasterLvl + SPGetPenetr();
    float fDur = HoursToSeconds(nCasterLvl);
    int nMetaMagic = PRCGetMetaMagicFeat();
    if(nMetaMagic & METAMAGIC_EXTEND)
        fDur *= 2;
    int nDC = PRCGetSaveDC(oTarget, oPC);

    //only works on undead
    if(MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
    {
        if(GetMaster(oTarget) == oPC//casting on own undead
        || (!PRCDoResistSpell(oPC, oTarget, nPenetr)//Spell Resistance
            && !PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_SPELL)))//Saving Throw
        {
            int nCounter = (FloatToInt(fDur))/3;
            int nHP = GetCurrentHitPoints(oTarget);

            HiImABomb(oTarget, nCounter, nHP, nCasterLvl, nMetaMagic, oPC);
        }
    }
    PRCSetSchool();
}

void HiImABomb(object oTarget, int nCounter, int nHP, int nCasterLvl, int nMetaMagic, object oCaster)
{
    if((nCounter < 1) || GetCurrentHitPoints(oTarget) < nHP)
    {
        //unused?
        //effect eSplode = EffectDeath(TRUE, TRUE);
        //       eSplode = SupernaturalEffect(eSplode);

        location lLoc = GetLocation(oTarget);
        int nDice = min((nCasterLvl/2), 10);

        SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_BLINDDEAF), oTarget);

        object oOuch = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lLoc, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        while(GetIsObjectValid(oOuch))
        {
            int nDam = d6(nDice);
            if(nMetaMagic & METAMAGIC_MAXIMIZE)
                nDam = 6 * nDice;
            if(nMetaMagic & METAMAGIC_EMPOWER)
                nDam += (nDam/2);
			nDam += SpellDamagePerDice(oCaster, nDice);
            //Apply damage
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_MAGICAL), oOuch);

            //Get next victim
            oOuch = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lLoc, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        }
    }
    nCounter--;

    DelayCommand(3.0f, HiImABomb(oTarget, nCounter, nHP, nCasterLvl, nMetaMagic, oCaster));
}