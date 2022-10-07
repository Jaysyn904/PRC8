//::///////////////////////////////////////////////
//:: Flame Lash
//:: NW_S0_FlmLash.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a whip of fire that targets a single
    individual
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 21, 2001
//:://////////////////////////////////////////////

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
#include "prc_inc_spells"
#include "prc_add_spell_dc"




void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);
/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    object oTarget = PRCGetSpellTargetObject();

    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);


    int nDC = PRCGetSaveDC(oTarget,OBJECT_SELF);
    int EleDmg = ChangedElementalDamage(OBJECT_SELF, DAMAGE_TYPE_FIRE);

    int nCasterLevel = CasterLvl;
    int nMetaMagic = PRCGetMetaMagicFeat();
    if(nCasterLevel > 3)
    {
        nCasterLevel = (nCasterLevel-3)/3;
    }
    else
    {
        nCasterLevel = 0;
    }
    int nDamage = d6(2 + nCasterLevel);

    //Enter Metamagic conditions
    if ((nMetaMagic & METAMAGIC_MAXIMIZE))
    {
        nDamage = 6 * (2 + nCasterLevel);//Damage is at max
    }
    if ((nMetaMagic & METAMAGIC_EMPOWER))
    {
        nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
    }
	nDamage += SpellDamagePerDice(OBJECT_SELF, 2 + nCasterLevel);
    CasterLvl +=SPGetPenetr();

    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
    effect eRay = EffectBeam(VFX_BEAM_FIRE_LASH, OBJECT_SELF, BODY_NODE_HAND);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7,FALSE);

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_FLAME_LASH));
        if (!PRCDoResistSpell(OBJECT_SELF, oTarget,CasterLvl, 1.0))
        {
            //nDamage += ApplySpellBetrayalStrikeDamage(oTarget, OBJECT_SELF);
            nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, (nDC), SAVING_THROW_TYPE_FIRE);
            effect eDam = PRCEffectDamage(oTarget, nDamage, EleDmg);
            if(nDamage > 0)
            {
                //Apply the VFX impact and effects
                DelayCommand(1.0, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                DelayCommand(1.0, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
            }
        }
    }



DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}
