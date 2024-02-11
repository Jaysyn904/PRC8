using System;
using System.Collections;
using System.Collections.Specialized;
using System.Globalization;
using System.IO;
using System.Text;

namespace NWN.FileTypes
{
	/// <summary>
	/// This class represents a 2da file.  It contains all of the functionality 
	/// necessary to merge the 2da files.
	/// </summary>
	public class _2DA
	{
		#region public properties
		public const string Empty = "****";
	
		/// <summary>
		/// Gets the number of rows in the 2da.
		/// </summary>
		public int Rows { get { return rows.Count; } }

		/// <summary>
		/// Gets the number of columns in the 2da.
		/// </summary>
		public int Columns { get { return heading.Count; } }

		/// <summary>
		/// Gets the heading row.
		/// </summary>
		public string Heading
		{
			get { return BuildString(heading); }
		}

		/// <summary>
		/// Gets the schema for the 2da, the schema defines the columns.
		/// </summary>
		public StringCollection Schema { get { return heading; }  }

		/// <summary>
		/// Gets/sets the index'th row of the 2da.
		/// </summary>
		public string this[int index]
		{
			get { return BuildString((StringCollection) rows[index]); }
			set
			{
				// Make sure we have a schema.
				TestForSchema();

				// Parse the line to get the individual cells and throw an exception if
				// the row's cell count does not match our cell count.
				StringCollection row = ParseLine(value, false);
				if (row.Count < heading.Count)
					throw new InvalidOperationException("Row does not contain enough cells");
				else if (row.Count > heading.Count)
					throw new InvalidOperationException("Row contains too many cells");

				// Pad the 2da to make sure it has room for the row, then add it.
				Pad(index + 1);
				rows[index] = row;
			}
		}

		/// <summary>
		/// Gets/sets a cell from the 2da.
		/// </summary>
		public string this[int row, int column]
		{
			get
			{
				return ((StringCollection) rows[row])[column];
			}
			set
			{
				// Make sure we have a schema.
				TestForSchema();

				// Pad the 2da to make sure it has room for the cell, then add it.
				Pad(row + 1);
				((StringCollection) rows[row])[column] = value;
			}
		}

		/// <summary>
		/// Gets the 2da file name w/o any path.
		/// </summary>
		public string Name { get { return Path.GetFileName(fileName); } }

		/// <summary>
		/// Gets the 2da name with any specified path information.
		/// </summary>
		public string FileName { get { return fileName; } }

		/// <summary>
		/// Gets/sets the 2da offset.  All rows in the 2da have their row numbers
		/// shifted to be relative to this offset, i.e. the first row has a row
		/// number of offset, the second offset + 1, etc.
		/// </summary>
		public int Offset
		{
			get { return offset; }
			set
			{
				if (value == offset) return;

				// Adjust all of the row numbers to
				// the correct index value.
				int index = value;
				foreach (StringCollection row in rows)
				{
					row[0] = index.ToString();
					index++;
				}

				// Save the offset.
				offset = value;
			}
		}
		#endregion

		#region public methods
		/// <summary>
		/// Default constructor
		/// </summary>
		public _2DA()
		{
			heading = new StringCollection();
			rows = new ArrayList();
			colSizes = new int[100];
			offset = 0;
			fileName = string.Empty;
		}

		/// <summary>
		/// Class constructor
		/// </summary>
		/// <param name="schema">The schema for the 2da.  The schema defines
		/// the columns contained in the 2da</param>
		public _2DA(StringCollection schema) : this()
		{
			SetSchema(schema);
		}

		/// <summary>
		/// Class constructor
		/// </summary>
		/// <param name="schema">The schema for the 2da.  The schema defines
		/// the columns contained in the 2da</param>
		public _2DA(string[] schema) : this()
		{
			StringCollection schemaColl = new StringCollection();
			schemaColl.AddRange(schema);
			SetSchema(schemaColl);
		}

