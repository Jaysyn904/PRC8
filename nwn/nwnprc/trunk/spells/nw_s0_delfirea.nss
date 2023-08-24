//::///////////////////////////////////////////////
//:: Delayed Blast Fireball: On Enter
//:: NW_S0_DelFireA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The caster creates a trapped area which detects
    the entrance of enemy creatures into 3 m area
    around the spell location.  When tripped it
    causes a fiery explosion that does 1d6 per
    caster level up to a max of 20d6 damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 27, 2001
//:://////////////////////////////////////////////
//:: modified by mr_bumpkin Dec 4, 2003
#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);

    //Declare major variables
    object oTarget = GetEnteringObject();
    object oCaster = GetAreaOfEffectCreator();
    location lTarget = GetLocation(OBJECT_SELF);
    int nDamage;
    int nMetaMagic = PRCGetMetaMagicFeat();
    int CasterLvl = GetLocalInt(OBJECT_SELF, "X2_AoE_Caster_Level");

    int nCasterLevel = CasterLvl;
    //Limit caster level
    if (nCasterLevel > 20)
        nCasterLevel = 20;
    
    CasterLvl += SPGetPenetr();
    
    int EleDmg = GetLocalInt(OBJECT_SELF, "DelayedBlastFireballDamage");
    int nSaveType = ChangedSaveType(EleDmg);

    effect eDam;
    effect eExplode = EffectVisualEffect(VFX_FNF_FIREBALL);
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
    //Check the faction of the entering object to make sure the entering object is not in the casters faction
    if(!GetLocalInt(OBJECT_SELF, "NW_SPELL_DELAY_BLAST_FIREBALL") && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
    {
        SetLocalInt(OBJECT_SELF, "NW_SPELL_DELAY_BLAST_FIREBALL",TRUE);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
        //Cycle through the targets in the explosion area
        oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        while(GetIsObjectValid(oTarget))
        {
            if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_DELAYED_BLAST_FIREBALL));
                //Make SR check
                if (!PRCDoResistSpell(oCaster, oTarget,CasterLvl))
                {                        
                    //Enter Metamagic conditions
                    if(nMetaMagic & METAMAGIC_MAXIMIZE)
                        nDamage = 6 * nCasterLevel;//Damage is at max
                    else
                        nDamage = d6(nCasterLevel);

                    if(nMetaMagic & METAMAGIC_EMPOWER)
                        nDamage += nDamage/2;//Damage/Healing is +50%

                    nDamage += SpellDamagePerDice(OBJECT_SELF, nCasterLevel);
                    //Change damage according to Reflex, Evasion and Improved Evasion
                    int nDC = PRCGetSaveDC(oTarget, oCaster, -1);
                    nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, nDC, nSaveType, GetAreaOfEffectCreator());
                    if(nDamage > 0)
                    {
                        //Set up the damage effect
                        eDam = PRCEffectDamage(oTarget, nDamage, EleDmg);
                        
                        //Apply VFX impact and damage effect
                        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                        DelayCommand(0.01, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                        PRCBonusDamage(oTarget);
                    }
                }
            }
            //Get next target in the sequence
            oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        }
        DestroyObject(OBJECT_SELF, 1.0);
    }


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}
