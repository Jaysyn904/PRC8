//::///////////////////////////////////////////////
//:: Name      Caustic Mire - OnHeartbeat
//:: FileName  inv_causticmirec.nss
//::///////////////////////////////////////////////

#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{
    object oCaster = GetAreaOfEffectCreator();
    int CasterLvl = GetInvokerLevel(oCaster, CLASS_TYPE_WARLOCK);
    int nPenetr = SPGetPenetrAOE(oCaster, CasterLvl);

    object oTarget = GetFirstInPersistentObject();
    while(GetIsObjectValid(oTarget))
    {
        //Spell resistance check
        if(!PRCDoResistSpell(oCaster, oTarget, nPenetr))
        {
            location lLastLocation = GetLocalLocation(oTarget, "LastMirePos");
            float fDistance = GetDistanceBetweenLocations(lLastLocation, GetLocation(oTarget));

            int nDam = FloatToInt(fDistance / FeetToMeters(5.0));
            if(nDam == 0) nDam = 1;
            effect eDam = EffectDamage(d6(nDam), DAMAGE_TYPE_ACID);
            effect eLink = EffectLinkEffects(eDam, EffectVisualEffect(VFX_IMP_ACID_S));

            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
        }
        SetLocalLocation(oTarget, "LastMirePos", GetLocation(oTarget));

        oTarget = GetNextInPersistentObject();
    }
}
