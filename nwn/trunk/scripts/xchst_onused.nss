#include "inc_debug"
#include "xchst_inc"

void main()
{
    object oPC = GetLastUsedBy();

    if(!GetIsPC(oPC))
        return;

    object oChest = GetLocalObject(OBJECT_SELF, XCHST_CONT);

    //only owner(caster) can open the chest
    if(oPC != GetLocalObject(oChest, XCHST_OWN))
        return;

    ClearAllActions();
    PlayAnimation(ANIMATION_PLACEABLE_OPEN);

    if(GetMaster(oChest) != oPC)
    {
        //add as henchmen and open inventory
        int i = GetMaxHenchmen();
        SetMaxHenchmen(99);
        AddHenchman(oPC, oChest);
        SetMaxHenchmen(i);
    }
    DelayCommand(1.0f, OpenInventory(oChest, oPC));
    AddChatEventHook(oPC, "xchst_chat");
}