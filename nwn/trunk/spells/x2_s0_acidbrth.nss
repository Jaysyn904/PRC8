//::///////////////////////////////////////////////
//:: Mestil's Acid Breath
//:: X2_S0_AcidBrth
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// You breathe forth a cone of acidic droplets. The
// cone inflicts 1d6 points of acid damage per caster
// level (maximum 10d6).
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov, 22 2002
//:://////////////////////////////////////////////
//float SpellDelay (object oTarget, int nShape);
//:: modified by mr_bumpkin Dec 4, 2003 for prc stuff
#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_EVOCATION);

    //Declare major variables
    object oCaster = OBJECT_SELF;
    location lTargetLocation = PRCGetSpellTargetLocation();
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    int nPenetr = nCasterLevel + SPGetPenetr();
    int nMetaMagic = PRCGetMetaMagicFeat();
    int EleDmg = ChangedElementalDamage(oCaster, DAMAGE_TYPE_ACID);
    int nSaveType = ChangedSaveType(EleDmg);
    int nDamage;
    float fDelay;

    //Limit Caster level for the purposes of damage.
    if(nCasterLevel > 10)
        nCasterLevel = 10;

    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = MyFirstObjectInShape(SHAPE_SPELLCONE, 11.0, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while(GetIsObjectValid(oTarget))
    {
        if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster) && oTarget != oCaster)
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_MESTILS_ACID_BREATH));
            //Get the distance between the target and caster to delay the application of effects
            fDelay = GetDistanceBetween(oCaster, oTarget)/20.0;
            //Make SR check, and appropriate saving throw(s).
            if(!PRCDoResistSpell(oCaster, oTarget, nPenetr, fDelay))
            {
                //Detemine damage
                nDamage = d6(nCasterLevel);
                //Enter Metamagic conditions
                if(nMetaMagic & METAMAGIC_MAXIMIZE)
                    nDamage = 6 * nCasterLevel;//Damage is at max
                if(nMetaMagic & METAMAGIC_EMPOWER)
                    nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
                // Acid Sheath adds +1 damage per die to acid descriptor spells
                if (GetHasDescriptor(GetSpellId(), DESCRIPTOR_ACID) && GetHasSpellEffect(SPELL_MESTILS_ACID_SHEATH, oCaster))
                	nDamage += nCasterLevel;                      
				nDamage += SpellDamagePerDice(oCaster, nCasterLevel);
                int nDC = PRCGetSaveDC(oTarget, oCaster);

                //Adjust damage according to Reflex Save, Evasion or Improved Evasion
                nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, nDC, nSaveType);

                if(nDamage > 0)
                {
                    // Apply effects to the currently selected target.
                    effect eAcid = PRCEffectDamage(oTarget, nDamage, EleDmg);
                    effect eVis = EffectVisualEffect(VFX_IMP_ACID_L);

                    //Apply delayed effects
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eAcid, oTarget));
                    PRCBonusDamage(oTarget);
                }
            }
        }
        //Select the next target within the spell shape.
        oTarget = MyNextObjectInShape(SHAPE_SPELLCONE, 11.0, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
    PRCSetSchool();
}