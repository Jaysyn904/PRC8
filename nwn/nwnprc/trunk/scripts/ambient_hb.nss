void main()
{
    if(GetLocalInt(OBJECT_SELF, "AMBIENT_RANDOM_WALK"))
        return;

    SetLocalInt(OBJECT_SELF, "AMBIENT_RANDOM_WALK", TRUE);

    ActionRandomWalk();
}