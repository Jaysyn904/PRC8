// mirror_image_od.nss  
void main()  
{  
    object oDamager = GetLastDamager();  
    object oMaster = GetLocalObject(OBJECT_SELF, "oMaster");  
      
    // If damaged by anyone (not just master) and we have a valid master  
    if (GetIsObjectValid(oDamager) && GetIsObjectValid(oMaster))  
    {  
        // Destroy this image  
        SetPlotFlag(OBJECT_SELF, FALSE);  
        SetImmortal(OBJECT_SELF, FALSE);  
        DestroyObject(OBJECT_SELF, 0.0);  
          
        // Clear actions and revert faction for all other mirror images  
        string sImageTag = "PC_IMAGE" + ObjectToString(oMaster) + "mirror";  
        object oArea = GetArea(OBJECT_SELF);  
        object oCreature = GetFirstObjectInArea(oArea);  
          
        while (GetIsObjectValid(oCreature))  
        {  
            if (GetTag(oCreature) == sImageTag && oCreature != OBJECT_SELF)  
            {  
                // Clear hostile actions on a delay  
                DelayCommand(0.1, AssignCommand(oCreature, ClearAllActions(TRUE)));  
                  
                // Revert faction relationship  
                if(!GetIsPC(oMaster))  
                    DelayCommand(0.1, ChangeFaction(oCreature, oMaster));  
                else  
                    DelayCommand(0.1, ChangeToStandardFaction(oCreature, STANDARD_FACTION_DEFENDER));  
                  
                DelayCommand(0.1, SetIsTemporaryFriend(oMaster, oCreature, FALSE));  
            }  
            oCreature = GetNextObjectInArea(oArea);  
        }  
    }  
}