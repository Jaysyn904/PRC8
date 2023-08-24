//::///////////////////////////////////////////////
//:: mh_art_act1
//:://////////////////////////////////////////////
/*
    Creates the Light Wound Potion.
    Take the gold and experience.
*/
//:://////////////////////////////////////////////
//:: Created By: Age
//:: Created On:
//:://////////////////////////////////////////////

void main()
{
    CreateItemOnObject("NW_IT_MPOTION001", GetPCSpeaker());
    TakeGoldFromCreature(10, GetPCSpeaker(), TRUE);
    SetXP(GetPCSpeaker(), GetXP(GetPCSpeaker()) - 1);
        effect eVis = EffectVisualEffect(VFX_IMP_HEAD_ODD);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetPCSpeaker());

}
