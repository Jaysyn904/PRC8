#include "inc_pers_array"

void main()
{
    //ExecuteScript("nw_ch_ac7", OBJECT_SELF);
    //dont fire the bioware one, it does odd things
    //remove golem from masters list
    object oPC = GetMaster(OBJECT_SELF);
    int i;
    string sResRef = GetResRef(OBJECT_SELF);
    for(i=0;i<persistant_array_get_size(oPC, "GolemList");i++)
    {
        string sArrayResRef = persistant_array_get_string(oPC, "GolemList",i);
        if(sArrayResRef == sResRef)
        {
            persistant_array_set_string(oPC, "GolemList", i, "");
            int j;
            for(j=i+1;j<persistant_array_get_size(oPC, "GolemList");j++)
            {
                persistant_array_set_string(oPC, "GolemList", i, persistant_array_get_string(oPC, "GolemList",j));  
            }
            persistant_array_shrink(oPC, "GolemList",persistant_array_get_size(oPC, "GolemList")-1);
            break; //exit for
        }    
    }
    
}