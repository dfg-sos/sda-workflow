#include <gtest/gtest.h>
#include "ApproxAreaFilter.hpp"
#include "ProjectedAreaFilter.hpp"
#include <fishnet/WGS84Ellipsoid.hpp>
#include "InsidePolygonFilter.hpp"
#include <fishnet/TestUtil.hpp>
#include <fishnet/SimplePolygon.hpp>
using namespace fishnet;
using namespace fishnet::geometry;


class SimplePolygonSamples {
public:
    static SimplePolygon<double> aaBB(Vec2D<double> topLeft, Vec2D<double> botRight){
        if(topLeft == botRight) 
            throw std::invalid_argument("Points are coinciding");
        if(topLeft.x == botRight.x || topLeft.y == botRight.y)
            throw std::invalid_argument("Points do not form an area");
        return SimplePolygon<double>(std::initializer_list<Vec2D<double>>{topLeft,Vec2D(botRight.x,topLeft.y),botRight,Vec2D(topLeft.x,botRight.y)});
    }   

    static SimplePolygon<double> triangle(Vec2D<double> a, Vec2D<double> b, Vec2D<double> c) {
        if(Line(a,b).contains(c)) throw std::invalid_argument("Points are collinear");
        return SimplePolygon<double>(std::initializer_list<Vec2D<double>>{a,b,c});
    }

    static SimplePolygon<double> aaRhombus(Vec2D<double> center, double radius) {
        if(radius <= 0)
            throw std::invalid_argument("Radius has to be > 0");
        return SimplePolygon<double>({
            {center.x,center.y+radius},
            {center.x+radius,center.y},
            {center.x,center.y - radius},
            {center.x-radius,center.y}
        });
    }

    static std::vector<Vec2DReal> pointsOfSquareKilometerWue(){
        auto A = Vec2DReal(49.78136164352572, 9.966929808562949);
        auto B = Vec2DReal(49.78136164352572, 9.975970902326768);
        auto C = Vec2DReal(49.790481800072, 9.975970902326768);
        return std::vector<Vec2DReal>({
            A,B,C,Vec2DReal(C.x,A.y)
        });
    }

    const static inline SimplePolygon<double> SQUARE_KILOMETER = SimplePolygon(pointsOfSquareKilometerWue());
};


static double SQUARE_KILOMETER_IN_SQM = 1000000.0;

TEST(FilterTest, ApproxAreaFilter) {
    ApproxAreaFilter squareKilometerFilter {SQUARE_KILOMETER_IN_SQM};
    EXPECT_EQ(ApproxAreaFilter::type(),UnaryFilterType::ApproxAreaFilter);
    auto polygon = SimplePolygonSamples::SQUARE_KILOMETER;
    EXPECT_TRUE(squareKilometerFilter(polygon));
}

TEST(FilterTest, ProjectedAreaFilter) {
    // Implementation Deprecated

    // ProjectedAreaFilter squareKilometerFilter {SQUARE_KILOMETER_IN_SQM};
    // EXPECT_EQ(ProjectedAreaFilter::type(), UnaryFilterType::ProjectedAreaFilter);
    // EXPECT_TRUE(squareKilometerFilter(SimplePolygonSamples::SQUARE_KILOMETER));
}

TEST(FilterTest, InsideBoundaryFilter) {
    using namespace fishnet::geometry;
    InsidePolygonFilter filter;
    auto box = SimplePolygonSamples::aaBB({0,0},{4,4});
    auto inside = SimplePolygonSamples::triangle({1,1},{2,2},{1,2});
    auto intersecting = SimplePolygonSamples::aaRhombus({4,2},2);
    EXPECT_FALSE(filter(box,inside));
    EXPECT_FALSE(filter(box,box));
    EXPECT_TRUE(filter(box,intersecting));
}