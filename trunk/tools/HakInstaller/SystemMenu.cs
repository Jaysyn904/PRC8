//
// This code was pulled from www.developerfusion.com
//

using System; 
using System.Runtime.InteropServices; 
using System.Windows.Forms; 
using System.Windows; 
using System.Collections; 

namespace System
{
	public class SystemMenu : ArrayList 
	{ 
    
		public const int BYPOSITION = 0x400; 
		public const int REMOVE     = 0x1000; 
		public const int CHECKED    = 0x8; 
		public const int APPEND     = 0x100; 
		public const int SEPERATOR  = 0x800; 
		public const int GRAYED     = 0x1; 
		public const int DISABLED   = 0x2; 
		public const int BITMAP     = 0x4; 
		public const int RADIOCHECK = 0x200; 
		public const int BREAK      = 0x40; 
		public const int BARBREAK   = 0x20; 

		[DllImport("user32.dll")] 
		private static extern int GetSystemMenu(int HWND); 
		[DllImport("user32.dll")] 
		private static extern int AppendMenu(int MenuHandle, int Props, int FlagsW, string text); 
		[DllImport("user32.dll")] 
		private static extern int RemoveMenu(int MenuHandle, int pos, int Flags); 
		[DllImport("user32.dll")] 
		private static extern int GetMenuItemID(int Menuhandle, int pos); 
		[DllImport("user32.dll")] 
		private static extern int ModifyMenu(int MHandle, int pos,int flags,int newPos,string text); 

		private Form form; 
		private int SystemMenuHandle; 
    
		public int Handle 
		{ 
			get { return SystemMenuHandle; } 
		} 

		public SystemMenu(Form f) : base(0) 
		{ 
			form = f; 
			SystemMenuHandle = GetSystemMenu(form.Handle.ToInt32()); 
		} 
    
		public void Add(SystemMenuItem MI) 
		{ 
			base.Add(MI); 
			if(MI.Text == "-") 
			{ 
				AppendMenu(SystemMenuHandle,SystemMenu.SEPERATOR,MI.MenuID,null); 
			} 
			else 
			{ 
				AppendMenu(SystemMenuHandle,MI.Flags,MI.MenuID,MI.Text); 
			} 
		} 

		public void Remove(SystemMenuItem MI) 
		{ 
			base.Remove(MI); 
			RemoveMenu(SystemMenuHandle, MI.MenuID, 0); 
		} 

		public void ModifyMenuPosition(int pos, int flags, string text) 
		{ 
			ModifyMenu(this.Handle, pos, flags|SystemMenu.BYPOSITION, pos, text); 
		} 

		public new SystemMenuItem this[int index] 
		{ 
			get { return (SystemMenuItem)base[index]; } 
			set 
			{ 
				if(value!=null) 
				{ 
					SystemMenuItem MI = (SystemMenuItem)value; 
					ModifyMenu(this.Handle, this[index].MenuID, MI.Flags, MI.MenuID, MI.Text); } 
				base[index] = (object)value; 
			} 
		} 

	}// end of class SystemMenu 

	public class SystemMenuItem : MenuItem 
	{ 
		[DllImport("user32.dll")] 
		private static extern int GetSystemMenu(int HWND); 
		[DllImport("user32.dll")] 
		private static extern int AppendMenu(int MenuHandle, int Props, int FlagsW, string text); 
		[DllImport("user32.dll")] 
		private static extern int RemoveMenu(int MenuHandle, int pos, int Flags); 
		[DllImport("user32.dll")] 
		private static extern int GetMenuItemID(int Menuhandle, int pos); 
		[DllImport("user32.dll")] 
		private static extern int ModifyMenu(int MHandle, int pos,int flags,int newPos,string text); 
		[DllImport("user32.dll")] 
		private static extern int CheckMenuItem(int HMenu, int pos, int flags); 

		private int flags = 0; 
		public int Flags 
		{ 
			get { return flags; } 
		} 

		private SystemMenu menu;     
		public SystemMenuItem(string text, SystemMenu SM) 
		{ 
			base.Text = text; 
			menu = SM; 
			if(text == "-") 
				this.flags = SystemMenu.SEPERATOR; 
		} 

		public new int MenuID 
		{ 
			get { return base.MenuID; } 
		} 

		public SystemMenuItem CloneMenu(int should_be_null) 
		{ 
			should_be_null = 0; 
			return new SystemMenuItem(this.Text, menu); 
		} 

		public new bool Checked 
		{ 
			get { return base.Checked; } 
			set 
			{ 
				base.Checked = value; 
				if(base.Checked) 
				{ 
					flags = (flags|SystemMenu.CHECKED); 
					CheckMenuItem(menu.Handle, this.MenuID, flags); 
				} 
				else 
				{ 
					flags = (flags&(~SystemMenu.CHECKED)); 
					CheckMenuItem(menu.Handle, this.MenuID, flags); 
				}     
			} 
		} 

		public new string Text 
		{ 
			get { return base.Text; } 
			set 
			{ 
				base.Text = value; 
				ModifyMenu(menu.Handle, this.MenuID, this.flags, this.MenuID, base.Text); 
			} 
		} 
    
		public new bool Break 
		{ 
			get { return base.Break; } 
			set 
			{ 
				base.Break = value; 
				if(base.Break) 
				{ 
					flags = flags|SystemMenu.BREAK; 
					ModifyMenu(menu.Handle, this.MenuID, this.flags, this.MenuID, base.Text); 
				} 
				else 
				{ 
					flags = flags&(~SystemMenu.BREAK); 
					ModifyMenu(menu.Handle, this.MenuID, this.flags, this.MenuID, base.Text); 
				} 
			} 
		} 

		public new bool BarBreak 
		{ 
			get { return base.BarBreak; } 
			set 
			{ 
				base.BarBreak = value; 
				if(base.BarBreak) 
				{ 
					flags = flags|SystemMenu.BARBREAK; 
					ModifyMenu(menu.Handle, this.MenuID, this.flags, this.MenuID, base.Text); 
				} 
				else 
				{ 
					flags = flags&(~SystemMenu.BARBREAK); 
					ModifyMenu(menu.Handle, this.MenuID, this.flags, this.MenuID, base.Text); 
				} 
			} 
		} 

    
	}//end of class SystemMenuItem 
}