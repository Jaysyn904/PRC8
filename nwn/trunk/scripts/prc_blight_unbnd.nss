//::///////////////////////////////////////////////
//:: Unsummon
//:: prc_tn_unsum.nss
//:://////////////////////////////////////////////
/*
    Unsummons a True Necromancer or Hathran summon.
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: June 26 , 2004
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "inc_npc"

int PRCCanCreatureBeDestroyed(object oTarget)
{
    if (GetPlotFlag(oTarget) == FALSE && GetImmortal(oTarget) == FALSE)
    {
        return TRUE;
    }
    return FALSE;
}

void main()
{
    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    object oMaster = GetMaster(oTarget);
    int nDC = GetLevelByClass(CLASS_TYPE_BLIGHTER, oCaster) + 10 + GetAbilityModifier(ABILITY_WISDOM, oCaster);
    effect eVis       = EffectVisualEffect(VFX_IMP_UNSUMMON);
   
        if (oMaster == OBJECT_INVALID)
        {
            oMaster = OBJECT_SELF;  // TO prevent problems with invalid objects
            // passed into GetAssociate
        }

        // * Is the creature a summoned associate
        // * or is the creature an outsider
        // * and is there enough points in the pool
        if( // A familiar
            GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oMaster) == oTarget ||
            // A Bonded Summoner familiar
            GetTag(OBJECT_SELF) == "BONDFAMILIAR"                     ||
            // An animal companion
            GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oMaster) == oTarget
           )// End - Target validity tests
        {
            if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_NONE))
            {
                        //Apply the VFX and delay the destruction of the summoned monster so
                        //that the script and VFX can play.
                        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oTarget));
                        if(PRCCanCreatureBeDestroyed(oTarget) == TRUE)
                        {
                            //bugfix: Simply destroying the object won't fire it's OnDeath script.
                            //Which is bad when you have plot-specific things being done in that
                            //OnDeath script... so lets kill it.
                            effect eKill = EffectDamage(GetCurrentHitPoints(oTarget));
                            //just to be extra-sure... :)
                            effect eDeath = EffectDeath(FALSE, FALSE);
                            DelayCommand(0.25, ApplyEffectToObject(DURATION_TYPE_INSTANT, eKill, oTarget));
                            DelayCommand(0.25, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
                            DeathlessFrenzyCheck(oTarget);
                        }            
            }
        }    
}
