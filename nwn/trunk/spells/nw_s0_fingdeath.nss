//::///////////////////////////////////////////////
//:: Finger of Death
//:: NW_S0_FingDeath
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// You can slay any one living creature within range.
// The victim is entitled to a Fortitude saving throw to
// survive the attack. If he succeeds, he instead
// sustains 3d6 points of damage +1 point per caster
// level.
*/
//:://////////////////////////////////////////////
//:: Created By: Noel Borstad
//:: Created On: Oct 17, 2000
//:://////////////////////////////////////////////
//:: Updated By: Georg Z, On: Aug 21, 2003 - no longer affects placeables

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
#include "prc_inc_spells"  
#include "prc_add_spell_dc"




void main()
{

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_NECROMANCY);
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
    int nCasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nDamage;
    effect eDam;
    effect eVis = EffectVisualEffect(VFX_IMP_DEATH_L);
    effect eVis2 = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    nCasterLvl +=SPGetPenetr();
    
    if(spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE,OBJECT_SELF))
    {
        //GZ: I still signal this event for scripting purposes, even if a placeable
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_FINGER_OF_DEATH));
         if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE && PRCGetIsAliveCreature(oTarget))
        {

            //Make SR check
            if (!PRCDoResistSpell(OBJECT_SELF, oTarget,nCasterLvl))
               {
                 //Make Forttude save
                 if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, (PRCGetSaveDC(oTarget,OBJECT_SELF)), SAVING_THROW_TYPE_DEATH))
                 {
                    DeathlessFrenzyCheck(oTarget);
                    
                    //Apply the death effect and VFX impact
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget);
                    //SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                 }
                 else
                 {
                    // Target shouldn't take damage if they are immune to death magic.
                    if (!GetIsImmune( oTarget, IMMUNITY_TYPE_DEATH) && !(GetHasMettle(oTarget, SAVING_THROW_FORT)))
                    {
                        //Roll damage
                        nDamage = d6(3) + nCasterLvl;
                        //Make metamagic checks
                        if ((nMetaMagic & METAMAGIC_MAXIMIZE))
                        {
                            nDamage = 18 + nCasterLvl;
                        }
                        if ((nMetaMagic & METAMAGIC_EMPOWER))
                        {
                            nDamage = nDamage + (nDamage/2);
                        }
                        nDamage += SpellDamagePerDice(OBJECT_SELF, 3);
                        //Set damage effect
                        eDam = PRCEffectDamage(oTarget, nDamage, DAMAGE_TYPE_NEGATIVE);
                        //Apply damage effect and VFX impact
                        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
                    }
                }
            }
        }
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}
