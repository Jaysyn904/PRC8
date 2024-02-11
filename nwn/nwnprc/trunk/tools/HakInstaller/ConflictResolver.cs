using System;
using System.Collections;
using System.Collections.Specialized;
using System.Diagnostics;
using System.IO;
using System.Globalization;
using System.Reflection;
using HakInstaller.Utilities;
using NWN;
using NWN.FileTypes;

namespace HakInstaller
{
	/// <summary>
	/// This class impelments logic to resolve file conflicts between content
	/// being added to the module from HIFs and content that already exists
	/// in the module.  Support is provided for the following:
	/// 
	/// TLK: If there are multiple tlk files between all content the class
	/// will attempt to generate a single tlk file by merging all non-empty
	/// rows into one tlk.  If multiple tlk files use the same row then
	/// the merge will fail.
	/// 
	/// 2DA: If HIFs and the module both have copies of the same 2da file
	/// then the class will attempt to generate a merge hak containing
	/// merged copies of all of the conflicting 2da's.  The merged 2da's
	/// will be built from the topmost version of the 2da from each HIF and
	/// the module.  If two content sources change the same row in a 2da
	/// and the rows are not exactly the same then the merge for that 2da
	/// will fail, but it will still attempt to merge other conflicting 2das.
	/// </summary>
	public class ConflictResolver
	{
		#region public properties/methods
		/// <summary>
		/// Class constructor
		/// </summary>
		/// <param name="progress">The interface used to provide progress information
		/// to the user</param>
		public ConflictResolver(IHakInstallProgress progress)
		{
			this.progress = progress;
			conflictHak = string.Empty;
			conflictHakDir = string.Empty;
			conflictHakMessageShown = false;
		}

		/// <summary>
		/// Attempts to resolve tlk file conflicts between the module tlk and any
		/// tlk's defined in the hifs.  It does this by attempting to build a
		/// new tlk file containing all of the tlk entries from all tlks.  If there
		/// are no overlapping entries in the tlks's then this will succeed and
		/// the name of the new tlk will be returned, if there are overlaps then
		/// this will fail and string.Empty will be returned.
		/// </summary>
		/// <param name="module">The module for which we are resolving conflicts</param>
		/// <param name="hifTlks">The list of tlk files from the HIFs being
		/// installed.</param>
		/// <returns>The name of the merge tlk file, or string.Empty if a merge tlk
		/// could not be generated.</returns>
		public string ResolveTlkConflict(Erf module, string[] hifTlks)
		{
			try
			{
				// Let the user know we are building a merge tlk.
				progress.SetMessage("Building merge tlk for module\n'{0}'.", 
					Path.GetFileNameWithoutExtension(module.FileName));
                
				// Create an array to hold all of the tlk objects.
				Tlk[] tlks = new Tlk[hifTlks.Length];

				// Load all of the tlk's.
				for (int i = 0; i < hifTlks.Length; i++)
					tlks[i] = Tlk.LoadTlk(NWNInfo.GetFullFilePath(hifTlks[i]));

				// Generate the name of the new tlk file.
				string newTlkFileName = GetFileName(module, "tlk");
				if (null == newTlkFileName) 
					throw new NWNException("Cannot create new tlk file for module {0}", module.FileName);

				// Get the largest entry count in all of the tlk files, we cannot move any of the tlk
				// entries from where they are so the new tlk file will have as many entries as the
				// largest source tlk file.
				int count = 0;
				foreach (Tlk tlk in tlks)
					if (tlk.Count > count) count = tlk.Count;

				// Create a new tlk file and add all of the entries from all of the tlk files
				// to it.
				Tlk newTlk = new Tlk(count);
				for (int i = 0; i < count; i++)
				{
					// Check to see which tlk file contains this entry.  If multiple tlk
					// files contain this entry we cannot merge the tlk's
					Tlk.TlkEntry entry = null;
					foreach (Tlk tlk in tlks)
					{
						// Ignore empty entries.
						if (i >= tlk.Count || tlk.IsEmpty(i)) continue;

						// If we haven't gotten an entry for this row yet
						// then save this entry.  If we have then we cannot
						// do the merge.
						if (null == entry)
							entry = tlk[i];
						else
						{
							// Check to see if the data in two entries is the same.
							// If it is then both tlk files have the same string
							// data in the entry and we can still do the merge.  This
							// is most likely to happen at index 0 where many tlk
							// files place "Bad Strref".
							if (0 == string.Compare(entry.Text, tlk[i].Text, true, CultureInfo.InvariantCulture))
								continue;

							throw new InvalidOperationException();
						}
					}

					// Save the entry in our new tlk file.
					if (null != entry) newTlk[i] = entry;
				}

				// Save the new tlk file and return it's file name.
				newTlk.SaveAs(NWN.NWNInfo.GetFullFilePath(newTlkFileName));
				return newTlkFileName;
			}
			catch (InvalidOperationException)
			{
				// If an error occurs return string.Empty to indicate we couldn't generate
				// a merge tlk.
				return string.Empty;
			}
		}