		/// <summary>
		/// Sets the schema for the 2da.  Setting the schema also clears the 2da.
		/// </summary>
		/// <param name="schema">The schema for the 2da.  The schema defines
		/// the columns contained in the 2da</param>
		public void SetSchema(string schema)
		{
			// Setup the schema for the 2da.
			heading = ParseSchema(schema);
			AddRowColumnToSchema(heading);

			// Changing the schema clears the 2da.
			Clear();
		}

		/// <summary>
		/// Sets the schema for the 2da.  Setting the schema also clears the 2da.
		/// </summary>
		/// <param name="schema">The schema for the 2da.  The schema defines
		/// the columns contained in the 2da</param>
		public void SetSchema(StringCollection schema)
		{
			// Setup the schema for the 2da.
			heading = schema;
			AddRowColumnToSchema(heading);

			// Changing the schema clears the 2da.
			Clear();
		}

		/// <summary>
		/// Sets the schema for the 2da.  Setting the schema also clears the 2da.
		/// </summary>
		/// <param name="schema">The schema for the 2da.  The schema defines
		/// the columns contained in the 2da</param>
		public void SetSchema(string[] schema)
		{
			// Setup the schema for the 2da.
			heading = new StringCollection();
			heading.AddRange(schema);
			AddRowColumnToSchema(heading);

			// Changing the schema clears the 2da.
			Clear();
		}

		/// <summary>
		/// Gets the index of a column given it's heading.
		/// </summary>
		/// <param name="headingText">The heading text</param>
		/// <returns>The index of the column or -1 if it's not found</returns>
		public int GetIndex(string headingText)
		{
			// Loop through the headings doing a case-insensetive compare of the
			// passed heading text, if we find it return the index.
			for (int i = 0; i < heading.Count; i++)
				if (0 == string.Compare(headingText, heading[i], true, CultureInfo.InvariantCulture))
					return i;

			// We didn't find the heading return -1.
			return -1;
		}

		/// <summary>
		/// Tests to see if the specified row is empty.
		/// </summary>
		/// <param name="row">The row to test</param>
		/// <returns>true if the row is empty, false if it is not.</returns>
		public bool IsEmpty (int row)
		{
			// Reality check on row argument.
			if (row < 0 || row >= rows.Count) return false;

			// Get the row and loop through all of the columns except the first
			// (which is the row number) checking to see if any are not empty.  As
			// soon as we find a non-empty row return false.
			StringCollection strings = (StringCollection) rows[row];
			for (int i = 1; i < strings.Count; i++)
				if (_2DA.Empty != strings[i])
				{
					// We need a special case here.  Many 2da's use the label column
					// to indicate reserved or free rows, purely as an informational
					// message to someone trying to mod the 2da.  If a row has data
					// in the label column but no other then we want to consider the
					// row empty as it has no meaningful content.
					if (0 == string.Compare("label", heading[i], true, CultureInfo.InvariantCulture)) continue;

					return false;
				}

			// All columns but the row number are empty return true.
			return true;
		}

		/// <summary>
		/// Tests to see if the specified cell is empty.
		/// </summary>
		/// <param name="row">The row of the cell</param>
		/// <param name="column">The column of the cell</param>
		/// <returns>true if the row is empty, false if it is not.</returns>
		public bool IsEmpty(int row, int column)
		{
			return Empty == this[row, column];
		}

		/// <summary>
		/// Clears the 2da of all cell data, preserving the schema.
		/// </summary>
		public void Clear()
		{
			// Reset the 2da to be empty.
			offset = 0;
			rows.Clear();

			// Set the column widths to be the widths of the heading cells.
			for (int i = 0; i < heading.Count; i++)
				colSizes[i] = heading[i].Length;
		}

		/// <summary>
		/// Pads the 2da to have the specified number of rows.  If the 2da already has
		/// more rows than the specified number nothing is done, if it doesn't then
		/// blank rows are added to the end to pad.
		/// </summary>
		/// <param name="length">The new row count</param>
		public void Pad(int length)
		{
			// Figure out how many rows we need to pad.
			int numPad = length - rows.Count;
			if (numPad <= 0) return;

			// Add enough empty rows to pad the 2da.
			for (int i = 0; i < numPad; i++)
			{
				StringCollection empty = EmptyRow(rows.Count);
				rows.Add(empty);
			}
		}

