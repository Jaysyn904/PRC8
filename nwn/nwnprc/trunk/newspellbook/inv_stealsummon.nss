
#include "prc_alterations"
#include "inv_inc_invfunc"

void main()
{
    //Declare major variables
    object oMaster;
    object oTarget = PRCGetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_IMP_DOMINATE_S);
    effect eDominate = EffectDominated();
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    //Link effects
    effect eLink = EffectLinkEffects(eMind, eDominate);
    eLink = EffectLinkEffects(eLink, eDur);

    int CasterLvl = GetInvokerLevel(OBJECT_SELF, GetInvokingClass());
    CasterLvl += SPGetPenetr();
    int nDuration = CasterLvl + 1;

    //does the creature have a master.
    oMaster = GetMaster(oTarget);
    //Is that master valid and is he an enemy
    if(GetIsObjectValid(oMaster) && GetIsEnemy(oMaster))
    {
        // * Is the creature a summoned associate
        if((GetAssociate(ASSOCIATE_TYPE_SUMMONED, oMaster) == oTarget &&
              GetStringLeft(GetTag(oTarget), 14) != "psi_astral_con"
             )                                                                 ||
            GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oMaster) == oTarget         ||
            GetTag(OBJECT_SELF)=="BONDFAMILIAR"                               ||
            GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oMaster) == oTarget
           )
        {
            if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
            {
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, INVOKE_STEAL_SUMMONING));

                if(d20() + CasterLvl > 11 + PRCGetCasterLevel(oMaster))
                {
                    //Apply the VFX and delay the destruction of the summoned monster so
                    //that the script and VFX can play.

                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration),TRUE,-1,CasterLvl);
                    DelayCommand(3.0, CheckConcentrationOnEffect(OBJECT_SELF, INVOKE_STEAL_SUMMONING, oTarget, FloatToInt(RoundsToSeconds(nDuration))));
                }
            }
        }
    }

}
