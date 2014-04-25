function to_project()
{
	## Localize
	typeset invalid_choice web_root a b c small_env small_domain #local variables
	typeset -i selection #local integer variable
	typeset -a items item environment domain application project #local arrays 
	typeset -A chosen_item #associative array

	## Set the variables
	invalid_choice="\n${bg[red]}${fg_bold[red]} Invalid choice ${reset_color}"
	web_root="/Library/WebServer/Documents/www"

	## Set the arrays
	items=('environment' 'domain' 'application')
	set -A ${items[1]} 'development' 'test' 'production' # custom environments
	set -A ${items[2]} 'faiyazhaider.com' 'funcfoo.com' 'devoop.com' # custom domains
	set -A ${items[3]} 'custom' 'mobile' 'web' # custom apps

	## Change into the web directory
	cd $web_root
	clear # clear screen
	# Loop through the 'items' array
	for (( a=1; a<=${#items}; a++ )); do
		print "\n${bg[green]}${fg_bold[green]} Select $items[$a] ${reset_color}\n"
		# Based on the value of $a, the 'item' array will hold either env, domain or app
		item=(${(P)items[$a]}) # parameter expansion flag
		# Based on the item, loop through its avilable values
		for (( b=1; b<=${#item}; b++ )); do
			# Print choices based on returned values
			print "Type ${fg_bold[green]}${b}${reset_color} for ${fg_bold[green]}${item[$b]}${reset_color}"
		done
		print ""
		# Allow user to input a number and catch the input with 'selection' variable
		read selection"?Type the number: ${fg_bold[white]}"
		# Condition to verify if user selected a valid number
		if [[ $selection -gt 0 && $selection -le ${#item} ]]; then
			cd ${item[$selection]} # Change directory to selected item
			chosen_item+=(${items[$a]} ${item[$selection]}) # Save selection in an associative array
			clear # clear screen
			# Condition to verify if we are at the last item 
			if [[ $a -eq ${#items} ]]; then
				# Loop through the current list of directories
				for c (*/); do
					# Except 'log', put all on a project array
					if [[ ${c:0:-1} != 'log' ]]; then
						# the -1 deletes the '/' from the end of the string
						project+=("${c:0:-1}")
					fi
				done
				# If the project array is not empty, we have projects
				if [[ ${#project} -gt 0 ]]; then
					print "\n${bg[green]}${fg_bold[green]} Select project ${reset_color}\n"
					# Loop through the project array to create selection
					for (( d=1; d<=${#project}; d++ )); do
						print "Type ${fg_bold[green]}${d}${reset_color} for ${fg_bold[green]}${project[${d}]}${reset_color}"
					done
					print ""
					# Allow user to input a number and catch the input with 'selection' variable
					read selection"?Type the number: ${fg_bold[white]}"
					# Condition to verify if user selected a valid project
					if [[ $selection -gt 0 && $selection -le ${#project} ]]; then
						# Change directory to selected project
						cd ${project[$selection]} 
						chosen_item+=(project ${project[$selection]}) # Save selection in an associative array
						clear # Clear screen
						# Remove the '.com' from end of the domain names
						small_domain=${chosen_item[domain]:0:-4}
						# Shorten the environment names 
						if [[ ${chosen_item[environment]} == 'development' ]]; then
							small_env=${chosen_item[environment]:0:3}
						else
							small_env=${chosen_item[environment]:0:4}
						fi
						clear # Clear screen
						# Output Success, and print final result to user
						print "\n${fg_bold[green]}Success!!${reset_color}"
						print "\n${fg_bold[green]}Environment: ${fg_bold[white]}${chosen_item[environment]}${reset_color}"
						print "${fg_bold[green]}Domain: ${fg_bold[white]}${chosen_item[domain]}${reset_color}"
						print "${fg_bold[green]}Application: ${fg_bold[white]}${chosen_item[application]}${reset_color}"
						print "${fg_bold[green]}Total projects: ${fg_bold[white]}${#project}${reset_color}"
						print "${fg_bold[green]}Selected project: ${fg_bold[white]}${chosen_item[project]}${reset_color}"
						print "${fg_bold[green]}Access this project with: ${fg_bold[white]}${small_env}_${small_domain}_${chosen_item[application]}_${chosen_item[project]}${reset_color}"
						# Create shortcut to the project directory
						eval "${small_env}_${small_domain}_${chosen_item[application]}_${chosen_item[project]}=$PWD"
					else # User provided incorrect data
						print $invalid_choice
						return
					fi
				else # The project array is empty
					# Output result to user
					print "\n${fg_bold[green]}Environment: ${fg_bold[white]}${chosen_item[environment]}${reset_color}"
					print "${fg_bold[green]}Domain: ${fg_bold[white]}${chosen_item[domain]}${reset_color}"
					print "${fg_bold[green]}Application: ${fg_bold[white]}${chosen_item[application]}${reset_color}"
					print "${fg_bold[green]}Total projects: ${fg_bold[white]}${#project}${reset_color}"
					print "\n${fg_bold[red]}Sorry, but you currently have no project setup${reset_color}"
				fi
			fi
		else # User provided incorrect data
			print $invalid_choice
			return
		fi
	done
}