		/// <summary>
		/// Copies a row from a source 2da to this 2da.
		/// </summary>
		/// <param name="source">The source 2da</param>
		/// <param name="sourceRow">The index of the row in the source 2da</param>
		/// <param name="row">The index of the row in this 2da</param>
		public void CopyRow(_2DA source, int sourceRow, int row)
		{
			// Get the row from the source 2da and let our overload do all of the
			// work.
			StringCollection sourceRowData = (StringCollection) source.rows[sourceRow];
			CopyRow(sourceRowData, row);
		}

		/// <summary>
		/// Copies a row to this 2da.
		/// </summary>
		/// <param name="sourceRow"></param>
		/// <param name="row"></param>
		public void CopyRow(StringCollection sourceRow, int row)
		{
			// Get the target StringCollection, and determine the
			// number of columns to copy being the minimum between the source
			// 2da's column count and ours.
			StringCollection rowData = (StringCollection) rows[row];
			int columns = System.Math.Min(sourceRow.Count, heading.Count);

			// Copy the row data, adjusting our column widths as necessary.
			rowData[0] = row.ToString();
			colSizes[0] = System.Math.Max(colSizes[0], rowData[0].Length);
			for (int i = 1; i < columns; i++)
			{
				rowData[i] = sourceRow[i];
				colSizes[i] = System.Math.Max(colSizes[i], rowData[i].Length);
			}
		}

		/// <summary>
		/// Gets the StringCollection containing the row data for the
		/// given row.
		/// </summary>
		/// <param name="row">The row for which to get the row data</param>
		/// <returns>A StringCollection containing the row data</returns>
		public StringCollection GetRowData(int row)
		{
			return (StringCollection) rows[row];
		}

		/// <summary>
		/// Fixes up a 2da join column by adding the given offset to all of the values
		/// in the column.
		/// </summary>
		/// <param name="column">The index of the column (0 biased)</param>
		/// <param name="offset">The offset to add to the column values</param>
		public void Fixup2daColumn(int column, int offset)
		{
			// Loop through each row, adding offset to all of the
			// values in the specified column.
			foreach (StringCollection row in rows)
			{
				if ("****" != row[column])
				{
					int val = System.Int32.Parse(row[column]) + offset;
					row[column] = val.ToString();
				}
			}
		}

		/// <summary>
		/// Fixes up a 2da join column by adding the given offset to all of the values
		/// in the column.
		/// </summary>
		/// <param name="column">The index of the column (0 biased)</param>
		/// <param name="offset">The offset to add to the column values</param>
		/// <param name="customTlk">If true, indicaets that the tlk offset is for a custom
		/// tlk, this causes the custom tlk offset to be added to the offset as well.</param>
		public void FixupTlkColumn(int column, int offset, bool customTlk)
		{
			// Custom tlk's have 0x1000000 added to their
			// value, i.e. entry 0 in the tlk is really
			// index 0x1000000, etc.
			if (customTlk) offset += 0x1000000;
			Fixup2daColumn(column, offset);
		}

		/// <summary>
		/// Saves the 2da.
		/// </summary>
		public void Save()
		{
			SaveAs(fileName);
		}

		/// <summary>
		/// Saves the 2da with the given file name.
		/// </summary>
		/// <param name="fileName">The name of the 2da</param>
		public void SaveAs(string fileName)
		{
			using (StreamWriter writer = new StreamWriter(fileName, false, Encoding.ASCII))
			{
				// Write the 2da header.
				writer.WriteLine(headerString);
				writer.WriteLine();
				writer.WriteLine(Heading);

				// Write the row data.
				for (int i = 0; i < rows.Count; i++)
					writer.WriteLine(this[i]);
			}

			this.fileName = fileName;
		}
		#endregion

		#region public static methods
		/// <summary>
		/// Compares 2 2da cell values to see if they are the same or not.
		/// </summary>
		/// <param name="value1">The first value</param>
		/// <param name="value2">The second value</param>
		/// <param name="ignoreCase">True if the comparison should be case-insensitive</param>
		/// <returns>True if the cells are the same, false if they are different</returns>
		public static bool CompareCell(string value1, string value2, bool ignoreCase)
		{
			return 0 == string.Compare(value1, value2, ignoreCase, 
				CultureInfo.InvariantCulture);
		}

