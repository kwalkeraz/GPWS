//Use this page to keep track of global variables that can be used by all javascripts
//Do Not use this file to store functions/methods, they should have their own file

//URI
var g_uri='/tools/print';

//RegExp variables:
var g_fax_number_regexp='^[0-9 _+().-]*$';
var g_phone_number_regexp='^[0-9 _+().-]*$';
var g_tieline_regexp='^[0-9 _().+-]*$';
var g_device_regexp='^[A-Za-z0-9 _.-]*$';
var g_room_regexp='[^+*\\^`~\'\"\\{\\}\\[\\]!@#%\\\\&\\$|\\<\\>;=,?]*$';
var g_port_regexp='^[0-9 _.-]*$';
var g_macaddr_regexp='^[a-zA-Z0-9 _.:-]*$';
var g_iphost_regexp='^[a-zA-Z0-9 _.-]*$';
var g_ipaddr_regexp='^[0-9.]*$';
var g_driver_package='^[A-Za-z0-9 _.;\/-]*$';
var g_driver_version='^[A-Za-z0-9 _.;-]*$';
var g_driver_datafile='^[A-Za-z0-9 _.;]*$';
var g_driver_path='^[A-Za-z0-9 _.;]*$';
var g_driver_configfile='^[A-Za-z0-9 _.;]*$';
var g_driver_datafile='^[A-Za-z0-9 _.;]*$';
var g_driver_helpfile='^[A-Za-z0-9 _.;]*$';
var g_driver_filelist='^[A-Za-z0-9 _.;]*$';
var g_username_regexp='^[A-Za-z0-9 _.(),*-]*$';
var g_email_regexp='^[a-zA-Z0-9_.-]+@[a-zA-Z0-9-]+.[a-zA-Z0-9-]+.[a-zA-Z0-9-.]+$';
var g_emailList_regexp='^[A-Za-z0-9 _.,-@;]*$';
var g_loc_geo_regexp='^[A-Za-z0-9 ]*$';
var g_loc_country_regexp='^[A-Za-z0-9 ]*$';
var g_loc_state_regexp='^[A-Za-z0-9 .]*$';
//Please note that city and building have a range of regex characters that it accepts
//This is to avoid writing each language character, such as umlauts, which can be too many
var g_loc_city_regexp='^[A-Za-z0-9\u00C0-\u017F _.(),-]*$';
var g_loc_building_regexp='^[A-Za-z0-9\u00C0-\u017F _.(),-:#/]*$';
var g_loc_floor_regexp='^[A-Za-z0-9 _.,-/]*$';
var g_driver_regexp='^[A-Za-z0-9 _.()*/-]*$';
var g_driver_model_regexp='^[A-Za-z0-9 _.()*/-]*$';
var g_option_file_regexp='^[A-Za-z0-9 _.,+#$-]*$';
var g_server_name='^[a-zA-Z0-9 _.-]*$';

//Array of values
var nameAddOns = ["*VENDOR*","*CONTRACTOR*","*FUNCTIONAL-ID*","*APPLICATION-ID*"];

var g_pass_variable='**********';
