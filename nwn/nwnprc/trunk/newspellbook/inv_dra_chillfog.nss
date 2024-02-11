//::///////////////////////////////////////////////
//:: Name      Chilling Fog
//:: FileName  inv_dra_chillfog.nss
//::///////////////////////////////////////////////
/*

Greater Invocation
6th Level Spell

A misty cloud expands around a point you designate,
granting 20% concealment to any within. The cloud
is so thick any within are slowed to a crawl, and
attacks by those within are at a -2 penalty. In
addition, any within take 2d6 points of cold
damage per round. This cloud lasts for 1 minute per
level before dispersing.

*/
//::///////////////////////////////////////////////

#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{
    if(!PreInvocationCastCode()) return;

    object oCaster = OBJECT_SELF;
    if(GetIsObjectValid(GetLocalObject(oCaster, "ChillingFog")))
    {
        SendMessageToPC(oCaster, "You can only have one Chilling Fog cast at any given time.");
        return;
    }

    //Declare major variables including Area of Effect Object
    location lTarget = PRCGetSpellTargetLocation();
    int CasterLvl = GetInvokerLevel(oCaster, GetInvokingClass());
    float fDuration = TurnsToSeconds(CasterLvl);
    effect eAOE = EffectAreaOfEffect(INVOKE_AOE_CHILLFOG);
    effect eImpact = EffectVisualEffect(257);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);

    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, fDuration);

    object oAoE = GetAreaOfEffectObject(lTarget, "INVOKE_AOE_CHILLFOG");
    SetAllAoEInts(INVOKE_CHILLING_FOG, oAoE, GetInvocationSaveDC(OBJECT_INVALID, OBJECT_SELF, INVOKE_CHILLING_FOG), 0, CasterLvl);
    SetLocalObject(oCaster, "ChillingFog", oAoE);
}