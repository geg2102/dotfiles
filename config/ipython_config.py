c = get_config()

c.TerminalIPython.display_banner = True
c.TerminalInteractiveShell.editing_mode = "vi"
c.TerminalInteractiveShell.autoformatter = "black"
c.InteractiveShell.autoformatter = "black"
c.InteractiveShellApp.log_level = 20
c.InteractiveShell.autoindent = False
c.InteractiveShell.confirm_exit = False
c.InteractiveShell.xmode = "Context"
c.IPCompleter.use_jedi = True
c.PrefilterManager.multi_line_specials = True
