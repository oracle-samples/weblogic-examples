#!/usr/bin/env bash
# Copyright (c) 2025 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v1.0 as shown at https://oss.oracle.com/licenses/upl.

#############################################################################################################################
# Name                 : init_petclinic.sh
# Description          : Clones spring-framework-petclinic branch 5.3.x from spring-petclinic github repository
#                         - Injects weblogic.xml
#                         - Creates petclinic.tld
#                         - Trims WEB-INF/tags/*.tag trimWhiteSpaces
#                         - set Spring Boot Default Handler
#############################################################################################################################
scriptName=$(basename "$0")
scriptPath=$(dirname "$0")
cloned_branch_dir="$scriptPath/spc-b_5_3_x"


function update_custom_layout_tag(){
   local repo_path=$1
   #layout.tag
   if [ -f "$repo_path/src/main/webapp/WEB-INF/tags/layout.tag" ] ; then
      sed -i '1d' $repo_path/src/main/webapp/WEB-INF/tags/layout.tag
   else
        echo "layout.tag file not found"
        echo "script $scriptName is not in the same directory as tutorial.  Change directory to deploy/deploy-petclinic-weblogic-12.2.1.4 and run this script. exiting..."
        exit 1
   fi
}
function update_custom_localDate_tag(){
  local repo_path=$1
    #localDate.tag
    #<%@ tag body-content="empty" pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
   if [ -f "$repo_path/src/main/webapp/WEB-INF/tags/localDate.tag" ] ; then
     sed -i '/body-content/,/%>/ s/\(trimDirectiveWhitespaces="true"\)//' $repo_path/src/main/webapp/WEB-INF/tags/localDate.tag
   else
           echo "lacalDate.tag file not found"
           echo "script $scriptName is not in the same directory as tutorial.  Change directory to deploy/deploy-petclinic-weblogic-12.2.1.4 and run this script. exiting..."
           exit 1
  fi
}

function inject_weblogic_xml(){
  local repo_path=$1
   #weblogic.xml
   if [ -f "$scriptPath/weblogic.xml" ]; then
     cp "$scriptPath/weblogic.xml" "$repo_path/src/main/webapp/WEB-INF/"
   else
     echo "weblogic.xml file not found."
     echo "script $scriptName is not in the same directory as weblogic.xml.  Change directory to deploy/deploy-petclinic-weblogic-12.2.1.4 and run this script. exiting..."
     exit 1
   fi
}

function update_default_handler() {
  local repo_path=$1
  #replace <mvc:default-servlet-handler with <mvc:default-servlet-handler default-servlet-name="default"/>
  # file: tutorial/deploy/deploy-petclinic-weblogic-12.2.1.4/src/main/resources/spring/mvc-core-config.xml
  if [ -f "$repo_path/src/main/resources/spring/mvc-core-config.xml" ]; then
    sed -i 's|\(.*mvc:default-servlet-handler.*\)|<mvc:default-servlet-handler default-servlet-name="default"/>|' "$repo_path/src/main/resources/spring/mvc-core-config.xml"
   else
     echo "mvc-core-config.xml file not found."
     echo "script $scriptName is not in the same directory as tutorial.  Change directory to deploy/deploy-petclinic-weblogic-12.2.1.4 and run this script. exiting..."
     exit 1
   fi
}

function update_weblogic_dependencies() {
  local local_path=${1:-"$cloned_branch_dir"}
  inject_weblogic_xml $local_path
  echo "Weblogic.xml added..."
  update_custom_layout_tag $local_path
  echo "layout.tag updated..."
  update_custom_localDate_tag $local_path
  echo "localDate.tag updated..."
  update_default_handler $local_path
  echo "default handler set in Spring Framework config..."
}

function git_clone_petclinic(){
   local_path=${1:-"$cloned_branch_dir"}
   git clone -b 5.3.x --single-branch https://github.com/spring-petclinic/spring-framework-petclinic.git $local_path
   if [ $? -ne 0 ]; then
     echo "Error occurred during git clone. If repo is cloned already. Try other options. Exiting."
     exit 1
   fi
}
print_help() {
    # Menu Options
    echo "Usage: $0 [option] [env_name]"
    echo "Options:"
    echo "  wls   Update cloned Spring Framework Petclinic path with Weblogic dependencies"
    echo "  clone   Clone Spring Framework Petclinic branch 5.3.x only"
    echo "  all or <default> Clone Spring Framework Petclinic and update with WebLogic dependencies"

}

if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    print_help
    return 0
fi
case "$1" in
    "wls")
          update_weblogic_dependencies $2
          echo "DONE updating weblogic dependencies"
        ;;
    "clone")
           git_clone_petclinic $2
           ;;
    "all")
          git_clone_petclinic $2
          update_weblogic_dependencies $2
          echo "DONE updating Spring Petclinic Framework branch 5.3.x"
          ;;
    "")
         git_clone_petclinic
         update_weblogic_dependencies
         echo "DONE updating Spring Petclinic Framework branch 5.3.x"
         ;;
    *)
        echo "Unknown option: $1"
        print_help
        exit 1
        ;;
esac

echo "Exiting..."

