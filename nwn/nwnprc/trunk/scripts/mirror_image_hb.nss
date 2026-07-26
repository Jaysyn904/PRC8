// mirror_image_hb.nss  
void main()  
{  
    object oSelf = OBJECT_SELF;  
    object oMaster = GetLocalObject(oSelf, "oMaster");  
      
    // If damaged by anyone (not just master) and we have a valid master  
    if (GetIsObjectValid(oSelf) && GetIsObjectValid(oMaster))  
    {          
        // Clear actions and revert faction for all other mirror images  
        string sImageTag = "PC_IMAGE" + ObjectToString(oMaster) + "mirror";  
        object oArea = GetArea(OBJECT_SELF);  
        object oCreature = GetFirstObjectInArea(oArea);  
          
        while (GetIsObjectValid(oCreature))  
        {  
            if (GetTag(oCreature) == sImageTag && oCreature != OBJECT_SELF)  
            {  
                // Clear hostile actions on a delay  
                DelayCommand(0.0, AssignCommand(oCreature, ClearAllActions(TRUE)));  
                  
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