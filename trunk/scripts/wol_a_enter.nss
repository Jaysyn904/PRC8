// For trigger enters

void main()
{
    object oPC = GetEnteringObject();
    if (!GetIsObjectValid(oPC)) oPC = GetLastUsedBy();
    object oTrigger = OBJECT_SELF;
    string sTag = GetTag(oTrigger);

    if (GetIsPC(oPC))
    {  
        if (sTag == "wol_a_bbbcreek")
        {
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(EffectMovementSpeedDecrease(50), "BBBCreek"), oPC);
        }           
    }        
}