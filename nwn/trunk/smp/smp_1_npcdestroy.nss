// NPC ONLY
// SMP_1_NPCDestroy
// Destroys themselves (the body) if dead, thier inventory is copied to the ground
// where they lay.

void main()
{
    // Debug
    if(!GetIsDead(OBJECT_SELF)) return;

    // Declare, and stop
    location lSelf = GetLocation(OBJECT_SELF);
    ClearAllActions();

    // Make sure we don't disappear just yet
    SetIsDestroyable(FALSE, FALSE, FALSE);

    // Apply cutseen invisibility
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectCutsceneGhost(), OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY), OBJECT_SELF);

    // Copy inventory
    object oToCopy = GetFirstItemInInventory();
    while(GetIsObjectValid(oToCopy))
    {
        // Droppable?
        if(GetDroppableFlag(oToCopy))
        {
            // + Copy vars, when copied across.
            CopyItem(oToCopy, OBJECT_INVALID, TRUE);
        }
        oToCopy = GetNextItemInInventory();
    }
    // Re-destroyable
    SetIsDestroyable(TRUE, FALSE, FALSE);

    // Destroy self
    DelayCommand(0.0, DestroyObject(oToCopy));
}
