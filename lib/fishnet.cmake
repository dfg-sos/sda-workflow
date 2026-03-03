include(FetchContent)
set(FISHNET_TEST OFF)
set(FISHNET_APPS OFF)
set(FISHNET_TEST_LIB OFF)
if(${SDA_TEST})
    set(FISHNET_TEST_LIB ON)
endif()
FetchContent_Declare(fishnet
    GIT_REPOSITORY https://gitlab2.informatik.uni-wuerzburg.de/descartes/sos/fishnet
    GIT_TAG 1.2
)
FetchContent_MakeAvailable(fishnet)
