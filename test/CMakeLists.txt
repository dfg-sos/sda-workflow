set(SDAWorkflowTestBin Test-SDA-Workflow)
add_executable(${SDAWorkflowTestBin}
FilterTest.cpp
JobAdjacencyTest.cpp
ConcurrentSessionsTest.cpp
MemgraphTest.cpp
PolygonDistanceTest.cpp
CipherQueryTest.cpp
)
gtest_discover_tests(${SDAWorkflowTestBin} WORKING_DIRECTORY ${CMAKE_SOURCE_DIR})
target_link_libraries(${SDAWorkflowTestBin} PRIVATE SDA_Workflow::SDA_Workflow Fishnet::Test Fishnet::Graph) 