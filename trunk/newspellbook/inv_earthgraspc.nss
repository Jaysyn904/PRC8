//::///////////////////////////////////////////////
//:: Name      Earthen Grasp - OnHeartbeat
//::           Stony Grasp - OnHeartbeat
//:: FileName  inv_earthgraspc.nss
//::///////////////////////////////////////////////

#include "prc_inc_combmove"
#include "inv_inc_invfunc"

void main()
{
    object oAoE = OBJECT_SELF;
    SetAllAoEInts(INVOKE_AOE_EARTHEN_GRASP_GRAPPLE, oAoE, GetSpellSaveDC());

    object oCaster = GetAreaOfEffectCreator();
    object oTarget = GetFirstInPersistentObject();
    int nCasterLevel = GetInvokerLevel(oCaster, CLASS_TYPE_WARLOCK);
    int nPenetr = SPGetPenetrAOE(oCaster);
    int StrMod = 2 + nCasterLevel / 3;

    while(GetIsObjectValid(oTarget))
    {
        if((spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE , oCaster)
          && GetCreatureFlag(oTarget, CREATURE_VAR_IS_INCORPOREAL) != TRUE
          && !GetLocalInt(oAoE, "AlreadyGrappling")
          && !GetLocalInt(oTarget, "SourceOfGrapple"))
        || GetLocalObject(oAoE, "CurrentlyGrappling") == oTarget)
        {
            //Fire cast spell at event for the target
            SignalEvent(oTarget, EventSpellCastAt(oCaster, INVOKE_EARTHEN_GRASP));

            //now do grappling and stuff
            int nGrappleSucessful = FALSE;
            //this spell doesnt need to make a touch attack
            //as defined in the spell
            int nAttackerGrappleMod = nCasterLevel + StrMod;
            nGrappleSucessful = _DoGrappleCheck(OBJECT_INVALID, oTarget, nAttackerGrappleMod);
            if(nGrappleSucessful)
            {
                //if already being grappled, apply damage
                if(GetLocalObject(oAoE, "CurrentlyGrappling") == oTarget)
                {
                    //apply the damage
                    int nDamage = d6();
                    nDamage += StrMod;
                    effect eDam = PRCEffectDamage(oTarget, nDamage, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_NORMAL);
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                }
                //now being grappled
                AssignCommand(oTarget, ClearAllActions());
                effect eHold = EffectCutsceneImmobilize();
                effect eEntangle = EffectVisualEffect(VFX_DUR_SPELLTURNING_R);
                effect eLink = EffectLinkEffects(eHold, eEntangle);
                //eLink = EffectKnockdown();
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 6.0);
                SetLocalInt(oAoE, "AlreadyGrappling", TRUE);
                SetLocalObject(oAoE, "CurrentlyGrappling", oTarget);
            }
            else
            {
                DeleteLocalInt(oAoE, "AlreadyGrappling");
                DeleteLocalObject(oAoE, "CurrentlyGrappling");
            }
        }
        oTarget = GetNextInPersistentObject();
    }
}