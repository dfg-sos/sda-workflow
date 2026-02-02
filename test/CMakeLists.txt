set(SDAWorkflowTestBin Test-SDA-Workflow)
add_executable(${SDAWorkflowTestBin}
FilterTest.cpp
JobAdjacencyTest.cpp
ConcurrentSessionsTest.cpp
MemgraphTest.cpp
PolygonDistanceTest.cpp
CipherQueryTest.cpp
)
gtest_discover_tests(${SDAWorkflowTestBin})
target_link_libraries(${SDAWorkflowTestBin} PRIVATE SDA_Workflow::SDA_Workflow Fishnet::Test Fishnet::Graph) 