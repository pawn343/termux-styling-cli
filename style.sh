#!/data/data/com.termux/files/usr/bin/bash

#https://github.com/termux/termux-styling/tree/master/app/src/main/assets

###############################################################################
#
#
#
#
#           Termux styling from cli interface
#           By re0x00;
#
#
#
#
#
#
#
#
#
###############################################################################


termux_styling="https://github.com/termux/termux-styling"
git_path=~/termux-styling
styling_path=app/src/main/assets
termux_styling_path=~/.termux


function is_file (){
  [ -f $1 ] && echo "file $1 already exists"
}

function is_dir (){
  [ -d $1 ] && echo "folder $1 already exists"
}

function setup (){
  echo "The $git_path doesn't exists, so we'll initialize it for you." 
  echo "\
    Setting things up..\
    "
  git clone --depth 1 --filter=blob:none --sparse \
    https://github.com/termux/termux-styling $git_path
  cd ${git_path}
  git sparse-checkout set $styling_path/colors $styling_path/fonts
  echo "Everything is good."
}

function apply_theme (){
  echo "
  You selected: \"$opt\"
  Applying theme.."
  cp $git_path/$styling_path/colors/$opt $termux_styling_path/colors.properties
  termux-reload-settings
}

function apply_font (){
  echo "
  You selected: \"$opt\"
  Applying font.."
  cp $git_path/$styling_path/fonts/$opt $termux_styling_path/font.ttf
  termux-reload-settings
}

function _quit (){
  case $REPLY in
    "quit" | "q")
      echo "Bye bye.." 
      exit 0;;
    *) echo "\
      #########################################
            Not found: \"$REPLY\".
            Type \"quit\" or \"q\" to Quit.
      ########################################"
            ;;
    esac
}


function theme (){
  _colors=`ls $git_path/$styling_path/colors`
  PS3='
Select the theme by the index number: '
  colors=($_colors)
  select opt in "${colors[@]}"
  do
    [[ -z $opt ]] && _quit || apply_theme;
  done
}


function font (){
  _fonts=`ls $git_path/$styling_path/fonts`
  PS3='
Select the font by the index number: '
  fonts=($_fonts)
  select opt in "${fonts[@]}"
  do
    [[ -z $opt ]] && _quit || apply_font;
  done
}

function usage (){
  echo "
Usage:
      $0 font|theme

      example if you want to change the font, run:
      $0 font
      then select the font by the index.
  "
}




is_dir $git_path || setup 
if [[ -z $1 ]]; then usage;
elif [[ $(type -t $1) == function ]]; then $1;
else echo "

Invalid option: $1"; usage;
fi




