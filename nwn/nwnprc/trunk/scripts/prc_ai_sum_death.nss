void DestroyAllInventory(object oCreature)
{
    object oItem = GetFirstItemInInventory(oCreature);
    while (GetIsObjectValid(oItem))
    {
        DestroyObject(oItem);
        oItem = GetNextItemInInventory(oCreature);
    }
}

void main()
{
    object oDead = OBJECT_SELF;
    object oMaster = GetMaster(oDead);

    // Only destroy inventory if this creature is summoned
    if (GetIsObjectValid(oMaster))
    {
        int nType = GetAssociateType(oDead);

        if (nType == ASSOCIATE_TYPE_SUMMONED)
        {
            DestroyAllInventory(oDead);
        }
    }
	
	ExecuteScript("prc_npc_death", OBJECT_SELF);
    ExecuteScript("nw_ch_ac7", OBJECT_SELF);
}