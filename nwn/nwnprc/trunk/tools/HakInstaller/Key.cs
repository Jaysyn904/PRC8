using System;
using System.Collections;
using System.Collections.Specialized;
using System.IO;
using System.Runtime.InteropServices;
using System.Text;
using NWN.FileTypes.Tools;

namespace NWN.FileTypes.BIF
{
	/// <summary>
	/// The class encapsulates a NWN BIF file, allowing access to the files
	/// within the BIF.
	/// </summary>
	internal class Bif
	{
		#region public properties/methods
		/// <summary>
		/// Class constructor.  It caches the list of files in the BIF for quick
		/// searching.
		/// </summary>
		/// <param name="name">The name of the BIF</param>
		public Bif(string name)
		{
			// Delay loading the cache until needed.
			this.name = name;
			entries = null;
		}

		/// <summary>
		/// Attempts to extract the specified file ID from the BIF, returning
		/// the file's data in a Stream.
		/// </summary>
		/// <param name="id">The id of the file</param>
		/// <returns>A stream for the file or null if the BIF does not contain
		/// the file.</returns>
		public Stream GetFile(uint id)
		{
			id = id & 0xfffff;

			// If we haven't populated the cache then do so now.
			if (null == entries) Cache();

			// If the file isn't ours then return null.
			BifEntry entry = entries[id] as BifEntry;
			if (null == entry) return null;

			// Read the raw data into a memory stream.
			NWNLogger.Log(1, "Bif.GetFile({0}) found file in BIF {1}", id, name);
			using (FileStream reader = 
				new FileStream(name, FileMode.Open, FileAccess.Read, FileShare.Read))
			{
				// Read the file's data.
				byte[] buffer = new byte[entry.Size];
				reader.Seek(entry.Offset, SeekOrigin.Begin);
				reader.Read(buffer, 0, buffer.Length);

				// Create a memory stream for the data and return it.
				MemoryStream s = new MemoryStream(buffer, false);
				return s;
			}
		}
		#endregion

		#region private raw structures for reading bif file data
		[StructLayout(LayoutKind.Sequential, Pack=1, CharSet=CharSet.Ansi)] 
		private struct RawHeader
		{
			#region members
			public UInt32 FileType;
			public UInt32 FilerVersion;
			public UInt32 VariableResourceCount;
			public UInt32 FixedResourceCount;
			public UInt32 VariableTableOffset;
			#endregion
		}

		[StructLayout(LayoutKind.Sequential, Pack=1, CharSet=CharSet.Ansi)] 
		private struct RawEntry
		{
			#region members
			public UInt32 ID;
			public UInt32 Offset;
			public UInt32 FileSize;
			public UInt32 ResourceType;
			#endregion
		}
		#endregion

		#region private nested classes
		/// <summary>
		/// Class that contains the data for a BIF file entry
		/// </summary>
		private class BifEntry
		{
			public uint Offset;
			public uint Size;
		}
		#endregion

		#region private fields/properties/methods
		private string name;
		private Hashtable entries;

		/// <summary>
		/// Caches the biff's file entries in our hashtable.
		/// </summary>
		private void Cache()
		{
			entries = new Hashtable();

			using (FileStream reader = 
				new FileStream(name, FileMode.Open, FileAccess.Read, FileShare.Read))
			{
				// Read the file header.
				RawHeader header = (RawHeader) 
					RawSerializer.Deserialize(typeof(RawHeader), reader);

				// Read all of the variable sized resources from the BIF, storing
				// their size/offset entries in our hash table.  Fixed resources
				// are not implemented we don't have to worry about them.
				reader.Seek(header.VariableTableOffset, SeekOrigin.Begin);
				for (int i = 0; i < header.VariableResourceCount; i++)
				{
					// Read the raw entry data.
					RawEntry rawEntry = (RawEntry) 
						RawSerializer.Deserialize(typeof(RawEntry), reader);

					// Create an entry and add it to our hash table.
					BifEntry entry = new BifEntry();
					entry.Offset = rawEntry.Offset;
					entry.Size = rawEntry.FileSize;
					entries.Add((uint) (rawEntry.ID & 0xfffff), entry);
				}
			}
		}
		#endregion
	}


