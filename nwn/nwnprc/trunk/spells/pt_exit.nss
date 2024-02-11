
#include "prc_alterations"
#include "inc_Timestop"
void main()
{
    object oTarget = GetExitingObject();
    if(GetIsDM(oTarget))
        return;
    if(oTarget == GetAreaOfEffectCreator())
        return;
    RemoveTSFromObject(oTarget);
}
