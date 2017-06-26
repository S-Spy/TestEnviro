/client/verb/check_icon_state()
	var/path_main = input(usr, "Choose a path to main dmi(with name of file) for checking.", "Icon path", "uniform.dmi")
	if(!fexists(path_main))
		usr << alert("\"[path_main]\" not found!")
		return
	var/list/icons_main = icon_states(new/icon(path_main))

	var/path_request = input(usr, "Choose a path to request dmi(with name of file) for checking.", "Icon path", "request.dmi")
	if(!fexists(path_request))
		usr << alert("\"[path_request]\" not found!")
		return
	var/list/icons_request = icon_states(new/icon(path_request))

	var/dat = "<html><body>This icons existing in \"[path_main]\" and \"[path_request]\" files: <br>"
	var/check = 1
	for(var/IS in icons_request)
		if(!(IS in icons_main))
			check = 0
			dat += "\"[IS]\" <br>"
	if(check)
		dat += "No matches | Нет совпадений"
	dat += "</body></html>"
	usr << browse(dat, "window=icons")