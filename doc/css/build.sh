#!/bin/sh
# Runs sass on all .sass files in the current directory

neutral_colour="\033[1;37m"
success_colour="\033[1;32m"
failure_colour="\033[1;31m"
black="\033[0;0m"

successes="0"
failures="0"
failed_files=""

# The compile target is the final sass/css file that holds all the other files
compile_target="compile"


# Delete any old compile target, and the temp file we use to build it
rm $compile_target.sass .tmp 2>/dev/null

# Compile all sass files
for i in *.sass; do
  
  echo -e "$neutral_colour $i$black... "
  if sass $i `basename $i .sass`.css; then
    echo -e $success_colour "success" $black
    successes=`expr $successes + 1`
  else
    echo -e $failure_colour "failure" $black
    failures=`expr $failures + 1`
    failed_files="$failed_files   $i
"
  fi
  
  # Blank line for readability
  echo
  
  # Add the current file to the temporary sass file
  echo "@import $i" >> .tmp
  
done

# If none of the sass files failed to compile, build the compile target
if [ $failures -eq 0 ]; then
echo "-------------------------------------------------------------------------------"
  echo " Compiling..."

  mv .tmp $compile_target.sass
  if sass compile.sass compile.css; then
    echo -e $success_colour "success" $black
  else
    echo -e $failure_colour "failure" $black
  fi
fi

# Output the number of successfully built files, and any failures
echo "-------------------------------------------------------------------------------"
echo
echo -e "$success_colour $successes succeeded $black"
if [ $failures -gt 0 ]; then
  echo -e "$failure_colour $failures failed$black:"
  echo "$failed_files"
else
  echo -e " 0 failed $black"
fi