		/// <summary>
		/// Compares rows in 2 different 2da files to see if they are equal or not.
		/// </summary>
		/// <param name="twoDA1">The first 2da to test</param>
		/// <param name="row1">The row in the first 2da to compare</param>
		/// <param name="twoDA2">The second 2da to test</param>
		/// <param name="row">The row in the second 2da to compare</param>
		/// <param name="ignoreCase">True if the comparison should be case insensitive</param>
		/// <returns>True if the rows are equal false if they are not</returns>
		public static bool CompareRow(_2DA twoDA1, int row1, _2DA twoDA2, int row2,
			bool ignoreCase)
		{
			// Get the data for each of the rows.
			StringCollection row1Data = (StringCollection) twoDA1.rows[row1];
			StringCollection row2Data = (StringCollection) twoDA2.rows[row2];

			// If the rows have different amounts of cells then they are by
			// definition different.
			if (row1Data.Count != row2Data.Count) return false;

			// Loop through the rows doing a cell by cell compare, stopping
			// if we find any differences.  We start at column 1 to skip
			// the row numbrs which would of course be different.
			for (int i = 1; i < row1Data.Count; i++)
				if (!CompareCell(row1Data[i], row2Data[i], ignoreCase))
					return false;

			// The rows are identical return true.
			return true;
		}

		/// <summary>
		/// Factory method to create C2da objects from 2da files.
		/// </summary>
		/// <param name="fileName">The name of the 2da file</param>
		/// <returns>A 2da object for the 2da file.</returns>
		public static _2DA Load2da (string fileName)
		{
			// Open the 2da file.
			_2DA file = new _2DA(fileName);
			using(StreamReader reader = new StreamReader(fileName))
			{
				file.Read(reader);
			}

			return file;
		}

		/// <summary>
		/// Factory method to create C2da objects from streams.
		/// </summary>
		/// <param name="stream">The stream to create the 2da object from</param>
		/// <returns>A 2da object for the stream.</returns>
		public static _2DA Load2da(Stream stream)
		{
			_2DA file = new _2DA();
			using (StreamReader reader = new StreamReader(stream, Encoding.ASCII))
			{
				file.Read(reader);
			}

			return file;
		}

		/// <summary>
		/// Merges 2 2da objects, saving the results in a 2da file.  The method expects that
		/// the source 2da will have at least enough rows to be contiguous with the merge
		/// 2da (the source 2da should be padded by calling Pad() if necessary).  If the
		/// source and merge 2da's share some rows, the merge 2da rows will overwrite the
		/// source 2da rows.
		/// </summary>
		/// <param name="source">The source 2da</param>
		/// <param name="merge">The merge 2da</param>
		/// <param name="outFile">The name of the output 2da</param>
		public static void Merge2da (_2DA source, _2DA merge, string outFile)
		{
			using(StreamWriter writer = new StreamWriter(outFile, false))
			{
				// Write the 2da header.
				writer.WriteLine(headerString);
				writer.WriteLine();
				writer.WriteLine(source.Heading);

				// Make the column sizes in the source and 2da files to be the largest
				// of each file, to make the columns have the correct width.
				for (int i = 0; i < source.colSizes.Length; i++)
				{
					source.colSizes[i] = System.Math.Max(source.colSizes[i], merge.colSizes[i]);
					merge.colSizes[i] = source.colSizes[i];
				}

				// output all of the source strings before our merge.
				for (int i = 0; i < merge.Offset; i++)
				{
					string s = source[i];
					writer.WriteLine(s);
				}

				// Test all of the rows that the merge is about to overwrite to make sure they
				// are really empty.  If any are not then generate a warning message for those
				// rows.
				int end = System.Math.Min(source.rows.Count, merge.Offset + merge.rows.Count);
				for (int i = merge.Offset; i < end; i++)
					if (!source.IsEmpty(i))
					{
						//CMain.Warning("Overwriting non-empty row {0} in {1}", i, source.FileName);
					}
				
				// output all of the merge strings.
				for (int i = 0; i < merge.rows.Count; i++)
				{
					string s = merge[i];
					writer.WriteLine(s);
				}

				// output any remaining source strings, in case the merge is in the middle.
				for (int i = merge.Offset + merge.rows.Count; i < source.rows.Count; i++)
				{
					string s = source[i];
					writer.WriteLine(s);
				}

				writer.Flush();
				writer.Close();
			}
		}
		#endregion

