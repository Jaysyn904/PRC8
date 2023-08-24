/*
Tenser's Floating Disk script

Disk's OnSpawn script.

Created by: xwarren
Created: August 15, 2009
*/

void ApplyDuration()
{
int nDuration = GetLocalInt(OBJECT_SELF, "nDuration");
float fDelay = HoursToSeconds(nDuration)-1.5;

DelayCommand(fDelay, ExecuteScript("fdisk_end", OBJECT_SELF));
}

void main()
{
DelayCommand(1.0f, ApplyDuration());
}