		/// <summary>
		/// Attempts to resolve tlk file conflicts between the module tlk and any
		/// tlk's defined in the hifs.  It does this by attempting to build a
		/// new tlk file containing all of the tlk entries from all tlks.  If there
		/// are no overlapping entries in the tlks's then this will succeed and
		/// the name of the new tlk will be returned, if there are overlaps then
		/// this will fail and string.Empty will be returned.
		/// </summary>
		/// <param name="hakInfos">The HIFs being added to the module</param>
		/// <param name="module">The module for which we are resolving conflicts</param>
		/// <param name="moduleInfo">The module info for the module</param>
		/// <param name="conflicts">The list of files in conflict</param>
		/// <returns>The name of the merge hak file, or string.Empty if a merge tlk
		/// could not be generated.</returns>
		public string ResolveConflicts(HakInfo[] hakInfos, Erf module, ModuleInfo moduleInfo,
			OverwriteWarningCollection conflicts)
		{
			try
			{
				// Reset the message shown flag so we show the message once.
				conflictHakMessageShown = false;

				// Generate the name of the conflict resolution hak and the directory
				// in which to place the files that will be added to the hak.
				conflictHak = GetFileName(module, "hak");
				conflictHakDir = NWN.NWNInfo.GetFullFilePath(conflictHak) + ".temp";

				OverwriteWarningCollection copy = conflicts.Clone();
				foreach (OverwriteWarning conflict in copy)
				{
					// Check to see if we can attempt to resolve the conflict, if
					// we can then attempt to resolve it, and if the resolution is
					// successful then remove the conflict from the collection.
					switch (Path.GetExtension(conflict.File).ToLower())
					{
						case ".2da":
							DisplayConflictHakMessage(module);
							if (Resolve2daConflict(hakInfos, module, moduleInfo, conflict))
								conflicts.Remove(conflict);
							break;
					}
				}

				// Get all of the files in the conflict hak directory, if there are none
				// then there is no conflict hak.
				if (!Directory.Exists(conflictHakDir)) return string.Empty;
				string[] files = Directory.GetFiles(conflictHakDir);
				if (0 == files.Length) return string.Empty;

				// We have some resolved conflicts make the merge hak.
				Erf hak = Erf.New(Erf.ErfType.HAK, "Auto-generated merge hak");
				foreach (string file in files)
					hak.AddFile(file, true);
				hak.SaveAs(NWN.NWNInfo.GetFullFilePath(conflictHak));
				return conflictHak;
			}
			finally
			{
				if (Directory.Exists(conflictHakDir)) Directory.Delete(conflictHakDir, true);
			}
		}
		#endregion

		#region private fields/properties/methods
		private bool conflictHakMessageShown;
		private IHakInstallProgress progress;
		private string conflictHak;
		private string conflictHakDir;

		/// <summary>
		/// Displays the building merge hak message once.
		/// </summary>
		/// <param name="module">The module that we are resolving conflicts for</param>
		private void DisplayConflictHakMessage(Erf module)
		{
			if (conflictHakMessageShown) return;

			// Let the user know we are building a merge tlk.
			progress.SetMessage("Building merge hak for module\n'{0}'.", 
				Path.GetFileNameWithoutExtension(module.FileName));
			conflictHakMessageShown = true;
		}

