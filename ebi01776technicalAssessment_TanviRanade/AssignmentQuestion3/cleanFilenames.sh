
: ' This is a utility to sanitize file names as per customer input or predefined invalid characters
		Author : Tanvi Ranade Date:- 13-03-2021 '

# Usage definition function
usage() {
  echo 'This script can be used to sanitize filenames in a folder'
  echo 'Default characters are defined as #%&{}<>*?/\t$!@+|=`"'':, custom invalid characters can be given in a text file with -i argument'
  echo 'Default behaviour of sanization is to remove all invalid characters.It can be changed by giving space seperated tuples of replacement sets in -o argument'
  echo 'Example of line in options file -> + - , here character + wil be replaced by - and invalid characters will be ignored'
  echo "Usage: $0 [-f <foldername> -o <options> -i <invalidCharacters> ]"
  1>&2
  exit 1
}

# Read commandline arguments for script
while getopts ":f:o:i:" o; do
  case "${o}" in
    f)
        foldername=${OPTARG}
        ;;
    o)
        optionsFile=${OPTARG}
        ;;
    i)
		invalidCharactersFile=${OPTARG}
        ;;
    *)
        usage
        ;;
  esac
done
shift $((OPTIND-1))

# Print Usage if mandatory argument, foldername containing files is not passed
if [ -z "${foldername}" ]; then
    usage
fi

#print user input for reference
echo "${foldername}"
echo "options file name is '${optionsFile}'"
echo "invalidCharactersFile name is '${invalidCharactersFile}'"

# Default definition of invalid characters for usage definition
invalidCharacters=='#%&{}<>*?/\ $!@+|=`"'':'

presentworkingdirectory=$(pwd)
cd $foldername
#Iterate over files in a folder to sanitize filenames
for f in *;
do
   #User definition for invalid characters not available
   if [ -z "${invalidCharactersFile}" ]
   then
		# Replacement option sets not available ,invoke default behaviour and delete invalid characters from filenames
		if [ -z "${optionsFile}" ]
		then
			newNameCommand="echo '${f}' | tr -d '${invalidCharacters}'"
			newName=$(eval $newNameCommand)
			renameCommand="mv '${f}' '${newName}'"
			eval $renameCommand
		# Replacement option sets available, iterate over option sets for each filename to replace appropriate characters
		else
			while read line 
			do 
				twostrings=(${line// / })
				newNameCommand="echo '${f}' | tr -d '${invalidCharacters}'"
				echo "${newNameCommand}"
				newName=$(eval $newNameCommand)
				renameCommand="mv '${f}' '${newName}'"
				echo $renameCommand
				eval $renameCommand
			done < "${optionsFile:-/dev/stdin}"
		fi
	# Consider user defined invalid characters and delete them accordingly from filenames
	else
		while read line 
		do 
			echo "${line}"
			newNameCommand=" echo ${f} | tr -d '${line}' "
			echo $newNameCommand
			newName=$(eval $newName)
			renameCommand="mv '${f}' '${newName}'"
			eval $renameCommand
			done <"${invalidCharactersFile:-/dev/stdin}"
	fi
done
