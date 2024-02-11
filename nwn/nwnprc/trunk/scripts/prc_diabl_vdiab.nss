void main()
{
    object oCaster = OBJECT_SELF;
    
    if (GetLocalInt(oCaster, "VileDiabolism") == FALSE)
    {
       	SetLocalInt(oCaster, "VileDiabolism", TRUE);
    	FloatingTextStringOnCreature("Vile Diabolism On", oCaster, FALSE);
    }
    else
    {
       	SetLocalInt(oCaster, "VileDiabolism", FALSE);
    	FloatingTextStringOnCreature("Vile Diabolism Off", oCaster, FALSE);
    }    
    //FloatingTextStringOnCreature(IntToString(GetLocalInt(oCaster, "VileDiabolism")), oCaster, FALSE);
}