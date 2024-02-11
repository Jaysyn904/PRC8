// -------------------------
// CLS_FEAT_2DA by WodahsEht
// -------------------------
// Basically this utility goes through any specified cls_feat_*.2da and determines which feats
// are duplicated.  It's not exactly the fastest algorithm possible but it shouldn't take long at
// all to parse all 2da's in one fell swoop.
//
// If you want to parse all 2da's at one time, add this line to a batch file:
// for %%a in (..\2das\cls_feat_*.2da) do cls_feat_2da.exe %%a

#include <stdio.h>
#include <string.h>

int main (int argc, char *argv[])
{
	char featnum[1000][20];
	int i, j, k;
	char find[20];
	FILE *input2da;

	input2da = fopen(argv[1],"r");

    if (input2da == NULL)
    {
		printf("Error, invalid file name.\n");
		return (1);
	}

	while (i != -1 && !feof(input2da))
	{
		fscanf(input2da, "%s", &find);
		if (strcmp(find, "OnMenu") == 0)
			i = -1;
	}

	i = 0;

	while (!feof(input2da))
	{
		fscanf(input2da, "%*s");
		fscanf(input2da, "%*s");
		fscanf(input2da, "%s", &featnum[i]);
		fscanf(input2da, "%*s");
		fscanf(input2da, "%*s");
		fscanf(input2da, "%*s");
		i++;
	}

	fclose(input2da);

	i--;

	i = (i > 1000) ? 1000 : i;

	for (j = 0 ; j <= i ; j++)
	{
		for (k = j - 1 ; k >= 0 ; k--)
		{
			if (strcmp(featnum[j], featnum[k]) == 0 &&
				strcmp(featnum[j], "****") != 0 &&
				strcmp(featnum[k], "****") != 0)
					printf("Lines %i and %i have the same feat number.\n", j/* + 4*/, k/* + 4*/); // Busquishage - Ornedan
		}
	}

	return (0);
}
