set(workflowTask ${WORKFLOW_NAME}Splitter)
add_executable(${workflowTask}
    ShapefileSplitter.cpp
)
target_link_libraries(${workflowTask} Fishnet::Fishnet CLI11::CLI11)
install(TARGETS ${workflowTask} RUNTIME DESTINATION ${CMAKE_INSTALL_PREFIX}/bin)