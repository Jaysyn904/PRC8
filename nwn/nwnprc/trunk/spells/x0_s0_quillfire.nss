//::///////////////////////////////////////////////
//:: Quillfire
//:: [x0_s0_quillfire.nss]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Fires a cluster of quills at a target. Ranged Attack.
    1d8 + 1 point /2 levels (max 5)

*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 17 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Andrew Nobbs May 02, 2003

//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "prc_inc_spells"

#include "prc_alterations"
#include "prc_add_spell_dc"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);
/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
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
    int nCasterLvl = CasterLvl;
    int nDamage = 0;
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nCnt;
    effect eVis = EffectVisualEffect(VFX_IMP_ACID_S);

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_QUILLFIRE));
        //Apply a single damage hit for each missile instead of as a single mass
        //Make SR Check
        {
            // BK: No spell resistance for quillfire
            //if(!PRCDoResistSpell(OBJECT_SELF, oTarget, fDelay))
            {
                //eMissile = EffectVisualEffect(VFX_IMP_MIRV_FLAME);
                //Roll damage
                int nDam = d8(1);
                //Enter Metamagic conditions
                if ((nMetaMagic & METAMAGIC_MAXIMIZE))
                {
                      nDam = 8;//Damage is at max
                }
                if ((nMetaMagic & METAMAGIC_EMPOWER))
                {
                      nDam = nDam + nDam/2; //Damage/Healing is +50%
                }
                //* apply bonus damage for level
                int nBonus = nCasterLvl/ 2;
                if (nBonus > 5)
                {
                    nBonus = 5;
                }
                nDam = nDam + nBonus;
                nDam += SpellDamagePerDice(OBJECT_SELF, 1);
                //nDam += ApplySpellBetrayalStrikeDamage(oTarget, OBJECT_SELF);
                effect eDam = PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_MAGICAL);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget,0.0f,TRUE,-1,CasterLvl);
                // * also applies poison damage
                effect ePoison = EffectPoison(POISON_LARGE_SCORPION_VENOM);
                SPApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoison, oTarget,0.0f,TRUE,-1,CasterLvl);

                //Apply the MIRV and damage effect
                //SPApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget);
            }

        }
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school
}