		#region private fields/properties/methods
		private const string headerString = "2DA V2.0";

		private StringCollection heading;
		private ArrayList rows;
		private int[] colSizes;
		private int offset;
		private string fileName;

		/// <summary>
		/// Private constructor, to create objects use the static factory method
		/// </summary>
		/// <param name="fileName">The name of the 2da file</param>
		private _2DA(string fileName) : this()
		{
			// Save the name of the 2da file.
			this.fileName = fileName;
		}

		/// <summary>
		/// Checks to make sure that a schema has been defined for the 2da, and throws
		/// an InvalidOperationException if it doesn't.
		/// </summary>
		private void TestForSchema()
		{
			// If we have no heading row we have no schema throw an exception.
			if (0 == heading.Count) throw new InvalidOperationException("2da contains no schema.");
		}

		/// <summary>
		/// Creates an empty row for the 2da file.
		/// </summary>
		/// <param name="row">The index of the row which is being created</param>
		/// <returns>The empty row</returns>
		private StringCollection EmptyRow(int row)
		{
			// Create an empty row, and assign it a row number.
			StringCollection empty = new StringCollection();
			empty.Add(row.ToString());

			// Adjust the maximum width of our column if it changed.
			colSizes[0] = System.Math.Max(colSizes[0], empty[0].Length);

			// Fill all other columns with the empty value.
			int count = heading.Count;
			for (int i = 1; i < count; i++)
			{
				empty.Add(_2DA.Empty);
				colSizes[i] = System.Math.Max(colSizes[i], _2DA.Empty.Length);
			}

			// Return the empty row.
			return empty;
		}

		/// <summary>
		/// Builds a string from the data for the row.  The string has padding whitespace
		/// inserted such that all of the columns in the 2da will line up of the lines are
		/// output to a text file.
		/// </summary>
		/// <param name="row">The row for which to build the string</param>
		/// <returns></returns>
		private string BuildString(StringCollection row)
		{
			System.Text.StringBuilder b = new System.Text.StringBuilder(4096);
			int i = 0;
			foreach (string s in row)
			{
				// If this is not the first row add a space separator.
				if (i > 0) b.Append(' ');

				// If the string contains spaces then wrap it in quotes.
				string value = s;
				if (value.IndexOf(' ') >= 0) value = string.Format("\"{0}\"", value);

				// Add the string data and any whitespace padding necessary.
				b.Append(value);
				if (value.Length < colSizes[i]) b.Append(' ', colSizes[i] - value.Length);
				i++;
			}

			return b.ToString();
		}

		/// <summary>
		/// Adds the empty column for the row numbers to a schema
		/// </summary>
		/// <param name="schema">The schema to add the line to</param>
		private void AddRowColumnToSchema(StringCollection schema)
		{
			// If the first entry is not blank then we need to add an empty
			// column for the row number to the schema.
			if (string.Empty != schema[0]) schema.Insert(0, string.Empty);
		}

		/// <summary>
		/// Builds the schema for the 2da by parsing the text line.
		/// </summary>
		/// <param name="line">The line to parse</param>
		/// <returns>A string collection containing the schema</returns>
		private StringCollection ParseSchema(string line)
		{
			// Call ParseLine() to parse the schema line into the individual cell values,
			// then add an extra blank entry for the row number.
			StringCollection schema = ParseLine(line, true);
			AddRowColumnToSchema(schema);
			return schema;
		}