		/// <summary>
		/// Generates a name for a conflict resolution file (hak or tlk).  It generates
		/// a name that is currently unused on disk.
		/// </summary>
		/// <param name="module">The module for which to create a new tlk file</param>
		/// <param name="extension">The extension of the file to get a name for</param>
		/// <returns>The tlk file name, or null if the name could not be created</returns>
		private string GetFileName(Erf module, string extension)
		{
			// Use the first 12 characters of the module name as the base.  Tlk
			// files can only have 16 character names max, and we want to save 4
			// characters for the index.
			string namePrefix = Path.GetFileNameWithoutExtension(module.FileName);
			if (namePrefix.Length > 12) namePrefix = namePrefix.Substring(0, 12);
			namePrefix = namePrefix.Replace(" ", "_");

			for (int i = 1; i <= 9999; i ++)
			{
				// Build the name using the name prefix and i, if the file name
				// does not exist in the tlk directory then return it.
				string name = string.Format("{0}{1:0000}.{2}", namePrefix, i, extension);
				if (!File.Exists(NWNInfo.GetFullFilePath(name))) return name;
			}

			return null;
		}

		/// <summary>
		/// Extracts a 2da file from the specified hak file, returning a
		/// 2da object containing the 2da data.
		/// </summary>
		/// <param name="hak">The hak from which to extract the 2da</param>
		/// <param name="fileName">The file name of the 2da</param>
		/// <returns>A 2da object for the 2da file or null if the hak does not
		/// contain the 2da file</returns>
		private _2DA Extract2da(string hak, string fileName)
		{
			// Extract the 2da file from the hak and create an in memory copy.
			MemoryStream stream = Erf.GetFile(NWN.NWNInfo.GetFullFilePath(hak), fileName);
			return null == stream ? null : _2DA.Load2da(stream);
		}

		/// <summary>
		/// Gets the 2da file from the module by looking at all of the haks in the
		/// module info and checking each hak for the file.
		/// </summary>
		/// <param name="moduleInfo">The module info for the module</param>
		/// <param name="fileName">The name of the 2da to get</param>
		/// <returns>A 2da object for the 2da or null if the 2da is not in any
		/// of the module's haks</returns>
		private _2DA Get2da(ModuleInfo moduleInfo, string fileName)
		{
			// Get the list of haks in the module and loop through all of them
			// trying to load the 2da, as soon as we get it return it.
			StringCollection haks = moduleInfo.Haks;
			if (null == haks) return null;
			foreach (string hak in haks)
			{
				_2DA twoDA = Extract2da(hak + ".hak", fileName);
				if (null != twoDA) return twoDA;
			}

			return null;
		}

		/// <summary>
		/// Gets the 2da file from the HIF by looking at all of the haks in the
		/// HIF and checking each hak for the file.
		/// </summary>
		/// <param name="hakInfo">The HIF</param>
		/// <param name="fileName">The name of the 2da to get</param>
		/// <returns>A 2da object for the 2da or null if the 2da is not in any
		/// of the HIF's haks</returns>
		private _2DA Get2da(HakInfo hakInfo, string fileName)
		{
			// Get the list of haks in the HIF and loop through all of them
			// trying to load the 2da, as soon as we get it return it.
			StringCollection haks = hakInfo.ModuleProperties["hak"];
			if (null == haks) return null;
			foreach (string hak in haks)
			{
				_2DA twoDA = Extract2da(hak, fileName);
				if (null != twoDA) return twoDA;
			}

			return null;
		}

