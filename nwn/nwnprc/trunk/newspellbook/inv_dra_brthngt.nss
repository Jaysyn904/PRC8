//::///////////////////////////////////////////////
//:: Name      Breath of the Night
//:: FileName  inv_dra_brthngt.nss
//::///////////////////////////////////////////////
/*

Least Invocation
1st Level Spell

A misty cloud expands around you, granting 20%
concealment to any within. This cloud lasts for 1
minute before dispersing.

*/
//::///////////////////////////////////////////////

#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{
    if(!PreInvocationCastCode()) return;

    //Declare major variables including Area of Effect Object
    location lTarget = PRCGetSpellTargetLocation();
    int CasterLvl = GetInvokerLevel(OBJECT_SELF, GetInvokingClass());
    float fDuration = TurnsToSeconds(1);
    effect eAOE = EffectAreaOfEffect(INVOKE_AOE_BREATH_OF_NIGHT);

    effect eImpact = EffectVisualEffect(257);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);

    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, fDuration);
}