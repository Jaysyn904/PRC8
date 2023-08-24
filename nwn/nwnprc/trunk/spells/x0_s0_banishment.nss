//::///////////////////////////////////////////////
//:: Banishment
//:: x0_s0_banishment.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All summoned creatures within 30ft of caster
    make a save and SR check or be banished
    + As well any Outsiders being must make a
    save and SR check or be banished (up to
    2 HD creatures / level can be banished)
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 22, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001

//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff

#include "prc_inc_spells"
#include "prc_add_spell_dc"
#include "inc_npc"

int PRCCanCreatureBeDestroyed(object oTarget)
{
    if (!GetPlotFlag(oTarget) && !GetImmortal(oTarget))
        return TRUE;
    return FALSE;
}

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_ABJURATION);

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oMaster;
    location lTarget = GetLocation(oCaster);
    int CasterLvl = PRCGetCasterLevel(oCaster);
    // * the pool is the number of hit dice of creatures that can be banished
    int nPool = 2 * CasterLvl;
    CasterLvl += SPGetPenetr();
    int nSpellDC;

    effect eVis = EffectVisualEffect(VFX_IMP_UNSUMMON);
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_EVIL_30);

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);

    //Get the first object in the are of effect
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTarget))
    {
        //does the creature have a master.
        oMaster = GetMasterNPC(oTarget);
        int nAssociateType = GetAssociateTypeNPC(oTarget);

        // * Is the creature a summoned associate
        // * or is the creature an outsider
        // * and is there enough points in the pool
        if(((GetIsObjectValid(oMaster) &&
             (nAssociateType == ASSOCIATE_TYPE_SUMMONED &&
              GetStringLeft(GetTag(oTarget), 14) != "psi_astral_con") ||
              nAssociateType == ASSOCIATE_TYPE_FAMILIAR ||
              nAssociateType == ASSOCIATE_TYPE_ANIMALCOMPANION ||
              GetLocalInt(oTarget, "HenchPseudoSummon")) ||
            MyPRCGetRacialType((oTarget)) == RACIAL_TYPE_OUTSIDER) &&
            nPool > 0)
        {
            // * March 2003. Added a check so that 'friendlies' will not be
            // * unsummoned.
            if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
            {
                SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_BANISHMENT));

                // * Must be enough points in the pool to destroy target
                if (nPool >= GetHitDice(oTarget))
                {
                    nSpellDC = (PRCGetSaveDC(oTarget, oCaster));

                    // * Make SR and will save checks
                    if (!PRCDoResistSpell(oCaster, oTarget, CasterLvl) && !PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nSpellDC))
                    {
                        nPool = nPool - GetHitDice(oTarget);
                        DeathlessFrenzyCheck(oTarget);
                        //Apply the VFX and delay the destruction of the summoned monster so
                        //that the script and VFX can play.
                        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oTarget));
                        if(PRCCanCreatureBeDestroyed(oTarget) == TRUE)
                        {
                            //bugfix: Simply destroying the object won't fire it's OnDeath script.
                            //Which is bad when you have plot-specific things being done in that
                            //OnDeath script... so lets kill it.
                            effect eKill = PRCEffectDamage(oTarget, GetCurrentHitPoints(oTarget));
                            //just to be extra-sure... :)
                            effect eDeath = EffectDeath(FALSE, FALSE);
                            DelayCommand(0.25, ApplyEffectToObject(DURATION_TYPE_INSTANT, eKill, oTarget));
                            DelayCommand(0.25, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
                        }
                    }
                }
            } // rep check
        }
        //Get next creature in the shape.
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }

    PRCSetSchool();
}