		/// <summary>
		/// Attempts to resolve conflicts for a 2da file.  It does this be attempting to
		/// merge all duplicate copies of the 2da file into one merge 2da file.
		/// </summary>
		/// <param name="hakInfos">The HIFs being added to the module</param>
		/// <param name="module">The module</param>
		/// <param name="moduleInfo">The module info for the module</param>
		/// <param name="conflict">The 2da file in conflict</param>
		private bool Resolve2daConflict(HakInfo[] hakInfos, Erf module, ModuleInfo moduleInfo,
			OverwriteWarning conflict)
		{
			try
			{
				// Create an array list and get the 2da from the module,
				// adding it to the list if we get it.
				ArrayList list = new ArrayList();
				_2DA twoDA = Get2da(moduleInfo, conflict.File);
				if (null != twoDA) list.Add(twoDA);

				// Now get all of the copies of the 2da from the various HIFs and
				// add them as well.
				foreach (HakInfo hakInfo in hakInfos)
				{
					twoDA = Get2da(hakInfo, conflict.File);
					if (null != twoDA) list.Add(twoDA);
				}

				// Load the BioWare version of the the 2da to use as a baseline, if the
				// file isn't in the bioware directory then we will have to make due w/o
				// it just make a blank 2da with the correct schema.
				_2DA bioware = LoadBioWare2da(conflict.File);

				// At this point we have all relevent copies of the conflicting 2da loaded into
				// memory, we now need to generate a merge 2da if possible.
				_2DA merge = Merge2das(bioware, list);
				if (null == merge) return false;

				// We have successfully merged all of the 2das, save the merge 2da and
				// return true.
				if (!Directory.Exists(conflictHakDir)) Directory.CreateDirectory(conflictHakDir);
				merge.SaveAs(Path.Combine(conflictHakDir, conflict.File));
				return true;
			}
			catch (Exception)
			{
				return false;
			}
		}

		/// <summary>
		/// Loads a bioware 2da file.
		/// </summary>
		/// <param name="name">The name of the 2da to load</param>
		/// <returns>A _2DA object representing the file.</returns>
		private _2DA LoadBioWare2da(string name)
		{
			Stream stream = NWN.FileTypes.BIF.KeyCollection.GetFile(name);
			_2DA bioware = _2DA.Load2da(stream);
			return bioware;
		}

		/// <summary>
		/// Attempts to merge all of the 2da's in the passed array list into 1 merge
		/// 2da, by combining all of the non-empty rows in each 2da.  If 2 2da's have
		/// changes the same row then the merge will fail.
		/// </summary>
		/// <param name="baseline">The bioware baseline version of the 2da</param>
		/// <param name="list">The list of 2da's to merge</param>
		/// <returns>The merged 2da or null if the 2da's cannot be merged</returns>
		private _2DA Merge2das(_2DA baseline, ArrayList list)
		{
			// Create a flat list to have a strongly typed list of 2da's.
			_2DA[] merges = new _2DA[list.Count];
			list.CopyTo(merges);

			// Figure out the maximum number of rows we have to deal with
			int rows = baseline.Rows;
			foreach (_2DA merge in merges)
				rows = System.Math.Max(rows, merge.Rows);

			// Create the output 2da.
			_2DA output = new _2DA(baseline.Schema);
			output.Pad(rows);

			// Loop through all rows attempting to merge each row into the
			// output 2da.
			for (int i = 0; i < rows; i++)
			{
				StringCollection mergedRow = null;
				_2DA useForOutput = null;
				foreach (_2DA merge in merges)
				{
					// Make an attempt to filter out junk rows with things
					// such as "reserved", "deleted", etc in their labels.
					// These often conflict but are really empty rows.
					if (IsJunkRow(merge, i)) continue;

					// If we have gone past the end of this 2da or the
					// row is an empty row then ignore it.
					if (i >= merge.Rows || merge.IsEmpty(i)) continue;
					
					// If this is a row from the bioware version of the 2da
					// and the data is the same as the bioware 2da then
					// ignore this row in the 2da.
					if (i < baseline.Rows &&
						_2DA.CompareRow(baseline, i, merge, i, true)) continue;

					// If we get here we have a non-empty row that differs from
					// one of the bioware rows.  Only 1 2da file per row can
					// get past this point for use to be able to do a successful
					// merge, if 2 2da's get here then 2 have changed the same
					// row and we cannot merge.

					// If we don't have any proposed row data yet then
					// save this 2da's row data.
					if (null == useForOutput)
					{
						useForOutput = merge;
						continue;
					}

					// If we get here we have 2 2da's that want to change the same row.
					// Our only hope for a successful merge is that the data in the
					// 2 2da's is identical.
					if (_2DA.CompareRow(useForOutput, i, merge, i, true)) continue;

					// We already have an output 2da, which means that 2 2da's have
					// changed the same row, attempt to glue all of the merge changes
					// together.  If we cannot generate a merged row then return null.
					mergedRow = GenerateMergeRow(baseline, list, i);
					if (null == mergedRow) return null;

					// If we get here we have generated a merge row for all 2da's
					// so we don't need to look at the data in this row any further
					// break out of the loopo and use the mergedRow.
					break;
				}

				// If we have merge 2da to copy from then copy the
				// cell data.  If we don't have a merge 2da but the row is
				// withing the baseline 2da then copy the baseline data. 
				// Otherwise don't copy any data.
				if (null != mergedRow)
					output.CopyRow(mergedRow, i);
				else if (null != useForOutput)
					output.CopyRow(useForOutput, i, i);
				else if (i < baseline.Rows)
					output.CopyRow(baseline, i, i);
			}

			return output;
		}

