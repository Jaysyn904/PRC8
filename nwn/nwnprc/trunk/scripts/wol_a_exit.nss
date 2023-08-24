// For trigger exits

void main()
{
    object oPC = GetExitingObject();
    object oTrigger = OBJECT_SELF;
    string sTag = GetTag(oTrigger);

    if (GetIsPC(oPC))
    { 
        if (sTag == "wol_a_bbbcreek")
        {
			effect eAOE = GetFirstEffect(oPC);
			while(GetIsEffectValid(eAOE))
    		{
        		if(GetEffectTag(eAOE) == "BBBCreek")
        		    RemoveEffect(oPC, eAOE);

        		// Get next effect on the target
        		eAOE = GetNextEffect(oPC);
    		}// end while - Effect loop    		
        }           
    }     
}