	/// <summary>
	/// This class encapsulates a NWN KEY file, which contains information
	/// about files stored in BIF files.
	/// </summary>
	internal class Key
	{
		/// <summary>
		/// Class constructor
		/// </summary>
		/// <param name="name">The name of the key file to load</param>
		public Key(string name)
		{
			keyFileName = name;
			bifs = new ArrayList();
			keys = new Hashtable();

			// Glue the NWN install dir onto the file name and open it.
			string fileName = Path.Combine(NWN.NWNInfo.InstallPath, name);
			using (FileStream reader = 
				new FileStream(fileName, FileMode.Open, FileAccess.Read, FileShare.Read))
			{
				// Read the file header.
				RawHeader header = (RawHeader) 
					RawSerializer.Deserialize(typeof(RawHeader), reader);

				// Read all of the BIF file entries from the key file.
				reader.Seek(header.OffsetToFileTable, SeekOrigin.Begin);
				RawFileEntry[] files = new RawFileEntry[header.BIFCount];
				for (int i = 0; i < header.BIFCount; i++)
					files[i] = (RawFileEntry) 
						RawSerializer.Deserialize(typeof(RawFileEntry), reader);

				// Loop through the BIF file entries making a list of all of
				// the BIFs this key file covers.
				byte[] fileNameBuffer = new byte[2048];
				for (int i = 0; i < header.BIFCount; i++)
				{
					// Read the raw name data and convert it to a string.
					reader.Seek(files[i].FilenameOffset, SeekOrigin.Begin);
					reader.Read(fileNameBuffer, 0, files[i].FilenameSize);
					string s = RawSerializer.DeserializeString(fileNameBuffer, 0, files[i].FilenameSize);

					// The path is relative to the install directory, so glue that on before adding
					// the BIF to our string collection.
					//if (0 != (1 & files[i].Drives))
					s = Path.Combine(NWN.NWNInfo.InstallPath, s);
					//else
					//	throw new NWNException("Uknown data in file entry block in key file {0}", name);
					bifs.Add(new Bif(s));
				}

				// Read all of the key entries, i.e. what files are in the BIFs.
				reader.Seek(header.OffsetToKeyTable, SeekOrigin.Begin);
				for (int i = 0; i < header.KeyCount; i++)
				{
					// Read the raw data.
					RawKeyEntry key = (RawKeyEntry) 
						RawSerializer.Deserialize(typeof(RawKeyEntry), reader);

					// Build the file name from the ResRef and resource type.  Then
					// add the file name and ID to our hash table.  If this booms then
					// that is because of a resource type we don't know about, for
					// now we ignore that.
					ResType resType = (ResType) key.ResourceType;
					try
					{
						string ext = resType.ToString().Substring(3, 3).ToLower();
						string s = RawSerializer.DeserializeString(key.ResRef, 0, 16);
						s = string.Format("{0}.{1}", s, ext);
						keys.Add(s, key.ResID);
					}
					catch (Exception) {}
				}
			}
		}

		/// <summary>
		/// Checks to see if the key contains the file, and if it does extracts
		/// it from it's BIF and returns it's data in a Stream.
		/// </summary>
		/// <param name="file">The file to extract</param>
		/// <returns>A Stream containing the file's data or null if the key
		/// does not contain the file.</returns>
		public Stream GetFile(string file)
		{
			if (!keys.Contains(file)) return null;

			// The file is ours, check each of our BIFS for the file.
			// The bottom 20 bits are the index in the bif and the top
			// 12 bits are the bif index in our bif array.
			uint id = (uint) keys[file];
			uint index = id >> 20;
			Bif bif = (Bif) bifs[(int) index];
			return bif.GetFile(id & 0xfffff);

			/*
			 * Not totally sure the above code is right so saving this
			foreach (Bif bif in bifs)
			{
				// Try to load the file from the BIF, if successful return it.
				Stream s = bif.GetFile(id);
				if (null != s) return s;
			}

			// If we get here something really bad has happened.
			throw new NWNException("Cannot extract file {0} from BIFs", file);
			*/
		}

