void main()
{
    object oSymbol = OBJECT_SELF;
    object oCaster = GetLocalObject(oSymbol, "X2_PLC_GLYPH_CASTER");

    if(!GetIsObjectValid(oCaster) || GetIsDead(oCaster))
    {
        DestroyObject(GetLocalObject(oSymbol, "X2_PLC_GLYPH_AOE"));
        DestroyObject(oSymbol);
    }
}