#include "inc_debug"
#include "xchst_inc"

void main()
{
    object oPC = GetExitingObject();
    object oChest = GetLocalObject(oPC, XCHST_CONT);

    if(GetMaster(oChest) != oPC)
        return;

    AssignCommand(GetLocalObject(oChest, XCHST_PLC), PlayAnimation(ANIMATION_PLACEABLE_CLOSE));

    AssignCommand(oChest, ClearAllActions(TRUE));
    RemoveHenchman(oPC, oChest);
    _clear_chat_vars(oPC);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectEthereal()), oChest);
}