		#region private raw structures for reading key file data
		[StructLayout(LayoutKind.Sequential, Pack=1, CharSet=CharSet.Ansi)] 
		private struct RawHeader
		{
			#region members
			public UInt32 FileType;
			public UInt32 FilerVersion;
			public UInt32 BIFCount;
			public UInt32 KeyCount;
			public UInt32 OffsetToFileTable;
			public UInt32 OffsetToKeyTable;
			public UInt32 BuildYear;
			public UInt32 BuildDay;
			[MarshalAs(UnmanagedType.ByValArray, SizeConst=32)] private Byte[] Reserved;
			#endregion
		}

		[StructLayout(LayoutKind.Sequential, Pack=1, CharSet=CharSet.Ansi)] 
		private struct RawFileEntry
		{
			#region members
			public UInt32 FileSize;
			public UInt32 FilenameOffset;
			public UInt16 FilenameSize;
			public UInt16 Drives;
			#endregion
		}

		[StructLayout(LayoutKind.Sequential, Pack=1, CharSet=CharSet.Ansi)] 
		private struct RawKeyEntry
		{
			#region members
			[MarshalAs(UnmanagedType.ByValArray, SizeConst=16)] public byte[] ResRef;
			public UInt16 ResourceType;
			public UInt32 ResID;
			#endregion
		}
		#endregion

		#region private fields/properties/methods
		private string keyFileName;
		private ArrayList bifs;
		private Hashtable keys;
		#endregion
	}

	
	/// <summary>
	/// This class implements a collection of all of the KEY files installed
	/// on the user's system.  It can be used to extract files from those
	/// keys.
	/// </summary>
	public class KeyCollection
	{
		#region public static methods
		/// <summary>
		/// Looks in all of the key files for the given file, extracting it
		/// from it's BIF and returning it's data in a stream.
		/// </summary>
		/// <param name="file">The file to extract</param>
		/// <returns>A Stream containing the file data or null if the file
		/// cannot be found</returns>
		public static Stream GetFile(string file)
		{
			// Get a lower case copy of just the file name.
			file = Path.GetFileName(file).ToLower();

			// Loop through all of the keys looking for the file.
			foreach (Key key in Singleton.keys)
			{
				// Ask the key for the file if we get it return it.
				Stream s = key.GetFile(file);
				if (null != s) return s;
			}

			// We couldn't find the file return null.
			return null;
		}
		#endregion

		#region private static methods
		private static KeyCollection singleton;

		/// <summary>
		/// Gets the singleton instance
		/// </summary>
		private static KeyCollection Singleton
		{
			get
			{
				if (null == singleton) singleton = new KeyCollection();
				return singleton;
			}
		}
		#endregion

		#region private fields/properties/methods
		private ArrayList keys;

		/// <summary>
		/// Default constructor
		/// </summary>
		private KeyCollection()
		{
			keys = new ArrayList();

			// Get a list of the key files for the NWN install and add the files
			// to a StringCollection, forcing the names to lower case.
			string[] filesArray = Directory.GetFiles(NWN.NWNInfo.InstallPath, "*.key");
			StringCollection files = new StringCollection();
			foreach (string file in filesArray)
				files.Add(Path.GetFileName(file).ToLower());

			// We need to do the files in a certain order, as we want to check the xp's in
			// reverse order, then the main game last.
            ProcessFile(files, "xp3.key");
			ProcessFile(files, "xp2patch.key");
			ProcessFile(files, "xp2.key");
			ProcessFile(files, "xp1patch.key");
			ProcessFile(files, "xp1.key");

			// Now process whatever is left.
			foreach (string file in files)
			{
				Key key = new Key(file);
				keys.Add(key);
			}
		}

		/// <summary>
		/// Checks to see if the string collection contains the key file, and if it does
		/// loads it and removes it from the collection.
		/// </summary>
		/// <param name="files">The list of files</param>
		/// <param name="file">The key file to process</param>
		private void ProcessFile(StringCollection files, string file)
		{
			if (files.Contains(file))
			{
				// Create the key, add it to our collection, and remove the
				// file from the list as we've loaded it.
				Key key = new Key(file);
				keys.Add(key);
				files.Remove(file);
			}
		}
		#endregion
	}
}
