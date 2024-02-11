#include "tetris_inc"

void main()
{
    object oPC = GetLastUsedBy();
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_IMP_UNSUMMON),
        GetLocation(OBJECT_SELF));
    DelayCommand(1.0, Tetris_StartGame(oPC));
}
