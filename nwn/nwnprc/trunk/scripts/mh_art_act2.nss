//::///////////////////////////////////////////////
//:: mh_art_act2
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates the Antidote.
    Take the gold and experience.
*/
//:://////////////////////////////////////////////
//:: Created By: Age
//:: Created On:
//:://////////////////////////////////////////////

void main()
{
    CreateItemOnObject("NW_IT_MPOTION006", GetPCSpeaker());
    TakeGoldFromCreature(150, GetPCSpeaker(), TRUE);
    SetXP(GetPCSpeaker(), GetXP(GetPCSpeaker()) - 12);
        effect eVis = EffectVisualEffect(VFX_IMP_HEAD_ODD);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetPCSpeaker());

}
