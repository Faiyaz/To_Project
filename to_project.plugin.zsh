function to_project() 
{
	## Localize
	typeset -a env domain app
	typeset invalid_choice web_root

	## Set some intial arrays
	env=('development' 'test' 'production') # custom environments
	domain=('faiyazhaider' 'funcfoo' 'devoop') # custom domains
	app=('custom' 'mobile' 'web') # custom apps

	## Set some common variables
	invalid_choice="\n${bg[red]}${fg_bold[red]} Invalid choice ${reset_color}"
	web_root="/Library/WebServer/Documents/www"

	# Start out by changing directory to the root of of web directory
	cd $web_root
	## Begin user input selection process
	# 1) Environment
	clear
	print "${bg[green]}${fg_bold[green]} Select environment ${reset_color}\n"
	print "Type ${fg_bold[green]}1${reset_color} for ${fg_bold[green]}${env[1]}${reset_color}"
	print "Type ${fg_bold[green]}2${reset_color} for ${fg_bold[green]}${env[2]}${reset_color}"
	print "Type ${fg_bold[green]}3${reset_color} for ${fg_bold[green]}${env[3]}${reset_color}\n"
	read selection"?Type the number: "
	# Condition to verify if user selected a valid environment
	if [[ $selection -gt 0 && $selection -le ${#env[@]} ]]; then
		chosen_env=${env[$selection]}
		# Move into the chosen environment
		cd $chosen_env
		# Using sub-string to make smaller environment string name
		if [[ $chosen_env == ${env[1]} ]]; then
			small_env=${chosen_env:0:3}
		elif [[ $chosen_env == ${env[3]} ]]; then
			small_env=${chosen_env:0:4}
		else 
			small_env=$chosen_env
		fi
		# 2) Domain
		clear
		print "${bg[yellow]}${fg_bold[yellow]} Select domain ${reset_color}\n"
		print "Type ${fg_bold[yellow]}1${reset_color} for ${fg_bold[yellow]}${domain[1]}${reset_color}"
		print "Type ${fg_bold[yellow]}2${reset_color} for ${fg_bold[yellow]}${domain[2]}${reset_color}"
		print "Type ${fg_bold[yellow]}3${reset_color} for ${fg_bold[yellow]}${domain[3]}${reset_color}\n"
		read selection"?Type the number: "
		# Condition to verify if user selected a valid domain
		if [[ $selection -gt 0 && $selection -le ${#domain[@]} ]]; then
			chosen_domain=${domain[$selection]}
			# Move into the chosen domain
			cd ${chosen_domain}.com
			# 3) Application
			clear
			print "${bg[cyan]}${fg_bold[cyan]} Select application ${reset_color}\n"
			print "Type ${fg_bold[cyan]}1${reset_color} for ${fg_bold[cyan]}${app[1]}${reset_color}"
			print "Type ${fg_bold[cyan]}2${reset_color} for ${fg_bold[cyan]}${app[2]}${reset_color}"
			print "Type ${fg_bold[cyan]}3${reset_color} for ${fg_bold[cyan]}${app[3]}${reset_color}\n"
			read selection"?Type the number: "
			# Condition to verify if user selected a valid application
			if [[ $selection -gt 0 && $selection -le ${#app[@]} ]]; then
				chosen_app=${app[$selection]}
				# Move into the chosen application
				cd $chosen_app
				# Loop through the current list of directories
				for i (*/); do
					# Except 'log', put all on a project array
					if [[ ${i:0:-1} != 'log' ]]; then
						# the -1 deletes the '/' from the end of the string
						project+=("${i:0:-1}")
					fi
				done
				# If the project array is not empty, we have projects
				if [[ ${#project[@]} -gt 0 ]]; then
					# 4) project
					clear
					print "${bg[white]}${fg_bold[white]} Select project ${reset_color}\n"
					# Loop through the project array to create selection
					for (( i=1; i<=${#project[@]}; i++ )); do
						print "Type ${fg_bold[white]}${i}${reset_color} for ${fg_bold[white]}${project[${i}]}${reset_color}"
					done
					read selection"?Type the number: "
					# Condition to verify if user selected a valid project
					if [[ $selection -gt 0 && $selection -lt ${#project[@]} ]]; then
						chosen_project=${project[$selection]}
						# Move into the chosen project
						cd $chosen_project
						#create a variable to represent the project directory and use 'eval' command to execute
						eval "${chosen_env}_${chosen_domain}_${chosen_app}_${chosen_project}=$PWD"
					fi
				else # The project array is empty
					print "${fg_bold[red]}Sorry, but you currently have no ${fg_bold[white]}${chosen_app} app ${fg_bold[red]}setup for ${fg_bold[white]}${chosen_domain}.com${reset_color}"
				fi
			else # User provided an incorrect data for app selection
				print $invalid_choice
			fi
		else # User provided an incorrect data for domain selection
			print $invalid_choice
		fi
	else # User provided an incorrect data for env selection
		print $invalid_choice
	fi

	# Destroy arrays and variables
	unset -v project selection small_env chosen_env chosen_domain chosen_app chosen_project
}
