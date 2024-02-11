//::///////////////////////////////////////////////
//:: Name      Caustic Mire - OnExit
//:: FileName  inv_causticmireb.nss
//::///////////////////////////////////////////////

#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{
    //Get the object that is exiting the AOE
    object oTarget = GetExitingObject();
    object oCaster = GetAreaOfEffectCreator();
    int CasterLvl = GetInvokerLevel(oCaster, CLASS_TYPE_WARLOCK);
    int nPenetr = SPGetPenetrAOE(oCaster, CasterLvl);

    //Search through the valid effects on the target.
    effect eAOE = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eAOE))// && bValid == FALSE)
    {
        //If the effect was created by the Web then remove it
        if (GetEffectCreator(eAOE) == oCaster)
        {
            if(GetEffectSpellId(eAOE) == INVOKE_CAUSTIC_MIRE)
            {
                RemoveEffect(oTarget, eAOE);
            }
        }
        eAOE = GetNextEffect(oTarget);
    }

    if(!PRCDoResistSpell(oCaster, oTarget, nPenetr))
    {
        location lLastLocation = GetLocalLocation(oTarget, "LastMirePos");
        float fDistance = GetDistanceBetweenLocations(lLastLocation, GetLocation(oTarget));

        int nDam = FloatToInt(fDistance / FeetToMeters(5.0));
        effect eDam = EffectDamage(d6(nDam), DAMAGE_TYPE_ACID);
        effect eLink = EffectLinkEffects(eDam, EffectVisualEffect(VFX_IMP_ACID_S));

        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
    }
    DeleteLocalLocation(oTarget, "LastMirePos");
}