		/// <summary>
		/// Parses a 2da file line to break the line into each of the column values.
		/// Parses both the heading line (which contains no row number) and row data
		/// lines (which do).
		/// </summary>
		/// <param name="line">The line to parse</param>
		/// <param name="headerLine">True if the line is a header line</param>
		/// <returns>A StringCollection containing the line's data</returns>
		private StringCollection ParseLine(string line, bool headerLine)
		{
			StringCollection coll = new StringCollection();

			// Determine the start index for the column sizes, if it's a header
			// line we are parsing then the start index is 1 otherwise it's 0
			int iColSize = headerLine ? 1 : 0;

			try
			{
				for (int i= 0;;)
				{
					// Skip whitespace, if we skip past the end of the string then an
					// index out of range exception will be thrown which we catch
					// to end the parse.
					while (' ' == line[i] || '\t' == line[i]) i++;

					// OK, hack time.  Some 2da's (itemprops.2da is the known case have 
					// a "Label" column as the last column.  In this case the "label" 
					// IGNORES the rules about quoting spaces and allows spaces in the name,
					// we have to catch this case by checking the schema to see if we are
					// on the last column and it is called "Label".
					bool isLabelColumn = !headerLine &&
						coll.Count == heading.Count - 1 && 
						0 == string.Compare(heading[coll.Count], "LABEL", true, CultureInfo.InvariantCulture);

					// items in a 2da are separated by whitespace, unless quoted.
					if (isLabelColumn)
					{
						// If we are reading the name column just grab the rest of the text to the
						// end of the line and remove trailing whitespace.
						string s = line.Substring(i);
						s = s.Trim();
						coll.Add(s);
						i = line.Length;
					}
					else if ('"' == line[i])
					{
						// Find the end quote then add the substring.
						int iEndQuote = line.IndexOf('"', i + 1);
						string s = line.Substring(i + 1, iEndQuote - i - 1);
						coll.Add (s);
					
						// If the string we just added is the widest string for this column we've
						// seen then save that info.
						colSizes[iColSize] = System.Math.Max(colSizes[iColSize], s.Length);
						iColSize++;

						// Advance i past what we just added.
						i = iEndQuote + 1;
					}
					else
					{
						// Find the next whitespace char and add the substring to the collection.
						int iFirstWhitespace = line.IndexOfAny(new char[]{' ', '\t'}, i);
						if (-1 == iFirstWhitespace) iFirstWhitespace = line.Length;
						string s = line.Substring(i, iFirstWhitespace - i);
						coll.Add(s);

						// If the string we just added is the widest string for this column we've
						// seen then save that info.
						colSizes[iColSize] = System.Math.Max(colSizes[iColSize], s.Length);
						iColSize++;

						// Advance i past what we just added.
						i = iFirstWhitespace;
					}
				}
			}
			catch (System.IndexOutOfRangeException)
			{
				// We use this exception as the terminating condition of the loop, so no
				// error.
			}

			return coll;
		}

		/// <summary>
		/// Reads 2da data from the specified stream, initializing the object with
		/// the 2da data.
		/// </summary>
		/// <param name="reader">The reader from which to read the data</param>
		private void Read(StreamReader reader)
		{
			// 2da files have the header followed by a line of white space.
			// Consume that now.
			reader.ReadLine();
			reader.ReadLine();

			// Read the header into memory and add an extra 
			// Now read the header and all of the data into memory.
			for (bool fHeader = true; reader.Peek() > -1; fHeader = false)
			{
				string line = reader.ReadLine();
				line = line.Trim();
				if (0 == line.Length) continue;

				// Parse the line into the collection of individual strings.  If
				// we have just read in the header row we don't have a heading
				// for the row number, so add a dummy column to the front of
				// the array so the header and data rows have the same number of
				// columns.
				StringCollection strings = fHeader ?
					ParseSchema(line) : ParseLine(line, fHeader);

				if (fHeader)
					heading = strings;
				else
				{
					// Do a reality check on the column count.
					// Commented out until the CEP team fixes their fucked up 2da.
					/*
					if (strings.Count != Columns)
						throw new InvalidOperationException(
							string.Format("Row {0} in {1} does not have the correct number of columns",
							rows.Count, Name));
					*/

					rows.Add(strings);
				}
			}
		}
		#endregion
	}
}
