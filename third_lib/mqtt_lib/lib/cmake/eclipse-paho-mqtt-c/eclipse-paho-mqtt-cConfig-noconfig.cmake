#----------------------------------------------------------------
# Generated CMake target import file.
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "eclipse-paho-mqtt-c::paho-mqtt3c" for configuration ""
set_property(TARGET eclipse-paho-mqtt-c::paho-mqtt3c APPEND PROPERTY IMPORTED_CONFIGURATIONS NOCONFIG)
set_target_properties(eclipse-paho-mqtt-c::paho-mqtt3c PROPERTIES
  IMPORTED_LOCATION_NOCONFIG "${_IMPORT_PREFIX}/lib/libpaho-mqtt3c.so.1.3.10"
  IMPORTED_SONAME_NOCONFIG "libpaho-mqtt3c.so.1"
  )

list(APPEND _IMPORT_CHECK_TARGETS eclipse-paho-mqtt-c::paho-mqtt3c )
list(APPEND _IMPORT_CHECK_FILES_FOR_eclipse-paho-mqtt-c::paho-mqtt3c "${_IMPORT_PREFIX}/lib/libpaho-mqtt3c.so.1.3.10" )

# Import target "eclipse-paho-mqtt-c::paho-mqtt3a" for configuration ""
set_property(TARGET eclipse-paho-mqtt-c::paho-mqtt3a APPEND PROPERTY IMPORTED_CONFIGURATIONS NOCONFIG)
set_target_properties(eclipse-paho-mqtt-c::paho-mqtt3a PROPERTIES
  IMPORTED_LOCATION_NOCONFIG "${_IMPORT_PREFIX}/lib/libpaho-mqtt3a.so.1.3.10"
  IMPORTED_SONAME_NOCONFIG "libpaho-mqtt3a.so.1"
  )

list(APPEND _IMPORT_CHECK_TARGETS eclipse-paho-mqtt-c::paho-mqtt3a )
list(APPEND _IMPORT_CHECK_FILES_FOR_eclipse-paho-mqtt-c::paho-mqtt3a "${_IMPORT_PREFIX}/lib/libpaho-mqtt3a.so.1.3.10" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
