/*
Tenser's Floating Disk script

Disk's heartbeat script.  If not in conversation with the caster, it will follow the caster around.

Created by: xwarren
Created: August 15, 2009
*/
void CheckRange(float fRange, object oMaster, object oDisk)
{
    if(GetDistanceToObject(oMaster) > fRange)
    {
        DelayCommand(0.5, ExecuteScript("fdisk_end", oDisk));
    }
}

void main()
{
    //check if enything is equipped in weapon inventory slots (not vital, but looks better without weapons)
    //if(GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, OBJECT_SELF))) ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, OBJECT_SELF));
    //if(GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, OBJECT_SELF))) ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, OBJECT_SELF));

    object oDisk = OBJECT_SELF;
    object oMaster = GetMaster(oDisk);
    //check if caster is in spells range
    int nCasterLevel = GetLocalInt(oDisk, "CasterLevel");
    float fRange = 8.33 + 1.67 * nCasterLevel / 2;
    if(GetDistanceToObject(oMaster) > fRange - 2)
    {
        FloatingTextStringOnCreature("You are walking too far form your floating disk", oMaster, FALSE);
        DelayCommand(3.0, CheckRange(fRange, oMaster, oDisk));
    }

    //check if disk is not overloaded
    int nWeight = GetWeight();
    int nLimit = GetLocalInt(oDisk, "Weight_Limit") + 1;

    if(nWeight > nLimit)
    {
       //if overloaded disk will not follow PC
       if(!GetLocalInt(oDisk, "overloaded"))
       {
           FloatingTextStringOnCreature("A floating disk is holding too much", oMaster, FALSE);
           SetLocalInt(oDisk, "overloaded", 1);
       }
    }
    else
    {
       //follow the PC
       DeleteLocalInt(oDisk, "overloaded");
       if(!GetLocalInt(oDisk, "bDiskBussy"))
       {
           ClearAllActions();
           ActionMoveToObject(oMaster, TRUE, 2.0);
       }
    }
}

