#pragma once
#include <fishnet/Graph.hpp>
#include <JobAdjacency.hpp>

using JobDAG_t = decltype(fishnet::graph::GraphFactory::DAG(JobAdjacency(MemgraphConnection::create({}).value())));

static JobDAG_t loadDAG(JobAdjacency && adj) {
    return fishnet::graph::GraphFactory::DAG(std::move(adj));
}