#
# Set up deal.II specific definitions
#

SET_IF_EMPTY(DEAL_II_PACKAGE_NAME "deal.II")

SET(DEAL_II_PACKAGE_VERSION ${VERSION})
SET(DEAL_II_PACKAGE_STRING
  "${DEAL_II_PACKAGE_NAME} ${DEAL_II_PACKAGE_VERSION}"
  )

SET_IF_EMPTY(DEAL_II_PACKAGE_BUGREPORT "dealii@dealii.org")
SET_IF_EMPTY(DEAL_II_PACKAGE_TARNAME ${DEAL_II_PACKAGE_NAME}) #TODO
SET_IF_EMPTY(DEAL_II_PACKAGE_URL "http://www.dealii.org")

STRING(REGEX REPLACE
  "^([0-9]+)\\..*" "\\1" DEAL_II_VERSION_MAJOR "${VERSION}"
  )
STRING(REGEX REPLACE
  "^[0-9]+\\.([0-9]+).*" "\\1" DEAL_II_VERSION_MINOR "${VERSION}"
  )

SET(DEAL_II_PROJECT_CONFIG_NAME "${DEAL_II_PACKAGE_NAME}")

SET_IF_EMPTY(DEAL_II_BASE_NAME "deal_II")

SET_IF_EMPTY(DEAL_II_DEBUG_SUFFIX ".g")

SET(DEAL_II_PATH ${CMAKE_INSTALL_PREFIX})

IF(DEAL_II_COMPONENT_COMPAT_FILES)
  #
  # The good, old directory structure:
  #
  SET_IF_EMPTY(DEAL_II_DOCUMENTATION_RELDIR "doc")
  SET_IF_EMPTY(DEAL_II_EXAMPLES_RELDIR "examples")
  SET_IF_EMPTY(DEAL_II_INCLUDE_RELDIR "include")
  SET_IF_EMPTY(DEAL_II_LIBRARY_RELDIR "lib")
  SET_IF_EMPTY(DEAL_II_PROJECT_CONFIG_RELDIR ".")

ELSE()
  #
  # IF DEAL_II_COMPONENT_COMPAT_FILES is not set, we assume that we have to
  # obey the FSHS...
  #
  SET_IF_EMPTY(DEAL_II_DOCUMENTATION_RELDIR "share/doc/${DEAL_II_PACKAGE_NAME}/html")
  SET_IF_EMPTY(DEAL_II_EXAMPLES_RELDIR "share/doc/${DEAL_II_PACKAGE_NAME}/examples")
  SET_IF_EMPTY(DEAL_II_INCLUDE_RELDIR "include")
  SET_IF_EMPTY(DEAL_II_LIBRARY_RELDIR "lib${LIB_SUFFIX}")
  SET_IF_EMPTY(DEAL_II_PROJECT_CONFIG_RELDIR "${DEAL_II_LIBRARY_RELDIR}/cmake/${DEAL_II_PROJECT_CONFIG_NAME}")
ENDIF()


LIST(APPEND DEAL_II_INCLUDE_DIRS
  "${CMAKE_INSTALL_PREFIX}/${DEAL_II_INCLUDE_RELDIR}"
  )

#
# A lot of magic to guess the resulting library names:
#

IF(BUILD_SHARED_LIBS)
  SET(DEAL_II_LIBRARY_NAME_RELEASE ${CMAKE_SHARED_LIBRARY_PREFIX}${DEAL_II_BASE_NAME}${CMAKE_SHARED_LIBRARY_SUFFIX} )
  SET(DEAL_II_LIBRARY_NAME_DEBUG ${CMAKE_SHARED_LIBRARY_PREFIX}${DEAL_II_BASE_NAME}${DEAL_II_DEBUG_SUFFIX}${CMAKE_SHARED_LIBRARY_SUFFIX} )
ELSE()
  SET(DEAL_II_LIBRARY_NAME_RELEASE ${CMAKE_STATIC_LIBRARY_PREFIX}${DEAL_II_BASE_NAME}${CMAKE_STATIC_LIBRARY_SUFFIX} )
  SET(DEAL_II_LIBRARY_NAME_DEBUG ${CMAKE_STATIC_LIBRARY_PREFIX}${DEAL_II_BASE_NAME}${DEAL_II_DEBUG_SUFFIX}${CMAKE_STATIC_LIBRARY_SUFFIX} )
ENDIF()

IF(CMAKE_BUILD_TYPE MATCHES "Debug")
  LIST(APPEND DEAL_II_LIBRARIES_DEBUG
    "${CMAKE_INSTALL_PREFIX}/${DEAL_II_LIBRARY_RELDIR}/${DEAL_II_LIBRARY_NAME_DEBUG}"
    )
  LIST(APPEND DEAL_II_LIBRARIES
    DEBUG
    "${CMAKE_INSTALL_PREFIX}/${DEAL_II_LIBRARY_RELDIR}/${DEAL_II_LIBRARY_NAME_DEBUG}"
    )
ENDIF()

IF(CMAKE_BUILD_TYPE MATCHES "Release")
  LIST(APPEND DEAL_II_LIBRARIES_RELEASE
    "${CMAKE_INSTALL_PREFIX}/${DEAL_II_LIBRARY_RELDIR}/${DEAL_II_LIBRARY_NAME_RELEASE}"
    )
  LIST(APPEND DEAL_II_LIBRARIES
    RELEASE
    "${CMAKE_INSTALL_PREFIX}/${DEAL_II_LIBRARY_RELDIR}/${DEAL_II_LIBRARY_NAME_RELEASE}"
    )
ENDIF()

