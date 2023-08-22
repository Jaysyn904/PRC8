/*****************************************************
* Feat: Walk Through the Mountains
* Description: For 2 rounds per level
* (spell: etheralness). Used once a day.
*
* by Jeremiah Teague
*****************************************************/

void main()
{
    object oPC = OBJECT_SELF;
    int nHD = GetHitDice(oPC);
    float fDuration = RoundsToSeconds(nHD * 2);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectEthereal(), oPC, fDuration);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_DISPEL_GREATER), oPC);
}