//::///////////////////////////////////////////////
//:: Dismissal
//:: NW_S0_Dismissal.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All summoned creatures within 30ft of caster
    make a save and SR check or be banished
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 22, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001
//:: modified by mr_bumpkin Dec 4, 2003

#include "prc_inc_spells"
#include "prc_add_spell_dc"
#include "inc_npc"

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_ABJURATION);

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oMaster;
    location lTarget = GetLocation(oCaster);
    int CasterLvl = PRCGetCasterLevel(oCaster);
    CasterLvl += SPGetPenetr();

    effect eVis = EffectVisualEffect(VFX_IMP_UNSUMMON);
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_EVIL_30);

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);

    //Get the first object in the are of effect
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget);
    while(GetIsObjectValid(oTarget))
    {
        //does the creature have a master.
        oMaster = GetMasterNPC(oTarget);
        //Is that master valid and is he an enemy
        if(GetIsObjectValid(oMaster) && spellsIsTarget(oMaster, SPELL_TARGET_STANDARDHOSTILE, oCaster))
        {
            //Is the creature a summoned associate
            int nAssociateType = GetAssociateTypeNPC(oTarget);
            if((nAssociateType == ASSOCIATE_TYPE_SUMMONED &&
                GetStringLeft(GetTag(oTarget), 14) != "psi_astral_con") ||
                nAssociateType == ASSOCIATE_TYPE_FAMILIAR ||
                nAssociateType == ASSOCIATE_TYPE_ANIMALCOMPANION ||
                GetLocalInt(oTarget, "HenchPseudoSummon"))
             {
                SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_DISMISSAL));
                 //Make SR and will save checks
                if (!PRCDoResistSpell(oCaster, oTarget, CasterLvl)
                    && !PRCMySavingThrow(SAVING_THROW_WILL, oTarget, PRCGetSaveDC(oTarget, oCaster) + 6))
                {
                     //Apply the VFX and delay the destruction of the summoned monster so
                     //that the script and VFX can play.
                     SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                     AssignCommand(oTarget, SetIsDestroyable(TRUE));
                     //OnDeath script... so lets kill it.
                     effect eKill = EffectDamage(GetCurrentHitPoints(oTarget));
                     //just to be extra-sure... :)
                     effect eDeath = EffectDeath(FALSE, FALSE);
                     DelayCommand(0.25, ApplyEffectToObject(DURATION_TYPE_INSTANT, eKill, oTarget));
                     DelayCommand(0.25, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
                     DestroyObject(oTarget, 0.5);
                }
            }
        }
        //Get next creature in the shape.
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget);
    }

    PRCSetSchool();
}