		/// <summary>
		/// Attempts to generate a merge row by taking all of the alterations made
		/// to the bioware row from the merge 2da's and incorporating them into 1
		/// row.  This will work unless 2 different 2da's change the same column
		/// in the row, which will make the merge fail.
		/// </summary>
		/// <param name="baseline">The bioware baseline 2da</param>
		/// <param name="list">The list of 2da's being merged</param>
		/// <param name="row">The row for which to generate a merge row</param>
		/// <returns>The merged row, or null if a merge row could not be
		/// generated.</returns>
		private StringCollection GenerateMergeRow(_2DA baseline, ArrayList list, int row)
		{
			try
			{
				// We cannot merge if the row is not in the baseline.
				if (row > baseline.Rows) return null;

				// Create a copy of the merge row in the baseline 2da.
				StringCollection resultRow = new StringCollection();
				StringCollection baselineRow = baseline.GetRowData(row);
				foreach (string s in baselineRow)
					resultRow.Add(s);
			
				// Create a bool array to keep track of which columns
				// we modify.
				bool[] writtenTo = new bool[resultRow.Count];
				for (int i = 0; i < writtenTo.Length; i++)
					writtenTo[i] = false;

				foreach (_2DA merge in list)
				{
					// Get the row from the merge 2da.
					StringCollection mergeRow = merge.GetRowData(row);

					// If the collections do not have the same length then
					// fail the merge, the added column may not be at the end.
					if (mergeRow.Count != resultRow.Count) return null;

					// Loop through all of the columns.
					for (int i = 1; i < resultRow.Count; i++)
					{
						// Ignore empty data cells in the merge row.
						if (_2DA.Empty == mergeRow[i]) continue;

						// Compare the cell value against the baseline.  If it is the
						// same then ignore it. (the result row starts out as the baseline
						// so we do not need to set these values, and we need to ignore
						// them to detect double writes to the same cell)
						if (_2DA.CompareCell(baselineRow[i], mergeRow[i], true))
							continue;

						// Compare the cells from the result row and the merge row,
						// if they are different then we need to copy the merge
						// row's value into the result row.  However, if a previous
						// merge 2da has modified this column then we have 2 different
						// 2da's wanting non-bioware default values in the same
						// column, if that happens there is no way to merge.
						if (!_2DA.CompareCell(mergeRow[i], resultRow[i], true))
						{
							// If we've already changed the bioware default for this
							// column we cannot merge return null.
							if (writtenTo[i])
								return null;
							else
							{
								// Overwrite the bioware default for this column and
								// save the fact that we have changed this column
								resultRow[i] = mergeRow[i];
								writtenTo[i] = true;
							}
						}
					}
				}

				// If we get here we were able to take all of the various 2da
				// modifications to the bioware row and make 1 merge row with all
				// of the changes, return it.
				return resultRow;
			}
			catch (Exception)
			{
				return null;
			}
		}

		/// <summary>
		/// Returns true if the row is a junk row.
		/// </summary>
		/// <param name="file">The 2da to test</param>
		/// <param name="row">The row to test</param>
		/// <returns>True if the row is a junk row.</returns>
		private bool IsJunkRow(_2DA file, int row)
		{
			if (row >= file.Rows) return false;

			int index = file.GetIndex("LABEL");
			if (-1 == index) index = file.GetIndex("NAME");
			if (-1 == index) return false;

			// Check for common labels indicating that it is a junk row.
			string value = file[row, index].ToLower();
			if (-1 != value.IndexOf("deleted") ||
				-1 != value.IndexOf("reserved") ||
				-1 != value.IndexOf("user")) return true;
			
			return false;
		}
		#endregion
	}
}
